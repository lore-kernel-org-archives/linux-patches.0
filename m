Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7F6D6DD10;
	Tue, 23 Jan 2024 02:03:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975407; cv=none; b=JXyr0Neveqldv6EMd/8f7SEOM7IKJN4GhPCunBwtu2Udbf7rtz1+S2LnmaTVT3HVRkYAMNK4JQcKY9p4QJnGFEUfJJ/YFIgQ8x3fTn/wE2NKylv4R0RMFlk2Me2ClCHjOnAGBgq2qVaWB2Y+WaBX1G1y6LWmi9t2SIjlWRyKBIE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975407; c=relaxed/simple;
	bh=X20E/BumwcPFD+RuWLQ+35/CaHjmYPB0NlGZ6Oc69p8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YIE1Fy9zsMQ5i2n5mLKMLfoquVbbtNviWr29Jw6YTMfyV3kGDQAwuRA5FcJPEdaVqiFjdpn72/sgD7oRYOjrPv+mTyXG5Io3DTPPmuoamqzPitJN8Hm8HW0Iphvf3wWVDs5f7DqU5Z7inBUs/cvdDisw0Xd7N7x9sqr5VXeKUuM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bMippKeV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bMippKeV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC7C1C433B1;
	Tue, 23 Jan 2024 02:03:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975406;
	bh=X20E/BumwcPFD+RuWLQ+35/CaHjmYPB0NlGZ6Oc69p8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bMippKeVn/tsfF2kcVszEAUTtjsoM9ZYv6EJzwqG17uq09jLeOThpGIC9UChQ9Qid
	 9A+rF7q5eoydMRdxZWVCF3+mVFz+I0x/PDc6+hPELiSRyTEP/a7DVZQoG3LBldGVh0
	 tDo6fQcDcsQmdvMrt8NmWKW+ZwsLwZNfVozynXZk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Li <Frank.Li@nxp.com>
Subject: [PATCH 6.6 367/583] usb: cdns3: Fix uvc fail when DMA cross 4k boundery since sg enabled
Date: Mon, 22 Jan 2024 15:56:58 -0800
Message-ID: <20240122235823.245505318@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Frank Li <Frank.Li@nxp.com>

commit 40c304109e866a7dc123661a5c8ca72f6b5e14e0 upstream.

Supposed DMA cross 4k bounder problem should be fixed at DEV_VER_V2, but
still met problem when do ISO transfer if sg enabled.

Data pattern likes below when sg enabled, package size is 1k and mult is 2
	[UVC Header(8B) ] [data(3k - 8)] ...

The received data at offset 0xd000 will get 0xc000 data, len 0x70. Error
happen position as below pattern:
	0xd000: wrong
	0xe000: wrong
	0xf000: correct
	0x10000: wrong
	0x11000: wrong
	0x12000: correct
	...

To avoid DMA cross 4k bounder at ISO transfer, reduce burst len according
to start DMA address's alignment.

Cc:  <stable@vger.kernel.org>
Fixes: 7733f6c32e36 ("usb: cdns3: Add Cadence USB3 DRD Driver")
Signed-off-by: Frank Li <Frank.Li@nxp.com>
Link: https://lore.kernel.org/r/20231224153816.1664687-4-Frank.Li@nxp.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/cdns3/cdns3-gadget.c |   32 +++++++++++++++++++++++++++++++-
 1 file changed, 31 insertions(+), 1 deletion(-)

--- a/drivers/usb/cdns3/cdns3-gadget.c
+++ b/drivers/usb/cdns3/cdns3-gadget.c
@@ -1120,6 +1120,7 @@ static int cdns3_ep_run_transfer(struct
 	u32 togle_pcs = 1;
 	int sg_iter = 0;
 	int num_trb_req;
+	int trb_burst;
 	int num_trb;
 	int address;
 	u32 control;
@@ -1242,7 +1243,36 @@ static int cdns3_ep_run_transfer(struct
 			total_tdl += DIV_ROUND_UP(length,
 					       priv_ep->endpoint.maxpacket);
 
-		trb->length |= cpu_to_le32(TRB_BURST_LEN(priv_ep->trb_burst_size) |
+		trb_burst = priv_ep->trb_burst_size;
+
+		/*
+		 * Supposed DMA cross 4k bounder problem should be fixed at DEV_VER_V2, but still
+		 * met problem when do ISO transfer if sg enabled.
+		 *
+		 * Data pattern likes below when sg enabled, package size is 1k and mult is 2
+		 *       [UVC Header(8B) ] [data(3k - 8)] ...
+		 *
+		 * The received data at offset 0xd000 will get 0xc000 data, len 0x70. Error happen
+		 * as below pattern:
+		 *	0xd000: wrong
+		 *	0xe000: wrong
+		 *	0xf000: correct
+		 *	0x10000: wrong
+		 *	0x11000: wrong
+		 *	0x12000: correct
+		 *	...
+		 *
+		 * But it is still unclear about why error have not happen below 0xd000, it should
+		 * cross 4k bounder. But anyway, the below code can fix this problem.
+		 *
+		 * To avoid DMA cross 4k bounder at ISO transfer, reduce burst len according to 16.
+		 */
+		if (priv_ep->type == USB_ENDPOINT_XFER_ISOC && priv_dev->dev_ver <= DEV_VER_V2)
+			if (ALIGN_DOWN(trb->buffer, SZ_4K) !=
+			    ALIGN_DOWN(trb->buffer + length, SZ_4K))
+				trb_burst = 16;
+
+		trb->length |= cpu_to_le32(TRB_BURST_LEN(trb_burst) |
 					TRB_LEN(length));
 		pcs = priv_ep->pcs ? TRB_CYCLE : 0;
 


