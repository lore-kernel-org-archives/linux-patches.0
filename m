Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E47E4487AF;
	Wed, 20 Dec 2023 16:11:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q9hlGCm6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65459C433C8;
	Wed, 20 Dec 2023 16:11:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1703088691;
	bh=m7L7w4OqqOeuS0Gs5EmR3tj25epedNStiSyohF0pfGU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q9hlGCm6bVEuk1W4oExdEliTCdhVq6cSAx2b1exChJD0uoC3A7/yOYCdsxkrcxwWQ
	 yIDgj39F3cJIeU5uCF8NJb4QuUU05D499Ph8D7v+jlIuwIoM14qQAWz4JtbIl1vYjn
	 1TKtTrtnDRDJFv72rOolRFxTkOPbymYU/04Fo7UI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.15 023/159] ksmbd: smbd: validate buffer descriptor structures
Date: Wed, 20 Dec 2023 17:08:08 +0100
Message-ID: <20231220160932.353993774@linuxfoundation.org>
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

From: Hyunchul Lee <hyc.lee@gmail.com>

[ Upstream commit 6d896d3b44cf64ab9b2483697e222098e7b72f70 ]

Check ChannelInfoOffset and ChannelInfoLength
to validate buffer descriptor structures.
And add a debug log to print the structures'
content.

Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Hyunchul Lee <hyc.lee@gmail.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ksmbd/smb2pdu.c |   36 ++++++++++++++++++++++++++++++------
 1 file changed, 30 insertions(+), 6 deletions(-)

--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -6209,13 +6209,26 @@ static int smb2_set_remote_key_for_rdma(
 					__le16 ChannelInfoOffset,
 					__le16 ChannelInfoLength)
 {
+	unsigned int i, ch_count;
+
 	if (work->conn->dialect == SMB30_PROT_ID &&
 	    Channel != SMB2_CHANNEL_RDMA_V1)
 		return -EINVAL;
 
-	if (ChannelInfoOffset == 0 ||
-	    le16_to_cpu(ChannelInfoLength) < sizeof(*desc))
+	ch_count = le16_to_cpu(ChannelInfoLength) / sizeof(*desc);
+	if (ksmbd_debug_types & KSMBD_DEBUG_RDMA) {
+		for (i = 0; i < ch_count; i++) {
+			pr_info("RDMA r/w request %#x: token %#x, length %#x\n",
+				i,
+				le32_to_cpu(desc[i].token),
+				le32_to_cpu(desc[i].length));
+		}
+	}
+	if (ch_count != 1) {
+		ksmbd_debug(RDMA, "RDMA multiple buffer descriptors %d are not supported yet\n",
+			    ch_count);
 		return -EINVAL;
+	}
 
 	work->need_invalidate_rkey =
 		(Channel == SMB2_CHANNEL_RDMA_V1_INVALIDATE);
@@ -6273,9 +6286,15 @@ int smb2_read(struct ksmbd_work *work)
 
 	if (req->Channel == SMB2_CHANNEL_RDMA_V1_INVALIDATE ||
 	    req->Channel == SMB2_CHANNEL_RDMA_V1) {
+		unsigned int ch_offset = le16_to_cpu(req->ReadChannelInfoOffset);
+
+		if (ch_offset < offsetof(struct smb2_read_req, Buffer)) {
+			err = -EINVAL;
+			goto out;
+		}
 		err = smb2_set_remote_key_for_rdma(work,
 						   (struct smb2_buffer_desc_v1 *)
-						   &req->Buffer[0],
+						   ((char *)req + ch_offset),
 						   req->Channel,
 						   req->ReadChannelInfoOffset,
 						   req->ReadChannelInfoLength);
@@ -6516,11 +6535,16 @@ int smb2_write(struct ksmbd_work *work)
 
 	if (req->Channel == SMB2_CHANNEL_RDMA_V1 ||
 	    req->Channel == SMB2_CHANNEL_RDMA_V1_INVALIDATE) {
-		if (req->Length != 0 || req->DataOffset != 0)
-			return -EINVAL;
+		unsigned int ch_offset = le16_to_cpu(req->WriteChannelInfoOffset);
+
+		if (req->Length != 0 || req->DataOffset != 0 ||
+		    ch_offset < offsetof(struct smb2_write_req, Buffer)) {
+			err = -EINVAL;
+			goto out;
+		}
 		err = smb2_set_remote_key_for_rdma(work,
 						   (struct smb2_buffer_desc_v1 *)
-						   &req->Buffer[0],
+						   ((char *)req + ch_offset),
 						   req->Channel,
 						   req->WriteChannelInfoOffset,
 						   req->WriteChannelInfoLength);


