Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94B921C2A9;
	Wed,  3 Jan 2024 16:58:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K/UhGLuX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE907C433C7;
	Wed,  3 Jan 2024 16:58:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704301125;
	bh=tb80snFTQt8j4FXYaEdsD30u1/4N8VdiIkcMhE2iItQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K/UhGLuXjPven7nQlq4zXMJc2wwks58TEqmLmzlGHRSm/KlV8KHF2BGEJVJJuZ+Fs
	 t5MZcR+tgU4Eb/38f+EpHDKF9PnFHzE5z817L/VeqF9xuy7W5tygi0B20lJWQaiE2K
	 EXeUhZ52Fk8WfmYKxIQa0RzkxZFKCBE9UAaf/cQU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Disseldorp <ddiss@suse.de>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 014/100] ksmbd: set NegotiateContextCount once instead of every inc
Date: Wed,  3 Jan 2024 17:54:03 +0100
Message-ID: <20240103164858.243365701@linuxfoundation.org>
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

[ Upstream commit 34e8ccf9ce24b6b2e275bbe35cd392e18fbbd369 ]

There are no early returns, so marshalling the incremented
NegotiateContextCount with every context is unnecessary.

Signed-off-by: David Disseldorp <ddiss@suse.de>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/smb2pdu.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index ee128f5d38c35..c7d43c83d2335 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -847,7 +847,6 @@ static void assemble_neg_contexts(struct ksmbd_conn *conn,
 		    "assemble SMB2_PREAUTH_INTEGRITY_CAPABILITIES context\n");
 	build_preauth_ctxt((struct smb2_preauth_neg_context *)pneg_ctxt,
 			   conn->preauth_info->Preauth_HashId);
-	rsp->NegotiateContextCount = cpu_to_le16(neg_ctxt_cnt);
 	inc_rfc1001_len(smb2_buf_len, AUTH_GSS_PADDING);
 	ctxt_size = sizeof(struct smb2_preauth_neg_context);
 	/* Round to 8 byte boundary */
@@ -859,7 +858,7 @@ static void assemble_neg_contexts(struct ksmbd_conn *conn,
 			    "assemble SMB2_ENCRYPTION_CAPABILITIES context\n");
 		build_encrypt_ctxt((struct smb2_encryption_neg_context *)pneg_ctxt,
 				   conn->cipher_type);
-		rsp->NegotiateContextCount = cpu_to_le16(++neg_ctxt_cnt);
+		neg_ctxt_cnt++;
 		ctxt_size += sizeof(struct smb2_encryption_neg_context) + 2;
 		/* Round to 8 byte boundary */
 		pneg_ctxt +=
@@ -874,7 +873,7 @@ static void assemble_neg_contexts(struct ksmbd_conn *conn,
 		/* Temporarily set to SMB3_COMPRESS_NONE */
 		build_compression_ctxt((struct smb2_compression_capabilities_context *)pneg_ctxt,
 				       conn->compress_algorithm);
-		rsp->NegotiateContextCount = cpu_to_le16(++neg_ctxt_cnt);
+		neg_ctxt_cnt++;
 		ctxt_size += sizeof(struct smb2_compression_capabilities_context) + 2;
 		/* Round to 8 byte boundary */
 		pneg_ctxt += round_up(sizeof(struct smb2_compression_capabilities_context) + 2,
@@ -886,7 +885,7 @@ static void assemble_neg_contexts(struct ksmbd_conn *conn,
 		ksmbd_debug(SMB,
 			    "assemble SMB2_POSIX_EXTENSIONS_AVAILABLE context\n");
 		build_posix_ctxt((struct smb2_posix_neg_context *)pneg_ctxt);
-		rsp->NegotiateContextCount = cpu_to_le16(++neg_ctxt_cnt);
+		neg_ctxt_cnt++;
 		ctxt_size += sizeof(struct smb2_posix_neg_context);
 		/* Round to 8 byte boundary */
 		pneg_ctxt += round_up(sizeof(struct smb2_posix_neg_context), 8);
@@ -898,10 +897,11 @@ static void assemble_neg_contexts(struct ksmbd_conn *conn,
 			    "assemble SMB2_SIGNING_CAPABILITIES context\n");
 		build_sign_cap_ctxt((struct smb2_signing_capabilities *)pneg_ctxt,
 				    conn->signing_algorithm);
-		rsp->NegotiateContextCount = cpu_to_le16(++neg_ctxt_cnt);
+		neg_ctxt_cnt++;
 		ctxt_size += sizeof(struct smb2_signing_capabilities) + 2;
 	}
 
+	rsp->NegotiateContextCount = cpu_to_le16(neg_ctxt_cnt);
 	inc_rfc1001_len(smb2_buf_len, ctxt_size);
 }
 
-- 
2.43.0



