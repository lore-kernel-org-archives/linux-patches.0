Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CFFD4C97;
	Tue, 11 Nov 2025 00:59:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822762; cv=none; b=OPAJkOGGKZMLXPek4E7zyLXdSCWZdAOFg7/e/HPQSWQUfHc3lrDg6EeBzU0gFtPGrkKqRfonYpH5OUqiVZlYz32iwfbBOR2E3GEu+bO1SQWiFGGIodL9ri4j2V9n++cQjQUNFfx6/PZ/I3edZSbDQtGWW16uiu+M9u1nIKfuTVE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822762; c=relaxed/simple;
	bh=xkA4pfjBRzOG0VGVa/tVSV6L33uPXN6KGxHGdy+H+zg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c4cQNY5f7XeoX0W080N+fffoDpj/CiHI45gML1QUilTnE+jV3PJzqR8tEYS2Gh2pi7jHlBKpeZv/0+LHxeUM1N8uL3inO6PnuT2l59bNtvTD48Bv3xROT4wngJG5E8qsHJJki6+oHPB52nmtpuYR2Tw/xCJ1SZaCnl+Lv6kzaaw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CsFfKneR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CsFfKneR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE818C116B1;
	Tue, 11 Nov 2025 00:59:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822762;
	bh=xkA4pfjBRzOG0VGVa/tVSV6L33uPXN6KGxHGdy+H+zg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CsFfKneRGGJRZpFubOrsYkdylIRLHiJbh4w1lPaZvn1tNIscFcaT0Lo99obKIFw/E
	 oFeptrVlDF0EJfk+MzJJFtylyRapv+3xhg/g7Cr0EO6Fddjoi/YtlMu5tw4WTgBsMf
	 65i8TIGQ71rdr+EPHtIxLEu4PSN7Q1xDbf2nclPE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Gleixner <tglx@linutronix.de>,
	Inochi Amaoto <inochiama@gmail.com>,
	Nam Cao <namcao@linutronix.de>,
	Chen Wang <unicorn_wang@outlook.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 100/565] irqchip/sifive-plic: Respect mask state when setting affinity
Date: Tue, 11 Nov 2025 09:39:16 +0900
Message-ID: <20251111004529.202960184@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

From: Inochi Amaoto <inochiama@gmail.com>

[ Upstream commit adecf78df945f4c7a1d29111b0002827f487df51 ]

plic_set_affinity() always calls plic_irq_enable(), which clears up the
priority setting even the interrupt is only masked. This unmasks the
interrupt unexpectly.

Replace the plic_irq_enable/disable() with plic_irq_toggle() to avoid
changing the priority setting.

Suggested-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Inochi Amaoto <inochiama@gmail.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Tested-by: Nam Cao <namcao@linutronix.de> # VisionFive 2
Tested-by: Chen Wang <unicorn_wang@outlook.com> # Pioneerbox
Reviewed-by: Nam Cao <namcao@linutronix.de>
Reviewed-by: Chen Wang <unicorn_wang@outlook.com>
Link: https://lore.kernel.org/all/20250811002633.55275-1-inochiama@gmail.com
Link: https://lore.kernel.org/lkml/20250722224513.22125-1-inochiama@gmail.com/
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-sifive-plic.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/irqchip/irq-sifive-plic.c b/drivers/irqchip/irq-sifive-plic.c
index 9c4af7d588463..c0cf4fed13e09 100644
--- a/drivers/irqchip/irq-sifive-plic.c
+++ b/drivers/irqchip/irq-sifive-plic.c
@@ -179,12 +179,14 @@ static int plic_set_affinity(struct irq_data *d,
 	if (cpu >= nr_cpu_ids)
 		return -EINVAL;
 
-	plic_irq_disable(d);
+	/* Invalidate the original routing entry */
+	plic_irq_toggle(irq_data_get_effective_affinity_mask(d), d, 0);
 
 	irq_data_update_effective_affinity(d, cpumask_of(cpu));
 
+	/* Setting the new routing entry if irq is enabled */
 	if (!irqd_irq_disabled(d))
-		plic_irq_enable(d);
+		plic_irq_toggle(irq_data_get_effective_affinity_mask(d), d, 1);
 
 	return IRQ_SET_MASK_OK_DONE;
 }
-- 
2.51.0



