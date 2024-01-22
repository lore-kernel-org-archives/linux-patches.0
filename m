Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C01812CDB0;
	Tue, 23 Jan 2024 00:16:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705968998; cv=none; b=rd25G2dXA35zUnTAIjwsMocupW8cMjm0LWJ86VjcEON8TDcBup61e+CyK4emxueBA5TC5BabsOCeKjC6BDLuyMXtt9kNlbGYhS5447KjWsKLmR7DfOUwZJNiqDKbGc37fQTkWX+7KF419Bqfh1MFqnNJfcXaDnCLpC8nUGBKR7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705968998; c=relaxed/simple;
	bh=NZ/8dS/l2BqXh+b/XsvO4xFdDe4FVMEXMranS3Rnnd8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LjW0+EkMDn56P1Lrg9JSzdVkdVou2UQzjPIbaGZQHRZHLLPdSCbTB0XXiEkCW+bKS3jihAfZHKGXnEZP4XYLHpw0gODDxiOOwDZN6ROdTHrv6V1x2RPc9nHCjyV1ePiD+HUZ8ED8htdgy5wtuUhXtXcUETOuRURIxXdkRFRXqXM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wGjUWlrv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wGjUWlrv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8B39C433F1;
	Tue, 23 Jan 2024 00:16:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705968998;
	bh=NZ/8dS/l2BqXh+b/XsvO4xFdDe4FVMEXMranS3Rnnd8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wGjUWlrvknrzYBI85c4nNrRLAaovhYJEg6wItC/nXb3RPxefeJ093JAzq24RrbVIB
	 CwD9+78M5x/2XtkQ+VzpGB5ge8Zg+irUe+U6tSJuHK1iVwdoYzYZ3+vz5VZc/AXQqv
	 YVjSeMIC7mjWzuUp9JZEImnHMnFH8Obgx/pLXWE4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH 5.4 150/194] Revert "usb: dwc3: dont reset device side if dwc3 was configured as host-only"
Date: Mon, 22 Jan 2024 15:58:00 -0800
Message-ID: <20240122235725.642817595@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235719.206965081@linuxfoundation.org>
References: <20240122235719.206965081@linuxfoundation.org>
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

From: Thinh Nguyen <Thinh.Nguyen@synopsys.com>

commit afe28cd686aeb77e8d9140d50fb1cf06a7ecb731 upstream.

This reverts commit e835c0a4e23c38531dcee5ef77e8d1cf462658c7.

Don't omit soft-reset. During initialization, the driver may need to
perform a soft reset to ensure the phy is ready when the controller
updates the GCTL.PRTCAPDIR or other settings by issuing phy soft-reset.
Many platforms often have access to DCTL register for soft-reset despite
being host-only. If there are actual reported issues from the platforms
that don't expose DCTL registers, then we will need to revisit (perhaps
to teach dwc3 to perform xhci's soft-reset USBCMD.HCRST).

Cc:  <stable@vger.kernel.org>
Fixes: e835c0a4e23c ("usb: dwc3: don't reset device side if dwc3 was configured as host-only")
Signed-off-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Link: https://lore.kernel.org/r/7668ab11a48f260820825274976eb41fec7f54d1.1703282469.git.Thinh.Nguyen@synopsys.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc3/core.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/usb/dwc3/core.c
+++ b/drivers/usb/dwc3/core.c
@@ -248,9 +248,9 @@ int dwc3_core_soft_reset(struct dwc3 *dw
 	/*
 	 * We're resetting only the device side because, if we're in host mode,
 	 * XHCI driver will reset the host block. If dwc3 was configured for
-	 * host-only mode or current role is host, then we can return early.
+	 * host-only mode, then we can return early.
 	 */
-	if (dwc->dr_mode == USB_DR_MODE_HOST || dwc->current_dr_role == DWC3_GCTL_PRTCAP_HOST)
+	if (dwc->current_dr_role == DWC3_GCTL_PRTCAP_HOST)
 		return 0;
 
 	reg = dwc3_readl(dwc->regs, DWC3_DCTL);


