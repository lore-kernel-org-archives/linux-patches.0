Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 000062DF714;
	Mon, 22 Sep 2025 19:34:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758569679; cv=none; b=QBiRghywTuQAwgvw2MiCQU9hkx3f/8Lu3TCrqS0b1LgPA8/OU4bhAZc9k1iMM7PPYP1hbA4lnGltoqJbrAkUwqO4OQskDCqA73mC2/n3sRl7Xi7oiGdWwZBZ9h37zO97vcdXZ8RdAs/Su13LAGuI65cTqqrXWeENzB4R2VKVLTw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758569679; c=relaxed/simple;
	bh=i5acwSpoxP/ZUzdDm8vF/abfMHQoynFibu421C91/iA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DGrPRfE9tIBMd2k04Cb6pmzsN15y5GZDkaK7RKrjonXKGvHuUAcV6hlhnzGNVWY18Uvq8XQ2e280Ao5S39JrP1d3npKSap8GlzaALK5dkOeID9H7L3e8ZZI2JWWkzcXqjet8bVN831Pr6rHLysowOCiYHhVX1PPkpR+2F/n9mXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fOrMyFXl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fOrMyFXl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49B19C4CEF0;
	Mon, 22 Sep 2025 19:34:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758569678;
	bh=i5acwSpoxP/ZUzdDm8vF/abfMHQoynFibu421C91/iA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fOrMyFXluT23w12dKFAnVyBWi7fnSzeSBAYLXrv2whQOjbgV760T9yMEJjbFQgP7f
	 1QSifjTmPJYLbkGjscBWfdi/ITz5zuSjYNQJMHZHMo4yMqiaLbwRtF/5fakogME+dZ
	 WFzF4N+P0Pj6aiJ06SgDf2b4LJ0YHY8AXXjr9STk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Metzmacher <metze@samba.org>,
	"Luigino Camastra, Aisle Research" <luigino.camastra@aisle.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.6 26/70] ksmbd: smbdirect: validate data_offset and data_length field of smb_direct_data_transfer
Date: Mon, 22 Sep 2025 21:29:26 +0200
Message-ID: <20250922192405.276602656@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250922192404.455120315@linuxfoundation.org>
References: <20250922192404.455120315@linuxfoundation.org>
User-Agent: quilt/0.68
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

commit 5282491fc49d5614ac6ddcd012e5743eecb6a67c upstream.

If data_offset and data_length of smb_direct_data_transfer struct are
invalid, out of bounds issue could happen.
This patch validate data_offset and data_length field in recv_done.

Cc: stable@vger.kernel.org
Fixes: 2ea086e35c3d ("ksmbd: add buffer validation for smb direct")
Reviewed-by: Stefan Metzmacher <metze@samba.org>
Reported-by: Luigino Camastra, Aisle Research <luigino.camastra@aisle.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/transport_rdma.c |   17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

--- a/fs/smb/server/transport_rdma.c
+++ b/fs/smb/server/transport_rdma.c
@@ -553,7 +553,7 @@ static void recv_done(struct ib_cq *cq,
 	case SMB_DIRECT_MSG_DATA_TRANSFER: {
 		struct smb_direct_data_transfer *data_transfer =
 			(struct smb_direct_data_transfer *)recvmsg->packet;
-		unsigned int data_length;
+		unsigned int data_offset, data_length;
 		int avail_recvmsg_count, receive_credits;
 
 		if (wc->byte_len <
@@ -564,14 +564,15 @@ static void recv_done(struct ib_cq *cq,
 		}
 
 		data_length = le32_to_cpu(data_transfer->data_length);
-		if (data_length) {
-			if (wc->byte_len < sizeof(struct smb_direct_data_transfer) +
-			    (u64)data_length) {
-				put_recvmsg(t, recvmsg);
-				smb_direct_disconnect_rdma_connection(t);
-				return;
-			}
+		data_offset = le32_to_cpu(data_transfer->data_offset);
+		if (wc->byte_len < data_offset ||
+		    wc->byte_len < (u64)data_offset + data_length) {
+			put_recvmsg(t, recvmsg);
+			smb_direct_disconnect_rdma_connection(t);
+			return;
+		}
 
+		if (data_length) {
 			if (t->full_packet_received)
 				recvmsg->first_segment = true;
 


