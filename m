Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8A4A4ABBA5;
	Wed, 30 Sep 2026 18:24:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790792648; cv=none; b=GF11Lq3pLtkuzaRpPvF3KcBHuleMupQd/vP6EJP/mwLqsq6n/oA/4lMXuTPmWbOnWDS6IPQhxO1v1vpqqavTo2u+iIPjb1k8Ff3inihXE0YPyxr4eR6Q3tBKmGBMH4J9Pqv/slyZOWqKj8VlwMjUPSSc/vpbcQbX1Crg0sdh2+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790792648; c=relaxed/simple;
	bh=8Joa8uNYP55aFKujixPYUMRi8ml7SR9PhSJokZLavn0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UZMgIpUcSw+TUAA5MUJHQk/3QsQHpccmEVYRUg0Kluw770O/isMIq5NFOH3mQGoIU2g9FdjVWrBUyfRNsXi89uVfJ4AjpTPa2N2ojTGv9qvb3iUdX2BAkHQogM6S6D97dwPkb0HoFlhOMaC9cPLLBctWcalikkhcnwDeFtUiBdQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nzPTnaeG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nzPTnaeG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3C481F00899;
	Wed, 30 Sep 2026 18:24:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790792647;
	bh=l7vStYZ5V9GktHdVN/sP/AoNKaZeEQYAnE3rScrfcuU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nzPTnaeGlabNiAupLvrCRiTwdhsAdLuqk65YEPwASjI3uuHI/7jnXs1F8qHYc4fd+
	 4nASrq+6XgLSH/bCXtkXL2r8RDcdBR4zc8nHuCWFTnrMW/JvcCwO0lyq4+RgzO9sBa
	 KD6bMOw3TSU2fVgHo7J5pxwIf8Vkj8ymuC2S7oWg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Doruk Tan Ozturk <doruk@0sec.ai>,
	Simon Horman <horms@kernel.org>,
	David Heidelberg <david@ixit.cz>
Subject: [PATCH 5.15 729/752] nfc: port100: reject frames whose declared length exceeds the received data
Date: Wed, 30 Sep 2026 17:29:59 +0200
Message-ID: <20260930152413.991724722@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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


