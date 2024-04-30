Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81D5012C805;
	Tue, 30 Apr 2024 11:24:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714476257; cv=none; b=hx7l8NBsj/DhlpD/dnrweoDO1PSHqCdNTBcxc8CD3/dbrue3wju9jED02xBb46n55W4Un6rHCwY1N5ykoZcoc4I5NxrnXrK6QO/rpPt+Df/R4WndbY41ezCw7oJWDfFArShB1avqa3HwunLIyHB7NpJuurf+bAYNsVBoHXEjLQk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714476257; c=relaxed/simple;
	bh=HJ8WZk2vjMyh20c7ugR9KaWkCKF7CreAhC/PtJrx4p8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bwQ/6Ct3J6z0RIruk2vzwEe3cqffnyEZNRganRqrJy/qq8L/OZtrKSQehqadwyDkd/FEW9Ybvezni3tCyLME5BxVfz5HwdC6CBxoFZFZYN8faBQuEKd9bWF5OqAe10bgdyrn2sBT/xQj7oi8K24fEQCDcGaa7HLUu7PzSv//WtA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qWtdWgFN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qWtdWgFN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7977C2BBFC;
	Tue, 30 Apr 2024 11:24:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714476257;
	bh=HJ8WZk2vjMyh20c7ugR9KaWkCKF7CreAhC/PtJrx4p8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qWtdWgFNOUGUjXTluQ1QoijrwuKQ9yY4o4kQxUUR9SMEStRBQHsviTMc04r4/g0ZN
	 /enprR1wBDKEwceAzpeW5EFYVCYK3lvtaPVo+rSHHtakcRvmNwZHiKi1ndwzCClwVr
	 JwSlo/q5woGMRHh94xrgk4XLm7VSfXoRkdqDogwk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Minas Harutyunyan <Minas.Harutyunyan@synopsys.com>
Subject: [PATCH 5.4 045/107] usb: dwc2: host: Fix dereference issue in DDMA completion flow.
Date: Tue, 30 Apr 2024 12:40:05 +0200
Message-ID: <20240430103045.988651321@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103044.655968143@linuxfoundation.org>
References: <20240430103044.655968143@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -897,13 +897,15 @@ static int dwc2_cmpl_host_isoc_dma_desc(
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


