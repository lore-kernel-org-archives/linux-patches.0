Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60CD64FDE71;
	Tue, 13 Oct 2026 12:06:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791893205; cv=none; b=rrjUyPM0LgF6rVHSszSvCZUpqk573QEekLbWuGEaeuGJXGfUj+qPpB/HOyiCn+COsQCSYbBaXe14Y56MRHl+Zlb7alANvnavvj6eRfD+2fjwSuKUJ+l4n4Rsoc8E3pu/bT+m9rya9hzRO9oYR5qGtZj2xRHwr6Jn/Jm/3bET5MI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791893205; c=relaxed/simple;
	bh=3lcw1qMRabj3tiY2M9CgI+twiW5W+Tq9l8zfNq8o7fI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RxGeTk2y96RhP6egNYRcZ8NYa1j7wMjcQ7C14YU2BuBHZNRGq2AMnnshlfMrPrM3+XZ38KDkeeAfGjBHNlNOc1SjQdXsgl1cOYq7fMwj9WNlMVHawnLlKLZu14MfUIc3Lv403s1p4sAIDNpG0JfFEhHqB9UkY35O76GRGHSz0RQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W5KFOei/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W5KFOei/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B683C1F000FF;
	Tue, 13 Oct 2026 12:06:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791893204;
	bh=n9GZr7JhyTqDMljV5iMSViElgFy1fZcaA6k84/TJ5ag=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=W5KFOei/JyUJTPrtcgst8RkNE1gU7uCE1+gl/DhPWzy11jS5uL1WwXifdKye5l1+Q
	 vVzMVqzjLGNdOTES+6ZhkWRWZH5cZDTHDfrTGHLyML+amuzD4VtJfh0SF/x51s8R9Q
	 gmsIj4ve3kL63qoZO1TSeDo3j5p4ii7a18BDNHSU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Christian Brauner (Amutable)" <brauner@kernel.org>
Subject: [PATCH 6.18 147/621] namespace: never expire a locked mount
Date: Tue, 13 Oct 2026 13:32:22 +0200
Message-ID: <20261013112924.343047000@linuxfoundation.org>
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

commit f78ddcc872248c7aa1d7e904928441a0be4c6d5d upstream.

Locked mounts are special. They protect the underlying files and
directories from being revealed. do_umount() refuses to unmount locked
mounts but shrink_submounts() doesn't.

A shrinkable mount can become locked once the owner of a user namespace
puts it beneath a locked mount with MOVE_MOUNT_BENEATH. The locked
property now moves to the mount at the bottom making it possible to
unmount the top mount.

So umount() of an unlocked ancestor now expires the bottom mount first
and the covered directory is revealed:

  move_mount(c -> x/hidden, MOVE_MOUNT_BENEATH) = 0
  the cover after the lock moved:  umount2(x/hidden) = 0
  the holder of the lock:          umount2(x/hidden) = EINVAL
  the root of the copy, busy:      umount2(x) = EBUSY
  reads x/hidden/secret: "covered-by-root"

So leave a locked mount alone as it dies together with its parent. A
plain umount() of an unlocked mount with a locked one below it is EBUSY
from now on. It's the same for any other locked child. A lazy umount
still takes the whole tree.

mark_mounts_for_expiry() never sees a locked mount. lock_mnt_tree()
leaves a mount on an expiry list alone and nothing else puts a locked
one on such a list. Add an assert for this.

Fixes: 5ff9d8a65ce8 ("vfs: Lock in place mounts from more privileged users")
Fixes: c62a4766937e ("move_mount: transfer MNT_LOCKED")
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20261002-work-mount-fixes-4-v1-8-dd44b89d44ce@kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/namespace.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -3849,6 +3849,8 @@ void mark_mounts_for_expiry(struct list_
 	list_for_each_entry_safe(mnt, next, mounts, mnt_expire) {
 		if (!is_mounted(&mnt->mnt))
 			continue;
+		/* lock_mnt_tree() leaves expirable mounts alone */
+		VFS_WARN_ON_ONCE(IS_MNT_LOCKED(mnt));
 		if (!xchg(&mnt->mnt_expiry_mark, 1) ||
 			propagate_mount_busy(mnt, 1))
 			continue;
@@ -3875,7 +3877,8 @@ EXPORT_SYMBOL_GPL(mark_mounts_for_expiry
  */
 static bool shrink_submount(struct mount *mnt)
 {
-	if (propagate_mount_busy(mnt, 1))
+	/* not the kernel's to remove either */
+	if (IS_MNT_LOCKED(mnt) || propagate_mount_busy(mnt, 1))
 		return false;
 	touch_mnt_namespace(mnt->mnt_ns);
 	umount_tree(mnt, UMOUNT_PROPAGATE|UMOUNT_SYNC);


