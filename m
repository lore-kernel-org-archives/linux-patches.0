Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60E071F957
	for <patches@lists.linux.dev>; Tue,  1 Aug 2023 09:36:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6ABCC433C9;
	Tue,  1 Aug 2023 09:36:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690882608;
	bh=hB7NuOiQg8PlTLYscv7D/DffUh8UyxyCY7hI5dm6BQU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R9iduapVGEDVSso8pau6elIIdedBv3g5dFcn4a6vVqtFlMz4eRXdsy/9EC2TdH9iv
	 UjdVDpgMh10ApLAC+6rX6KwS91Z+zYrVl0zb+jsT51xBdUbU/rzYzsz+kGv8yFwCW4
	 cLiyekQIyiDqX3aumenFinpY+CnhcQfkEal4/8kw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Jisheng Zhang <jszhang@kernel.org>,
	Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH 6.1 166/228] usb: dwc3: dont reset device side if dwc3 was configured as host-only
Date: Tue,  1 Aug 2023 11:20:24 +0200
Message-ID: <20230801091928.865156933@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230801091922.799813980@linuxfoundation.org>
References: <20230801091922.799813980@linuxfoundation.org>
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
@@ -277,9 +277,9 @@ int dwc3_core_soft_reset(struct dwc3 *dw
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


