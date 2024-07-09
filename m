Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64B9013A25F;
	Tue,  9 Jul 2024 11:23:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720524234; cv=none; b=OynR0zBdqOhboPBZgSDyFNo2ti/yRndxhLnDZhRZBHjwXwcGcqX62h+6oRbXJhheLnQraCPv8A9+GLuoUSKYpth++r81ICh2bcGL5pSH6c/7NglzZ3sdXQog+a0N+iaTmBvuhnXClkJDczejvC0UJyHIyqBHKsurf+thHgVK/AU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720524234; c=relaxed/simple;
	bh=XBTIliFTJQ8QUOERtWTrrxg9lE3MYYtFs8h8VBLvV2w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K/wYPk9oTY4SbCYHzE/1Wh7raFxapsdDaWSAs4eENMCX2Ol3fprh5XDiEi80TO98YgqNVU7LbObeQRkhdpmsZ44Sk61XhVPvrVY+b6tpjaHXh/ee1Zjykx5FcwrGELLqGrixi95d4Eo/4ifoDQ3hZs4p0aF+srGzsiiP/QbxlLw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=14+O+r4j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="14+O+r4j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC313C3277B;
	Tue,  9 Jul 2024 11:23:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720524234;
	bh=XBTIliFTJQ8QUOERtWTrrxg9lE3MYYtFs8h8VBLvV2w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=14+O+r4jrCXAaNUjLpOQKhi3iiwmkyFvXDTcuaGmnVqLQA7lJWW/IXw9B8Nu/i//T
	 L2biRjPkSWDBEppiuxgTQy5gO6ywuZrVOzGV1xoRUuX8UXiKsd4o37fp6TJNhAu4wK
	 GlQRrdkFE0N+NKDxkFUzGsBGkeIa2jRRbeGZVSSI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Song Shuai <songshuaishuai@tinylab.org>,
	Ryo Takakura <takakura@valinux.co.jp>,
	Palmer Dabbelt <palmer@rivosinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 115/197] riscv: kexec: Avoid deadlock in kexec crash path
Date: Tue,  9 Jul 2024 13:09:29 +0200
Message-ID: <20240709110713.402590662@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709110708.903245467@linuxfoundation.org>
References: <20240709110708.903245467@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Song Shuai <songshuaishuai@tinylab.org>

[ Upstream commit c562ba719df570c986caf0941fea2449150bcbc4 ]

If the kexec crash code is called in the interrupt context, the
machine_kexec_mask_interrupts() function will trigger a deadlock while
trying to acquire the irqdesc spinlock and then deactivate irqchip in
irq_set_irqchip_state() function.

Unlike arm64, riscv only requires irq_eoi handler to complete EOI and
keeping irq_set_irqchip_state() will only leave this possible deadlock
without any use. So we simply remove it.

Link: https://lore.kernel.org/linux-riscv/20231208111015.173237-1-songshuaishuai@tinylab.org/
Fixes: b17d19a5314a ("riscv: kexec: Fixup irq controller broken in kexec crash path")
Signed-off-by: Song Shuai <songshuaishuai@tinylab.org>
Reviewed-by: Ryo Takakura <takakura@valinux.co.jp>
Link: https://lore.kernel.org/r/20240626023316.539971-1-songshuaishuai@tinylab.org
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/kernel/machine_kexec.c | 10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

diff --git a/arch/riscv/kernel/machine_kexec.c b/arch/riscv/kernel/machine_kexec.c
index ed9cad20c039d..3c830a6f7ef46 100644
--- a/arch/riscv/kernel/machine_kexec.c
+++ b/arch/riscv/kernel/machine_kexec.c
@@ -121,20 +121,12 @@ static void machine_kexec_mask_interrupts(void)
 
 	for_each_irq_desc(i, desc) {
 		struct irq_chip *chip;
-		int ret;
 
 		chip = irq_desc_get_chip(desc);
 		if (!chip)
 			continue;
 
-		/*
-		 * First try to remove the active state. If this
-		 * fails, try to EOI the interrupt.
-		 */
-		ret = irq_set_irqchip_state(i, IRQCHIP_STATE_ACTIVE, false);
-
-		if (ret && irqd_irq_inprogress(&desc->irq_data) &&
-		    chip->irq_eoi)
+		if (chip->irq_eoi && irqd_irq_inprogress(&desc->irq_data))
 			chip->irq_eoi(&desc->irq_data);
 
 		if (chip->irq_mask)
-- 
2.43.0



