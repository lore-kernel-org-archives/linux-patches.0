Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213374;
	b=GJwKmD7kzxi2nsL48dvfbOO2no3usNCDdTfr5GWKhrB6igfSFe1IGFMMvEo2xCh+LcW6
	 Tt+HxkvLwTteTJcrAxGpXRUCwI73sZ38Xa1GjPWIEFAGyN1PSW6SdiHAS42x6RE2qny+Z
	 H9xZi/Ju/6ZRaGYJ+PSzZs+ZUR27Kl0aAgPdVkicuPyScxfknG7LEH+NGx23ukhjFFBfR
	 OP70uDS7+gCQGy3KOJ/DUX4B/m2c8PB8GjJVo4Be+EUFnJXypVUW/xaxmsHYVGhUd8SFk
	 XIwWWiyaifoCJ9MuOTFEXbBWzOfMEYDi2awMVFd243dyaqXfZKfe/FyKnCr8pBYskcg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213374;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=XMKkqVD4kRgbdho14nQTXc/o5fYC0cBTlElWvHcyI0o=;
	b=axVrK4fXGelBD4cpqhDgJ3CL13NSHgOfJRNMfWnAZoZJgiv2hwZqO5H6jNVJo2IB9iN6
	 QzWDabPl79+F7W7kX7Tjc4OMLz//SwN3sOYIQJrztrHVkgeRAVFsjTJ3Bg9kumOYgqfjt
	 z9iuei3CJfVN56qcjS4J4B8FytgVeoVXYG/6skDpwwgN55m6pik8DyI/QfVgFfwYjE/AL
	 UuWoFCfQf7yRXJnu9BDbl/bB0Ro6vDR8Q1wPXqdx5YNDHKsF617YAci7bK2gebYUj7r0W
	 Nf2rgoStalx5bRiJpIomrJX+hYOcs6fdhSGN5ocGGlvpotGVgkh9WyP7qEgLy2mTrSg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UpjVCGP3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BD1D606A31C;
	Wed, 28 Oct 2026 18:49:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UpjVCGP3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BBA91F01825;
	Wed, 28 Oct 2026 18:49:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213374;
	bh=XMKkqVD4kRgbdho14nQTXc/o5fYC0cBTlElWvHcyI0o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UpjVCGP3sxBVa1c87kNoofOL5M2waY7sVnwFWlaRMuc3LK1m6d6v1MaLKHVIbVUQe
	 GT7uh5wxvFUIjAWQMPh4U1yNrw0qmeV2zt5wOw0jMcwtOFv9iKmyrx7xp/hUsj1VXM
	 7zwZ5CTn7+puD5Bgwy9h8KxgKeHRI3LWMntJWcUQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Christian Brauner (Amutable)" <brauner@kernel.org>
Subject: [PATCH 6.1 0481/1887] dcache: dont put a mountpoint on a dentry thats being removed
Date: Wed, 28 Oct 2026 17:42:57 +0100
Message-ID: <20261028170510.202932962@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Brauner <brauner@kernel.org>

commit 75f4197f1e11d2eb75c2d6f916a7d4764db621e5 upstream.

rmdir(), unlink() and rename() call dont_mount() on the victim and then
detach_mounts() with the victim's inode locked. do_lock_mount() takes
the inode lock of the mountpoint and checks cant_mount() so a mount
can't show up after detach_mounts().

But attach_recursive_mnt() makes a second mountpoint for the root of the
source mount so that the mounts already located at the destination can
be put on top of it. No inode is locked for that one and d_set_mounted()
only refuses a dentry that is unlinked. Between detach_mounts() and
d_delete() the victim is still hashed:

  rmrace: b passed dont_mount() and detach_mounts(), sleeping
  T2: move_mount(S, /tmp/plcant/x, BENEATH) = 0 errno 0 ()
  T1: rmdir(/tmp/plcant/d/b) = 0 errno 0
      109 107 0:61 /d/b//deleted /tmp/plcant/x rw,relatime - tmpfs tmpfs rw
      108 109 0:63 / /tmp/plcant/x rw,relatime - tmpfs T rw

A bind mount of the directory that's being removed is moved beneath an
existing mount while the rmdir() is located between the two calls. The
mount ends up on the removed directory and nothing will ever detach it.

Check cant_mount() in d_set_mounted() as well. dont_mount() raises the
flag under d_lock before detach_mounts() runs so either the mountpoint
is set first and detach_mounts() finds the mount or the flag is seen and
the mount is refused.

Fixes: 1064f874abc0 ("mnt: Tuck mounts under others instead of creating shadow/side mounts.")
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260930-work-mount-fixes-3-v1-15-be34c83956ae@kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/dcache.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -1502,6 +1502,8 @@ EXPORT_SYMBOL(path_has_submounts);
  *
  * Only one of d_invalidate() and d_set_mounted() must succeed.  For
  * this reason take rename_lock and d_lock on dentry and ancestors.
+ * Likewise for dont_mount() which marks a dentry that is being removed
+ * under d_lock.
  */
 int d_set_mounted(struct dentry *dentry)
 {
@@ -1518,7 +1520,7 @@ int d_set_mounted(struct dentry *dentry)
 		spin_unlock(&p->d_lock);
 	}
 	spin_lock(&dentry->d_lock);
-	if (!d_unlinked(dentry)) {
+	if (!d_unlinked(dentry) && !cant_mount(dentry)) {
 		ret = -EBUSY;
 		if (!d_mountpoint(dentry)) {
 			dentry->d_flags |= DCACHE_MOUNTED;


