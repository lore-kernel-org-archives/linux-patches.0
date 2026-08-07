Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93F0737AA9A;
	Fri,  7 Aug 2026 15:00:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786114830; cv=none; b=asR5DGd4vIhND+POUXesghOJJ70oyBKbVe0UdvGib3qFISKIAMlvuf+09ICUpKipR+hxtrTRwWp7ZnYF1Qh08EWHhbmtozvsaa9MG2lIKPZYT7UVnoTe3KR5nbE6in6aVmyXDjfNhdxhntWCvYHSy4Ty2zX8KhGJ6lf2GboM3Aw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786114830; c=relaxed/simple;
	bh=ZkSolZwv8SZiRWT4v5cTty1kBkn+vWwzJMTEhsCJrWM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bdZgYgu8CECYJpddvsXchvjHhD9V4mtxNoLkj6FNvRFhsB9608PA8mYZJ0C68JDwP07oLlfbTYTlJ8+yGwZyU1NE6m2PgTFll043TTwbNeR8mkp5vva9f4Bw0Krj4uBVanegu9hdrEwcP6pSD6W7CTZVV/AMnTccNwbfvFP8K3Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FsIEM+X7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FsIEM+X7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF9521F000E9;
	Fri,  7 Aug 2026 15:00:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786114828;
	bh=mNiPxP0/htN5DGicr8I8pFAWJQM4s1LZ/CFO6L9Cahg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FsIEM+X7uTMKae7j9hXX4m76tBYZCIfRpZE1W8XYG1he6bAevKBphiurjNMJcTbY7
	 XeItEp8hYpCWOmkbu0YdRQ4Dw3Zj1STotzJV7+6TFphrD0P8vA++xANK61UdB4EVWR
	 v6viM0S5+n6nNMDsUjyHzguVElsh/wGi1uIFvvoU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 063/396] pinctrl-amd: Dont clear S4 wake bits at probe
Date: Fri,  7 Aug 2026 16:33:43 +0200
Message-ID: <20260807143425.632901005@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143424.272339768@linuxfoundation.org>
References: <20260807143424.272339768@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 2dac5c71eb008..d962f2e1d2acd 100644
--- a/drivers/pinctrl/pinctrl-amd.c
+++ b/drivers/pinctrl/pinctrl-amd.c
@@ -886,8 +886,7 @@ static void amd_gpio_irq_init(struct amd_gpio *gpio_dev)
 	u32 pin_reg, mask;
 	int i;
 
-	mask = BIT(WAKE_CNTRL_OFF_S0I3) | BIT(WAKE_CNTRL_OFF_S3) |
-		BIT(WAKE_CNTRL_OFF_S4);
+	mask = BIT(WAKE_CNTRL_OFF_S0I3) | BIT(WAKE_CNTRL_OFF_S3);
 
 	for (i = 0; i < desc->npins; i++) {
 		int pin = desc->pins[i].number;
-- 
2.53.0



