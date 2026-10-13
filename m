Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A08C4F5DF1;
	Tue, 13 Oct 2026 12:06:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791893190; cv=none; b=iBP29T717lNLyIpXz0AL6JmSX5b3+ls5sF/Cp0G+HObxz4sKsTiZTrZhcp20QfVqSKMKA43SGpN7MzVcJx3FEYcUK8BOQicM14NY8+7JKK7sSB/BODOmkuE6v4eCgJdhhBuVzMM1tBNq9nqnJQN/Aii5htDJV1UisM6O8dUTjN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791893190; c=relaxed/simple;
	bh=HYuSDV3zN0F5HWWribVblciYicY/UPInZcPVAy1wlRQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UDnexUbLDG4IxtbDwDEqlSmfYr/tu3/+20L5W23jjWugA/oO+0kb8cShNPFMp0/+wbh8ZqKv5fy/rJwl0fWr8X/3CB+oSjaFU1MgrhnWrY54HfE+GAACAlEA6ED4zLya1v3cmDnbA5glcrK7WFsZRs/X8Ztm3j90/j6PZAr6Aw8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ejHt5Pyb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ejHt5Pyb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5F441F000FF;
	Tue, 13 Oct 2026 12:06:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791893189;
	bh=oL+TWix1gIWs9oP0hf6ebi+9EXJbVWyb4eICIGd/4iw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ejHt5PybtEVb8wqCql/U+n2S9LdnxSVEQN2qJb/YlCaCL0TKnTlKmwjliHbwU7dor
	 OK8aL23sB2oE3fAUyyC6uyF9u8HPGqix+jjtFoxUU/jCRRLboB7Id1FNo+Otln9Dxw
	 h/SlkLClQ5Xg81+UVlq0QB3yKYPJxbBjDZpX7wNs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Christian Brauner (Amutable)" <brauner@kernel.org>
Subject: [PATCH 6.18 142/621] namespace: dont let a pseudo dentry become the root of a mount
Date: Tue, 13 Oct 2026 13:32:17 +0200
Message-ID: <20261013112924.225166898@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Brauner <brauner@kernel.org>

commit b138e16fb1e81376cea89f727dda7bfccd140de4 upstream.

d_alloc_pseudo() hands out dentries for pipes, sockets and other files
that are never anyone's child or parent. They carry DCACHE_NORCU and
dentry_free() frees them right away because no lockless path walk can
ever reach them. That holds as long as such a dentry isn't the root of
a mount. But bind mounting /proc/self/fd/<fd> of such a file does
exactly that.

Most callers of alloc_file_pseudo() put their files on kernel-internal
mounts and may_copy_tree() refuses those. bpf_token_create() doesn't. It
places the token file on the bpffs mount the caller handed it and that
mount is in the caller's mount namespace so the clone goes through:

  mount --bind /proc/self/fd/<token> <file>
  open_tree(tokfd, "", AT_EMPTY_PATH | OPEN_TREE_CLONE) + move_mount()

__follow_mount_rcu() then loads ->mnt_root of that mount, reads d_seq
and d_flags of the dentry and only then checks mount_lock. The dentry
can be gone by then. The final mntput() of an unmounted parent unhooks
a child that stayed attached to it under mount_lock alone. When the
child's holder does the final put right after that the root is dput()
and freed immediately while a walker that found the mount hashed still
looks at it.

Refuse to clone a mount with a DCACHE_NORCU dentry as its root. Nothing
sensible can be done with a bind mount of a bpf token anyway.

Fixes: 35f96de04127 ("bpf: Introduce BPF token object")
Cc: stable@vger.kernel.org # v6.9+
Link: https://patch.msgid.link/20260930-work-mount-fixes-3-v1-17-be34c83956ae@kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/namespace.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -2971,6 +2971,10 @@ static struct mount *__do_loopback(const
 	if (!may_copy_tree(old_path))
 		return ERR_PTR(-EINVAL);
 
+	/* a pseudo dentry is freed without an RCU delay, no walk may find it */
+	if (old_path->dentry->d_flags & DCACHE_NORCU)
+		return ERR_PTR(-EINVAL);
+
 	if (recurse && !old->mnt_ns)
 		return ERR_PTR(-EINVAL);
 


