Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE8FC4F403D;
	Tue, 13 Oct 2026 11:53:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791892414; cv=none; b=VH3R3oG6lOt2GRm+qVDcC+WXaM4UgnLy1Mmv0Yzk5HWWGLEYVKTnVe1OvZlr2QoqydyG15/4xyvoG0odSpMKe6gUfqJ6edigGHXLsIHiGMTF9op+Z/wvQv3OZdP2efmEjwz8MYpCu//9OP2ZQZd9FSNlv3vB0EYpl6bAvcq9Xug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791892414; c=relaxed/simple;
	bh=7vkt4cFL8NimnLVcD7V5UUis2LcwKgaHR4LEfALAYHw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sNe0iEZVEFXXv+dZOaf9eylX0SIHWKwAXDDJoZXQjZQJNkl6SK54Px+QmZWptKRuT5Pbe6EHwhesiL0/F5gOf0EFPdVF7neoOA3+MfNgp0tHU33M660osvPQ89VHFJwbm5+pdLFA2W2oa20iX6BhsgYl555fbnT+oDfDS1Pod4E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=avdc+dUk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="avdc+dUk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D902A1F000FF;
	Tue, 13 Oct 2026 11:53:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791892413;
	bh=CcKr6KKxlZl1AsCF7fi7FSFGDK4C601FGmlHInErqIw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=avdc+dUkKVC/im97xNmXuOS8Z1eZM8e8IICveYrpiVflau95YtlkUV223sE5dbrhP
	 8BfjqgIrKNGNzg9ki7FjVhKEKkz6Rt9WiCUW2hL1fW7uBf4nIuyLzoC+z38j7UrsfS
	 cuzzKZqfeeQhRUzNKWXzXs5tA/Bkv2uN3pt4E6po=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Christian Brauner (Amutable)" <brauner@kernel.org>
Subject: [PATCH 7.2 163/281] dcache: dont put a mountpoint on a dentry thats being removed
Date: Tue, 13 Oct 2026 13:37:59 +0200
Message-ID: <20261013112859.120867467@linuxfoundation.org>
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
@@ -1583,6 +1583,8 @@ EXPORT_SYMBOL(path_has_submounts);
  *
  * Only one of d_invalidate() and d_set_mounted() must succeed.  For
  * this reason take rename_lock and d_lock on dentry and ancestors.
+ * Likewise for dont_mount() which marks a dentry that is being removed
+ * under d_lock.
  */
 int d_set_mounted(struct dentry *dentry)
 {
@@ -1599,7 +1601,7 @@ int d_set_mounted(struct dentry *dentry)
 		spin_unlock(&p->d_lock);
 	}
 	spin_lock(&dentry->d_lock);
-	if (!d_unlinked(dentry)) {
+	if (!d_unlinked(dentry) && !cant_mount(dentry)) {
 		ret = -EBUSY;
 		if (!d_mountpoint(dentry)) {
 			dentry->d_flags |= DCACHE_MOUNTED;


