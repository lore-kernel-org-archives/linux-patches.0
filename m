Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C05C2572
	for <patches@lists.linux.dev>; Tue, 18 Apr 2023 12:53:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DEE6C4339E;
	Tue, 18 Apr 2023 12:53:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1681822418;
	bh=qD7DoLbDeFsWhvdCSOJ5OAayrjgOYTRWYbMVYo35hrc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ilHmDdtsw+Zd1ON95fK1eHW/hI4RCP53nBBY+srzO8kZXGpBMYVLNd2goX1PgihdC
	 ks2jPOOldBF7ETFCSqiJg4dv6np8aszLEgcnIDOMAkT7PZG6ZQRohLuwp/vsYVU+LL
	 5anA7NXPaZ0uvrlsgpFQE8W0t1sRExAK9gW9839U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Volker Lendecke <vl@samba.org>,
	"Paulo Alcantara (SUSE)" <pc@manguebit.com>,
	David Disseldorp <ddiss@suse.de>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 135/139] cifs: fix negotiate context parsing
Date: Tue, 18 Apr 2023 14:23:20 +0200
Message-Id: <20230418120318.979061068@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120313.725598495@linuxfoundation.org>
References: <20230418120313.725598495@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: David Disseldorp <ddiss@suse.de>

[ Upstream commit 5105a7ffce19160e7062aee67fb6b3b8a1b56d78 ]

smb311_decode_neg_context() doesn't properly check against SMB packet
boundaries prior to accessing individual negotiate context entries. This
is due to the length check omitting the eight byte smb2_neg_context
header, as well as incorrect decrementing of len_of_ctxts.

Fixes: 5100d8a3fe03 ("SMB311: Improve checking of negotiate security contexts")
Reported-by: Volker Lendecke <vl@samba.org>
Reviewed-by: Paulo Alcantara (SUSE) <pc@manguebit.com>
Signed-off-by: David Disseldorp <ddiss@suse.de>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/smb2pdu.c | 41 +++++++++++++++++++++++++++++++----------
 1 file changed, 31 insertions(+), 10 deletions(-)

diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index b37379b62cc77..ab59faf8a06a7 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -588,11 +588,15 @@ assemble_neg_contexts(struct smb2_negotiate_req *req,
 
 }
 
+/* If invalid preauth context warn but use what we requested, SHA-512 */
 static void decode_preauth_context(struct smb2_preauth_neg_context *ctxt)
 {
 	unsigned int len = le16_to_cpu(ctxt->DataLength);
 
-	/* If invalid preauth context warn but use what we requested, SHA-512 */
+	/*
+	 * Caller checked that DataLength remains within SMB boundary. We still
+	 * need to confirm that one HashAlgorithms member is accounted for.
+	 */
 	if (len < MIN_PREAUTH_CTXT_DATA_LEN) {
 		pr_warn_once("server sent bad preauth context\n");
 		return;
@@ -611,7 +615,11 @@ static void decode_compress_ctx(struct TCP_Server_Info *server,
 {
 	unsigned int len = le16_to_cpu(ctxt->DataLength);
 
-	/* sizeof compress context is a one element compression capbility struct */
+	/*
+	 * Caller checked that DataLength remains within SMB boundary. We still
+	 * need to confirm that one CompressionAlgorithms member is accounted
+	 * for.
+	 */
 	if (len < 10) {
 		pr_warn_once("server sent bad compression cntxt\n");
 		return;
@@ -633,6 +641,11 @@ static int decode_encrypt_ctx(struct TCP_Server_Info *server,
 	unsigned int len = le16_to_cpu(ctxt->DataLength);
 
 	cifs_dbg(FYI, "decode SMB3.11 encryption neg context of len %d\n", len);
+	/*
+	 * Caller checked that DataLength remains within SMB boundary. We still
+	 * need to confirm that one Cipher flexible array member is accounted
+	 * for.
+	 */
 	if (len < MIN_ENCRYPT_CTXT_DATA_LEN) {
 		pr_warn_once("server sent bad crypto ctxt len\n");
 		return -EINVAL;
@@ -679,6 +692,11 @@ static void decode_signing_ctx(struct TCP_Server_Info *server,
 {
 	unsigned int len = le16_to_cpu(pctxt->DataLength);
 
+	/*
+	 * Caller checked that DataLength remains within SMB boundary. We still
+	 * need to confirm that one SigningAlgorithms flexible array member is
+	 * accounted for.
+	 */
 	if ((len < 4) || (len > 16)) {
 		pr_warn_once("server sent bad signing negcontext\n");
 		return;
@@ -720,14 +738,19 @@ static int smb311_decode_neg_context(struct smb2_negotiate_rsp *rsp,
 	for (i = 0; i < ctxt_cnt; i++) {
 		int clen;
 		/* check that offset is not beyond end of SMB */
-		if (len_of_ctxts == 0)
-			break;
-
 		if (len_of_ctxts < sizeof(struct smb2_neg_context))
 			break;
 
 		pctx = (struct smb2_neg_context *)(offset + (char *)rsp);
-		clen = le16_to_cpu(pctx->DataLength);
+		clen = sizeof(struct smb2_neg_context)
+			+ le16_to_cpu(pctx->DataLength);
+		/*
+		 * 2.2.4 SMB2 NEGOTIATE Response
+		 * Subsequent negotiate contexts MUST appear at the first 8-byte
+		 * aligned offset following the previous negotiate context.
+		 */
+		if (i + 1 != ctxt_cnt)
+			clen = ALIGN(clen, 8);
 		if (clen > len_of_ctxts)
 			break;
 
@@ -748,12 +771,10 @@ static int smb311_decode_neg_context(struct smb2_negotiate_rsp *rsp,
 		else
 			cifs_server_dbg(VFS, "unknown negcontext of type %d ignored\n",
 				le16_to_cpu(pctx->ContextType));
-
 		if (rc)
 			break;
-		/* offsets must be 8 byte aligned */
-		clen = ALIGN(clen, 8);
-		offset += clen + sizeof(struct smb2_neg_context);
+
+		offset += clen;
 		len_of_ctxts -= clen;
 	}
 	return rc;
-- 
2.39.2



