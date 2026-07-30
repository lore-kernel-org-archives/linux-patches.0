Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67EF843B6D1;
	Thu, 30 Jul 2026 14:34:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785422043; cv=none; b=jc5hVhX8eLirFW0qSOM6Yzt2KfoBpOTufiOkUYLhmQ217Z45gtg7budFi7F6Cz3+TXVwxMIrnCapYAY3TNsSpRF63bbxcMb6P9On3JHMYJiRROS2U3e5u4qxT7QWm8ORQQqvp2IeldrfuzpbqX/y2A8Mq4dDJ1rRSgTkx5tyJ9s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785422043; c=relaxed/simple;
	bh=9gpch5OU27zuMPP4RWxsm85zM0MC7ZFRFH8vjNBIPx8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HUTtfjTCF/A7mCmYMgmeVKuz9WZqsxb/oZqrZBkurfHTAIYrSyn/X0F1bbOey5R6Bd2bJYN/s7eIQFZhj/gpbKyYadM8s/lcNUOveK1B/f2Qs1XD06+PHKx311alJl7a0EYLZmmgmojg2A7l4r5UBOvomk4NQ4Na5lddA4mmKPQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TPMyOi4w; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TPMyOi4w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7555A1F000E9;
	Thu, 30 Jul 2026 14:34:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785422042;
	bh=SXTtY01KPPTFMp64FrzbVAQCxYhutzf8i8DXyzNioHM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TPMyOi4w1Qd0JE45Q3Ud0I2YADG7diPzGG4/Z94fQhTb56SIAFugd0OnqdCoWcpxW
	 rthirjUrTnpxiDdBxiIe44zUiJ87yc4UqY/3NU8QZp9fZtZqEYi2OTRNIZcXD6VQ8p
	 fBtP2yJ6kSj05/B3oOq+S5aPNsm8zxw08WCRCK10=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amir Goldstein <amir73il@gmail.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 304/744] ovl: check access to copy_file_range source with src mounter creds
Date: Thu, 30 Jul 2026 16:09:37 +0200
Message-ID: <20260730141450.752377269@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Amir Goldstein <amir73il@gmail.com>

[ Upstream commit a1e0eb8f55cfe09bb31a202a388babc411292656 ]

Commit 5dae222a5ff0c ("vfs: allow copy_file_range to copy across devices")
allowed filesystems that implement the copy_file_range() f_op to decide
if they want to access cross-sb copy from/to the same fs type.

The same commit added checks to verify same sb copy for filesystems that
implement ->copy_file_range() and do not support cross-sb copy at the
time, namely, to ceph, fuse and nfs.

The two remaining fs which implement ->copy_file_range(), cifs and
overlayfs started to support cross-sb copy from this time.

While overlayfs does support cross-sb copy when the two underlying files
are on the same base fs, the copy operation on the two real files from
two different overalyfs filesystems is performed with the mounter
creds of the destination overlayfs and the read permission access hook
for the source file was called with the wrong creds.

This could cause either deny of access to copy which would otherwise be
allowed (e.g. with splice) or allow read access to file which would
otherwise be denied.

Fix the latter case by explicitly verifying read access to source file
with the source overlayfs mounter creds.

The former case remains a quirk of cross-sb overlayfs copy, but
userspace could fall back to regular copy so no harm done.

Fixes: 5dae222a5ff0c ("vfs: allow copy_file_range to copy across devices")
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Link: https://patch.msgid.link/20260712122421.203113-1-amir73il@gmail.com
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/overlayfs/file.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/fs/overlayfs/file.c b/fs/overlayfs/file.c
index 27cc07738f33bf..f3d97eb146e85b 100644
--- a/fs/overlayfs/file.c
+++ b/fs/overlayfs/file.c
@@ -528,6 +528,7 @@ static loff_t ovl_copyfile(struct file *file_in, loff_t pos_in,
 			    struct file *file_out, loff_t pos_out,
 			    loff_t len, unsigned int flags, enum ovl_copyop op)
 {
+	struct inode *inode_in = file_inode(file_in);
 	struct inode *inode_out = file_inode(file_out);
 	struct file *realfile_in, *realfile_out;
 	loff_t ret;
@@ -551,7 +552,20 @@ static loff_t ovl_copyfile(struct file *file_in, loff_t pos_in,
 	if (IS_ERR(realfile_in))
 		goto out_unlock;
 
-	with_ovl_creds(file_inode(file_out)->i_sb) {
+	/*
+	 * For cross-sb copy, vfs_copy_file_range() will verify read access with
+	 * the mounter creds of the dest fs mounter, so we need to explicitly
+	 * verify read access with the source mounter creds.
+	 */
+	if (unlikely(inode_in->i_sb != inode_out->i_sb)) {
+		with_ovl_creds(inode_in->i_sb) {
+			ret = rw_verify_area(READ, realfile_in, &pos_in, len);
+			if (unlikely(ret))
+				goto out_unlock;
+		}
+	}
+
+	with_ovl_creds(inode_out->i_sb) {
 		switch (op) {
 		case OVL_COPY:
 			ret = vfs_copy_file_range(realfile_in, pos_in,
-- 
2.53.0



