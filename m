Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA60B4DB566;
	Tue, 21 Jul 2026 18:45:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784659514; cv=none; b=KFLqERA1/zV3p/bHx51IEVc9cBLS5M+pqyTF6TyDv59xQt/GrY93dajVDg0MDMfn6VlJ5aWzlqGJYE2WakiC1sZkn0op2doF2Yu49P9RyGK38+zs/VNWKqdwmv8EPiWSgVsfAtqJqARdF1RveT516OqNSmnBQTfY6zNtsI4iNzM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784659514; c=relaxed/simple;
	bh=rvaodVS3QDF5oyKrTETBzGAsm8Vgqji1HKgkUSSoFSI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hbX4qNhI4yZGkpa2J+Ok94LwRESJ9pm7LbdFaJnqeyfhD9AQOZM6J53ro6lZvewvegCj/CvJswJtMfqFDBQpsXRTWihcawuMEj63pGNAD6tKnPpJVNNsn6aKJMwvd2hnU1vg4hac1vZpPjFuRL07x+tYirw9tskJPFsCmgunJ6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eqxMXE6S; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eqxMXE6S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B7181F00A3A;
	Tue, 21 Jul 2026 18:45:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784659512;
	bh=2lpkDbl5b8bcWWztB96GMt9clp9G0o5NDbR+yOCPNGA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eqxMXE6SH45kWa+/AfunQMz9UXhs4JLriEqGbTSwbpgbWPPdkXLBB6hJU5WZaKoD4
	 DZrRfawV/exjZEk9yXS8PmitFAzkrZD99KWuC4PZH02dWKGQGSmxzNFKqCMmcP0QEk
	 T4x45TbGPxlzgmiPc6XnqyfmJvzMUR/DkH43e4mE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Musaab Khan <musaab.khan@protonmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1549/1611] ksmbd: use opener credentials for FSCTL mutations
Date: Tue, 21 Jul 2026 17:27:45 +0200
Message-ID: <20260721152550.294825084@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit c6394bcaf254c5baf9aff43376020be5db6d3316 ]

SET_SPARSE, SET_ZERO_DATA and SET_COMPRESSION operate on an open SMB
handle but call VFS xattr, fallocate or fileattr helpers with the current
ksmbd worker credentials. Those helpers can revalidate inode permissions,
ownership and LSM policy independently of the SMB handle access mask.

Run each operation with the credentials captured in the target file when
the handle was opened. Keep credential handling local to these single-file
FSCTLs rather than applying session credentials to the complete IOCTL
handler, which also contains handle-less and multi-handle operations.

Cc: stable@vger.kernel.org
Reported-by: Musaab Khan <musaab.khan@protonmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/smb2pdu.c |    3 +++
 fs/smb/server/vfs.c     |   20 +++++++++++++-------
 2 files changed, 16 insertions(+), 7 deletions(-)

--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -8273,6 +8273,7 @@ static inline int fsctl_set_sparse(struc
 	if (fp->f_ci->m_fattr != old_fattr &&
 	    test_share_config_flag(work->tcon->share_conf,
 				   KSMBD_SHARE_FLAG_STORE_DOS_ATTRS)) {
+		const struct cred *saved_cred;
 		struct xattr_dos_attrib da;
 
 		ret = ksmbd_vfs_get_dos_attrib_xattr(idmap,
@@ -8281,9 +8282,11 @@ static inline int fsctl_set_sparse(struc
 			goto out;
 
 		da.attr = le32_to_cpu(fp->f_ci->m_fattr);
+		saved_cred = override_creds(fp->filp->f_cred);
 		ret = ksmbd_vfs_set_dos_attrib_xattr(idmap,
 						     &fp->filp->f_path,
 						     &da, true);
+		revert_creds(saved_cred);
 		if (ret)
 			fp->f_ci->m_fattr = old_fattr;
 	}
--- a/fs/smb/server/vfs.c
+++ b/fs/smb/server/vfs.c
@@ -995,15 +995,21 @@ void ksmbd_vfs_set_fadvise(struct file *
 int ksmbd_vfs_zero_data(struct ksmbd_work *work, struct ksmbd_file *fp,
 			loff_t off, loff_t len)
 {
+	const struct cred *saved_cred;
+	int err;
+
 	smb_break_all_levII_oplock(work, fp, 1);
+	saved_cred = override_creds(fp->filp->f_cred);
 	if (fp->f_ci->m_fattr & FILE_ATTRIBUTE_SPARSE_FILE_LE)
-		return vfs_fallocate(fp->filp,
-				     FALLOC_FL_PUNCH_HOLE | FALLOC_FL_KEEP_SIZE,
-				     off, len);
-
-	return vfs_fallocate(fp->filp,
-			     FALLOC_FL_ZERO_RANGE | FALLOC_FL_KEEP_SIZE,
-			     off, len);
+		err = vfs_fallocate(fp->filp,
+				    FALLOC_FL_PUNCH_HOLE | FALLOC_FL_KEEP_SIZE,
+				    off, len);
+	else
+		err = vfs_fallocate(fp->filp,
+				    FALLOC_FL_ZERO_RANGE | FALLOC_FL_KEEP_SIZE,
+				    off, len);
+	revert_creds(saved_cred);
+	return err;
 }
 
 int ksmbd_vfs_fqar_lseek(struct ksmbd_file *fp, loff_t start, loff_t length,


