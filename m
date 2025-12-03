Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98BEE30ACE6;
	Wed,  3 Dec 2025 15:44:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764776677; cv=none; b=MbDRcbUOr4xMb1Xkn0Nt2oUOkIqGmTDuPC4xhOKnrfXKwOkqPaTRJuvEmUn/piI12l3JRg6RCuEke5rn5s77PA9GO+5sijCpnfje4/Eg9sSQzaBPHyJ9mkxeOKh4cGXJZSeqzXUqm2FyKTNsOt8xbMrjAfDaoZ8RiKKRVYK5J+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764776677; c=relaxed/simple;
	bh=e0/3rlBwI70/j/eZSA4cxCsM3BlA2WDB1ZxCX0EcGp4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PoK+FoCjLOvQQk1innQ5Gm2dO3IY4X3EoHQRSvcGUMN0Qn3T20UD1g8dunrUlODfvh5mXh3NouOaAgmii6aVhKu4xQx3EzrsUbwqCPDvpHzDKXe6L9J1fNvGPiHS9Y8ZuftcGwRrgV9b8ndzgqpV5W0eQUG8UvzCdikBD2RIqYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WpR33rxR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WpR33rxR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04801C4CEF5;
	Wed,  3 Dec 2025 15:44:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764776677;
	bh=e0/3rlBwI70/j/eZSA4cxCsM3BlA2WDB1ZxCX0EcGp4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WpR33rxRMgitUCUDsit0Wzczy+8SEII5aYMQ3qhnVlUcqMA0ZGIN04pUV0p4zPmmu
	 vLEA7SEeZxWf+5VY7nA3OH5jY1JvDBxP9PN+Xv8oY5bVqgGfl4oJ4KtJKVpKh5SkYt
	 LSNtumGcXG7FyhcAAlNmH8wPanMbokEI8DF78xOE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Seungjin Bae <eeodqql09@gmail.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 255/300] Input: pegasus-notetaker - fix potential out-of-bounds access
Date: Wed,  3 Dec 2025 16:27:39 +0100
Message-ID: <20251203152410.083561046@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152400.447697997@linuxfoundation.org>
References: <20251203152400.447697997@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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


