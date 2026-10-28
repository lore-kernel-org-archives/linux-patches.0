Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793209228;
	b=DkvVKGLcbZA4GpKTHuZnn8ZU/Oaj2nDdaq7DJR2oE7BjiFjMa7IStRSRIEIGZtDix6cB
	 7+t4i+eIV0c/3DG9U9UJxpDIjL82WGRy5cigd3jotqXlWQ7v2PksYpTRqeDyUa7uw/MBG
	 4vGQneGXMlChiwrr1Ggs8T1jIMvYhcisFDzl9X7Z3TbM9bq8tuv1fD4D95lDPkrG+nXMu
	 50nAoWDnNyhO9bLPqM1duNYuRpHxZi16c3AZufEGDAigU3WKMoCB2zedHn1RPWFvWXQUG
	 MAs70axmSGmmESzep2Qh0xb5LJ2uNfnDkHX0asEB0caCLDDCluzarzT9FapG/GJYPfQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793209228;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2l4DM1xzSljn2RZfuhCP1G4THxAnGlAUOEExq1uPO6E=;
	b=5Tf5z6gKN9YtgYpmO1g32mM5ysmh+kYGsqtWOY/P35aIrR2P0r0ErtEa/JdTB0e3c2zC
	 noT6bM+mSra0Mt430F28oGHVrrMVb/6+V9MehkpBWHSkN6TAts0RsWHq6QoU5dfr9/HRL
	 yL6HPKslm7VcJkVJJWVZQHsqFonZ21a82UMVU3kMNxFguAomBNAECCoPGxd5osJd1V8Gi
	 0BV+/BvuJjaENxTHIquFqNGngxkuMZ+8Any9HKDspmAT1VmU2AoiD4dn3hqFb9dD6BTBr
	 ygwHu/iZOtHiw2gtZoV6zbJg5nL5HlqtXbvWsL9Lz7AopYoWNyxe5bLUoLmO5nYKjsA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=R2zeB6oQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B17AE606A31D;
	Wed, 28 Oct 2026 17:40:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=R2zeB6oQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE14D1F01825;
	Wed, 28 Oct 2026 17:40:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793209227;
	bh=2l4DM1xzSljn2RZfuhCP1G4THxAnGlAUOEExq1uPO6E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=R2zeB6oQCoYJA/PPrKXvv2tRfR8dXwFf16SMCZvhgGeFnTJAKofvebM1HH+BQhHwn
	 Yc8hlhf4ikMM2qFUqoyKf5UI6A8Y6nS0txEkMzHRSiqC2RWjDsgYxTK4ftf7Pbs1IO
	 Oga6EpThKpk+ZZ9k3axRkdtXivwHOCjgnFLY2KNo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 397/516] namespace: dont copy an unmounted mount tree
Date: Wed, 28 Oct 2026 17:59:09 +0100
Message-ID: <20261028170012.884490544@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Brauner <brauner@kernel.org>

[ Upstream commit 8bacbf6be959973b28b691713a872c12eae69eec ]

may_copy_tree() accepts a mount whose root is an nsfs or pidfs file
before it checks whether that mount is mounted. This exception exists
for nsfs and pidfs mounts. They are part of no mount namespace so
neither check_mnt() nor is_mounted() would let them through and
bind-mounting a nsfsfd or a pidfd wouldn't work.

Problem is that exception also admits a bind mount of such a file when
it was lazily unmounted and is only kept alive by a file descriptor:

  mount --bind /proc/self/ns/net /tmp/x
  exec 3< /tmp/x
  umount -l /tmp/x
  mount --rbind /proc/self/fd/3 /tmp/y

With MS_REC or AT_RECURSIVE copy_tree() doesn't stop at the unmounted
mount. It copies every mount that stayed attached to it as well. So if
you have a bunch of overmounts over the nsfsfd or the pidfd the whole
unmounted stack is copied. That's a bug.

So refuse to walk an unmounted tree. Copying its root alone stays
possible. So a bind mount of a namespace that is gone can still be
recreated from a file descriptor on the old one. The file descriptor
pins that mount and its root and __has_locked_children() only reads the
direct children which don't leave the parent's list without
namespace_sem. The internal mounts carry MNT_NS_INTERNAL instead of NULL
and are still walked. Copying an unmounted tree recursively fails with
EINVAL.

Fixes: e149ed2b805f ("take the targets of /proc/*/ns/* symlinks to separate fs")
Fixes: ef4144ac2dec ("pidfs: allow bind-mounts")
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260926-work-mount-fixes-2-v1-4-f357abf3d17b@kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
[ sashal: adjusted context for the inline mount check instead of may_copy_tree() ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/namespace.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/namespace.c b/fs/namespace.c
index c132729b4b1d1..ebf345754da94 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -2367,6 +2367,9 @@ static struct mount *__do_loopback(struct path *old_path, int recurse)
 	if (!check_mnt(old) && old_path->dentry->d_op != &ns_dentry_operations)
 		return mnt;
 
+	if (recurse && !old->mnt_ns)
+		return ERR_PTR(-EINVAL);
+
 	if (!recurse && has_locked_children(old, old_path->dentry))
 		return mnt;
 
-- 
2.53.0



