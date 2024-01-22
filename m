Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3392112DDB0;
	Tue, 23 Jan 2024 01:02:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705971721; cv=none; b=qzDDKRK2l1ckCcFawG+YMb9J4Zhzn3ftFSLqOyZ25v5TQ+dqVb/pZL9If795Un+ydhXBfrJCj/tbNc9fOMRI3pvfG0jQMKLHjWT7LeB+Rwoyd5sqN/kEqVkGRCE+IVMC78WTlzlxUUICgW2EkwtNHgFdNOu084B7SlXgjQQIV+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705971721; c=relaxed/simple;
	bh=81NA0Wd7aOR7bLV6ZaMRbNGyLSnxIaUOzsU8ndjkYZM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DPFpsteE/sjy5d+7INaPZdbBSI/u01PsEOmfiyG2DHCgzbAl7kTlcsDy/LNiBKsJEiux3X9bkK+JPRSzKgdm3AOuYYb3bjZnf8tAzujK4OU/L/o6q/Ewlr4dpr11DK5sukN9ZFiJZxzycNpyp4E9V0u8mNYos1uz8EVa1d1mxr0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1iG2chbO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1iG2chbO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5497C433C7;
	Tue, 23 Jan 2024 01:02:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705971721;
	bh=81NA0Wd7aOR7bLV6ZaMRbNGyLSnxIaUOzsU8ndjkYZM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1iG2chbOec/4fh0QYi8U8q+Pd4Mi2OTJna4TrS7PfQ2sTxsJJ5bbwIIlPqgGXSYnC
	 xyiFJu29vanWPVB6pEIn0Ne8a/RH/sASy5t/fbv+36AyPu19pNm8Maf0DGTEigMbjS
	 PQBzv7pU39+6cOmbfN52zZlRc6JzLWGlPG8pj41k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH 5.10 214/286] Revert "usb: dwc3: dont reset device side if dwc3 was configured as host-only"
Date: Mon, 22 Jan 2024 15:58:40 -0800
Message-ID: <20240122235740.330733663@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235732.009174833@linuxfoundation.org>
References: <20240122235732.009174833@linuxfoundation.org>
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
@@ -275,9 +275,9 @@ int dwc3_core_soft_reset(struct dwc3 *dw
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


