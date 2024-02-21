Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93217762C1;
	Wed, 21 Feb 2024 13:54:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708523698; cv=none; b=aoe01ewGOYBMlCe/ZxFhPr67tIqfQbOLVgPJRQt/IFovLbWQyIC4HEjb4Hn6cfeuGAWi6cOHbpoeAjfFdtDCTZFzR/L93lIn7qSgNksN4e0qC08CsVaKtigiFYZ/YnAKbq9aEWiFpcQzHhA6eSJ3UssILxTSupVNnO6Rjbo6KIA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708523698; c=relaxed/simple;
	bh=x4AtH/sZaJBfS6ZfbV/LBfLGsk+BPNiseBk1eQ3IdpE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f1Z+NujQ3tFHU+CKBbqb3/879GhOHYoYtvaH7UEVbajeTBdL7DlbPylLzG9Yl+DmeyaUm/LcXORsgIiDSQQpHW1kJqYBMasa3B8qJRfZS3pSzUlk4SrogvQg0sHcaYZGy9HxP/D5XprQaNuOePV+tc/3GTC0Vpcp5buvWnYC3Yw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hKET4KSg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hKET4KSg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09FA4C433C7;
	Wed, 21 Feb 2024 13:54:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708523698;
	bh=x4AtH/sZaJBfS6ZfbV/LBfLGsk+BPNiseBk1eQ3IdpE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hKET4KSgvO/MB+3MAnAx9Pm9PBW6LonCLwpc/b81fOewasqytd0RleDuP2TkDPRIH
	 MuwZKa6NfXW8MraeXbl52JebdJckxP1Gs0SEsldeb4ttBYt0TFRiylRGUV0O8oUDhD
	 wbaEfjKjlbm+LNeddimGEvEp/K0/STjY0EQcnP1w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 005/379] usb: cdns3: Fix uvc fail when DMA cross 4k boundery since sg enabled
Date: Wed, 21 Feb 2024 14:03:04 +0100
Message-ID: <20240221125955.081133755@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125954.917878865@linuxfoundation.org>
References: <20240221125954.917878865@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Frank Li <Frank.Li@nxp.com>

[ Upstream commit 40c304109e866a7dc123661a5c8ca72f6b5e14e0 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/cdns3/gadget.c | 32 +++++++++++++++++++++++++++++++-
 1 file changed, 31 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/cdns3/gadget.c b/drivers/usb/cdns3/gadget.c
index 118c9402bb60..8a1f0a636848 100644
--- a/drivers/usb/cdns3/gadget.c
+++ b/drivers/usb/cdns3/gadget.c
@@ -1119,6 +1119,7 @@ static int cdns3_ep_run_transfer(struct cdns3_endpoint *priv_ep,
 	u32 togle_pcs = 1;
 	int sg_iter = 0;
 	int num_trb_req;
+	int trb_burst;
 	int num_trb;
 	int address;
 	u32 control;
@@ -1241,7 +1242,36 @@ static int cdns3_ep_run_transfer(struct cdns3_endpoint *priv_ep,
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
 
-- 
2.43.0



