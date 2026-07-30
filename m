Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4256B441635;
	Thu, 30 Jul 2026 15:59:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785427176; cv=none; b=ASiiOBA+zgXYRzI9jwyU4P8Og45qz4j8VulLvSX97jaLmVKlR4hHROMUzdGsby5Tl0qkCGD+eoX4dFRW+8yB1gH+kWFJ8ym/1wEgnefHBHd/RkTOou2fhoar5Dttu6QpzkHe+I1poyyYuVwOX2T7x70nS7BXdC8sNzOISgAb3UM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785427176; c=relaxed/simple;
	bh=zu06AdEljR375qNmn4b74Zn0jLAbD4DFozHSqC1w+w0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Li8QtNFP85lt/cb/UkYAuXr2fpsyRMepc9pZfk4WYkWoX9fmmDRJNS6bk91pjnEwLpx3KM1akECV03gnDli7Da4OBFUWH6R2+ScSWrbr1R+fBYWx/dQSSyXsgaLdoqQOyEpQMkVRkgz7HHqcL8WxlMgTBVOnM1eW+thZp5zjiLU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e8prdTq4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e8prdTq4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A5B01F000E9;
	Thu, 30 Jul 2026 15:59:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785427175;
	bh=zz5bTyGqiRX8htNIvn3TNaSlCJMjkP01Rft0QOvWA2s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=e8prdTq4ya0HMpZCtwt9VMeXbW7H5O8TAuxywJg73tGliXPnJCcIFB00yWjoUUH7Z
	 EHQJWakPWC2z1Fk1dR3kUU0HDhdn3zIFzHQfIxd4t0pR2i+PCXkAV2/5YfFZ3E+1Gp
	 H2njg0rYh4pmcJFHQiaG7S2CYcLepW5CLCUg+77Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 076/484] ata: sata_dwc_460ex: fix clear_interrupt_bit() clearing all pending interrupts
Date: Thu, 30 Jul 2026 16:09:33 +0200
Message-ID: <20260730141425.088440149@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141423.392222816@linuxfoundation.org>
References: <20260730141423.392222816@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rosen Penev <rosenp@gmail.com>

[ Upstream commit 66c4e310ad71f41e41736d33dd8a1fb5eaaec7f3 ]

clear_interrupt_bit() ignores the bit argument and performs a
read-write-back of the entire INTPR register.  If INTPR uses standard
Write-1-to-Clear semantics, this clears every pending interrupt bit,
not just the intended one.  Coalesced interrupts (e.g. DMAT + NEWFP)
would be cleared together, silently losing the second event.

Write only the specific bit to clear so that other pending interrupts
are preserved.

Fixes: 62936009f35a ("[libata] Add 460EX on-chip SATA driver, sata_dwc_460ex")
Assisted-by: opencode:big-pickle
Signed-off-by: Rosen Penev <rosenp@gmail.com>
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ata/sata_dwc_460ex.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/ata/sata_dwc_460ex.c b/drivers/ata/sata_dwc_460ex.c
index 97b934fa116e26..74514608a7fada 100644
--- a/drivers/ata/sata_dwc_460ex.c
+++ b/drivers/ata/sata_dwc_460ex.c
@@ -394,8 +394,7 @@ static void clear_serror(struct ata_port *ap)
 
 static void clear_interrupt_bit(struct sata_dwc_device *hsdev, u32 bit)
 {
-	sata_dwc_writel(&hsdev->sata_dwc_regs->intpr,
-			sata_dwc_readl(&hsdev->sata_dwc_regs->intpr));
+	sata_dwc_writel(&hsdev->sata_dwc_regs->intpr, bit);
 }
 
 static u32 qcmd_tag_to_mask(u8 tag)
-- 
2.53.0



