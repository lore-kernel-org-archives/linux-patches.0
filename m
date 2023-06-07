Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A00241D2A5
	for <patches@lists.linux.dev>; Wed,  7 Jun 2023 20:46:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21686C433D2;
	Wed,  7 Jun 2023 20:46:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686170776;
	bh=S9gPJwb/sZGMauHLF9epA1QH+KD6C2dCnqvY/pksIOY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u2zxNBbpcBKBiO7XDj5bPpfQaECjvD/8/PyA4DewagF/r/OAlMJEGIAMt5Qtj1qLK
	 jWMRYjRWsd3cuvJ46yvyPvpxWtosPyfzuHL30sGK/7N7mQZDzCIBzKU/usINNedIOC
	 aPLnPhORsG+mDvwpbP37oyuIrhHgEbDoMs7Ci7tk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuan-Ting Chen <h3xrabbit@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.1 212/225] ksmbd: fix multiple out-of-bounds read during context decoding
Date: Wed,  7 Jun 2023 22:16:45 +0200
Message-ID: <20230607200921.301219766@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230607200913.334991024@linuxfoundation.org>
References: <20230607200913.334991024@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Kuan-Ting Chen <h3xrabbit@gmail.com>

commit 0512a5f89e1fae74251fde6893ff634f1c96c6fb upstream.

Check the remaining data length before accessing the context structure
to ensure that the entire structure is contained within the packet.
Additionally, since the context data length `ctxt_len` has already been
checked against the total packet length `len_of_ctxts`, update the
comparison to use `ctxt_len`.

Cc: stable@vger.kernel.org
Signed-off-by: Kuan-Ting Chen <h3xrabbit@gmail.com>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ksmbd/smb2pdu.c |   53 ++++++++++++++++++++++++++++++++++-------------------
 1 file changed, 34 insertions(+), 19 deletions(-)

--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -861,13 +861,14 @@ static void assemble_neg_contexts(struct
 
 static __le32 decode_preauth_ctxt(struct ksmbd_conn *conn,
 				  struct smb2_preauth_neg_context *pneg_ctxt,
-				  int len_of_ctxts)
+				  int ctxt_len)
 {
 	/*
 	 * sizeof(smb2_preauth_neg_context) assumes SMB311_SALT_SIZE Salt,
 	 * which may not be present. Only check for used HashAlgorithms[1].
 	 */
-	if (len_of_ctxts < MIN_PREAUTH_CTXT_DATA_LEN)
+	if (ctxt_len <
+	    sizeof(struct smb2_neg_context) + MIN_PREAUTH_CTXT_DATA_LEN)
 		return STATUS_INVALID_PARAMETER;
 
 	if (pneg_ctxt->HashAlgorithms != SMB2_PREAUTH_INTEGRITY_SHA512)
@@ -879,15 +880,23 @@ static __le32 decode_preauth_ctxt(struct
 
 static void decode_encrypt_ctxt(struct ksmbd_conn *conn,
 				struct smb2_encryption_neg_context *pneg_ctxt,
-				int len_of_ctxts)
+				int ctxt_len)
 {
-	int cph_cnt = le16_to_cpu(pneg_ctxt->CipherCount);
-	int i, cphs_size = cph_cnt * sizeof(__le16);
+	int cph_cnt;
+	int i, cphs_size;
+
+	if (sizeof(struct smb2_encryption_neg_context) > ctxt_len) {
+		pr_err("Invalid SMB2_ENCRYPTION_CAPABILITIES context size\n");
+		return;
+	}
 
 	conn->cipher_type = 0;
 
+	cph_cnt = le16_to_cpu(pneg_ctxt->CipherCount);
+	cphs_size = cph_cnt * sizeof(__le16);
+
 	if (sizeof(struct smb2_encryption_neg_context) + cphs_size >
-	    len_of_ctxts) {
+	    ctxt_len) {
 		pr_err("Invalid cipher count(%d)\n", cph_cnt);
 		return;
 	}
@@ -935,15 +944,22 @@ static void decode_compress_ctxt(struct
 
 static void decode_sign_cap_ctxt(struct ksmbd_conn *conn,
 				 struct smb2_signing_capabilities *pneg_ctxt,
-				 int len_of_ctxts)
+				 int ctxt_len)
 {
-	int sign_algo_cnt = le16_to_cpu(pneg_ctxt->SigningAlgorithmCount);
-	int i, sign_alos_size = sign_algo_cnt * sizeof(__le16);
+	int sign_algo_cnt;
+	int i, sign_alos_size;
+
+	if (sizeof(struct smb2_signing_capabilities) > ctxt_len) {
+		pr_err("Invalid SMB2_SIGNING_CAPABILITIES context length\n");
+		return;
+	}
 
 	conn->signing_negotiated = false;
+	sign_algo_cnt = le16_to_cpu(pneg_ctxt->SigningAlgorithmCount);
+	sign_alos_size = sign_algo_cnt * sizeof(__le16);
 
 	if (sizeof(struct smb2_signing_capabilities) + sign_alos_size >
-	    len_of_ctxts) {
+	    ctxt_len) {
 		pr_err("Invalid signing algorithm count(%d)\n", sign_algo_cnt);
 		return;
 	}
@@ -981,18 +997,16 @@ static __le32 deassemble_neg_contexts(st
 	len_of_ctxts = len_of_smb - offset;
 
 	while (i++ < neg_ctxt_cnt) {
-		int clen;
-
-		/* check that offset is not beyond end of SMB */
-		if (len_of_ctxts == 0)
-			break;
+		int clen, ctxt_len;
 
 		if (len_of_ctxts < sizeof(struct smb2_neg_context))
 			break;
 
 		pctx = (struct smb2_neg_context *)((char *)pctx + offset);
 		clen = le16_to_cpu(pctx->DataLength);
-		if (clen + sizeof(struct smb2_neg_context) > len_of_ctxts)
+		ctxt_len = clen + sizeof(struct smb2_neg_context);
+
+		if (ctxt_len > len_of_ctxts)
 			break;
 
 		if (pctx->ContextType == SMB2_PREAUTH_INTEGRITY_CAPABILITIES) {
@@ -1003,7 +1017,7 @@ static __le32 deassemble_neg_contexts(st
 
 			status = decode_preauth_ctxt(conn,
 						     (struct smb2_preauth_neg_context *)pctx,
-						     len_of_ctxts);
+						     ctxt_len);
 			if (status != STATUS_SUCCESS)
 				break;
 		} else if (pctx->ContextType == SMB2_ENCRYPTION_CAPABILITIES) {
@@ -1014,7 +1028,7 @@ static __le32 deassemble_neg_contexts(st
 
 			decode_encrypt_ctxt(conn,
 					    (struct smb2_encryption_neg_context *)pctx,
-					    len_of_ctxts);
+					    ctxt_len);
 		} else if (pctx->ContextType == SMB2_COMPRESSION_CAPABILITIES) {
 			ksmbd_debug(SMB,
 				    "deassemble SMB2_COMPRESSION_CAPABILITIES context\n");
@@ -1033,9 +1047,10 @@ static __le32 deassemble_neg_contexts(st
 		} else if (pctx->ContextType == SMB2_SIGNING_CAPABILITIES) {
 			ksmbd_debug(SMB,
 				    "deassemble SMB2_SIGNING_CAPABILITIES context\n");
+
 			decode_sign_cap_ctxt(conn,
 					     (struct smb2_signing_capabilities *)pctx,
-					     len_of_ctxts);
+					     ctxt_len);
 		}
 
 		/* offsets must be 8 byte aligned */


