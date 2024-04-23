Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF1E8146017;
	Tue, 23 Apr 2024 21:44:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908662; cv=none; b=Yo7J0GVVEfcKKCTUe5rqmrTGAv9eMti/jMNH7ufDu+lcFAkLqzSXcoXY1y/kb44tPyIa+dWuHFU9/+TNOUnoypsO1p7axJlqh7HlYJnZt3eKbZ107uKK60Ex/X/bg1Phnt7jeaWL7EYrmOS8nhJ9VIJRvf8IBYp+sXC9mveKfxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908662; c=relaxed/simple;
	bh=XwiW8XqxeoyZy0GU5vosztLuZMTJjAAPTnISdS4vkpQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FFnxP1702oY0KlPvkouawuSBsKtvE1HSDs5/Ujr56K2B5gaQVVULQEFQ+9XXv3C9WPL/gjI+elgAkZPP1q4jLOqB04AG3Si2/Qtd1gF/jOEZ6qN8JBXyB3FN4UdjoXTOKFKdchbxi4wj6G56wvrX5XVfy6niQqDfWkP8iXoPXg4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V6OwBsVk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V6OwBsVk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6873C116B1;
	Tue, 23 Apr 2024 21:44:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908661;
	bh=XwiW8XqxeoyZy0GU5vosztLuZMTJjAAPTnISdS4vkpQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V6OwBsVk+pdKHgMSAjWDZTog8sb24qo76w6tqsKZFhZLf8RO2JSWtvEnwykhZtQlq
	 LM90H58NnKexPH4x2nRZ1qIxyVEcNrp1pIRBF4BuDy3x0cxGwoGodt1/1vbQQ8ZNZQ
	 bNHLZe3tSKDPb2CkpqDFEh7CendwZ8zr7diID0xs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Norbert Szetei <norbert@doyensec.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.6 154/158] ksmbd: fix slab-out-of-bounds in smb2_allocate_rsp_buf
Date: Tue, 23 Apr 2024 14:39:51 -0700
Message-ID: <20240423213900.674335281@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213855.696477232@linuxfoundation.org>
References: <20240423213855.696477232@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namjae Jeon <linkinjeon@kernel.org>

commit c119f4ede3fa90a9463f50831761c28f989bfb20 upstream.

If ->ProtocolId is SMB2_TRANSFORM_PROTO_NUM, smb2 request size
validation could be skipped. if request size is smaller than
sizeof(struct smb2_query_info_req), slab-out-of-bounds read can happen in
smb2_allocate_rsp_buf(). This patch allocate response buffer after
decrypting transform request. smb3_decrypt_req() will validate transform
request size and avoid slab-out-of-bound in smb2_allocate_rsp_buf().

Reported-by: Norbert Szetei <norbert@doyensec.com>
Cc: stable@vger.kernel.org
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/server.c |   13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

--- a/fs/smb/server/server.c
+++ b/fs/smb/server/server.c
@@ -167,20 +167,17 @@ static void __handle_ksmbd_work(struct k
 	int rc;
 	bool is_chained = false;
 
-	if (conn->ops->allocate_rsp_buf(work))
-		return;
-
 	if (conn->ops->is_transform_hdr &&
 	    conn->ops->is_transform_hdr(work->request_buf)) {
 		rc = conn->ops->decrypt_req(work);
-		if (rc < 0) {
-			conn->ops->set_rsp_status(work, STATUS_DATA_ERROR);
-			goto send;
-		}
-
+		if (rc < 0)
+			return;
 		work->encrypted = true;
 	}
 
+	if (conn->ops->allocate_rsp_buf(work))
+		return;
+
 	rc = conn->ops->init_rsp_hdr(work);
 	if (rc) {
 		/* either uid or tid is not correct */


