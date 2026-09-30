Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3746E45D926;
	Wed, 30 Sep 2026 19:38:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790797084; cv=none; b=VjUnM5lwnajcPrRVMzIsMiYhAZRzj3n3PODBZjr1WzeWmtonaWoo5pt1ES9rITz5PS49RRl9lSFmFWDqQo6X9EpNAz1lpzMtU8iEnq66PnAMSbgJd8Pwibo0nv4vk+++haw3wlMHGwV2d+EhIqxVK1oCKDbK4PrbofsN0WjB1k4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790797084; c=relaxed/simple;
	bh=5VNz8xc36yXT1LrYGCql+05li1guyA4uyzLnzJIjeJc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WmRpb28CPufU48YAJZQ5yfUd/6vt0SRZnq0wcymp6617/SQ2GZck4YJa2721I9h05aOLIgmoe7CMVZ2R2yxGNx4le+KtjIyfNDEilDDawX1b97Qd9CDMsJCqLdPhwLTviQ7w9I70dYzI4NzN1yL8YwPanU8AgFVquid29/gF3Po=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AmCtlX7r; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AmCtlX7r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FEE71F000FF;
	Wed, 30 Sep 2026 19:38:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790797083;
	bh=E/bS7bPri0qdhizXIYxf0Gl/J7cd9GjUcb1/G4E1Yrk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AmCtlX7rtr+/6u60cpMjF2qp3uVcWd+15CZOqKXjiAqcc0e3cRCot4acjWHAb5xby
	 6UH4u/e/npydDTFhunx60UpCGalzWA6FczM4e9P7SmNtakt7yBKYIQ377/yMuC+v1W
	 sd5T+hZvfq5WsuP+mA8K+9B4vvvEvIlIZXZw1qD8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Doruk Tan Ozturk <doruk@0sec.ai>,
	Simon Horman <horms@kernel.org>,
	David Heidelberg <david@ixit.cz>
Subject: [PATCH 6.6 1139/1193] nfc: port100: reject frames whose declared length exceeds the received data
Date: Wed, 30 Sep 2026 17:30:23 +0200
Message-ID: <20260930152459.545044857@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Doruk Tan Ozturk <doruk@0sec.ai>

commit 092c6a605cbd6414ef499834c2e0da69c2c3388e upstream.

port100_recv_response() passes the URB transfer buffer to
port100_rx_frame_is_valid(), which checksums le16_to_cpu(frame->datalen)
bytes of frame->data. datalen is a 16-bit field supplied by the device
and is never checked against the number of bytes actually received
(urb->actual_length), so a device reporting a datalen larger than the
received frame makes port100_data_checksum() read out of bounds past the
transfer buffer.

Reject a response whose declared frame size does not fit the received
length before validating it.

Found by 0sec (https://0sec.ai) using automated source analysis; the
missing bound is evident from source. Compile-tested.

Fixes: 562d4d59b8a1 ("NFC: Sony Port-100 Series driver")
Cc: stable@vger.kernel.org
Assisted-by: 0sec:claude-opus-4-8
Signed-off-by: Doruk Tan Ozturk <doruk@0sec.ai>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20260711123651.32595-1-doruk@0sec.ai
Signed-off-by: David Heidelberg <david@ixit.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nfc/port100.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/nfc/port100.c
+++ b/drivers/nfc/port100.c
@@ -636,6 +636,13 @@ static void port100_recv_response(struct
 
 	in_frame = dev->in_urb->transfer_buffer;
 
+	if (urb->actual_length < PORT100_FRAME_HEADER_LEN ||
+	    urb->actual_length < port100_rx_frame_size(in_frame)) {
+		nfc_err(&dev->interface->dev, "Received a truncated frame\n");
+		cmd->status = -EIO;
+		goto sched_wq;
+	}
+
 	if (!port100_rx_frame_is_valid(in_frame)) {
 		nfc_err(&dev->interface->dev, "Received an invalid frame\n");
 		cmd->status = -EIO;


