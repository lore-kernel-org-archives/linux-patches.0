Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECEEB12B72;
	Tue, 16 Jul 2024 15:48:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721144884; cv=none; b=IWUfjjP6A6ngqBQ5/WsdEyzW/FOb5jx9s8xgKizvTQ6dQJkLEYJaCOalDq7cAWyvWwhS7Ng4c89IlkrhfHL8hQ0UKT0Jkak97Uxu8c4Gnk80aN8eI4XggiBktt6XzWy07Medl9zNrHLp17MuaOqfMTRs3ic36LttdInUu2QFphs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721144884; c=relaxed/simple;
	bh=Xg41I+gKstuJ8mlyC9vyl2o2g3+j7pIVfHIb5Z/U7BQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ncwnks4R4PlcsedYwmwSlNGbnhJYpsoqSWARkOmEXKB+ccf4ne1wjdQNDIhjjehPdYS5TcpAJf5SM3RBpcLXb4Z9ko67y15ZtjnFhZuLlbsI42uFIk5169GpCYL/cbDSim/M9s6Jh+WHssX4EL8QKjFJHfaw5jDWdgWP0yca9JY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ObK+3Fl5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ObK+3Fl5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76230C116B1;
	Tue, 16 Jul 2024 15:48:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721144883;
	bh=Xg41I+gKstuJ8mlyC9vyl2o2g3+j7pIVfHIb5Z/U7BQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ObK+3Fl5KdA/wMXn+ssniA7bXRDtNY9lPK+mlxs/wQTRztbW+B9G+dPENc6OP8OYh
	 YhuSXBoE40RquSglSyl12+zJW40mI7j+LETOkZd2oy1zDT/wPhiB8PaoIXzqC+LyX+
	 JO6n9HDVZvdAk+JCMVv3KQamjuH5YGqWeJoqRank=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baokun Li <libaokun1@huawei.com>,
	Gao Xiang <hsiangkao@linux.alibaba.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 006/143] cachefiles: propagate errors from vfs_getxattr() to avoid infinite loop
Date: Tue, 16 Jul 2024 17:30:02 +0200
Message-ID: <20240716152756.231176514@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152755.980289992@linuxfoundation.org>
References: <20240716152755.980289992@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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
index bcb6173943ee4..4dd8a993c60a8 100644
--- a/fs/cachefiles/xattr.c
+++ b/fs/cachefiles/xattr.c
@@ -110,9 +110,11 @@ int cachefiles_check_auxdata(struct cachefiles_object *object, struct file *file
 	if (xlen == 0)
 		xlen = vfs_getxattr(&nop_mnt_idmap, dentry, cachefiles_xattr_cache, buf, tlen);
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
 		xlen = vfs_getxattr(&nop_mnt_idmap, dentry, cachefiles_xattr_cache, buf, len);
 	if (xlen != len) {
 		if (xlen < 0) {
+			ret = xlen;
 			trace_cachefiles_vfs_error(NULL, d_inode(dentry), xlen,
 						   cachefiles_trace_getxattr_error);
 			if (xlen == -EIO)
-- 
2.43.0



