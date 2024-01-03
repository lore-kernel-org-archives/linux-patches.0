Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4007E1BDE9;
	Wed,  3 Jan 2024 16:58:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eOBYGHMi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46C9BC433C7;
	Wed,  3 Jan 2024 16:58:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704301131;
	bh=+lUk9rOHB+irjBOn6HzlJ2L+13CTWxrsIHonvUqEyY0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eOBYGHMiuojOSxqAJ/3dZikuf5K1bvfj3qYz6irn5QsbxZawKb1ArP65sey0AEaD5
	 J+CLLOdcdGjRii65ihsxKG5M7Lj6izkt1V9xUin7LKDKjS3F+rifMGoHRnWAbcKgIe
	 Lz76jODEa1CDkhShUWVMtZX+MkkGzOZHtF5g/dDI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Disseldorp <ddiss@suse.de>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 016/100] ksmbd: remove unused compression negotiate ctx packing
Date: Wed,  3 Jan 2024 17:54:05 +0100
Message-ID: <20240103164858.550166015@linuxfoundation.org>
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

[ Upstream commit af36c51e0e111de4e908328d49cba49de758f66e ]

build_compression_ctxt() is currently unreachable due to
conn.compress_algorithm remaining zero (SMB3_COMPRESS_NONE).

It appears to have been broken in a couple of subtle ways over the
years:
- prior to d6c9ad23b421 ("ksmbd: use the common definitions for
  NEGOTIATE_PROTOCOL") smb2_compression_ctx.DataLength was set to 8,
  which didn't account for the single CompressionAlgorithms flexible
  array member.
- post d6c9ad23b421 smb2_compression_capabilities_context
  CompressionAlgorithms is a three member array, while
  CompressionAlgorithmCount is set to indicate only one member.
  assemble_neg_contexts() ctxt_size is also incorrectly incremented by
  sizeof(struct smb2_compression_capabilities_context) + 2, which
  assumes one flexible array member.

Signed-off-by: David Disseldorp <ddiss@suse.de>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/smb2pdu.c | 26 ++------------------------
 1 file changed, 2 insertions(+), 24 deletions(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 92e6570972437..ca57e85abf915 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -786,19 +786,6 @@ static void build_encrypt_ctxt(struct smb2_encryption_neg_context *pneg_ctxt,
 	pneg_ctxt->Ciphers[0] = cipher_type;
 }
 
-static void build_compression_ctxt(struct smb2_compression_capabilities_context *pneg_ctxt,
-				   __le16 comp_algo)
-{
-	pneg_ctxt->ContextType = SMB2_COMPRESSION_CAPABILITIES;
-	pneg_ctxt->DataLength =
-		cpu_to_le16(sizeof(struct smb2_compression_capabilities_context)
-			- sizeof(struct smb2_neg_context));
-	pneg_ctxt->Reserved = cpu_to_le32(0);
-	pneg_ctxt->CompressionAlgorithmCount = cpu_to_le16(1);
-	pneg_ctxt->Flags = cpu_to_le32(0);
-	pneg_ctxt->CompressionAlgorithms[0] = comp_algo;
-}
-
 static void build_sign_cap_ctxt(struct smb2_signing_capabilities *pneg_ctxt,
 				__le16 sign_algo)
 {
@@ -862,17 +849,8 @@ static void assemble_neg_contexts(struct ksmbd_conn *conn,
 		ctxt_size += sizeof(struct smb2_encryption_neg_context) + 2;
 	}
 
-	if (conn->compress_algorithm) {
-		ctxt_size = round_up(ctxt_size, 8);
-		ksmbd_debug(SMB,
-			    "assemble SMB2_COMPRESSION_CAPABILITIES context\n");
-		/* Temporarily set to SMB3_COMPRESS_NONE */
-		build_compression_ctxt((struct smb2_compression_capabilities_context *)
-				       (pneg_ctxt + ctxt_size),
-				       conn->compress_algorithm);
-		neg_ctxt_cnt++;
-		ctxt_size += sizeof(struct smb2_compression_capabilities_context) + 2;
-	}
+	/* compression context not yet supported */
+	WARN_ON(conn->compress_algorithm != SMB3_COMPRESS_NONE);
 
 	if (conn->posix_ext_supported) {
 		ctxt_size = round_up(ctxt_size, 8);
-- 
2.43.0



