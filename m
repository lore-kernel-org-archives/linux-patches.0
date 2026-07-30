Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D30B379988;
	Thu, 30 Jul 2026 15:10:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785424217; cv=none; b=liUbeq1hzd/gQhDp4ig0sJwty0noXYBOdUCzBRSzXXammhB+xUckj2Xjo4s5YBeU+zgKcYVh4gT/2PPI/rugcCofi6K6rKfiLDBZxQzxprfFNJk+FrfGRgZZF9ny06xXlr8RPLyVjt3Uv5CE/Cg7df8ZtfB4oWk6cSMVryo7t2w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785424217; c=relaxed/simple;
	bh=AdyxprBZU2dh6NuKx43Ed3OIgQ8xQ20pLtIljYDUMn4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TC834SBjdlvtc0Kzg7o1yNTy7UuWgS/4lHuDSRSiEDj653ROmJeUT9SmA9iUawwtJ43oADNmGluIknP82TEBqv4t7Keu96lPv7MbjfHL1bujIqld+n9RS/2/f9r7egB33r/MgUfNkxfDyOLwmgOpT5m7wpq5fHGqCeYDU187YcU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sycc5rpw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sycc5rpw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9DA21F000E9;
	Thu, 30 Jul 2026 15:10:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785424216;
	bh=nMg6qVHLwwm+K58ZXuwz0ubu38ninCqP2X8K3ldMRK8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sycc5rpwzmxarGc0XnWjg1FnnQahbRl2GGk+TVp8PpCSYWbUCXDt+b3mOav/mrE7m
	 vAHHEhs8XLGUFRIfT26jQ2N7eQdsblk8F3eN2D41fTxbOjY8+urPcn8IBxuaAixDVt
	 aOpcEvyc3CN1PshDgyVRkxQrQtj4DCozdos1y2aI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amir Goldstein <amir73il@gmail.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 272/675] ovl: check access to copy_file_range source with src mounter creds
Date: Thu, 30 Jul 2026 16:10:02 +0200
Message-ID: <20260730141450.910777205@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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
index 4374fbad3fc437..a857ce377b0cfb 100644
--- a/fs/overlayfs/file.c
+++ b/fs/overlayfs/file.c
@@ -541,6 +541,7 @@ static loff_t ovl_copyfile(struct file *file_in, loff_t pos_in,
 			    struct file *file_out, loff_t pos_out,
 			    loff_t len, unsigned int flags, enum ovl_copyop op)
 {
+	struct inode *inode_in = file_inode(file_in);
 	struct inode *inode_out = file_inode(file_out);
 	struct file *realfile_in, *realfile_out;
 	loff_t ret;
@@ -564,7 +565,20 @@ static loff_t ovl_copyfile(struct file *file_in, loff_t pos_in,
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



