Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66D5C17CA0E;
	Tue, 16 Jul 2024 16:07:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721146037; cv=none; b=lvZm4EaBDWwLJWtFrZSntJfgT5asm3q6NBMXdyAumIvGwkicxWnVjKz3IRVHj/SMTu0G3r93BTNRAg8ruudV3aXZYxM1fctLROcsvbV5f+9nEy5xasEp7NvfMXLh9WZrVSv9+3NmFN+Fqm9nbA0qeI+IOrXV7RpD3Xv1h3vg5to=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721146037; c=relaxed/simple;
	bh=3O5Xa+QQFvD7xjxmXDikpt9TskDaKf3n4yYV7MMUJw0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QhnQTw3tOcJbu4wv71MLpDXLwAGEHlJvHoZRlWz5/dyd77g0KWKVACdzRxhvKlwOSNN1NcbSnr0GdyMn8iHYVOfdQTGjWesO2ox5tN7B0GaZ8A6g+AtDh9EvEpbhsWaFhXlIZnYJeaR2Ni6LG+dRc80y9XcuOwpz4/sCAjC9Ymg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CxsEpEFy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CxsEpEFy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFDDFC116B1;
	Tue, 16 Jul 2024 16:07:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721146037;
	bh=3O5Xa+QQFvD7xjxmXDikpt9TskDaKf3n4yYV7MMUJw0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CxsEpEFybkwiA7ME8LEs6UwpvT5HdDIc5M2/6FwlpVXqdje1gB6p+P0qU4t84ikxV
	 99JjaozdyViqZE0EF3CZ55+3zxgJN/CtHSLCoiFdIOEMnPykTTLpMzjbeH+VOHgbyW
	 M/nURcBXad3ZZkM4zX9z03yY4V+5+PsyLaXBFSEI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Song Shuai <songshuaishuai@tinylab.org>,
	Ryo Takakura <takakura@valinux.co.jp>,
	Palmer Dabbelt <palmer@rivosinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 037/144] riscv: kexec: Avoid deadlock in kexec crash path
Date: Tue, 16 Jul 2024 17:31:46 +0200
Message-ID: <20240716152753.969493154@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152752.524497140@linuxfoundation.org>
References: <20240716152752.524497140@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index db41c676e5a26..7889dfb55cf24 100644
--- a/arch/riscv/kernel/machine_kexec.c
+++ b/arch/riscv/kernel/machine_kexec.c
@@ -163,20 +163,12 @@ static void machine_kexec_mask_interrupts(void)
 
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



