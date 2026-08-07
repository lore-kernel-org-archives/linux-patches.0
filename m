Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9ACA1280331;
	Fri,  7 Aug 2026 15:32:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786116749; cv=none; b=sRwz+9Ls1H0/QAmmeW73JPjRA6aQmsanoUeIBXxAlzSQtxKfXp0X6bPnWMa/DyWIRwMPpghO7DtJnjUi5GoHMLaaQWEEsxgmPuGmFNQktiX2UgaSWn7hRGfdBFcO8ujH63CPAb3LUpojbViLdj+qdMzA8/8BEvhLcAzQDuUwTEM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786116749; c=relaxed/simple;
	bh=QRj0TjNc9NRZI0tRZZV2eFQNWWP6zv7/jjPzqStu+YQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ort5jCgFgHFQ6i16KOSIUpAz30KF7NasA/N+IILtG4iE02zxwFnCDjM1x+zN0wiW+81s7tFIXOEjh8Hvrgh1p2P7/syf7CrVUKwMMOHZj4ELr0PreBOJeJKBgk/iYClIkSrZ6MM2WxJUwhoZO4folzfnUr/QX73RqDTfV+DXKm4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GbARNOv7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GbARNOv7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 028F81F000E9;
	Fri,  7 Aug 2026 15:32:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786116748;
	bh=BTMjyniJjKe6VDG/Zq2+VT/CT85jRc8vMQtH/aZQ4w0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GbARNOv7rXksKWAqU7KInWAWRPzJMEHtLEGr9I/Y5or/qsyqboJX1oBc0g9YDDdhk
	 iBvOpmD4u1LEE7EXtMsp2KJIM1ebHuVo9iOBqXxkC3PNl3IRNjnD1b4/Q+7tnZLdzU
	 CtT3EAVjl930TXYWoDaxdN31gxPXy4FrgLm4tTIg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 078/438] pinctrl-amd: Dont clear S4 wake bits at probe
Date: Fri,  7 Aug 2026 16:34:34 +0200
Message-ID: <20260807143429.646910226@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
References: <20260807143428.008222056@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index e3128b0045d22..15a398bb3be23 100644
--- a/drivers/pinctrl/pinctrl-amd.c
+++ b/drivers/pinctrl/pinctrl-amd.c
@@ -884,8 +884,7 @@ static void amd_gpio_irq_init(struct amd_gpio *gpio_dev)
 	u32 pin_reg, mask;
 	int i;
 
-	mask = BIT(WAKE_CNTRL_OFF_S0I3) | BIT(WAKE_CNTRL_OFF_S3) |
-		BIT(WAKE_CNTRL_OFF_S4);
+	mask = BIT(WAKE_CNTRL_OFF_S0I3) | BIT(WAKE_CNTRL_OFF_S3);
 
 	for (i = 0; i < desc->npins; i++) {
 		int pin = desc->pins[i].number;
-- 
2.53.0



