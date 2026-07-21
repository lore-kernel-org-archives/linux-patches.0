Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2066A471423;
	Tue, 21 Jul 2026 18:48:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784659704; cv=none; b=cAzy8mC+Cq1VDBM9pMrav108XJdBEQIwgWyFMDv6lLQrFyQ7Ww55lyoROeILE0XAWsMWkdueW3QmJt7qmiW4vlnnW5IKyVdYEzvVDE6Gra3J62Czeg+E75HQuefe3p+lmdqW2CogB96GtIO1iFQYF3Fa3hHdA+7AWVJQFLV2TIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784659704; c=relaxed/simple;
	bh=L2CkW8g6DQF5BNuWGTvptaqILg1wyTfjzJKj6h7UBNo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GiMcys33+JVfZilpAEqcPgH2JLiRo+hNGSQAE/K3PEMZL4FMEjez7ngXvfsVx6Ts2WKPBnjg5UTSu8t8B+VvEjMbbY9EDPzvol1EfsMOFcVik7UGoiLE5zFjwBPtYuKH4btMB0TrncV00F63mTm1Tf1c7k4R0+NsXpOFCWAAJeY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dthr9RAl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dthr9RAl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 207771F00A3E;
	Tue, 21 Jul 2026 18:48:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784659698;
	bh=F+PkUf/UUVYCrM8yaciwShfrwthXPqKh7FI5irYLGwQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dthr9RAldPICl3qeaDxVEmT1lk75KdiAsAEfsa4aYUL3nRCryzSpjsvUm9oP1UO1J
	 8CBiKek5W7iAWeacu1kcI+yzPqxUiA+yO8Njr3Os0Is+wEkctjZ4TbDj/Jvj4CJ5+s
	 MRarc7OFR/EbSFVaLEPpDcMVS5kBeDi+C8cdSpVw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
	Ben Dooks <ben.dooks@codethink.co.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1574/1611] usb: dwc3: fix dwc3_readl() and dwc3_writel() calls in dwc3_ulpi_setup()
Date: Tue, 21 Jul 2026 17:28:10 +0200
Message-ID: <20260721152550.873155494@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Dooks <ben.dooks@codethink.co.uk>

[ Upstream commit e0f844d9d74200d311c6438a0f04270834ba5365 ]

The dwc3_ulpi_setup() calls the register read and write calls with
dwc3->regs when both these calls take the dwc3 structure directly.

Chnage these two calls to fix the following sparse warning, and
possibly a nasty bug in the dwc3_ulpi_setup() code:

drivers/usb/dwc3/core.c:796:45: warning: incorrect type in argument 1 (different address spaces)
drivers/usb/dwc3/core.c:796:45:    expected struct dwc3 *dwc
drivers/usb/dwc3/core.c:796:45:    got void [noderef] __iomem *regs
drivers/usb/dwc3/core.c:798:40: warning: incorrect type in argument 1 (different address spaces)
drivers/usb/dwc3/core.c:798:40:    expected struct dwc3 *dwc
drivers/usb/dwc3/core.c:798:40:    got void [noderef] __iomem *regs

Cc: stable <stable@kernel.org>
Fixes: 9accc68b1cf0 ("usb: dwc3: Add dwc pointer to dwc3_readl/writel")
Acked-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Signed-off-by: Ben Dooks <ben.dooks@codethink.co.uk>
Link: https://patch.msgid.link/20260703162033.2847599-1-ben.dooks@codethink.co.uk
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc3/core.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/usb/dwc3/core.c
+++ b/drivers/usb/dwc3/core.c
@@ -792,9 +792,9 @@ static void dwc3_ulpi_setup(struct dwc3
 
 	if (dwc->enable_usb2_transceiver_delay) {
 		for (index = 0; index < dwc->num_usb2_ports; index++) {
-			reg = dwc3_readl(dwc->regs, DWC3_GUSB2PHYCFG(index));
+			reg = dwc3_readl(dwc, DWC3_GUSB2PHYCFG(index));
 			reg |= DWC3_GUSB2PHYCFG_XCVRDLY;
-			dwc3_writel(dwc->regs, DWC3_GUSB2PHYCFG(index), reg);
+			dwc3_writel(dwc, DWC3_GUSB2PHYCFG(index), reg);
 		}
 	}
 }


