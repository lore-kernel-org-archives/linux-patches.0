Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A9E672618;
	Wed, 10 Dec 2025 03:49:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765338559; cv=none; b=aKy6i2rcDzj7GjwSQt/R5aiiSHohZKs+gpcm08Lj569T41G+NHpYChaH0zlLjAFyeNv6bfbf6lPJAuKe9GdqjF9QgSC0Kz+a1R2MhME5hXtuystpHIjskYO8GmhyWkTEaEgO/+AMGTmlLP0YeM/0vx8NNJ7UDouN+Jpi0ObS+PA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765338559; c=relaxed/simple;
	bh=EdoTQBVOSnfL3adtSB4OmKmM0oMbsG9LjOfOgavoKus=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=AmZIzV0qXgLRec777DoAwYZ8MZTkOcmwcp7YDbWuGmIrsjVy7qnE5pH/XihX+OoIWaL3U38qYEyO1Pjqei7EqhkoDFDmhOx86SNHgGP9K7ovhilqRNkvlY1iLVE+P2qvMdk1H3RaqyYKs+JUj2a7xZcBaXpr9w2aAJL6bdoGoVo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BQ/tx/RA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BQ/tx/RA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 541C0C4CEF1;
	Wed, 10 Dec 2025 03:49:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765338559;
	bh=EdoTQBVOSnfL3adtSB4OmKmM0oMbsG9LjOfOgavoKus=;
	h=From:To:Cc:Subject:Date:From;
	b=BQ/tx/RAIthZ91x7MqIa5xHl+LjySTlxrhfZHOJ9E8wLFwOrBWcisF81MLCyP9I92
	 LRdmEJ/CJgKxOsyNxJ7Y5m4JMlP3Yuvz5At2AHZC5itbSC7GA3Rc2lY0pUH4uuvN8O
	 89zlVrv0ZmqXrfOMYo6HwqBtjL7T4WeyWPMN9acKC1E1du4JE7pM/BP6884ybMXAdV
	 BM8/nNwDR+Tun1JLr+u0O29j21MbtcGYuJJ1Kr+8aCREkYQxYUKSUds8NktkRUzEdy
	 mVlkrzZhs8xtUuU9yuIv56hhY7JNxeU3Gw+4NGAc0XhdG7UygY4mzX4uliR7ykqzui
	 O1SQYN3qr9L/w==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Al Viro <viro@zeniv.linux.org.uk>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>,
	brauner@kernel.org,
	ingo.rohloff@lauterbach.com,
	nichen@iscas.ac.cn,
	mjguzik@gmail.com,
	guhuinan@xiaomi.com,
	liangjie@lixiang.com,
	akash.m5@samsung.com
Subject: [PATCH AUTOSEL 6.18-6.17] functionfs: fix the open/removal races
Date: Tue,  9 Dec 2025 22:48:42 -0500
Message-ID: <20251210034915.2268617-1-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Al Viro <viro@zeniv.linux.org.uk>

[ Upstream commit e5bf5ee266633cb18fff6f98f0b7d59a62819eee ]

ffs_epfile_open() can race with removal, ending up with file->private_data
pointing to freed object.

There is a total count of opened files on functionfs (both ep0 and
dynamic ones) and when it hits zero, dynamic files get removed.
Unfortunately, that removal can happen while another thread is
in ffs_epfile_open(), but has not incremented the count yet.
In that case open will succeed, leaving us with UAF on any subsequent
read() or write().

The root cause is that ffs->opened is misused; atomic_dec_and_test() vs.
atomic_add_return() is not a good idea, when object remains visible all
along.

To untangle that
	* serialize openers on ffs->mutex (both for ep0 and for dynamic files)
	* have dynamic ones use atomic_inc_not_zero() and fail if we had
zero ->opened; in that case the file we are opening is doomed.
	* have the inodes of dynamic files marked on removal (from the
callback of simple_recursive_removal()) - clear ->i_private there.
	* have open of dynamic ones verify they hadn't been already removed,
along with checking that state is FFS_ACTIVE.

Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Summary

### What the Commit Fixes

This commit fixes a **Use-After-Free (UAF)** vulnerability in USB gadget
functionfs. The race condition occurs between `ffs_epfile_open()` and
file removal:

1. Thread A is in `ffs_epfile_open()` but hasn't incremented
   `ffs->opened` yet
2. Thread B closes the last file handle, triggering removal (since
   `opened` is 0)
3. Thread A's open succeeds with `file->private_data` pointing to freed
   memory
4. Subsequent `read()`/`write()` operations cause UAF

### Fix Mechanism

The fix implements proper synchronization:
- Serializes openers using `ffs->mutex`
- Uses `atomic_inc_not_zero()` to fail if counter already zero
- Uses `smp_load_acquire()`/`smp_store_release()` for memory ordering
- Clears `i_private` during removal via `simple_recursive_removal()`
  callback
- Uses `file->private_data` instead of `inode->i_private` in release
  path

### Stable Kernel Criteria Assessment

| Criterion | Assessment |
|-----------|------------|
| Obviously correct | ✅ Uses standard kernel primitives, proper locking
patterns |
| Fixes real bug | ✅ UAF vulnerability, security-relevant |
| Important issue | ✅ Security bug, potential for crashes/exploitation |
| Small and contained | ✅ Single file, +43/-10 lines, localized changes
|
| No new features | ✅ Pure bug fix, no new APIs |

### Risk vs Benefit

**Benefits:**
- Fixes serious UAF vulnerability
- USB gadget functionfs used in Android, embedded systems
- Reviewed by Greg Kroah-Hartman (USB maintainer, stable maintainer)
- Written by Al Viro (highly respected kernel developer)

**Risks:**
- Moderate complexity (changes locking behavior)
- Recent commit (November 2025), limited mainline soak time
- No explicit `Cc: stable@vger.kernel.org` tag

### Dependencies

- `ffs_mutex_lock()` - exists in functionfs since early versions
- `simple_recursive_removal()` with callback - available since ~5.x
  kernels
- Standard kernel APIs (`atomic_inc_not_zero`, memory barriers) -
  universally available

### Concerns

1. **No Fixes: tag** - Makes it harder to determine which stable trees
   need this fix
2. **No Cc: stable tag** - May indicate maintainers wanted soak time, or
   an oversight given Greg KH reviewed it
3. **Backport effort** - May need adjustment for older stable trees
   depending on functionfs evolution

### Conclusion

This is a legitimate UAF security fix that affects real-world users
(Android, embedded USB gadgets). Despite moderate complexity, the fix:
- Addresses a serious vulnerability class (UAF)
- Uses correct synchronization patterns
- Has been reviewed by the appropriate maintainer who also maintains
  stable trees
- Is self-contained with no feature additions

The lack of explicit stable tags appears to be an oversight given the
security nature of the bug and Greg KH's review. UAF vulnerabilities
typically warrant expedited backporting.

**YES**

 drivers/usb/gadget/function/f_fs.c | 53 ++++++++++++++++++++++++------
 1 file changed, 43 insertions(+), 10 deletions(-)

diff --git a/drivers/usb/gadget/function/f_fs.c b/drivers/usb/gadget/function/f_fs.c
index 47cfbe41fdff8..69f6e3c0f7e00 100644
--- a/drivers/usb/gadget/function/f_fs.c
+++ b/drivers/usb/gadget/function/f_fs.c
@@ -640,13 +640,22 @@ static ssize_t ffs_ep0_read(struct file *file, char __user *buf,
 
 static int ffs_ep0_open(struct inode *inode, struct file *file)
 {
-	struct ffs_data *ffs = inode->i_private;
+	struct ffs_data *ffs = inode->i_sb->s_fs_info;
+	int ret;
 
-	if (ffs->state == FFS_CLOSING)
-		return -EBUSY;
+	/* Acquire mutex */
+	ret = ffs_mutex_lock(&ffs->mutex, file->f_flags & O_NONBLOCK);
+	if (ret < 0)
+		return ret;
 
-	file->private_data = ffs;
 	ffs_data_opened(ffs);
+	if (ffs->state == FFS_CLOSING) {
+		ffs_data_closed(ffs);
+		mutex_unlock(&ffs->mutex);
+		return -EBUSY;
+	}
+	mutex_unlock(&ffs->mutex);
+	file->private_data = ffs;
 
 	return stream_open(inode, file);
 }
@@ -1193,14 +1202,33 @@ static ssize_t ffs_epfile_io(struct file *file, struct ffs_io_data *io_data)
 static int
 ffs_epfile_open(struct inode *inode, struct file *file)
 {
-	struct ffs_epfile *epfile = inode->i_private;
+	struct ffs_data *ffs = inode->i_sb->s_fs_info;
+	struct ffs_epfile *epfile;
+	int ret;
 
-	if (WARN_ON(epfile->ffs->state != FFS_ACTIVE))
+	/* Acquire mutex */
+	ret = ffs_mutex_lock(&ffs->mutex, file->f_flags & O_NONBLOCK);
+	if (ret < 0)
+		return ret;
+
+	if (!atomic_inc_not_zero(&ffs->opened)) {
+		mutex_unlock(&ffs->mutex);
+		return -ENODEV;
+	}
+	/*
+	 * we want the state to be FFS_ACTIVE; FFS_ACTIVE alone is
+	 * not enough, though - we might have been through FFS_CLOSING
+	 * and back to FFS_ACTIVE, with our file already removed.
+	 */
+	epfile = smp_load_acquire(&inode->i_private);
+	if (unlikely(ffs->state != FFS_ACTIVE || !epfile)) {
+		mutex_unlock(&ffs->mutex);
+		ffs_data_closed(ffs);
 		return -ENODEV;
+	}
+	mutex_unlock(&ffs->mutex);
 
 	file->private_data = epfile;
-	ffs_data_opened(epfile->ffs);
-
 	return stream_open(inode, file);
 }
 
@@ -1332,7 +1360,7 @@ static void ffs_dmabuf_put(struct dma_buf_attachment *attach)
 static int
 ffs_epfile_release(struct inode *inode, struct file *file)
 {
-	struct ffs_epfile *epfile = inode->i_private;
+	struct ffs_epfile *epfile = file->private_data;
 	struct ffs_dmabuf_priv *priv, *tmp;
 	struct ffs_data *ffs = epfile->ffs;
 
@@ -2352,6 +2380,11 @@ static int ffs_epfiles_create(struct ffs_data *ffs)
 	return 0;
 }
 
+static void clear_one(struct dentry *dentry)
+{
+	smp_store_release(&dentry->d_inode->i_private, NULL);
+}
+
 static void ffs_epfiles_destroy(struct ffs_epfile *epfiles, unsigned count)
 {
 	struct ffs_epfile *epfile = epfiles;
@@ -2359,7 +2392,7 @@ static void ffs_epfiles_destroy(struct ffs_epfile *epfiles, unsigned count)
 	for (; count; --count, ++epfile) {
 		BUG_ON(mutex_is_locked(&epfile->mutex));
 		if (epfile->dentry) {
-			simple_recursive_removal(epfile->dentry, NULL);
+			simple_recursive_removal(epfile->dentry, clear_one);
 			epfile->dentry = NULL;
 		}
 	}
-- 
2.51.0

