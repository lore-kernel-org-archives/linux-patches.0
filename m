Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E21DF28D8E8;
	Thu, 27 Nov 2025 14:53:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764255234; cv=none; b=NUk1kuZZXM173n3sJ1fxd/e6oZOgJnoV4HppT2mUQhhfLTx1NVU5EV4XiDlgybQR2chyLbvx3PQCX7+3meDPOaQAUiefLphZHBgs/vQOOc2eTrSC+Z9+DcTI6ecPQvoig1hkw8FcnYQQje8hhJzJCM5FoPgsPZAolDq2eSQLWk4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764255234; c=relaxed/simple;
	bh=U4swBUNQzIToKizYDbZqAJyt9KKamyLyBtvPiMhyfG0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gm+wd7xHazyJg73dtUnc2kuHYIHCc2CR1fXjBcwXIbhjnWX87g+X+GLnmAwI8jK4Q7+telD2pVu4r1YY7vVZZ37ssZI4lYOU7DhSb/vdqGzaMErOoWARv8fAO1JN45QB20464T8o/bBtHUovUOzAnYIHYs8n8kjpdOJhnEYSIag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MlUVnRrq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MlUVnRrq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3218FC4CEF8;
	Thu, 27 Nov 2025 14:53:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764255232;
	bh=U4swBUNQzIToKizYDbZqAJyt9KKamyLyBtvPiMhyfG0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MlUVnRrqa61Kc1o5cj/mm5jOhVsq9V/ITH/62tRgxekSQ+T4wyWqdm714p7RIoF6P
	 qkE6Q6Tl86xsloYJBA2jYqYSB+ZqLyZ/ja6uLaTWur/6Y/mvMhV7M0FdWF4P90h5jK
	 Q1Dwb9FE9KzxGTANXvcCnGHgjoS/wInP/ioU3nD4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Seungjin Bae <eeodqql09@gmail.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.12 026/112] Input: pegasus-notetaker - fix potential out-of-bounds access
Date: Thu, 27 Nov 2025 15:45:28 +0100
Message-ID: <20251127144033.796446375@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251127144032.705323598@linuxfoundation.org>
References: <20251127144032.705323598@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


