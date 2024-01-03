Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEB621C293;
	Wed,  3 Jan 2024 16:58:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jdHZ8MEr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE1E1C433C7;
	Wed,  3 Jan 2024 16:58:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704301128;
	bh=OV37eABJFljyNATp+Ek8fBnOyy3orth7lHD1+yCEWcY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jdHZ8MErl9BtsfZDFLrMQQ5S2rjB8VNZzkWu6h6zzxYZ14iLCkTRA1+An1cDIUKs0
	 uSy15gPbA2lUkuRdd5bu+6fSLbIWE5aelaxOvylYqwg5jxeX/ub1hQUvDgYbn+7I6l
	 oUsqSHYLxWUySYVnqGhcsFCW2Jsi3glmA3bMt5+w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Disseldorp <ddiss@suse.de>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 015/100] ksmbd: avoid duplicate negotiate ctx offset increments
Date: Wed,  3 Jan 2024 17:54:04 +0100
Message-ID: <20240103164858.386702105@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240103164856.169912722@linuxfoundation.org>
References: <20240103164856.169912722@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Disseldorp <ddiss@suse.de>

[ Upstream commit a12a07a85aff72e19520328f78b1c64d2281a1ec ]

Both pneg_ctxt and ctxt_size change in unison, with each adding the
length of the previously added context, rounded up to an eight byte
boundary.
Drop pneg_ctxt increments and instead use the ctxt_size offset when
passing output pointers to per-context helper functions. This slightly
simplifies offset tracking and shaves off a few text bytes.
Before (x86-64 gcc 7.5):
   text    data     bss     dec     hex filename
 213234    8677     672  222583   36577 ksmbd.ko

After:
   text    data     bss     dec     hex filename
 213218    8677     672  222567   36567 ksmbd.ko

Signed-off-by: David Disseldorp <ddiss@suse.de>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/smb2pdu.c | 26 ++++++++++----------------
 1 file changed, 10 insertions(+), 16 deletions(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index c7d43c83d2335..92e6570972437 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -838,7 +838,7 @@ static void assemble_neg_contexts(struct ksmbd_conn *conn,
 				  struct smb2_negotiate_rsp *rsp,
 				  void *smb2_buf_len)
 {
-	char *pneg_ctxt = (char *)rsp +
+	char * const pneg_ctxt = (char *)rsp +
 			le32_to_cpu(rsp->NegotiateContextOffset);
 	int neg_ctxt_cnt = 1;
 	int ctxt_size;
@@ -849,21 +849,17 @@ static void assemble_neg_contexts(struct ksmbd_conn *conn,
 			   conn->preauth_info->Preauth_HashId);
 	inc_rfc1001_len(smb2_buf_len, AUTH_GSS_PADDING);
 	ctxt_size = sizeof(struct smb2_preauth_neg_context);
-	/* Round to 8 byte boundary */
-	pneg_ctxt += round_up(sizeof(struct smb2_preauth_neg_context), 8);
 
 	if (conn->cipher_type) {
+		/* Round to 8 byte boundary */
 		ctxt_size = round_up(ctxt_size, 8);
 		ksmbd_debug(SMB,
 			    "assemble SMB2_ENCRYPTION_CAPABILITIES context\n");
-		build_encrypt_ctxt((struct smb2_encryption_neg_context *)pneg_ctxt,
+		build_encrypt_ctxt((struct smb2_encryption_neg_context *)
+				   (pneg_ctxt + ctxt_size),
 				   conn->cipher_type);
 		neg_ctxt_cnt++;
 		ctxt_size += sizeof(struct smb2_encryption_neg_context) + 2;
-		/* Round to 8 byte boundary */
-		pneg_ctxt +=
-			round_up(sizeof(struct smb2_encryption_neg_context) + 2,
-				 8);
 	}
 
 	if (conn->compress_algorithm) {
@@ -871,31 +867,29 @@ static void assemble_neg_contexts(struct ksmbd_conn *conn,
 		ksmbd_debug(SMB,
 			    "assemble SMB2_COMPRESSION_CAPABILITIES context\n");
 		/* Temporarily set to SMB3_COMPRESS_NONE */
-		build_compression_ctxt((struct smb2_compression_capabilities_context *)pneg_ctxt,
+		build_compression_ctxt((struct smb2_compression_capabilities_context *)
+				       (pneg_ctxt + ctxt_size),
 				       conn->compress_algorithm);
 		neg_ctxt_cnt++;
 		ctxt_size += sizeof(struct smb2_compression_capabilities_context) + 2;
-		/* Round to 8 byte boundary */
-		pneg_ctxt += round_up(sizeof(struct smb2_compression_capabilities_context) + 2,
-				      8);
 	}
 
 	if (conn->posix_ext_supported) {
 		ctxt_size = round_up(ctxt_size, 8);
 		ksmbd_debug(SMB,
 			    "assemble SMB2_POSIX_EXTENSIONS_AVAILABLE context\n");
-		build_posix_ctxt((struct smb2_posix_neg_context *)pneg_ctxt);
+		build_posix_ctxt((struct smb2_posix_neg_context *)
+				 (pneg_ctxt + ctxt_size));
 		neg_ctxt_cnt++;
 		ctxt_size += sizeof(struct smb2_posix_neg_context);
-		/* Round to 8 byte boundary */
-		pneg_ctxt += round_up(sizeof(struct smb2_posix_neg_context), 8);
 	}
 
 	if (conn->signing_negotiated) {
 		ctxt_size = round_up(ctxt_size, 8);
 		ksmbd_debug(SMB,
 			    "assemble SMB2_SIGNING_CAPABILITIES context\n");
-		build_sign_cap_ctxt((struct smb2_signing_capabilities *)pneg_ctxt,
+		build_sign_cap_ctxt((struct smb2_signing_capabilities *)
+				    (pneg_ctxt + ctxt_size),
 				    conn->signing_algorithm);
 		neg_ctxt_cnt++;
 		ctxt_size += sizeof(struct smb2_signing_capabilities) + 2;
-- 
2.43.0



