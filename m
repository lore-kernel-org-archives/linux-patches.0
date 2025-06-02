Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88B6A223324;
	Mon,  2 Jun 2025 14:42:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748875328; cv=none; b=FNOgtJFNtVQPyygzH8P5h9z1SrOF68KLfBXhtGRaEtdhuOj2konnUf2ANVLgL4Lc2ijwYiGUR2QRZb/K2nGOqKNmZbzQCNB6MsSIjPuDg4WDi811TE6H7ekd6mDPxIbC37YdTyfM+MDsMOF4K5x0YWtL6+Ty5mLKLYzwAOwIsQk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748875328; c=relaxed/simple;
	bh=R3NXbNmEUTlz4eA2XkhfwLwBGoGWaqWQ4IRQ4ompFDo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uPeOQqBzWKrzbP2q99Ceja2BEELZRbUwmmhppzzORjtvtGkYGlzQg0kQwc6rby1/8VIw38Bl19lmVQZFeTlRwqRz7m6gzJeHQZLD12eqGY1c/yccMOQTgx9+1PnCyYP73ca85shtbBc8+72R3vP7tB+S0VM07a7xT4yJe5P5Ac8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b6YziXzA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b6YziXzA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D94DC4CEEB;
	Mon,  2 Jun 2025 14:42:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748875328;
	bh=R3NXbNmEUTlz4eA2XkhfwLwBGoGWaqWQ4IRQ4ompFDo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b6YziXzAB5fUTIaU3iRxic67fv1nYAJdlquRelwF3/hPtzlu357OHUbZ4N4nw7d8J
	 qhHKYpIH3t3hAW6ARsvqQ86kUKyLTEI2+U8Lln9rFxA1GSBC6AIB4aG6FxPltkvIAn
	 jaEeRr+uItpbtvZevyoyEYJOnTyE7ELKNSMyeLKQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Wayne Chang <waynec@nvidia.com>
Subject: [PATCH 5.10 069/270] usb: gadget: tegra-xudc: ACK ST_RC after clearing CTRL_RUN
Date: Mon,  2 Jun 2025 15:45:54 +0200
Message-ID: <20250602134310.008542528@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134307.195171844@linuxfoundation.org>
References: <20250602134307.195171844@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Wayne Chang <waynec@nvidia.com>

commit 59820fde001500c167342257650541280c622b73 upstream.

We identified a bug where the ST_RC bit in the status register was not
being acknowledged after clearing the CTRL_RUN bit in the control
register. This could lead to unexpected behavior in the USB gadget
drivers.

This patch resolves the issue by adding the necessary code to explicitly
acknowledge ST_RC after clearing CTRL_RUN based on the programming
sequence, ensuring proper state transition.

Fixes: 49db427232fe ("usb: gadget: Add UDC driver for tegra XUSB device mode controller")
Cc: stable <stable@kernel.org>
Signed-off-by: Wayne Chang <waynec@nvidia.com>
Link: https://lore.kernel.org/r/20250418081228.1194779-1-waynec@nvidia.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/udc/tegra-xudc.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/usb/gadget/udc/tegra-xudc.c
+++ b/drivers/usb/gadget/udc/tegra-xudc.c
@@ -1737,6 +1737,10 @@ static int __tegra_xudc_ep_disable(struc
 		val = xudc_readl(xudc, CTRL);
 		val &= ~CTRL_RUN;
 		xudc_writel(xudc, val, CTRL);
+
+		val = xudc_readl(xudc, ST);
+		if (val & ST_RC)
+			xudc_writel(xudc, ST_RC, ST);
 	}
 
 	dev_info(xudc->dev, "ep %u disabled\n", ep->index);


