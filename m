Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63B123FE375;
	Fri,  7 Aug 2026 14:44:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786113852; cv=none; b=Z4rgalAXm+ri48QPkuNyfu1N85ubPQrx5HIMRcEXI6CcVElNRR+MSim4rNdPj3GvqdXGrakDTrr3Sz+UAiiqMx9fi5kWDVZmWYfKGg6L1CvedCna00dyTEhtrQZzz0fcHFHqtsD0imiKMCh+m4akdreYpUwm8aS6CNRBiT3p9Tg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786113852; c=relaxed/simple;
	bh=ElJVPIA/rsyu2Rbow9Ksn4DOIDII+AiYDPv7GiOI2eA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rJekG89IxBtDMBB3KUKaSnBugYtGY2okBVpXe4Pg47wJ0mTlXLrrk6Juu7sHP0s6vDUO3vtffFI5tQX8X19+EkpvxIIsOM7GwrYUItwSs4cv8TGB6eM1ZW3Tv7nelJTcrZV2uw//yQptG+UMvukxhvW2JykYd7i0k0ukKim2w7A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2vdzaEOn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2vdzaEOn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 759FC1F00A3A;
	Fri,  7 Aug 2026 14:43:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786113840;
	bh=EGC5UAqFbNyULVMkwQsDrbrj6vWMgYUllAyfDMtRous=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2vdzaEOnEf7v6Qv32vjxdOHOgrLgacCrzlwu3Of4LF5ctffndRNV4UZcX982BTcwX
	 Xb01jJEHmvNLKNc4sR2HaqlJ2wuvYoEhNOSOh8XBqUP1MSO1hLaAmmTkOGl8eeJyka
	 dEEWjJKC3FYwIYzsHj1V4leFV2wmzjYM09mNNjRQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 053/337] pinctrl-amd: Dont clear S4 wake bits at probe
Date: Fri,  7 Aug 2026 16:34:16 +0200
Message-ID: <20260807143419.665965924@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143418.516897842@linuxfoundation.org>
References: <20260807143418.516897842@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mario Limonciello <mario.limonciello@amd.com>

[ Upstream commit ffe8a0c6b55285ceaf2f42fc20c3a0594d14f1e9 ]

commit 6bc3462a0f5e ("pinctrl: amd: Mask wake bits on probe again")
introduced a regression where Wake-on-LAN no longer works after suspend
or shutdown on some AMD platforms.

Firmware-programmed S4 wake bits for devices like PCIe NICs using PCI
PME are cleared at probe, but nothing restores them. Unlike S0i3/S3 wake
sources that use enable_irq_wake() -> amd_gpio_irq_set_wake(), PCIe PME
does not use GPIO IRQ infrastructure and relies on firmware configuration.

The original intent of commit 6bc3462a0f5e ("pinctrl: amd: Mask wake
bits on probe again") was to clear spurious wake bits left by firmware
to prevent unwanted wakeups. However, S4 wake bits are used for
hardware-level wake sources like WoL that bypass the kernel's IRQ wake
API.

Fix by preserving S4 wake bits at probe and only clearing S0i3/S3 bits:
- Firmware-configured S4 wake sources (WoL) continue working
- Kernel maintains control of S3/S0i3 wake policy via set_wake()
- S3-only wake sources work correctly per commit f31f33dbb3ba ("pinctrl:
  amd: Take suspend type into consideration which pins are non-wake")

The trade-off is that firmware-programmed spurious S4 wake bits remain
set, but this is less problematic than breaking WoL.

Fixes: 6bc3462a0f5e ("pinctrl: amd: Mask wake bits on probe again")
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Linus Walleij <linusw@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/pinctrl-amd.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-amd.c b/drivers/pinctrl/pinctrl-amd.c
index debf36ce57857..65006eceaf399 100644
--- a/drivers/pinctrl/pinctrl-amd.c
+++ b/drivers/pinctrl/pinctrl-amd.c
@@ -869,8 +869,7 @@ static void amd_gpio_irq_init(struct amd_gpio *gpio_dev)
 	u32 pin_reg, mask;
 	int i;
 
-	mask = BIT(WAKE_CNTRL_OFF_S0I3) | BIT(WAKE_CNTRL_OFF_S3) |
-		BIT(WAKE_CNTRL_OFF_S4);
+	mask = BIT(WAKE_CNTRL_OFF_S0I3) | BIT(WAKE_CNTRL_OFF_S3);
 
 	for (i = 0; i < desc->npins; i++) {
 		int pin = desc->pins[i].number;
-- 
2.53.0



