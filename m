Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28121377EA5;
	Tue, 17 Mar 2026 16:37:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773765455; cv=none; b=k5Pu5msBuAg1RnawMJWwUsazR6syLhJTdzt7SCZ+aUnoRDjIF/Rj2rlh8pamDJijgUBKeaGyBC4gv/y1tjZ99fbJJJLwf0hDP7XhlxbHiG87JfTv4TgICl1pHH0LqDH9tTyaTTr8n8yTw67r1ClJu+LSkyCEzpU03VOdywPkOkA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773765455; c=relaxed/simple;
	bh=ZInbshZsplJwNiIWWNFiYslJFmp/Fkpp2eSS66CeNw8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jm3wh9G7Z5GFVG1zZlFhLh96zzu22tBG7r4Nlkz/TcDs1kKR7jXzsLjsWXtPDo8z+IcQd5nGVChzvSxNu19vmkHftW1R6dHYNlXUJaQ+GDCiqGCxjiEpVI3bpXbl4+B4rLHmpg7YjPaDBlP56JagHQkzPfzNCF4mkPVBtFPrdkA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XMD2qZ2J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XMD2qZ2J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10605C4CEF7;
	Tue, 17 Mar 2026 16:37:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773765454;
	bh=ZInbshZsplJwNiIWWNFiYslJFmp/Fkpp2eSS66CeNw8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XMD2qZ2Jrh+/gc4aYwEMT52N0P1z59NPNCrkxkOS4wvznoeCv3eE0PD/i4P21MJUS
	 3SxIi6OqAex7ytllRuxbjIKQMp5hM0Hl3DrX4JAtmZ7O9QMA9/jkuIOfTjYKMxiLsL
	 7+XhwZYbVW4jl3QBHXE7rK7pK+3G/ZORly8PM4GI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Al Viro <viro@zeniv.linux.org.uk>,
	Waiman Long <longman@redhat.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 015/378] unshare: fix unshare_fs() handling
Date: Tue, 17 Mar 2026 17:29:32 +0100
Message-ID: <20260317163007.535445297@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317163006.959177102@linuxfoundation.org>
References: <20260317163006.959177102@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Al Viro <viro@zeniv.linux.org.uk>

[ Upstream commit 6c4b2243cb6c0755159bd567130d5e12e7b10d9f ]

There's an unpleasant corner case in unshare(2), when we have a
CLONE_NEWNS in flags and current->fs hadn't been shared at all; in that
case copy_mnt_ns() gets passed current->fs instead of a private copy,
which causes interesting warts in proof of correctness]

> I guess if private means fs->users == 1, the condition could still be true.

Unfortunately, it's worse than just a convoluted proof of correctness.
Consider the case when we have CLONE_NEWCGROUP in addition to CLONE_NEWNS
(and current->fs->users == 1).

We pass current->fs to copy_mnt_ns(), all right.  Suppose it succeeds and
flips current->fs->{pwd,root} to corresponding locations in the new namespace.
Now we proceed to copy_cgroup_ns(), which fails (e.g. with -ENOMEM).
We call put_mnt_ns() on the namespace created by copy_mnt_ns(), it's
destroyed and its mount tree is dissolved, but...  current->fs->root and
current->fs->pwd are both left pointing to now detached mounts.

They are pinning those, so it's not a UAF, but it leaves the calling
process with unshare(2) failing with -ENOMEM _and_ leaving it with
pwd and root on detached isolated mounts.  The last part is clearly a bug.

There is other fun related to that mess (races with pivot_root(), including
the one between pivot_root() and fork(), of all things), but this one
is easy to isolate and fix - treat CLONE_NEWNS as "allocate a new
fs_struct even if it hadn't been shared in the first place".  Sure, we could
go for something like "if both CLONE_NEWNS *and* one of the things that might
end up failing after copy_mnt_ns() call in create_new_namespaces() are set,
force allocation of new fs_struct", but let's keep it simple - the cost
of copy_fs_struct() is trivial.

Another benefit is that copy_mnt_ns() with CLONE_NEWNS *always* gets
a freshly allocated fs_struct, yet to be attached to anything.  That
seriously simplifies the analysis...

FWIW, that bug had been there since the introduction of unshare(2) ;-/

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Link: https://patch.msgid.link/20260207082524.GE3183987@ZenIV
Tested-by: Waiman Long <longman@redhat.com>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/fork.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/fork.c b/kernel/fork.c
index b1f3915d5f8ec..68ccbaea7398a 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -3082,7 +3082,7 @@ static int unshare_fs(unsigned long unshare_flags, struct fs_struct **new_fsp)
 		return 0;
 
 	/* don't need lock here; in the worst case we'll do useless copy */
-	if (fs->users == 1)
+	if (!(unshare_flags & CLONE_NEWNS) && fs->users == 1)
 		return 0;
 
 	*new_fsp = copy_fs_struct(fs);
-- 
2.51.0



