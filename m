Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CB103BE16E;
	Sat, 17 Oct 2026 17:47:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792259243; cv=none; b=GX504yvrjlAUAliZ7kdUUGGoFGTYAJabmRZUQXjjPMKLFwGX/by861lf3ckHdkFpwUnwXISvBTFxcBLHOzodnL7TUCtq/TfJuQeQsDzUalVFe55g1YSGyQreWhfvtmhEp25oxCg4tWoxIjPWHrbICmyslSFHRtbtXisvnxAD5Zg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792259243; c=relaxed/simple;
	bh=pJkHYbnq/uPDaRaah/BpM+7Qii9NKa6G/DAHwhatp6I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f1ez1Y1Jgb8WH6GIGxsdRuBv+PZv3gZHPk5IYfUUU/MGTScy8Xr52lmWXz6uMxT+13iXNM+x+V0XBBpa8IMDrdC23leDxhrAARTDHRFQKJvLhueqbKN/dgevIBLVPUDGtTPgC5ubTod81czU5/bB0Y4cRsahEEeGUASOeSv0+Zs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NFFmqu2O; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NFFmqu2O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4E721F000C4;
	Sat, 17 Oct 2026 17:47:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792259242;
	bh=3vR508lTnoYUx8UDeiYQqrUcywATWNq2n7hM/t9l2LE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NFFmqu2OacGThKtn4jWXp8WQz4wClXtZVpIjHP7kgV7yI7q/8T1K5xEaFiRjBwVzo
	 P3zexQREGVoTE/K7YQEn/g8WJgwwrnyT7mOfPTN/Hq0IibvAyWk8dQHOdfS3KaZwrz
	 6GWgLFldGepakkk+8bct6NfK1U8izVlAXOng/zao=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amir Goldstein <amir73il@gmail.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1110/1674] ovl: check access to copy_file_range source with src mounter creds
Date: Sat, 17 Oct 2026 17:56:22 +0200
Message-ID: <20261017160459.619286199@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
 fs/overlayfs/file.c | 19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

diff --git a/fs/overlayfs/file.c b/fs/overlayfs/file.c
index 07f00cf91977e..a493eed7f6053 100644
--- a/fs/overlayfs/file.c
+++ b/fs/overlayfs/file.c
@@ -615,6 +615,7 @@ static loff_t ovl_copyfile(struct file *file_in, loff_t pos_in,
 			    struct file *file_out, loff_t pos_out,
 			    loff_t len, unsigned int flags, enum ovl_copyop op)
 {
+	struct inode *inode_in = file_inode(file_in);
 	struct inode *inode_out = file_inode(file_out);
 	struct fd real_in, real_out;
 	const struct cred *old_cred;
@@ -639,7 +640,23 @@ static loff_t ovl_copyfile(struct file *file_in, loff_t pos_in,
 		goto out_unlock;
 	}
 
-	old_cred = ovl_override_creds(file_inode(file_out)->i_sb);
+	/*
+	 * For cross-sb copy, vfs_copy_file_range() will verify read access with
+	 * the mounter creds of the dest fs mounter, so we need to explicitly
+	 * verify read access with the source mounter creds.
+	 */
+	if (unlikely(inode_in->i_sb != inode_out->i_sb)) {
+		old_cred = ovl_override_creds(inode_in->i_sb);
+		ret = rw_verify_area(READ, real_in.file, &pos_in, len);
+		revert_creds(old_cred);
+		if (unlikely(ret)) {
+			fdput(real_in);
+			fdput(real_out);
+			goto out_unlock;
+		}
+	}
+
+	old_cred = ovl_override_creds(inode_out->i_sb);
 	switch (op) {
 	case OVL_COPY:
 		ret = vfs_copy_file_range(real_in.file, pos_in,
-- 
2.53.0



