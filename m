Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A81956FB8;
	Tue,  5 Dec 2023 03:26:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UwjZvARt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E52DC433C8;
	Tue,  5 Dec 2023 03:26:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701746812;
	bh=n+wx1ZyJIcLPndo7k7agml+vjpHmpZQ2A3XgiI1u3NA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UwjZvARtP6QOMeILZrbA/WVnWl3mE/PaTFt9KdcXauo97GJ4TL6qZLOvmiPJ1QFPW
	 JUsobVzYJ2lH9uRj/6ww5cJMzXZzVNaW5b7gjVi2kXEtnVXyHk7C6eatRSRrm0mOBv
	 KWvk1j83vfGx7Kj85I4gXlsDwZQjGE6zxdtFI86A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oliver Neukum <oneukum@suse.com>,
	Ivan Ivanov <ivan.ivanov@suse.com>,
	Andrea della Porta <andrea.porta@suse.com>,
	stable <stable@kernel.org>
Subject: [PATCH 4.19 30/71] USB: dwc2: write HCINT with INTMASK applied
Date: Tue,  5 Dec 2023 12:16:28 +0900
Message-ID: <20231205031519.606056604@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231205031517.859409664@linuxfoundation.org>
References: <20231205031517.859409664@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oliver Neukum <oneukum@suse.com>

commit 0583bc776ca5b5a3f5752869fc31cf7322df2b35 upstream.

dwc2_hc_n_intr() writes back INTMASK as read but evaluates it
with intmask applied. In stress testing this causes spurious
interrupts like this:

[Mon Aug 14 10:51:07 2023] dwc2 3f980000.usb: dwc2_hc_chhltd_intr_dma: Channel 7 - ChHltd set, but reason is unknown
[Mon Aug 14 10:51:07 2023] dwc2 3f980000.usb: hcint 0x00000002, intsts 0x04600001
[Mon Aug 14 10:51:08 2023] dwc2 3f980000.usb: dwc2_hc_chhltd_intr_dma: Channel 0 - ChHltd set, but reason is unknown
[Mon Aug 14 10:51:08 2023] dwc2 3f980000.usb: hcint 0x00000002, intsts 0x04600001
[Mon Aug 14 10:51:08 2023] dwc2 3f980000.usb: dwc2_hc_chhltd_intr_dma: Channel 4 - ChHltd set, but reason is unknown
[Mon Aug 14 10:51:08 2023] dwc2 3f980000.usb: hcint 0x00000002, intsts 0x04600001
[Mon Aug 14 10:51:08 2023] dwc2 3f980000.usb: dwc2_update_urb_state_abn(): trimming xfer length

Applying INTMASK prevents this. The issue exists in all versions of the
driver.

Signed-off-by: Oliver Neukum <oneukum@suse.com>
Tested-by: Ivan Ivanov <ivan.ivanov@suse.com>
Tested-by: Andrea della Porta <andrea.porta@suse.com>
Link: https://lore.kernel.org/r/20231115144514.15248-1-oneukum@suse.com
Cc: stable <stable@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc2/hcd_intr.c |   15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

--- a/drivers/usb/dwc2/hcd_intr.c
+++ b/drivers/usb/dwc2/hcd_intr.c
@@ -2045,15 +2045,17 @@ static void dwc2_hc_n_intr(struct dwc2_h
 {
 	struct dwc2_qtd *qtd;
 	struct dwc2_host_chan *chan;
-	u32 hcint, hcintmsk;
+	u32 hcint, hcintraw, hcintmsk;
 
 	chan = hsotg->hc_ptr_array[chnum];
 
-	hcint = dwc2_readl(hsotg, HCINT(chnum));
+	hcintraw = dwc2_readl(hsotg, HCINT(chnum));
 	hcintmsk = dwc2_readl(hsotg, HCINTMSK(chnum));
+	hcint = hcintraw & hcintmsk;
+	dwc2_writel(hsotg, hcint, HCINT(chnum));
+
 	if (!chan) {
 		dev_err(hsotg->dev, "## hc_ptr_array for channel is NULL ##\n");
-		dwc2_writel(hsotg, hcint, HCINT(chnum));
 		return;
 	}
 
@@ -2062,11 +2064,9 @@ static void dwc2_hc_n_intr(struct dwc2_h
 			 chnum);
 		dev_vdbg(hsotg->dev,
 			 "  hcint 0x%08x, hcintmsk 0x%08x, hcint&hcintmsk 0x%08x\n",
-			 hcint, hcintmsk, hcint & hcintmsk);
+			 hcintraw, hcintmsk, hcint);
 	}
 
-	dwc2_writel(hsotg, hcint, HCINT(chnum));
-
 	/*
 	 * If we got an interrupt after someone called
 	 * dwc2_hcd_endpoint_disable() we don't want to crash below
@@ -2076,8 +2076,7 @@ static void dwc2_hc_n_intr(struct dwc2_h
 		return;
 	}
 
-	chan->hcint = hcint;
-	hcint &= hcintmsk;
+	chan->hcint = hcintraw;
 
 	/*
 	 * If the channel was halted due to a dequeue, the qtd list might


