Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14E072F1FE3;
	Mon, 22 Sep 2025 19:38:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758569929; cv=none; b=Smp54FZcYlnV2d5nMu1EQR5cDaq6x5nrjVk1Y4DbfGz1Wa3UEhYv+16w49ZamIU9Oa/Ndz7S1a6pHqRFGPOVuGfWh6/xE8hLclbJkuDbWJrmrB7T9TvCwYmgRJpFTcCMz70oWqjW5VS/eUlBnN6nqbcZBId6E7GZJ2lQJivUnzY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758569929; c=relaxed/simple;
	bh=/f/gLZHFUyFl6eAzYG9bjxnINdLY6b3jvGLeWYtGNSI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BMSJJoo+G+1rZm60Dvuh/YvAETX4wLcLdqQWWynW3d3ch1hdRu8bpjZhD7+fYIKHn6tRV/LoASPHbUDUuTxpkAvN0lXxWFNrpeZeP+IyrDg1/V3Uk/Jp1Id05++T3R0CLdtpURxZd9y0SLl3qJFnCEPUTe8We/bnqNfhMg+S5fE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GyycxvFP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GyycxvFP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2E07C4CEF7;
	Mon, 22 Sep 2025 19:38:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758569929;
	bh=/f/gLZHFUyFl6eAzYG9bjxnINdLY6b3jvGLeWYtGNSI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GyycxvFP57PWTNHBje2gZyQjDJTnso0ipEToM+pXTQjG/fWCEkiULbOMTBIXHQaqq
	 XXF4G/+nsbsh8GL/R+uOvjdIrWyiHb2jbLtERQXVr9Ounhjy5un+27UdrNaX1uj833
	 1YAhBfeQDwy/ObIHRNtPm2h4XnyV9laXLrsKs5SU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Metzmacher <metze@samba.org>,
	"Luigino Camastra, Aisle Research" <luigino.camastra@aisle.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.12 034/105] ksmbd: smbdirect: validate data_offset and data_length field of smb_direct_data_transfer
Date: Mon, 22 Sep 2025 21:29:17 +0200
Message-ID: <20250922192409.806885688@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250922192408.913556629@linuxfoundation.org>
References: <20250922192408.913556629@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
 


