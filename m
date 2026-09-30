Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B796D344D9D;
	Wed, 30 Sep 2026 18:56:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790794581; cv=none; b=BBkA7xvpYtJ6ViljMRz+6CQt17GycNXPWOkaU282PurEtYy/I+j6duhwJyJmNVpnJf5CIBhzCm11MmImDkRSkY3jgg9AS/ycNMJo/dFCOrUMhY5VyzQYpUMmAROwoSBYkCDaaMBFZ/586euqM5NIasgrUBTuXpimeqIsWNf4P1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790794581; c=relaxed/simple;
	bh=S7weIcunjk/QHkdZIRPsbEcvgrKLyW8uIYnNW8Qwh0o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W+RcIuJuJWfqFPu+0ON3b0ALJjKztB22bx1BEBN2BUx5X3BqeSvf/ylppNKNxNcRGLsyRBw6Rd+8i31MNA3CV6Am/SPLSZcoXFSTIjW51qGnt3USwi6u9ZSj/l2DeZwQTkMun4JAM7OxNo/lblxxAYdVRgprNRdu8NUW+oNFWGo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NUwjBADC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NUwjBADC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EB1E1F000FF;
	Wed, 30 Sep 2026 18:56:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790794580;
	bh=/WyQjV2yDDMVjnkjjX3GFVS+qV6gxj+PoEfRt9plB2s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NUwjBADCoonGevrHPSL173wW0zGfkhMYhlwhTNc7QZFzryhXd78hVD5cn3g5ch41s
	 VbTzDNxpEE9/qUypqjlTMbbDGXKnfy5Ia2suLT1vdzRQCBE63alJsEQKlkgHgOaYes
	 F5HQ+p6/DxMaFab1oerVFT6XqiV3+2f/lUWXmiD8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0260/1193] ksmbd: break RH leases before delete-on-close
Date: Wed, 30 Sep 2026 17:15:44 +0200
Message-ID: <20260930152439.947129945@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit 1f1083c36fa11c5d9011451c7b9ab380545c72ea ]

The delete paths only marked the opened file delete pending or
delete-on-close.  When another client still held a read/handle lease, no
lease break was sent before the delete state changed.

smb2.lease.unlink uses a create request with FILE_DELETE_ON_CLOSE and
expects the second client's unlink to break the first client's RH lease to
R with ACK_REQUIRED set.  SetInfo(FileDispositionInformation) has the same
lease-breaking requirement.

Break level-II/read-handle leases before setting delete pending or
delete-on-close so clients are notified before the file is removed.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/smb2pdu.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 6c6da0125c4f8..e9a3fed457c38 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -3532,8 +3532,10 @@ int smb2_open(struct ksmbd_work *work)
 			goto err_out1;
 	}
 
-	if (req->CreateOptions & FILE_DELETE_ON_CLOSE_LE)
+	if (req->CreateOptions & FILE_DELETE_ON_CLOSE_LE) {
+		smb_break_all_levII_oplock(work, fp, 0);
 		ksmbd_fd_set_delete_on_close(fp, file_info);
+	}
 
 	if (need_truncate) {
 		rc = smb2_create_truncate(&fp->filp->f_path);
@@ -6427,7 +6429,8 @@ static int set_rename_info(struct ksmbd_work *work, struct ksmbd_file *fp,
 	return smb2_rename(work, fp, rename_info, work->conn->local_nls);
 }
 
-static int set_file_disposition_info(struct ksmbd_file *fp,
+static int set_file_disposition_info(struct ksmbd_work *work,
+				     struct ksmbd_file *fp,
 				     struct smb2_file_disposition_info *file_info)
 {
 	struct inode *inode;
@@ -6442,6 +6445,7 @@ static int set_file_disposition_info(struct ksmbd_file *fp,
 		if (S_ISDIR(inode->i_mode) &&
 		    ksmbd_vfs_empty_dir(fp) == -ENOTEMPTY)
 			return -EBUSY;
+		smb_break_all_levII_oplock(work, fp, 0);
 		ksmbd_set_inode_pending_delete(fp);
 	} else {
 		ksmbd_clear_inode_pending_delete(fp);
@@ -6565,7 +6569,7 @@ static int smb2_set_info_file(struct ksmbd_work *work, struct ksmbd_file *fp,
 		if (buf_len < sizeof(struct smb2_file_disposition_info))
 			return -EINVAL;
 
-		return set_file_disposition_info(fp,
+		return set_file_disposition_info(work, fp,
 						 (struct smb2_file_disposition_info *)buffer);
 	}
 	case FILE_FULL_EA_INFORMATION:
-- 
2.53.0



