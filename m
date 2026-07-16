Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71548305678;
	Thu, 16 Jul 2026 13:45:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784209535; cv=none; b=B8x7PJ7IHTTS2Hw5+Pj2GnFxX6GNVxc5hBY5sVjsVmo/VW8kQlnZepp9eqStsjQ3qhZIY1N9fJlaLOjJT6w+sqyPW4/liNM/6C3/hs+F9l5+4OYNZVlZwE9r7TPOL60bXP1dcMMS/kMG/+U8wj45RQr9Wr+sf3gQfBxwqmdgYAQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784209535; c=relaxed/simple;
	bh=k0TZstvSv819D10lB1hEZAFC/ucmbiC4KrDvlpPkjLQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=atC+IX70lvLgBiwxKftzazM1XBp7uMNUgbY92eW1hK8X5TIDoDUS9LYgEgIh9x6JMEFHJk/bEDXtHI0ni8+lSx+OZP9UiOMLcbJQK+8LyiNMFnwrw4npRQBMRiuPRWI7Nc5MBnoncfWXo/3cKsFHLuPxHzVPC4Fr8wzC+G0hkSY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Vj8uAKrw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Vj8uAKrw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D59091F000E9;
	Thu, 16 Jul 2026 13:45:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784209534;
	bh=Bm/fOPjlhPv/G9nBhwdnTfVPAQsvaStkzFgi5oLf4T4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Vj8uAKrw24uYoCXFzCWWbJRSh+brFXHP0rWuBZT7oeYwVUgUgGZlquIi5YjzhUxir
	 d0NZd7G6O7OHnvoZgw9lKsXe6FfM6y+cskyF8BCba1nql8zAFkcSGVGOQrY7nRsp99
	 eCUo0G12MejwGG2+ovuUZY1qa7Rs3GnxVgtvUZa0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Musaab Khan <musaab.khan@protonmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 7.1 223/518] ksmbd: run set info with opener credentials
Date: Thu, 16 Jul 2026 15:28:11 +0200
Message-ID: <20260716133052.698627293@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
References: <20260716133047.772246337@linuxfoundation.org>
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
@@ -6630,6 +6630,7 @@ static int smb2_set_info_sec(struct ksmb
  */
 int smb2_set_info(struct ksmbd_work *work)
 {
+	const struct cred *saved_cred;
 	struct smb2_set_info_req *req;
 	struct smb2_set_info_rsp *rsp;
 	struct ksmbd_file *fp = NULL;
@@ -6671,6 +6672,7 @@ int smb2_set_info(struct ksmbd_work *wor
 		goto err_out;
 	}
 
+	saved_cred = override_creds(fp->filp->f_cred);
 	switch (req->InfoType) {
 	case SMB2_O_INFO_FILE:
 		ksmbd_debug(SMB, "GOT SMB2_O_INFO_FILE\n");
@@ -6678,19 +6680,15 @@ int smb2_set_info(struct ksmbd_work *wor
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


