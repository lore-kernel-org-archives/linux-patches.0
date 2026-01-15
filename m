Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C183C3C0098;
	Thu, 15 Jan 2026 17:45:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768499152; cv=none; b=l8af6IP3LoFxe13tp0nYQxbGk0Y5mrhH3pNfTUMoraRqMA/2BRtrh+thv4bnZ5uwfuHt+uP7okiQH1dSQFWajv4D8bbJFkRUlNBZakcq82wqIO3mo2T0S9NdO4n61YlhZYQjLWpW+9BPpT7/yNA576ylhiBmuVSAxmQQILi46Ng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768499152; c=relaxed/simple;
	bh=WrYIflEjcc2O4cZBo9lzLQfxBw9pDe6dZ32ak8gVXvY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SbH5qai0yWkiv2ntBIEPwjH6/ydRdKaLt3OCwVF60/l08cU2k0rgPn19Y+g1hwPe4GlRrQVoLY0dmXrLgY7thrr8vHu5HrCGgGi9huzQ9vf2AbnPOu9TopJDhQ8XKFCl0OEp4f0R5WThP6D/Uf6pk72ui3ALOdzcFuvizTNF0ps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CT+a7x7I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CT+a7x7I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44E1FC19422;
	Thu, 15 Jan 2026 17:45:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768499152;
	bh=WrYIflEjcc2O4cZBo9lzLQfxBw9pDe6dZ32ak8gVXvY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CT+a7x7Iv6Y1nM3ZwWJnBYTwZMDq+soFQHuBq1fvH9zpR1bdcsOJ2VXYsk7i1zygK
	 +AWl2Rc000lW9pBN4225xPKPDVSTeKPTUGGj7Zg2Rgsqiz3MVsOhgULED/4j6rFOTH
	 WUFdGO45X1bexaGejx9d6kI++NdVer/RmuFXIdvo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jisheng Zhang <jszhang@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 093/451] usb: dwc2: fix hang during suspend if set as peripheral
Date: Thu, 15 Jan 2026 17:44:54 +0100
Message-ID: <20260115164234.281715386@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164230.864985076@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jisheng Zhang <jszhang@kernel.org>

[ Upstream commit 2b94b054ac4974ad2f89f7f7461840c851933adb ]

dwc2 on most platforms needs phy controller, clock and power supply.
All of them must be enabled/activated to properly operate. If dwc2
is configured as peripheral mode, then all the above three hardware
resources are disabled at the end of the probe:

	/* Gadget code manages lowlevel hw on its own */
	if (hsotg->dr_mode == USB_DR_MODE_PERIPHERAL)
		dwc2_lowlevel_hw_disable(hsotg);

But the dwc2_suspend() tries to read the dwc2's reg to check whether
is_device_mode or not, this would result in hang during suspend if dwc2
is configured as peripheral mode.

Fix this hang by bypassing suspend/resume if lowlevel hw isn't
enabled.

Fixes: 09a75e857790 ("usb: dwc2: refactor common low-level hw code to platform.c")
Signed-off-by: Jisheng Zhang <jszhang@kernel.org>
Link: https://patch.msgid.link/20251104002503.17158-3-jszhang@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/dwc2/platform.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/dwc2/platform.c b/drivers/usb/dwc2/platform.c
index 175b4c0886284..db667038c8ebc 100644
--- a/drivers/usb/dwc2/platform.c
+++ b/drivers/usb/dwc2/platform.c
@@ -626,9 +626,13 @@ static int dwc2_driver_probe(struct platform_device *dev)
 static int __maybe_unused dwc2_suspend(struct device *dev)
 {
 	struct dwc2_hsotg *dwc2 = dev_get_drvdata(dev);
-	bool is_device_mode = dwc2_is_device_mode(dwc2);
+	bool is_device_mode;
 	int ret = 0;
 
+	if (!dwc2->ll_hw_enabled)
+		return 0;
+
+	is_device_mode = dwc2_is_device_mode(dwc2);
 	if (is_device_mode)
 		dwc2_hsotg_suspend(dwc2);
 
@@ -679,6 +683,9 @@ static int __maybe_unused dwc2_resume(struct device *dev)
 	struct dwc2_hsotg *dwc2 = dev_get_drvdata(dev);
 	int ret = 0;
 
+	if (!dwc2->ll_hw_enabled)
+		return 0;
+
 	if (dwc2->phy_off_for_suspend && dwc2->ll_hw_enabled) {
 		ret = __dwc2_lowlevel_hw_enable(dwc2);
 		if (ret)
-- 
2.51.0



