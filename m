Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9D424F3922;
	Tue, 13 Oct 2026 11:53:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791892420; cv=none; b=AnRVh4tWMEj7XyhTDeRTFKA4ae97M20jH7vzI6X1T5f0LWYfZ21dfpgKVqV4Cu0y+WNT6fUBrSrslz7plkimAnxMIdkylH2WMy0MgKEnQNlBKbByffObSyb0Wtx4vhfpESjSfnz3JJUjq0qW/zoJguMOFPmFGCFcMCt97fDjDqs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791892420; c=relaxed/simple;
	bh=iTbUeIuFz+ztNFwSp0MiSCQ3UpYVIre5emP3y+D4nPE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kCLgQUKZqIp1MiCUz/+Js8TAVIuljy1JLXyl+9+t7F8hKOWp3McTvF71tY3uZfnk4ZrlEAOA33Ox2XxgsbHmWFcBw6CxmdCJzgP+xEG46Bg1bb4yii2I+BpOGbcSsHKqjlRCAtlYh4GT4+BTO6DdBPFfH4J9EkkyoQvr8AegovQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gV6TpjWd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gV6TpjWd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E5691F000FF;
	Tue, 13 Oct 2026 11:53:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791892419;
	bh=rFNHjqRW5nYMbwgi8HEFKVYEWilvMXNk/rKAgKci3DI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gV6TpjWdYcNa8u2wl7Abxdsu4uhzuw5JPMlvtsku2xvJZtmSNRh0K5nUUUVcdt1gs
	 E7ZHwnPI1z3ulzgf/rgf5PN1kLk063oFCxj2/gzrO9hixvmz7pthiV/pqyKrxaOnqN
	 3Kp4sO3ed+gpT5eWwRD4oWVcNHACaaxr/4QbAdWo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Christian Brauner (Amutable)" <brauner@kernel.org>
Subject: [PATCH 7.2 165/281] namespace: dont let a pseudo dentry become the root of a mount
Date: Tue, 13 Oct 2026 13:38:01 +0200
Message-ID: <20261013112859.170352365@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112855.045212108@linuxfoundation.org>
References: <20261013112855.045212108@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3008,6 +3008,10 @@ static struct mount *__do_loopback(const
 	if (!may_copy_tree(old_path))
 		return ERR_PTR(-EINVAL);
 
+	/* a pseudo dentry is freed without an RCU delay, no walk may find it */
+	if (old_path->dentry->d_flags & DCACHE_NORCU)
+		return ERR_PTR(-EINVAL);
+
 	if (recurse && !old->mnt_ns)
 		return ERR_PTR(-EINVAL);
 


