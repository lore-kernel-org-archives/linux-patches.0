Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61D7A3F2101;
	Tue, 21 Jul 2026 18:55:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660112; cv=none; b=Lm0FFSWNUO7OFv635nbw29UU3W93URMIv1w2U2xphJ5wIkfJ8lPEKrs8a9RERwtMoJl03/6o2VlpdcJfSrk4QoAhmIvKCNsJAANUvCdAXp2IZEKel6POuBvKbvxCmmrrQpufLPWR7n+oIkH3egD3coxVvxPCNWTS6K1Z+rhrIqk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660112; c=relaxed/simple;
	bh=Yli6JMMkRLq+JqRusUwWHLOkyAvZGNrduUH/g2sY27o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ke8vmWZPjhZXr8K35oJab/Q1b+2+XWq6YWfUsWtinspK4Bn4Il2zZFLYfP8S+tp1Pv6hEETQxvLUozuMSet95v4VQYb7fNHuR2oF/tYnI+zwXNbIRtLiqbEpGpuy1pbrYIObPzrhWiELfGdKoCjEz7qPbg9CFWKBVSfnffXh2gc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=THJry8ie; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="THJry8ie"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7CFD1F000E9;
	Tue, 21 Jul 2026 18:55:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660111;
	bh=MNFNwY3kCVSZIYPacMgKDwTUhBCPHBSUblCTU5OPEpE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=THJry8ie1SCHt/aR62T3uuFwjPhunmoer8GVsW6mUGJv7U8yxRhQKPfyoX4co2+kL
	 rmpXsgZJf9w90DVLTJr7FCcAiwmhcu/nmQWfxwqGxWuTZ3U+AZS7xFiTrabIAmztLu
	 NX157mPQBCTJLJ0tenqXj/rUDC7UXUjEs2S1394Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Eckert <fe@dev.tdt.de>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0855/2077] PCI: intel-gw: Move interrupt enable to own function
Date: Tue, 21 Jul 2026 17:08:48 +0200
Message-ID: <20260721152612.954774940@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Eckert <fe@dev.tdt.de>

[ Upstream commit abddc0539e5931f4ad2f589a03cbba5a6a64485f ]

To improve the readability of the code, move the interrupt enable
instructions to a separate function. That is already done for the disable
interrupt instruction.

In addition, clear and disable all pending interrupts, as is done in
intel_pcie_core_irq_disable(). After that, enable all relevant interrupts
again. The 'PCIE_APP_IRNEN' definition contains all the relevant interrupts
that are of interest.

This change is also done in the MaxLinear SDK [1]. As I unfortunately don’t
have any documentation for this IP core, I suspect that the intention is to
set the IP core for interrupt handling to a specific state. Perhaps the
problem is that the IP core did not reinitialize the interrupt register
properly after a power cycle.

In my view, it can’t do any harm to switch the interrupt off and then on
again to set them to a specific state.

The reason why the MaxLinear SDK is used as a reference here is, that this
PCIe DWC IP is used in the URX851 and URX850 SoC. This SoC was originally
developed by Intel when they acquired Lantiq’s home networking division in
2015 [2]. In 2020 the home network division was sold to MaxLinear [3].
Since then, this SoC belongs to MaxLinear. They use their own SDK, which
runs on kernel version '5.15.x'.

[1] https://github.com/maxlinear/linux/blob/updk_9.1.90/drivers/pci/controller/dwc/pcie-intel-gw.c#L431
[2] https://www.intc.com/news-events/press-releases/detail/364/intel-to-acquire-lantiq-advancing-the-connected-home
[3] https://investors.maxlinear.com/press-releases/detail/395/maxlinear-to-acquire-intels-home-gateway-platform

Signed-off-by: Florian Eckert <fe@dev.tdt.de>
Signed-off-by: Manivannan Sadhasivam <mani@kernel.org>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Link: https://patch.msgid.link/20260417-pcie-intel-gw-v5-3-0a2b933fe04f@dev.tdt.de
Stable-dep-of: 1eedabe7c617 ("PCI: intel-gw: Add .start_link() callback")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/dwc/pcie-intel-gw.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/pci/controller/dwc/pcie-intel-gw.c b/drivers/pci/controller/dwc/pcie-intel-gw.c
index c21906eced6189..3a85bd0ef1b7f9 100644
--- a/drivers/pci/controller/dwc/pcie-intel-gw.c
+++ b/drivers/pci/controller/dwc/pcie-intel-gw.c
@@ -196,6 +196,13 @@ static void intel_pcie_device_rst_deassert(struct intel_pcie *pcie)
 	gpiod_set_value_cansleep(pcie->reset_gpio, 0);
 }
 
+static void intel_pcie_core_irq_enable(struct intel_pcie *pcie)
+{
+	pcie_app_wr(pcie, PCIE_APP_IRNEN, 0);
+	pcie_app_wr(pcie, PCIE_APP_IRNCR, PCIE_APP_IRN_INT);
+	pcie_app_wr(pcie, PCIE_APP_IRNEN, PCIE_APP_IRN_INT);
+}
+
 static void intel_pcie_core_irq_disable(struct intel_pcie *pcie)
 {
 	pcie_app_wr(pcie, PCIE_APP_IRNEN, 0);
@@ -317,9 +324,7 @@ static int intel_pcie_host_setup(struct intel_pcie *pcie)
 	if (ret)
 		goto app_init_err;
 
-	/* Enable integrated interrupts */
-	pcie_app_wr_mask(pcie, PCIE_APP_IRNEN, PCIE_APP_IRN_INT,
-			 PCIE_APP_IRN_INT);
+	intel_pcie_core_irq_enable(pcie);
 
 	return 0;
 
-- 
2.53.0



