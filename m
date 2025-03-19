Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 067831C9B6C;
	Wed, 19 Mar 2025 14:34:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742394870; cv=none; b=q3aI2ukiEHiM4iwHHAQEwgRvhfQUKPfTwm7WzmCDxdlZo+t8XCx/zh6B+p0uHerRVLxPp2SXz0c8Apue2Lxc8ZvHpBMZJ0aT8kqkInLKICQNTyjRjW0aKb1NgyMU+4A4qqgtlXMiNOiVT3eY9TYRxVFup1DT5NlBkXIwlgFJ9Qs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742394870; c=relaxed/simple;
	bh=tkcJbZ+RGTz54T6EV01DN6d/FdDF1fHwNzYlyOB99c0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f6XQpu0NV1GzOfy5hXK9wIwvRdVKHESR6O85MavQjK6DNCZHchm5Lb9LqPtYc3s10Rb7LglunpSlqef1egQ+Vss2hbib5GOnhFMP9HlUrgaRW1AN+56sFzpxzEhuHzOayMWC+d90XJmjBGJVNnHs5GY3syCK91RT+dCFm4JBMok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PdJ/FGHV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PdJ/FGHV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC729C4CEE4;
	Wed, 19 Mar 2025 14:34:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742394869;
	bh=tkcJbZ+RGTz54T6EV01DN6d/FdDF1fHwNzYlyOB99c0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PdJ/FGHVueE5ZPb/mLj+2YBmQ4McIZaRUXCV/6j0ceZrENygSjtA87LY4xkszFYrm
	 Du5Saqx7zyF+Wmdk0VU5mqBrMdWdiseixFNfkeagPpW3b1W+8n5HCouC9vmSRI/s83
	 Kkk4cNzAhzOwmidzHWtNJWq5OP39Ey1dm+hDst04=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xu Lu <luxu.kernel@bytedance.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 062/241] irqchip/riscv: Ensure ordering of memory writes and IPI writes
Date: Wed, 19 Mar 2025 07:28:52 -0700
Message-ID: <20250319143029.262965797@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143027.685727358@linuxfoundation.org>
References: <20250319143027.685727358@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xu Lu <luxu.kernel@bytedance.com>

[ Upstream commit 825c78e6a60c309a59d18d5ac5968aa79cef0bd6 ]

RISC-V distinguishes between memory accesses and device I/O and uses FENCE
instruction to order them as viewed by other RISC-V harts and external
devices or coprocessors. The FENCE instruction can order any combination of
device input(I), device output(O), memory reads(R) and memory
writes(W). For example, 'fence w, o' is used to ensure all memory writes
from instructions preceding the FENCE instruction appear earlier in the
global memory order than device output writes from instructions after the
FENCE instruction.

RISC-V issues IPIs by writing to the IMSIC/ACLINT MMIO registers, which is
regarded as device output operation. However, the existing implementation
of the IMSIC/ACLINT drivers issue the IPI via writel_relaxed(), which does
not guarantee the order of device output operation and preceding memory
writes. As a consequence the hart receiving the IPI might not observe the
IPI related data.

Fix this by replacing writel_relaxed() with writel() when issuing IPIs,
which uses 'fence w, o' to ensure all previous writes made by the current
hart are visible to other harts before they receive the IPI.

Signed-off-by: Xu Lu <luxu.kernel@bytedance.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Link: https://lore.kernel.org/all/20250127093846.98625-1-luxu.kernel@bytedance.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-riscv-imsic-early.c      | 2 +-
 drivers/irqchip/irq-thead-c900-aclint-sswi.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/irqchip/irq-riscv-imsic-early.c b/drivers/irqchip/irq-riscv-imsic-early.c
index c5c2e6929a2f5..275df50057057 100644
--- a/drivers/irqchip/irq-riscv-imsic-early.c
+++ b/drivers/irqchip/irq-riscv-imsic-early.c
@@ -27,7 +27,7 @@ static void imsic_ipi_send(unsigned int cpu)
 {
 	struct imsic_local_config *local = per_cpu_ptr(imsic->global.local, cpu);
 
-	writel_relaxed(IMSIC_IPI_ID, local->msi_va);
+	writel(IMSIC_IPI_ID, local->msi_va);
 }
 
 static void imsic_ipi_starting_cpu(void)
diff --git a/drivers/irqchip/irq-thead-c900-aclint-sswi.c b/drivers/irqchip/irq-thead-c900-aclint-sswi.c
index b0e366ade4271..8ff6e7a1363bd 100644
--- a/drivers/irqchip/irq-thead-c900-aclint-sswi.c
+++ b/drivers/irqchip/irq-thead-c900-aclint-sswi.c
@@ -31,7 +31,7 @@ static DEFINE_PER_CPU(void __iomem *, sswi_cpu_regs);
 
 static void thead_aclint_sswi_ipi_send(unsigned int cpu)
 {
-	writel_relaxed(0x1, per_cpu(sswi_cpu_regs, cpu));
+	writel(0x1, per_cpu(sswi_cpu_regs, cpu));
 }
 
 static void thead_aclint_sswi_ipi_clear(void)
-- 
2.39.5



