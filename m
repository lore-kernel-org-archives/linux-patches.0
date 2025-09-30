Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A7D8307AF8;
	Tue, 30 Sep 2025 15:13:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759245207; cv=none; b=k4WVDworbJu+eYw+T98fXoctoZX7cu8FNugjCNJzdrVBilyxwonChMmVtmS+aVzc0AubyPJbIG0Q8eDap29PfUEGl1xjeZk8j28hw6b7yNCNXRlfPjXjyAW0sral5/RkJElXbJ8a7ms6zHwM0ka+plf/I3NyjDcLNNe+8M8u/Ds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759245207; c=relaxed/simple;
	bh=pDrz+WaQon+1pycsrb+6HTB1yiWWD6ZZbv8KYSJE7vE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g1dEQNO/SzQzIXcJQ6PFV3PZS9E4jndkN3nIdRfINYwbTRK3yaLZDU0qEKruDFjzC5lrBLATf3GmrmHV+pNbWUZ+H8AcwwIyECuSAhjrAbIFs95fM1aIqPHBJlrm2KcLilJLfrlWP88b5jZ+qo8+AP+aBQ0HOMkPxKEM5d5w7YM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d2lwkwrW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d2lwkwrW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E64BEC113D0;
	Tue, 30 Sep 2025 15:13:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759245207;
	bh=pDrz+WaQon+1pycsrb+6HTB1yiWWD6ZZbv8KYSJE7vE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d2lwkwrWUiYaekvjKWFoRo2NrPBO+fHclQr7a4XRynTJSBb8ju5LLbkVjeK6oiiqr
	 W0r9+8+YGGHfSbhn99UorPcmGacigAzcAWeFbOYX+W8iD2PhjSQZ3fwlXIMj2Y70w5
	 Z4ojH6WfLa93wqbrfIHWqKB13jVS6IzRAQ1cEJFk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Metzmacher <metze@samba.org>,
	"Luigino Camastra, Aisle Research" <luigino.camastra@aisle.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 099/151] ksmbd: smbdirect: validate data_offset and data_length field of smb_direct_data_transfer
Date: Tue, 30 Sep 2025 16:47:09 +0200
Message-ID: <20250930143831.540614578@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143827.587035735@linuxfoundation.org>
References: <20250930143827.587035735@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit 5282491fc49d5614ac6ddcd012e5743eecb6a67c ]

If data_offset and data_length of smb_direct_data_transfer struct are
invalid, out of bounds issue could happen.
This patch validate data_offset and data_length field in recv_done.

Cc: stable@vger.kernel.org
Fixes: 2ea086e35c3d ("ksmbd: add buffer validation for smb direct")
Reviewed-by: Stefan Metzmacher <metze@samba.org>
Reported-by: Luigino Camastra, Aisle Research <luigino.camastra@aisle.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
[ Applied to fs/ksmbd/transport_rdma.c instead of fs/smb/server/transport_rdma.c ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ksmbd/transport_rdma.c |   17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

--- a/fs/ksmbd/transport_rdma.c
+++ b/fs/ksmbd/transport_rdma.c
@@ -548,7 +548,7 @@ static void recv_done(struct ib_cq *cq,
 	case SMB_DIRECT_MSG_DATA_TRANSFER: {
 		struct smb_direct_data_transfer *data_transfer =
 			(struct smb_direct_data_transfer *)recvmsg->packet;
-		unsigned int data_length;
+		unsigned int data_offset, data_length;
 		int avail_recvmsg_count, receive_credits;
 
 		if (wc->byte_len <
@@ -559,14 +559,15 @@ static void recv_done(struct ib_cq *cq,
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
 


