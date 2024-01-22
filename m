Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77BE01586F1;
	Tue, 23 Jan 2024 00:28:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969737; cv=none; b=qtEBYxB3OFBPIfCOFIR9b34o3AhL7YW0CpkLN142epoeLnsTimAO+HVYTwtlMYfNqYh+j95QzseccbCq9nnnqLUrx3rfXyeUNfTummohEw9nq4hwkyScsbSIWt3o5kWcbJtQx+czNcEUF/sKUWHNAd1toQY52VHGl96KM1VKWpQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969737; c=relaxed/simple;
	bh=vErsPezn2LFkpmlUhUuPO6s+jT9xKm7MFAuYjbxajZE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=csPyHDY6kbRLF9DDT0CQxPt8xYrObUBQKODK/gk6EKKvc5ScaLTAndi1TxTZ7l4SFwwXRNlBqdxCV72n2l9qYCPgEp/6HsXwcvCZUqi61XtFV4zDLab9SpVbH1GS0tmcyvdyzLq3l5f6yBZdUyDNh+hKNT4aU//0PhuC3xd7qdg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jHdYomr1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jHdYomr1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06EFAC43399;
	Tue, 23 Jan 2024 00:28:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969737;
	bh=vErsPezn2LFkpmlUhUuPO6s+jT9xKm7MFAuYjbxajZE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jHdYomr1m7FhokdY2XvqflYft1xzYOoLsUF87lRAkGAofN3YNwM04Jo25vDgm25Ig
	 Qc+mmPB/kJU0vRAqEVTJTy6f5nh25Lpr0DHRpArEgG4PA5X2kFhTCoKZsAr0xKDuXn
	 AzvMg4tFnZVXO4/CnMOTuYNSpzMGMTNXhsn1QWUc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH 6.7 400/641] Revert "usb: dwc3: dont reset device side if dwc3 was configured as host-only"
Date: Mon, 22 Jan 2024 15:55:04 -0800
Message-ID: <20240122235830.485902647@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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


