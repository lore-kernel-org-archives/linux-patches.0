Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78E904B5CA;
	Wed, 20 Dec 2023 16:14:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Rp38r/z6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2209C433C9;
	Wed, 20 Dec 2023 16:14:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1703088853;
	bh=yz60FvZEGJaQUtQUz8UFfVcv7iXsNXT4gnqR2na2ZWU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Rp38r/z6gZ7bSIifnRtBW6TpRcKZM7iqvaPlrAH1h/wR970+fxR/ptj6WHnjsELlD
	 M1CgdtfiOf8RRMgVfx1Rfv7H7crghKrwb5TZkxP65rJzhi1jSCiQD1WjgSwLIV7zPa
	 dQ8kaLnAzYd3G+SXyjg9PNUr7l1xeTUMz/BSHZjI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Disseldorp <ddiss@suse.de>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.15 082/159] ksmbd: avoid out of bounds access in decode_preauth_ctxt()
Date: Wed, 20 Dec 2023 17:09:07 +0100
Message-ID: <20231220160935.203361228@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231220160931.251686445@linuxfoundation.org>
References: <20231220160931.251686445@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Disseldorp <ddiss@suse.de>

[ Upstream commit e7067a446264a7514fa1cfaa4052cdb6803bc6a2 ]

Confirm that the accessed pneg_ctxt->HashAlgorithms address sits within
the SMB request boundary; deassemble_neg_contexts() only checks that the
eight byte smb2_neg_context header + (client controlled) DataLength are
within the packet boundary, which is insufficient.

Checking for sizeof(struct smb2_preauth_neg_context) is overkill given
that the type currently assumes SMB311_SALT_SIZE bytes of trailing Salt.

Signed-off-by: David Disseldorp <ddiss@suse.de>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ksmbd/smb2pdu.c |   23 ++++++++++++++---------
 1 file changed, 14 insertions(+), 9 deletions(-)

--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -907,17 +907,21 @@ static void assemble_neg_contexts(struct
 }
 
 static __le32 decode_preauth_ctxt(struct ksmbd_conn *conn,
-				  struct smb2_preauth_neg_context *pneg_ctxt)
+				  struct smb2_preauth_neg_context *pneg_ctxt,
+				  int len_of_ctxts)
 {
-	__le32 err = STATUS_NO_PREAUTH_INTEGRITY_HASH_OVERLAP;
+	/*
+	 * sizeof(smb2_preauth_neg_context) assumes SMB311_SALT_SIZE Salt,
+	 * which may not be present. Only check for used HashAlgorithms[1].
+	 */
+	if (len_of_ctxts < 6)
+		return STATUS_INVALID_PARAMETER;
 
-	if (pneg_ctxt->HashAlgorithms == SMB2_PREAUTH_INTEGRITY_SHA512) {
-		conn->preauth_info->Preauth_HashId =
-			SMB2_PREAUTH_INTEGRITY_SHA512;
-		err = STATUS_SUCCESS;
-	}
+	if (pneg_ctxt->HashAlgorithms != SMB2_PREAUTH_INTEGRITY_SHA512)
+		return STATUS_NO_PREAUTH_INTEGRITY_HASH_OVERLAP;
 
-	return err;
+	conn->preauth_info->Preauth_HashId = SMB2_PREAUTH_INTEGRITY_SHA512;
+	return STATUS_SUCCESS;
 }
 
 static void decode_encrypt_ctxt(struct ksmbd_conn *conn,
@@ -1045,7 +1049,8 @@ static __le32 deassemble_neg_contexts(st
 				break;
 
 			status = decode_preauth_ctxt(conn,
-						     (struct smb2_preauth_neg_context *)pctx);
+						     (struct smb2_preauth_neg_context *)pctx,
+						     len_of_ctxts);
 			if (status != STATUS_SUCCESS)
 				break;
 		} else if (pctx->ContextType == SMB2_ENCRYPTION_CAPABILITIES) {


