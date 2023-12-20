Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3671241741;
	Wed, 20 Dec 2023 16:13:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zFefvAvx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64980C433C9;
	Wed, 20 Dec 2023 16:13:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1703088795;
	bh=sjuAKc67d2CYHyoYPpkuQgeg7A2vvd23Uu1HjC4jcgg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zFefvAvx3/Uj2qJqgkXD97ed6laXoPz+Ohs4h8aKXZzh3FnZjPeYrhqNMV29QHIGn
	 38TkF6w6vz4BWJtpWGdNlHTKXY9QsIvSEw6AWZiYEExN8kvpj+vBXC8NJEJmhDYgGq
	 vWKmDqb+RijLSoAdqzDXevGJdu6RLBBRPtFytTx8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marios Makassikis <mmakassikis@freebox.fr>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.15 032/159] ksmbd: validate length in smb2_write()
Date: Wed, 20 Dec 2023 17:08:17 +0100
Message-ID: <20231220160932.782226773@linuxfoundation.org>
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

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit 158a66b245739e15858de42c0ba60fcf3de9b8e6 ]

The SMB2 Write packet contains data that is to be written
to a file or to a pipe. Depending on the client, there may
be padding between the header and the data field.
Currently, the length is validated only in the case padding
is present.

Since the DataOffset field always points to the beginning
of the data, there is no need to have a special case for
padding. By removing this, the length is validated in both
cases.

Signed-off-by: Marios Makassikis <mmakassikis@freebox.fr>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ksmbd/smb2pdu.c |   42 ++++++++++++++++--------------------------
 1 file changed, 16 insertions(+), 26 deletions(-)

--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -6410,23 +6410,18 @@ static noinline int smb2_write_pipe(stru
 	length = le32_to_cpu(req->Length);
 	id = req->VolatileFileId;
 
-	if (le16_to_cpu(req->DataOffset) ==
-	    offsetof(struct smb2_write_req, Buffer)) {
-		data_buf = (char *)&req->Buffer[0];
-	} else {
-		if ((u64)le16_to_cpu(req->DataOffset) + length >
-		    get_rfc1002_len(work->request_buf)) {
-			pr_err("invalid write data offset %u, smb_len %u\n",
-			       le16_to_cpu(req->DataOffset),
-			       get_rfc1002_len(work->request_buf));
-			err = -EINVAL;
-			goto out;
-		}
-
-		data_buf = (char *)(((char *)&req->hdr.ProtocolId) +
-				le16_to_cpu(req->DataOffset));
+	if ((u64)le16_to_cpu(req->DataOffset) + length >
+	    get_rfc1002_len(work->request_buf)) {
+		pr_err("invalid write data offset %u, smb_len %u\n",
+		       le16_to_cpu(req->DataOffset),
+		       get_rfc1002_len(work->request_buf));
+		err = -EINVAL;
+		goto out;
 	}
 
+	data_buf = (char *)(((char *)&req->hdr.ProtocolId) +
+			   le16_to_cpu(req->DataOffset));
+
 	rpc_resp = ksmbd_rpc_write(work->sess, id, data_buf, length);
 	if (rpc_resp) {
 		if (rpc_resp->flags == KSMBD_RPC_ENOTIMPLEMENTED) {
@@ -6571,20 +6566,15 @@ int smb2_write(struct ksmbd_work *work)
 
 	if (req->Channel != SMB2_CHANNEL_RDMA_V1 &&
 	    req->Channel != SMB2_CHANNEL_RDMA_V1_INVALIDATE) {
-		if (le16_to_cpu(req->DataOffset) ==
+		if (le16_to_cpu(req->DataOffset) <
 		    offsetof(struct smb2_write_req, Buffer)) {
-			data_buf = (char *)&req->Buffer[0];
-		} else {
-			if (le16_to_cpu(req->DataOffset) <
-			    offsetof(struct smb2_write_req, Buffer)) {
-				err = -EINVAL;
-				goto out;
-			}
-
-			data_buf = (char *)(((char *)&req->hdr.ProtocolId) +
-					le16_to_cpu(req->DataOffset));
+			err = -EINVAL;
+			goto out;
 		}
 
+		data_buf = (char *)(((char *)&req->hdr.ProtocolId) +
+				    le16_to_cpu(req->DataOffset));
+
 		ksmbd_debug(SMB, "flags %u\n", le32_to_cpu(req->Flags));
 		if (le32_to_cpu(req->Flags) & SMB2_WRITEFLAG_WRITE_THROUGH)
 			writethrough = true;


