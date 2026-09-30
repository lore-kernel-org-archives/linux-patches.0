Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CABBC514766;
	Wed, 30 Sep 2026 17:03:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790787789; cv=none; b=J2tRl50hqmh6xLMB0wofoMd+k0YKaBWaOnfbOlYImPMeOcMhCDjTDa1oL0RlJOxhEceFgFVXg1n+25d2hySJy2hge2aYKvCzNlE5eF+bE8dhNo7O5+a6I+EKEObgojPm0fyVsjRpCX2utkk5U3rRDp2HmwAHlE3YnB+4LKRIQ9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790787789; c=relaxed/simple;
	bh=DAxdIScqM5KRyOLVF2LxD0NL8xS6+UzaILt3qPZ+NwU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JnqTBZfuSG/pMEq8yBV9GA4k9Eh15fzPsxgwloSVlT4YdnwnIXjh7NxBpFEWIZz32tpxz3Hv0oyfhwqDoT+aLKhfZo0eOLBDIiIIrKyiJJmc+yacSyVFqdKSb2y5DSmedNn7hFZ1xKj3dKOA45mRoWAXI+joMcSj+ximK0MzqHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H3r7gV/G; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H3r7gV/G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31E711F000FF;
	Wed, 30 Sep 2026 17:03:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790787788;
	bh=6LSNFio2+du5rYR3/MzYOPnqkrYreE78hkndeZtXHoQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=H3r7gV/GubqGcWtKNUemSR+ww9duNBvdJ1lgv3Puas6AaksXFMcyyyaoALvwEUxyF
	 Qp6COwuS+v3AxgIaxHmop9xfQeKv8yqZKlTxdwWNLopbwcWl4T1ln8X23YvHlLkzbT
	 QKETuuAy6/hRv0e+v8pwPj0WKHUlJhwGMlBtohqw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Doruk Tan Ozturk <doruk@0sec.ai>,
	Simon Horman <horms@kernel.org>,
	David Heidelberg <david@ixit.cz>
Subject: [PATCH 7.2 355/457] nfc: port100: reject frames whose declared length exceeds the received data
Date: Wed, 30 Sep 2026 17:27:40 +0200
Message-ID: <20260930152353.671896897@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152346.024115587@linuxfoundation.org>
References: <20260930152346.024115587@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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


