Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82E471A9B58;
	Thu, 27 Nov 2025 14:48:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764254882; cv=none; b=iRTn91VBuoNTGuY0rFTBfTEkmiFm9u+if+nP6zwYFS6EnWIwpz2JSgpY+zMC5AtknbPbpRQtoxe44Rshx2v/ZmvQpdwAbj5stEaqa2yQIcbiiaw+hhTgGoKRGkHJc+Is1D4AqfVo5yRsuloM7VGFArVG/+KenOsBJwpY8jVgP7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764254882; c=relaxed/simple;
	bh=NsiI5EexURH4K7OipxlVgbk+Ouv8+CmP61u0w2Rp+t4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eS/nOgOLH0gSaYQSUKLKlQJqUE/63dLYZuIlh0CDQmkPLNYikHwrmMGN3u4ad2DqJTcUHOh/tm4h2CH0Heu/1MXMvbRvy3nimIpA0xqFnM3bHx2zOKtqGguz4L89gWu8IvSX3niaam4DHbdqh9i3SgkOpEsEK1cjxZU9oa9hk0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZnxL6l2k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZnxL6l2k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC32EC4CEF8;
	Thu, 27 Nov 2025 14:48:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764254882;
	bh=NsiI5EexURH4K7OipxlVgbk+Ouv8+CmP61u0w2Rp+t4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZnxL6l2kRslDiAHlEUoFAG6cd/XgGCI7NFPjVJabRSxrZAR4VTSiGHJCZdhVgobL3
	 NzCfyLxk9taLEri+VDdWBiHLazn3UJXGKIBfpiRExMHLDcz9YT9qVBHgi12KawwRPd
	 8Fi+C9lZTvyWMrWYOz/reLmjs49pOnpHDW1Eiflo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Seungjin Bae <eeodqql09@gmail.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.6 19/86] Input: pegasus-notetaker - fix potential out-of-bounds access
Date: Thu, 27 Nov 2025 15:45:35 +0100
Message-ID: <20251127144028.520195655@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251127144027.800761504@linuxfoundation.org>
References: <20251127144027.800761504@linuxfoundation.org>
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

From: Seungjin Bae <eeodqql09@gmail.com>

commit 69aeb507312306f73495598a055293fa749d454e upstream.

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
@@ -303,6 +306,12 @@ static int pegasus_probe(struct usb_inte
 	}
 
 	pegasus->data_len = usb_maxpacket(dev, pipe);
+	if (pegasus->data_len < NOTETAKER_PACKET_SIZE) {
+		dev_err(&intf->dev, "packet size is too small (%d)\n",
+			pegasus->data_len);
+		error = -EINVAL;
+		goto err_free_mem;
+	}
 
 	pegasus->data = usb_alloc_coherent(dev, pegasus->data_len, GFP_KERNEL,
 					   &pegasus->data_dma);


