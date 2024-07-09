Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FDCD55E4C;
	Tue,  9 Jul 2024 11:31:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720524700; cv=none; b=DRqBxiWuQLUjCRnkcjOQW7MqJIwZJEkVGTq4mPqGGRPbWPMQyS0CQAL+TbTBFJkcHhVtVVDHBuBg+qELoc2Pm3lT65jkPC0aY7vNvvxUxm41wfGEAA7gGN7LuDYy2CSvG0Z7Mdfn70hU3MGK7vypRXp8rRUJiL3FlvooBzvvF5c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720524700; c=relaxed/simple;
	bh=Ed61RWbFFOlZHlsdgZ6d96GcmAWerziNXGkPrYMTgyE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Pk0JaFs9K4lUIk/I8DTVWgmnn01B65Pu47fU4as/EWPMx2f4/9aic6byNhU+tCIltAXk6vIGEnr+7yGd2L2dhiIVniNLQyPJA94YHLbg0+1VNZMzwvqXuqxAJUoyhcxrRoZEbZp5DAmhHk7xjQLH4NyDJb1bga4n549dw1/JXdI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HwBil8kG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HwBil8kG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C75AAC3277B;
	Tue,  9 Jul 2024 11:31:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720524700;
	bh=Ed61RWbFFOlZHlsdgZ6d96GcmAWerziNXGkPrYMTgyE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HwBil8kGQE8EYb7t0ixaw5ku3xcYdX+qmzcRvR9G83YXktE34hXNb99/k2wc2gdOJ
	 NR7R0GGMHaAb9vaB7svoQoJU4jsT3vL8PHefr7L3blpGHbEqEDG8Zxdnrqeq1XHRWQ
	 /fTboejFqkhOWlP43XU20oPZoBXdSQTvjeu1zLP8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Song Shuai <songshuaishuai@tinylab.org>,
	Ryo Takakura <takakura@valinux.co.jp>,
	Palmer Dabbelt <palmer@rivosinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 054/102] riscv: kexec: Avoid deadlock in kexec crash path
Date: Tue,  9 Jul 2024 13:10:17 +0200
Message-ID: <20240709110653.483166460@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709110651.353707001@linuxfoundation.org>
References: <20240709110651.353707001@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 2d139b724bc84..ccb0c5d5c63c4 100644
--- a/arch/riscv/kernel/machine_kexec.c
+++ b/arch/riscv/kernel/machine_kexec.c
@@ -147,20 +147,12 @@ static void machine_kexec_mask_interrupts(void)
 
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



