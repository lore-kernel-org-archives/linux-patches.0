Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C1CE15B10D;
	Mon, 28 Oct 2024 06:42:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730097779; cv=none; b=O5BgDixDbz63UjFaj/ySAcaAhaquoZvzUXaAr1xNfwkmDQD9xcjMSehTb5q41aIwOYn4k2IcZuIysr17IxrfQ2xKbINy/wnkVhVlAjVfU8TojjbgBj8L7uHCxG2jda3/JHBgHMderVexgXp8yryuhZvEbwsWIIkHWiXVMdGyFk0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730097779; c=relaxed/simple;
	bh=leZbh06WwREgnlaiJ7ykulNhblKXJ5AEy1vF7DglamA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tUafml13IUXQv4ojAWr9Xw25L8PrZJKlR5RviKom27NmJcaA/IdqOHm11Vw9myj36vJt++vdYSfR/0VxDRKMhbFi1+cBLwefJcG4fkkarLSam6Vs0IWY/cu3TOjD5Gb0VH6krwvrUK3c1codWIT/AdcY5PYwtoV4atiEuP4DOhU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EuYLVqWO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EuYLVqWO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A565C4CEC3;
	Mon, 28 Oct 2024 06:42:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730097779;
	bh=leZbh06WwREgnlaiJ7ykulNhblKXJ5AEy1vF7DglamA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EuYLVqWOrlXVunpadlGg6LaZjBcAw0+PKts2OlJN+u3OVsJPsATwghjTdHiiR1WOB
	 Vy+xFmjCDd9QrkraQ7VsAgz/JW+rr+zy/0Kqo7jVseXB20vIxDHjrrsyHB7/3f1pTJ
	 mMaRyo5u9ix+rH2VnjZ0us0jvEt0uSJCk8aDvldQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Roger Quadros <rogerq@kernel.org>,
	Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
	Markus Schneider-Pargmann <msp@baylibre.com>,
	Dhruva Gole <d-gole@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 106/208] usb: dwc3: core: Fix system suspend on TI AM62 platforms
Date: Mon, 28 Oct 2024 07:24:46 +0100
Message-ID: <20241028062309.269925907@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062306.649733554@linuxfoundation.org>
References: <20241028062306.649733554@linuxfoundation.org>
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

From: Roger Quadros <rogerq@kernel.org>

[ Upstream commit 705e3ce37bccdf2ed6f848356ff355f480d51a91 ]

Since commit 6d735722063a ("usb: dwc3: core: Prevent phy suspend during init"),
system suspend is broken on AM62 TI platforms.

Before that commit, both DWC3_GUSB3PIPECTL_SUSPHY and DWC3_GUSB2PHYCFG_SUSPHY
bits (hence forth called 2 SUSPHY bits) were being set during core
initialization and even during core re-initialization after a system
suspend/resume.

These bits are required to be set for system suspend/resume to work correctly
on AM62 platforms.

Since that commit, the 2 SUSPHY bits are not set for DEVICE/OTG mode if gadget
driver is not loaded and started.
For Host mode, the 2 SUSPHY bits are set before the first system suspend but
get cleared at system resume during core re-init and are never set again.

This patch resovles these two issues by ensuring the 2 SUSPHY bits are set
before system suspend and restored to the original state during system resume.

Cc: stable@vger.kernel.org # v6.9+
Fixes: 6d735722063a ("usb: dwc3: core: Prevent phy suspend during init")
Link: https://lore.kernel.org/all/1519dbe7-73b6-4afc-bfe3-23f4f75d772f@kernel.org/
Signed-off-by: Roger Quadros <rogerq@kernel.org>
Acked-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Tested-by: Markus Schneider-Pargmann <msp@baylibre.com>
Reviewed-by: Dhruva Gole <d-gole@ti.com>
Link: https://lore.kernel.org/r/20241011-am62-lpm-usb-v3-1-562d445625b5@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/dwc3/core.c | 19 +++++++++++++++++++
 drivers/usb/dwc3/core.h |  3 +++
 2 files changed, 22 insertions(+)

diff --git a/drivers/usb/dwc3/core.c b/drivers/usb/dwc3/core.c
index af851e4e8c8a7..8cbe19574bbcb 100644
--- a/drivers/usb/dwc3/core.c
+++ b/drivers/usb/dwc3/core.c
@@ -2106,6 +2106,11 @@ static int dwc3_suspend_common(struct dwc3 *dwc, pm_message_t msg)
 {
 	u32 reg;
 
+	dwc->susphy_state = (dwc3_readl(dwc->regs, DWC3_GUSB2PHYCFG(0)) &
+			    DWC3_GUSB2PHYCFG_SUSPHY) ||
+			    (dwc3_readl(dwc->regs, DWC3_GUSB3PIPECTL(0)) &
+			    DWC3_GUSB3PIPECTL_SUSPHY);
+
 	switch (dwc->current_dr_role) {
 	case DWC3_GCTL_PRTCAP_DEVICE:
 		if (pm_runtime_suspended(dwc->dev))
@@ -2153,6 +2158,15 @@ static int dwc3_suspend_common(struct dwc3 *dwc, pm_message_t msg)
 		break;
 	}
 
+	if (!PMSG_IS_AUTO(msg)) {
+		/*
+		 * TI AM62 platform requires SUSPHY to be
+		 * enabled for system suspend to work.
+		 */
+		if (!dwc->susphy_state)
+			dwc3_enable_susphy(dwc, true);
+	}
+
 	return 0;
 }
 
@@ -2215,6 +2229,11 @@ static int dwc3_resume_common(struct dwc3 *dwc, pm_message_t msg)
 		break;
 	}
 
+	if (!PMSG_IS_AUTO(msg)) {
+		/* restore SUSPHY state to that before system suspend. */
+		dwc3_enable_susphy(dwc, dwc->susphy_state);
+	}
+
 	return 0;
 }
 
diff --git a/drivers/usb/dwc3/core.h b/drivers/usb/dwc3/core.h
index 420753205fafa..3325796f3cb45 100644
--- a/drivers/usb/dwc3/core.h
+++ b/drivers/usb/dwc3/core.h
@@ -1127,6 +1127,8 @@ struct dwc3_scratchpad_array {
  * @sys_wakeup: set if the device may do system wakeup.
  * @wakeup_configured: set if the device is configured for remote wakeup.
  * @suspended: set to track suspend event due to U3/L2.
+ * @susphy_state: state of DWC3_GUSB2PHYCFG_SUSPHY + DWC3_GUSB3PIPECTL_SUSPHY
+ *		  before PM suspend.
  * @imod_interval: set the interrupt moderation interval in 250ns
  *			increments or 0 to disable.
  * @max_cfg_eps: current max number of IN eps used across all USB configs.
@@ -1351,6 +1353,7 @@ struct dwc3 {
 	unsigned		sys_wakeup:1;
 	unsigned		wakeup_configured:1;
 	unsigned		suspended:1;
+	unsigned		susphy_state:1;
 
 	u16			imod_interval;
 
-- 
2.43.0



