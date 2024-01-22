Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB9DF7317E;
	Tue, 23 Jan 2024 02:03:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975430; cv=none; b=cVbU8onBNGqDhgpJ1NanpqCigAMwBT/46krUlaT4mQtEVsDKvPJ73rqzwZ3riUPJ1Odk2Op1dJ57nwEz3buyDd2y1nLQR4MmOFjjSmkN+6fFok5Eq4Ficz7pfIOLjOLTRGs8VPsLK+uODYbQSiTfmuGktSxw27nGKMNBf/fQs+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975430; c=relaxed/simple;
	bh=hglqWBY0nugXjHaYGam2nCN4Ax4vPH7XgXE+vABJ1Hk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oHabi2AGbRb/3s7M0VS0dvJY4fz5vUag4cnnb1jDtxVklpIxpZWpShFxpiJrE1oPQtfc13AMYZQZzrzgycBHLqUNPsxmza7K8p497yPUTYhBu+ASjSx99bxR5cafoqHjGfTK0wAvoFAYioxWAPjfYBjNhL17J8qbBDG1wE0RvJA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PAZdWOML; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PAZdWOML"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E453C43390;
	Tue, 23 Jan 2024 02:03:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975430;
	bh=hglqWBY0nugXjHaYGam2nCN4Ax4vPH7XgXE+vABJ1Hk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PAZdWOML1ijsKPv/EVjjR2P4bRx0/mYBRuNrfmODwp7/rIk30ERghisXvIVZaiJjl
	 qdq63cBJPfXe3alSehp1I6Af2iGadWXlD1kBPWdjpW7e6u4KWTz1l2xmUIVCz84hOY
	 qdCTGAI6xKuzBiZw8CQbV3zfiBA0HaptcuNGSUb8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH 6.6 363/583] Revert "usb: dwc3: dont reset device side if dwc3 was configured as host-only"
Date: Mon, 22 Jan 2024 15:56:54 -0800
Message-ID: <20240122235823.126649685@linuxfoundation.org>
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
@@ -277,9 +277,9 @@ int dwc3_core_soft_reset(struct dwc3 *dw
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


