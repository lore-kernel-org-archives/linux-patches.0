Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F2DF42F705;
	Thu, 16 Jul 2026 14:27:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784212022; cv=none; b=Y33QoLGKBPODzmBo8+kHVd2AmNXK0YD0VLQYUWfbNrYpTCE6lZtBN0ZS/dCw6JkT8fSfLH02qcIRrWt49PStROCVjKFwoFgsjXQtGcDPERw9JQssLqJHa/U7Wjf/hKnNVcjHFke1WhPrUTXf1MBKoDlZASvEo2+xpjFj2fAAsf4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784212022; c=relaxed/simple;
	bh=TLJMpt/JOPxkvpcTNmIEgGESW/tjdyWc2ebvVjeHblk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jABAZJeZApTUvMh3jjr1I5oNBcfXK0Q6D8FKalzTD+w5730n7ojn4yduFdCt0N69ke5RKj6LmT7i8vrOT61NCFQtG6zBZOoU8VtO0xBe6NDmLpKZgimPSx4j9Qr+MqPSf7c1kg/TDMeg5gbQo2j+v2LUI8kd3j5bkS+hXlleLeI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ODIE0CK6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ODIE0CK6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBE101F00A3A;
	Thu, 16 Jul 2026 14:27:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784212021;
	bh=2Zmk4EOBy2jAH0MfmQRlYuy2/gl0eO1KIjOWknFZKrw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ODIE0CK69qDUJdVARL20RTKJ+2OyWRI+wX/HHvudCa/xR2JfaFw3cS9zphFzOG4SH
	 h0BhmrNgsDYowr6VICOMLTv5oeB9VAnBxNMcPrTryz45F60fKb1jCOqIK7LjuPOUIf
	 BML4sPIXkZ7prVyEPa/Komw2mXsKo4mAXavtsm+s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Musaab Khan <musaab.khan@protonmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.12 169/349] ksmbd: run set info with opener credentials
Date: Thu, 16 Jul 2026 15:31:43 +0200
Message-ID: <20260716133037.163432477@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133033.287196923@linuxfoundation.org>
References: <20260716133033.287196923@linuxfoundation.org>
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

commit b383bcad3d2fe634b26efbce53e22bbb5753a520 upstream.

SMB2 SET_INFO handlers call path-based VFS helpers after checking the
access mask granted to the SMB handle. Those helpers perform their owner,
inode permission and LSM checks using the current ksmbd worker credentials.

Run the complete SET_INFO dispatch with the credentials captured when the
handle was opened. This also removes the separate security information
credential setup and keeps all SET_INFO classes under one credential scope.

Direct override_creds() is used because it can nest with the request
credential overrides already used by rename and link helpers.

Cc: stable@vger.kernel.org
Reported-by: Musaab Khan <musaab.khan@protonmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/smb2pdu.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -6592,6 +6592,7 @@ static int smb2_set_info_sec(struct ksmb
  */
 int smb2_set_info(struct ksmbd_work *work)
 {
+	const struct cred *saved_cred;
 	struct smb2_set_info_req *req;
 	struct smb2_set_info_rsp *rsp;
 	struct ksmbd_file *fp = NULL;
@@ -6633,6 +6634,7 @@ int smb2_set_info(struct ksmbd_work *wor
 		goto err_out;
 	}
 
+	saved_cred = override_creds(fp->filp->f_cred);
 	switch (req->InfoType) {
 	case SMB2_O_INFO_FILE:
 		ksmbd_debug(SMB, "GOT SMB2_O_INFO_FILE\n");
@@ -6640,19 +6642,15 @@ int smb2_set_info(struct ksmbd_work *wor
 		break;
 	case SMB2_O_INFO_SECURITY:
 		ksmbd_debug(SMB, "GOT SMB2_O_INFO_SECURITY\n");
-		if (ksmbd_override_fsids(work)) {
-			rc = -ENOMEM;
-			goto err_out;
-		}
 		rc = smb2_set_info_sec(fp,
 				       le32_to_cpu(req->AdditionalInformation),
 				       (char *)req + le16_to_cpu(req->BufferOffset),
 				       le32_to_cpu(req->BufferLength));
-		ksmbd_revert_fsids(work);
 		break;
 	default:
 		rc = -EOPNOTSUPP;
 	}
+	revert_creds(saved_cred);
 
 	if (rc < 0)
 		goto err_out;


