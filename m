Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67B5F3E49F5;
	Tue, 21 Jul 2026 17:28:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654919; cv=none; b=jbxnU/ubhq2186x1hbbQrHH/UKaQDwh3bljxd8Pz2BA314+n0/BBy8Px7skcLSU1egYWfVVICs9+Npc+6jXEqpV3MNa6PtNYdZ6iW0EuHgXPbxJRkBqtd3VLN7tch0Ucyh4RLswtLk4zclcLVL8Kv0Wo5S7WWnoZHoxgQ80ZTFU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654919; c=relaxed/simple;
	bh=E5wQ1rP0Md6oxd83BDrDqt015ajgzwXWuacsgb8SUJY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=marKWWg8mpD/IOAj5me7nbSRSPu8FfRsV280NE7uGuoIMIaacDP0L2nyDsrxZkwyMN+N6NRdgEFLTY6DwVRKlkQ2cVJadhHiIbPd14SeX+dBcjCTt/9JGLDEG+Huet1lfNy8vphggtGifZQm9f8BHtSK5OLdhy6px8HoEkgvN1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KRyxiT71; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KRyxiT71"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91AFD1F000E9;
	Tue, 21 Jul 2026 17:28:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784654918;
	bh=oL3zEYt2cxMDjmVieKVG08VBJbmXFNDxEwSYxGE6yzM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KRyxiT71vHY3zigOOF4fObqBTwIw5r9wD9XPMm5TSzW1f4lM1lrj6Uutstr6gb7eR
	 aYhi1fp6UO/gW809jjryNbpfIFdh/HIUXU6JUNPsmRXVGfIQ+h6PyHxE4FpaQej2Vn
	 kbZCnlGnxAJj6x2VrLncbICN3hX6iUAlMiEGmsZM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko bot <sashiko-bot@kernel.org>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 7.1 1885/2077] Input: ims-pcu - fix DMA mapping violation in line setup
Date: Tue, 21 Jul 2026 17:25:58 +0200
Message-ID: <20260721152637.180836735@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

commit 8adf4289d945e8990e4336436a97da71d21d2cae upstream.

In ims_pcu_line_setup(), the driver uses pcu->cmd_buf as a transfer
buffer for usb_control_msg(). However, pcu->cmd_buf is embedded in the
struct ims_pcu allocation, which violates DMA mapping rules regarding
cacheline alignment.

Use a heap-allocated buffer for the line coding data instead.

Fixes: 628329d52474 ("Input: add IMS Passenger Control Unit driver")
Cc: stable@vger.kernel.org
Reported-by: Sashiko bot <sashiko-bot@kernel.org>
Assisted-by: Gemini:gemini-3.1-pro
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/misc/ims-pcu.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/drivers/input/misc/ims-pcu.c
+++ b/drivers/input/misc/ims-pcu.c
@@ -1841,11 +1841,16 @@ static void ims_pcu_stop_io(struct ims_p
 static int ims_pcu_line_setup(struct ims_pcu *pcu)
 {
 	struct usb_host_interface *interface = pcu->ctrl_intf->cur_altsetting;
-	struct usb_cdc_line_coding *line = (void *)pcu->cmd_buf;
+	struct usb_cdc_line_coding *line __free(kfree) =
+				kmalloc(sizeof(*line), GFP_KERNEL);
 	int error;
 
-	memset(line, 0, sizeof(*line));
+	if (!line)
+		return -ENOMEM;
+
 	line->dwDTERate = cpu_to_le32(57600);
+	line->bCharFormat = USB_CDC_1_STOP_BITS;
+	line->bParityType = USB_CDC_NO_PARITY;
 	line->bDataBits = 8;
 
 	error = usb_control_msg(pcu->udev, usb_sndctrlpipe(pcu->udev, 0),


