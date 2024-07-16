Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3601117A93F;
	Tue, 16 Jul 2024 15:54:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721145298; cv=none; b=PE+lGN6nSab5gi9jmPxA2NTh6BixkeMqhKrI/tpggOI8K+ibbXaN1kMOGPOVJmiE1PEYH3R5hsvJymyDn2We1KEKhVO4d/XU7CbNamGQjZ9zWL7N2/MP/UkGvRE9jpNhEycnSR/eyxni4gWC1Fcm80+xVKlE0GvEvzdFOWD5+s4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721145298; c=relaxed/simple;
	bh=x6w91sC4lEfC4CW+MWQCrMGSO5ZZDxzAlBLBUs5SU8Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uErOq/xOaM2nTeFQkMaGRzBABkXxkAkrr5s1o/TBbJ0gw7yQycToouvr6boEfUwsb1fMGWhFrMiaxMoFrAmGgsEteQosEL9DQv1vk7sYOJuL+6QwoJKzHYSOG4YhcoO6DZkCs+6CkEjbOjzkF1U4Z8od3oFN36foTCi1p1S7CgE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Na9Cgjtz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Na9Cgjtz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF2EAC116B1;
	Tue, 16 Jul 2024 15:54:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721145298;
	bh=x6w91sC4lEfC4CW+MWQCrMGSO5ZZDxzAlBLBUs5SU8Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Na9Cgjtzx69hMMNWFLsTop6DJmrrMh/cYt2Otgz9ENpR2esXcsBBFuPCP13HoaMzp
	 zRhuZ1ftaAG0xD9XbaFDs7ymPnHt6DKjnXkxamPsc+fUskR9/Ftw2xzemsypGnjkkm
	 fO6+Ctpf+Z8Yb8gKOQ9jdN43+rtiheLg6W0yPAv4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baokun Li <libaokun1@huawei.com>,
	Gao Xiang <hsiangkao@linux.alibaba.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 02/96] cachefiles: propagate errors from vfs_getxattr() to avoid infinite loop
Date: Tue, 16 Jul 2024 17:31:13 +0200
Message-ID: <20240716152746.612752318@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152746.516194097@linuxfoundation.org>
References: <20240716152746.516194097@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Baokun Li <libaokun1@huawei.com>

[ Upstream commit 0ece614a52bc9d219b839a6a29282b30d10e0c48 ]

In cachefiles_check_volume_xattr(), the error returned by vfs_getxattr()
is not passed to ret, so it ends up returning -ESTALE, which leads to an
endless loop as follows:

cachefiles_acquire_volume
retry:
  ret = cachefiles_check_volume_xattr
    ret = -ESTALE
    xlen = vfs_getxattr // return -EIO
    // The ret is not updated when xlen < 0, so -ESTALE is returned.
    return ret
  // Supposed to jump out of the loop at this judgement.
  if (ret != -ESTALE)
      goto error_dir;
  cachefiles_bury_object
    //  EIO causes rename failure
  goto retry;

Hence propagate the error returned by vfs_getxattr() to avoid the above
issue. Do the same in cachefiles_check_auxdata().

Fixes: 32e150037dce ("fscache, cachefiles: Store the volume coherency data")
Fixes: 72b957856b0c ("cachefiles: Implement metadata/coherency data storage in xattrs")
Signed-off-by: Baokun Li <libaokun1@huawei.com>
Link: https://lore.kernel.org/r/20240628062930.2467993-5-libaokun@huaweicloud.com
Reviewed-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cachefiles/xattr.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/cachefiles/xattr.c b/fs/cachefiles/xattr.c
index 00b087c14995a..0ecfc9065047c 100644
--- a/fs/cachefiles/xattr.c
+++ b/fs/cachefiles/xattr.c
@@ -110,9 +110,11 @@ int cachefiles_check_auxdata(struct cachefiles_object *object, struct file *file
 	if (xlen == 0)
 		xlen = vfs_getxattr(&init_user_ns, dentry, cachefiles_xattr_cache, buf, tlen);
 	if (xlen != tlen) {
-		if (xlen < 0)
+		if (xlen < 0) {
+			ret = xlen;
 			trace_cachefiles_vfs_error(object, file_inode(file), xlen,
 						   cachefiles_trace_getxattr_error);
+		}
 		if (xlen == -EIO)
 			cachefiles_io_error_obj(
 				object,
@@ -252,6 +254,7 @@ int cachefiles_check_volume_xattr(struct cachefiles_volume *volume)
 		xlen = vfs_getxattr(&init_user_ns, dentry, cachefiles_xattr_cache, buf, len);
 	if (xlen != len) {
 		if (xlen < 0) {
+			ret = xlen;
 			trace_cachefiles_vfs_error(NULL, d_inode(dentry), xlen,
 						   cachefiles_trace_getxattr_error);
 			if (xlen == -EIO)
-- 
2.43.0



