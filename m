Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F329C3C9892;
	Thu, 17 Sep 2026 18:03:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789668239; cv=none; b=nmIUjUnXP6B1bBMjwgkayQsHAlqqjx2gXpm3yC7WSbMfxBFCwfejYbybaBhChDCueLhuVpgaiy0YpoU0XhUVRj8GpNBWOS/8eKpryoDxsqfDM63wAE7qwL4SgqNjHwb+8Ui6y96yoemV79pZyuYG9WNyy+QPgEAUHWd3dJ3rnwY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789668239; c=relaxed/simple;
	bh=DcifOI/Sszrb0E4/TANNi/e4WP0tm6CqWYlZAVg1iPk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g15iHg14e1OuxpuDkM7D2AisNP7LggQnUk4tZZa7RPxpNIzg8kni1QnfeB0reAcY0SJdJb0zD6pjdelSvoav+fR7eAurNnUwdp7QDkpue6tfCRvKsf8S9dcOFxXiJs00ULS2wmXRX1QcQQHiNC24M/LbY3rQEPX7dkrO2GvcHYw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IohsR2Cx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IohsR2Cx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 537551F000FF;
	Thu, 17 Sep 2026 18:03:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789668237;
	bh=SdNRlKz6KuNOS4OQtN4EFmOyK06Ooo6Gt1aMuPApyYI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IohsR2CxSe+CESJeG/Cbo32jcg/S1X7k5Ndl3VZ5z3o6BWMoyWlLfI218kcoFlAMt
	 +eJ046rSzNDMdq90w/Xni5sxlVWtFPG1XQJNSrX4QYjfjgwZCKGwOH5fQTGlKbWfLz
	 OiWUt7GbcKZnFQY+ARaURNxgWfv2f4jetQGgs1vk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0358/1102] ksmbd: break RH leases before delete-on-close
Date: Thu, 17 Sep 2026 16:05:01 +0100
Message-ID: <20260917151548.634757603@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 09c97814fc9c0..5526006979269 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -3553,8 +3553,10 @@ int smb2_open(struct ksmbd_work *work)
 			goto err_out1;
 	}
 
-	if (req->CreateOptions & FILE_DELETE_ON_CLOSE_LE)
+	if (req->CreateOptions & FILE_DELETE_ON_CLOSE_LE) {
+		smb_break_all_levII_oplock(work, fp, 0);
 		ksmbd_fd_set_delete_on_close(fp, file_info);
+	}
 
 	if (need_truncate) {
 		rc = smb2_create_truncate(&fp->filp->f_path);
@@ -6449,7 +6451,8 @@ static int set_rename_info(struct ksmbd_work *work, struct ksmbd_file *fp,
 	return smb2_rename(work, fp, rename_info, work->conn->local_nls);
 }
 
-static int set_file_disposition_info(struct ksmbd_file *fp,
+static int set_file_disposition_info(struct ksmbd_work *work,
+				     struct ksmbd_file *fp,
 				     struct smb2_file_disposition_info *file_info)
 {
 	struct inode *inode;
@@ -6464,6 +6467,7 @@ static int set_file_disposition_info(struct ksmbd_file *fp,
 		if (S_ISDIR(inode->i_mode) &&
 		    ksmbd_vfs_empty_dir(fp) == -ENOTEMPTY)
 			return -EBUSY;
+		smb_break_all_levII_oplock(work, fp, 0);
 		ksmbd_set_inode_pending_delete(fp);
 	} else {
 		ksmbd_clear_inode_pending_delete(fp);
@@ -6587,7 +6591,7 @@ static int smb2_set_info_file(struct ksmbd_work *work, struct ksmbd_file *fp,
 		if (buf_len < sizeof(struct smb2_file_disposition_info))
 			return -EINVAL;
 
-		return set_file_disposition_info(fp,
+		return set_file_disposition_info(work, fp,
 						 (struct smb2_file_disposition_info *)buffer);
 	}
 	case FILE_FULL_EA_INFORMATION:
-- 
2.53.0



