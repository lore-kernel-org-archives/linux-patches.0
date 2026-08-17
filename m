Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C18863FA5CC;
	Mon, 17 Aug 2026 15:15:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786979746; cv=none; b=RpxFQ5BWO9qSK3GoMGaqb/j8Z6WxEWYC0g9NmUZYqVuASDrvr8+JHmFvpA8yF1GKiykHBhV6pj886FAjsHB5N1ptyj+Z699bgcg1tIHNa1ibDZdh9bygY3x0aCMWsTMxKTuNmIz9HwKnurRjazzc0gwg3oi/E2utidmpuIMY7Ew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786979746; c=relaxed/simple;
	bh=4R+Z349IQUgliwNJYbpS01p5G7KScjjo/GTFMhzNgF8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o+u1McjxyAOHv+hnaIOHUx2l4ce2PryYogEqZpkbXktaoy3M90JdaWRo0F9caDoTMdwSHu/Lvx9haTWH8MMEOQ5l67N4QV3MEMRDLRDvDng/18jRe/nvZWek7q41mWbJUVmL/xiq6EdMlzuNLvmydwX9V183LlDdEk5sOUawaRY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qYSbH6aF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qYSbH6aF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26C411F000E9;
	Mon, 17 Aug 2026 15:15:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786979745;
	bh=XpS44s5wmHH4OyqrUsCmw1AHZnIYFI7NltZzteFkzRs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qYSbH6aFw+Tm7CSpoguKk3RbGWeGvIarZINldyxdThRbQ3od5Rga4kI8SSTOMKWh0
	 wBoZ6fK2u4daPvtwYBanvPqk/IfZGbAavxJ57+hBv6VbdwXU+o031D+uKk5W63Aeyb
	 hTp092LbwqL2Q8n/Xn90cxxQSzuA60Gxi8Wq2La4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 334/609] pinctrl-amd: Dont clear S4 wake bits at probe
Date: Mon, 17 Aug 2026 15:30:30 +0200
Message-ID: <20260817132555.407111834@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 2b6d996e393e0..51506492302ef 100644
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



