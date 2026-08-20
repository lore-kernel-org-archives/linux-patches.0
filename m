Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 594803403F8;
	Thu, 20 Aug 2026 17:31:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787247067; cv=none; b=rU5Y72fMYXyuGIJmjYDom3CjGjlC46X/Ho4XqyQkxUeCPZK6Xa6SKyLhyZ6Zy4f8HfyCswKHyhNGzNwz07jw58Xgdkc6gIH1IngvO30sHq+hUiHvH+dOIJsC101rXINJbdTJd2wZvORrer1INzVrBRT0iKctQ3P0bVIwzi7FdBU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787247067; c=relaxed/simple;
	bh=1QzUdm2MxLGqZr7o44/ws9I3u/57lpmOeXd9YJg+BD0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oUtRkLqaYax8K/Ys3hmi0lvLS3/Dc8dJ0VQThXWtNP7vWWtX5lW4YWzXjcxLzNY7gmehomVHQCRIbAbgcEVKGFNidOoyZk8et/4yb7sGyDB/zf+AHGZKIyHLlyMD5tp3KeBZfXY2r6TOHnBbpCT6TrkcUrDaKRrblrzKN4Scwpo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JOM82G/l; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JOM82G/l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B81BC1F000E9;
	Thu, 20 Aug 2026 17:31:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787247066;
	bh=mEvZVWPgQMjeljMy8zSnUlUFPFJienW5VeRocf+NVvk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JOM82G/lvxh5hs3mJ8Zks3kL/3ghvYZszuMNEftEwqUeFn1AGtVFkNNP0IKOUCWTV
	 P058EL7a9ROJ6KDHA1qzdzppmA95IOS4xbfHg9dfypxpe5OntaNCesmWLFrTkbyq4Y
	 SwK1PiSYJF21vVhudxCFd7jvJLnZ+qKMKGDt2qYg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>,
	zdi-disclosures@trendmicro.com
Subject: [PATCH 6.12 136/220] ksmbd: validate minimum PDU size for transform requests
Date: Thu, 20 Aug 2026 16:55:26 +0200
Message-ID: <20260820145227.555956365@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145223.480031205@linuxfoundation.org>
References: <20260820145223.480031205@linuxfoundation.org>
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

[ Upstream commit cfc0b8e5080aec87700774e8568765eaa4b7b92b ]

The receive path applies the minimum SMB2 PDU size check only when
ProtocolId is SMB2_PROTO_NUMBER. A packet carrying
SMB2_TRANSFORM_PROTO_NUM bypasses the check even when the negotiated
dialect does not provide transform handling.

On an SMB 2.1 connection, a short transform packet therefore reaches
init_smb2_rsp_hdr(), which interprets the request as a full SMB2 header
and reads beyond the request allocation. The copied fields can then be
returned to the unauthenticated client.

Compression transforms are converted to ordinary SMB2 messages before
protocol validation. After that conversion, validate ordinary SMB2
requests against SMB2_MIN_SUPPORTED_PDU_SIZE and require encryption
transform requests to contain both a transform header and an SMB2
header. This rejects truncated requests before work allocation.

Fixes: 368ba06881c3 ("ksmbd: check the validation of pdu_size in ksmbd_conn_handler_loop")
Cc: stable@vger.kernel.org
Reported-by: zdi-disclosures@trendmicro.com # ZDI-CAN-31063
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/connection.c |   16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

--- a/fs/smb/server/connection.c
+++ b/fs/smb/server/connection.c
@@ -379,6 +379,8 @@ bool ksmbd_conn_alive(struct ksmbd_conn
 /* "+2" for BCC field (ByteCount, 2 bytes) */
 #define SMB1_MIN_SUPPORTED_PDU_SIZE (sizeof(struct smb_hdr) + 2)
 #define SMB2_MIN_SUPPORTED_PDU_SIZE (sizeof(struct smb2_pdu))
+#define SMB2_TRANSFORM_MIN_SUPPORTED_PDU_SIZE	\
+	(sizeof(struct smb2_transform_hdr) + sizeof(struct smb2_hdr))
 
 /**
  * ksmbd_conn_handler_loop() - session thread to listen on new smb requests
@@ -393,6 +395,7 @@ int ksmbd_conn_handler_loop(void *p)
 	struct ksmbd_conn *conn = (struct ksmbd_conn *)p;
 	struct ksmbd_transport *t = conn->transport;
 	unsigned int pdu_size, max_allowed_pdu_size, max_req;
+	__le32 proto;
 	char hdr_buf[4] = {0,};
 	int size;
 
@@ -476,11 +479,14 @@ recheck:
 		if (!ksmbd_smb_request(conn))
 			break;
 
-		if (((struct smb2_hdr *)smb_get_msg(conn->request_buf))->ProtocolId ==
-		    SMB2_PROTO_NUMBER) {
-			if (pdu_size < SMB2_MIN_SUPPORTED_PDU_SIZE)
-				break;
-		}
+		proto = *(__le32 *)smb_get_msg(conn->request_buf);
+		if (proto == SMB2_PROTO_NUMBER &&
+		    pdu_size < SMB2_MIN_SUPPORTED_PDU_SIZE)
+			break;
+
+		if (proto == SMB2_TRANSFORM_PROTO_NUM &&
+		    pdu_size < SMB2_TRANSFORM_MIN_SUPPORTED_PDU_SIZE)
+			break;
 
 		if (!default_conn_ops.process_fn) {
 			pr_err("No connection request callback\n");


