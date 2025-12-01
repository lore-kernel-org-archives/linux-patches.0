Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B423225A633;
	Mon,  1 Dec 2025 11:33:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764588825; cv=none; b=V7zjOmJ3fPLML2w9wNpvJkS99prGDQSJ0usyL3NSv7kY/JRjKni10TFbYGi78QcNlnvfypu18MnenpfuXX98Au7vwsTNkjrDgs3hsuVKKMAA18Kci0XBLbMKiQKY5PnuVucdsIp1KeII+KWz/W+6xf8qVntMiRUnlafPkwjtf6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764588825; c=relaxed/simple;
	bh=xnpn+hnHGYGyVo6yDCzGY/MF73NIAP/ZTqCGMgWwSQY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y7ji+6IgeWW0NWjK6ifAwo+AymjxkxLhjkYO2s5g7bD0RXcR+/KZ0K2McjqvREP6gb3DsyOGntVzNI0zK238NvjcGZs1SRkZ8MynmqkxdkwF2d20+9Qbbbh1UD27FyZLEsdww4jJ7jvJgg57MxvXov8RPtOPFrKRyYcyDYixDJQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TQdCeTAi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TQdCeTAi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7F1EC4CEF1;
	Mon,  1 Dec 2025 11:33:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764588825;
	bh=xnpn+hnHGYGyVo6yDCzGY/MF73NIAP/ZTqCGMgWwSQY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TQdCeTAipz0k6g8kSrAyEsaZqu2OwrD8Pk3vnV5yFyccIwpWYhHr3FA2akm9fSulw
	 TPGoh3zh8aUOENOJ5MBPcrvAX5D9QkAa5+zX/3t1PWNmHZyLF4dEdCN9OdmvB3Sj0Q
	 6MFRfTjHEAEC2yNMK4pXRVhkVnghgfhKUvcKQMsw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Seungjin Bae <eeodqql09@gmail.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 183/187] Input: pegasus-notetaker - fix potential out-of-bounds access
Date: Mon,  1 Dec 2025 12:24:51 +0100
Message-ID: <20251201112247.821447507@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251201112241.242614045@linuxfoundation.org>
References: <20251201112241.242614045@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Seungjin Bae <eeodqql09@gmail.com>

[ Upstream commit 69aeb507312306f73495598a055293fa749d454e ]

In the pegasus_notetaker driver, the pegasus_probe() function allocates
the URB transfer buffer using the wMaxPacketSize value from
the endpoint descriptor. An attacker can use a malicious USB descriptor
to force the allocation of a very small buffer.

Subsequently, if the device sends an interrupt packet with a specific
pattern (e.g., where the first byte is 0x80 or 0x42),
the pegasus_parse_packet() function parses the packet without checking
the allocated buffer size. This leads to an out-of-bounds memory access.

Fixes: 1afca2b66aac ("Input: add Pegasus Notetaker tablet driver")
Signed-off-by: Seungjin Bae <eeodqql09@gmail.com>
Link: https://lore.kernel.org/r/20251007214131.3737115-2-eeodqql09@gmail.com
Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/tablet/pegasus_notetaker.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/drivers/input/tablet/pegasus_notetaker.c
+++ b/drivers/input/tablet/pegasus_notetaker.c
@@ -63,6 +63,9 @@
 #define BUTTON_PRESSED			0xb5
 #define COMMAND_VERSION			0xa9
 
+/* 1 Status + 1 Color + 2 X + 2 Y = 6 bytes */
+#define NOTETAKER_PACKET_SIZE		6
+
 /* in xy data packet */
 #define BATTERY_NO_REPORT		0x40
 #define BATTERY_LOW			0x41
@@ -297,6 +300,12 @@ static int pegasus_probe(struct usb_inte
 
 	pipe = usb_rcvintpipe(dev, endpoint->bEndpointAddress);
 	pegasus->data_len = usb_maxpacket(dev, pipe);
+	if (pegasus->data_len < NOTETAKER_PACKET_SIZE) {
+		dev_err(&intf->dev, "packet size is too small (%d)\n",
+			pegasus->data_len);
+		error = -EINVAL;
+		goto err_free_mem;
+	}
 
 	pegasus->data = usb_alloc_coherent(dev, pegasus->data_len, GFP_KERNEL,
 					   &pegasus->data_dma);


