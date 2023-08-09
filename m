Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47C1F1775C
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 11:23:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF9BCC433C8;
	Wed,  9 Aug 2023 11:23:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691580209;
	bh=1KrlRgDgJMD01pr44YWqcVPHLTuU+b7rbTVBEcDTtHQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c3aXQR+m8HdNY0QLxQ+jGWbf2VCZFYtb6dQJtTRqgAtYfKWZrxP98HIBmPBfSC0tw
	 Y+/U65ogiScxKMefu2zmUe64pI6B55Kd93WUTVSmDN978iRiOD9ImpTQnj3gifEZEV
	 sA9wY135F5j8eKuOKOB7LiuHoDeu3/m4B7jFpmRw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Jisheng Zhang <jszhang@kernel.org>,
	Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH 4.19 265/323] usb: dwc3: dont reset device side if dwc3 was configured as host-only
Date: Wed,  9 Aug 2023 12:41:43 +0200
Message-ID: <20230809103710.177815340@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230809103658.104386911@linuxfoundation.org>
References: <20230809103658.104386911@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jisheng Zhang <jszhang@kernel.org>

commit e835c0a4e23c38531dcee5ef77e8d1cf462658c7 upstream.

Commit c4a5153e87fd ("usb: dwc3: core: Power-off core/PHYs on
system_suspend in host mode") replaces check for HOST only dr_mode with
current_dr_role. But during booting, the current_dr_role isn't
initialized, thus the device side reset is always issued even if dwc3
was configured as host-only. What's more, on some platforms with host
only dwc3, aways issuing device side reset by accessing device register
block can cause kernel panic.

Fixes: c4a5153e87fd ("usb: dwc3: core: Power-off core/PHYs on system_suspend in host mode")
Cc: stable <stable@kernel.org>
Signed-off-by: Jisheng Zhang <jszhang@kernel.org>
Acked-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Link: https://lore.kernel.org/r/20230627162018.739-1-jszhang@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc3/core.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/usb/dwc3/core.c
+++ b/drivers/usb/dwc3/core.c
@@ -242,9 +242,9 @@ static int dwc3_core_soft_reset(struct d
 	/*
 	 * We're resetting only the device side because, if we're in host mode,
 	 * XHCI driver will reset the host block. If dwc3 was configured for
-	 * host-only mode, then we can return early.
+	 * host-only mode or current role is host, then we can return early.
 	 */
-	if (dwc->current_dr_role == DWC3_GCTL_PRTCAP_HOST)
+	if (dwc->dr_mode == USB_DR_MODE_HOST || dwc->current_dr_role == DWC3_GCTL_PRTCAP_HOST)
 		return 0;
 
 	reg = dwc3_readl(dwc->regs, DWC3_DCTL);


