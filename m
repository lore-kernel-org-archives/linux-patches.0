Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE1DD178381;
	Tue,  2 Jul 2024 17:15:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719940543; cv=none; b=AC94zyuQ4ZrQxNbr5gzwqUzQ920y6pvJgJPs1TQyEvYLDtr+TfwmsZAoBR/+gc/uhv0BYmPGWtskYWiXDF0ApFqmIJH2DPekBCZXz3aMl38AxKLNCsh3XIdz2JCmzHCCDZ4wTny9MjTM1CETobJUG42d6M9hOWNMkvwwMjtJPxM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719940543; c=relaxed/simple;
	bh=UPgLQsy/3id1s3TYqrSWv4t9HwweA7iT7juYPvdWT4Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NA0iWTuwQYxDr/Xn5KLhlpVxK61Uu8vlxNhS49nmanCW4Jl4VivWSfPqtt1e3qw1Bcxo7qJ0k5xFaa42efrkmXWMyAeDEqd9k2cypdaLVNlYhWkM4gdht/dHcouwul90u7Ykx+nyyvojlXB9me28AgPe+1W2O2HbxshHpTBh794=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w4hGoXU+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w4hGoXU+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DA53C4AF0C;
	Tue,  2 Jul 2024 17:15:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719940543;
	bh=UPgLQsy/3id1s3TYqrSWv4t9HwweA7iT7juYPvdWT4Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w4hGoXU+MgYMrJaGbnaClHIF1fRv5qPPKPruyB2bQ8qdRof3C8q3Bpz2SRW2l4vXY
	 XffAOjmwnRRgx/SG53q7ypSu7OSvQq/kQcfZKyv+bfnF25yjAVHv8Ee4zNh/Zu/Kos
	 iDyUG2TYBTcbYpVM2eanW7EZP/MxprOy5i568StU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jos Wang <joswang@lenovo.com>,
	Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
	stable <stable@kernel.org>
Subject: [PATCH 6.9 154/222] usb: dwc3: core: Workaround for CSR read timeout
Date: Tue,  2 Jul 2024 19:03:12 +0200
Message-ID: <20240702170249.864246563@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170243.963426416@linuxfoundation.org>
References: <20240702170243.963426416@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jos Wang <joswang@lenovo.com>

commit fc1d1a712b517bbcb383b1f1f7ef478e7d0579f2 upstream.

This is a workaround for STAR 4846132, which only affects
DWC_usb31 version2.00a operating in host mode.

There is a problem in DWC_usb31 version 2.00a operating
in host mode that would cause a CSR read timeout When CSR
read coincides with RAM Clock Gating Entry. By disable
Clock Gating, sacrificing power consumption for normal
operation.

Cc: stable <stable@kernel.org> # 5.10.x: 1e43c86d: usb: dwc3: core: Add DWC31 version 2.00a controller
Signed-off-by: Jos Wang <joswang@lenovo.com>
Acked-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Link: https://lore.kernel.org/r/20240619114529.3441-1-joswang1221@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc3/core.c |   20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

--- a/drivers/usb/dwc3/core.c
+++ b/drivers/usb/dwc3/core.c
@@ -879,12 +879,16 @@ static bool dwc3_core_is_valid(struct dw
 
 static void dwc3_core_setup_global_control(struct dwc3 *dwc)
 {
+	unsigned int power_opt;
+	unsigned int hw_mode;
 	u32 reg;
 
 	reg = dwc3_readl(dwc->regs, DWC3_GCTL);
 	reg &= ~DWC3_GCTL_SCALEDOWN_MASK;
+	hw_mode = DWC3_GHWPARAMS0_MODE(dwc->hwparams.hwparams0);
+	power_opt = DWC3_GHWPARAMS1_EN_PWROPT(dwc->hwparams.hwparams1);
 
-	switch (DWC3_GHWPARAMS1_EN_PWROPT(dwc->hwparams.hwparams1)) {
+	switch (power_opt) {
 	case DWC3_GHWPARAMS1_EN_PWROPT_CLK:
 		/**
 		 * WORKAROUND: DWC3 revisions between 2.10a and 2.50a have an
@@ -917,6 +921,20 @@ static void dwc3_core_setup_global_contr
 		break;
 	}
 
+	/*
+	 * This is a workaround for STAR#4846132, which only affects
+	 * DWC_usb31 version2.00a operating in host mode.
+	 *
+	 * There is a problem in DWC_usb31 version 2.00a operating
+	 * in host mode that would cause a CSR read timeout When CSR
+	 * read coincides with RAM Clock Gating Entry. By disable
+	 * Clock Gating, sacrificing power consumption for normal
+	 * operation.
+	 */
+	if (power_opt != DWC3_GHWPARAMS1_EN_PWROPT_NO &&
+	    hw_mode != DWC3_GHWPARAMS0_MODE_GADGET && DWC3_VER_IS(DWC31, 200A))
+		reg |= DWC3_GCTL_DSBLCLKGTNG;
+
 	/* check if current dwc3 is on simulation board */
 	if (dwc->hwparams.hwparams6 & DWC3_GHWPARAMS6_EN_FPGA) {
 		dev_info(dwc->dev, "Running with FPGA optimizations\n");


