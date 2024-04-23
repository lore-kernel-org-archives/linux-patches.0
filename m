Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D148148307;
	Tue, 23 Apr 2024 21:45:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908743; cv=none; b=eTCtAlZTCmCQrRvxazDG4fYXwIq/TkDWa4roUOj4ZiQKh6Uwl+SMt8daW5wY9dMsshpfZPyOeaB7cIJSuv0YYcS2HCgMgNkDy8Z4Eab0tBjjM1umFbTun0HMnxo/GzlFOIVfvtBjxu5UV9J2oEas8tepmyC//jaFPD5mJyeDmiI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908743; c=relaxed/simple;
	bh=MuSaYfMusPak1WNuRAtDHsAKsOrktJJzEV4uqIBR4OE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Apf28USkMIdGlxfLX+6TEyTyK495Isze5xosHlZu5pUFoavIBQCjwXyiwPbgKIRxmr6dcalnip2o2d4z9Y3otuav/388k3q6rdzpX/LzQkfcgcYhcdFYNb17v3aezzfgujESAe2y1y438xB83XLjUrB9dzpV7o+v5+ZChTaJZxM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TrvSl5cC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TrvSl5cC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0166DC116B1;
	Tue, 23 Apr 2024 21:45:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908743;
	bh=MuSaYfMusPak1WNuRAtDHsAKsOrktJJzEV4uqIBR4OE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TrvSl5cCKaTW3wK2puqTONKclQJSXhhERli2p19JDS+H4jzwzohoT+doKoNOfiQzr
	 c/ZORD3Sqgj2M/QOjEGVwSM23w+dxOXh8sSlFvFTWgFSqWRJhdZWmKfJwf7Nf5jZDZ
	 nvgOyG5R1Re+mZ1fA6QrKWV1KbMOJ6b9L+BdhVEs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Minas Harutyunyan <Minas.Harutyunyan@synopsys.com>
Subject: [PATCH 6.1 115/141] usb: dwc2: host: Fix dereference issue in DDMA completion flow.
Date: Tue, 23 Apr 2024 14:39:43 -0700
Message-ID: <20240423213856.944373974@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213853.356988651@linuxfoundation.org>
References: <20240423213853.356988651@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Minas Harutyunyan <Minas.Harutyunyan@synopsys.com>

commit eed04fa96c48790c1cce73c8a248e9d460b088f8 upstream.

Fixed variable dereference issue in DDMA completion flow.

Fixes: b258e4268850 ("usb: dwc2: host: Fix ISOC flow in DDMA mode")
CC: stable@vger.kernel.org
Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Closes: https://lore.kernel.org/linux-usb/2024040834-ethically-rumble-701f@gregkh/T/#m4c4b83bef0ebb4b67fe2e0a7d6466cbb6f416e39
Signed-off-by: Minas Harutyunyan <Minas.Harutyunyan@synopsys.com>
Link: https://lore.kernel.org/r/cc826d3ef53c934d8e6d98870f17f3cdc3d2755d.1712665387.git.Minas.Harutyunyan@synopsys.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc2/hcd_ddma.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/usb/dwc2/hcd_ddma.c
+++ b/drivers/usb/dwc2/hcd_ddma.c
@@ -867,13 +867,15 @@ static int dwc2_cmpl_host_isoc_dma_desc(
 	struct dwc2_dma_desc *dma_desc;
 	struct dwc2_hcd_iso_packet_desc *frame_desc;
 	u16 frame_desc_idx;
-	struct urb *usb_urb = qtd->urb->priv;
+	struct urb *usb_urb;
 	u16 remain = 0;
 	int rc = 0;
 
 	if (!qtd->urb)
 		return -EINVAL;
 
+	usb_urb = qtd->urb->priv;
+
 	dma_sync_single_for_cpu(hsotg->dev, qh->desc_list_dma + (idx *
 				sizeof(struct dwc2_dma_desc)),
 				sizeof(struct dwc2_dma_desc),


