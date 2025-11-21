Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCA6534E768;
	Fri, 21 Nov 2025 13:39:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763732374; cv=none; b=h1VnEbIuWZvi25LmVEZOkGHZIZnQI/aOqamAdaaoqjap2K44V50ACUZYe/QYmjGSv3EwKIbZHvMIiw2Abq3pw/fzs+K4tnttYje4qtevn/TYioCD0wbTsoLDpgC5/I7bueOg1GLzvI/7h4HFclsq1WQlMTYp+msOdO4xu9OzHvY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763732374; c=relaxed/simple;
	bh=A2zbbmwzLZdrwFM/P32AbVOWNe0rBWTMcKBJxCZO2e8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uSnx6TjX4T+mtE34PYLDH7v0TB0r6zz4g/Tsk/2M546sCUW9cJRjGn9mxNZQTw5CSEqse6qscGfOSZZT7Kko0wIY7G42ZIAvGapq4sAkPtCxHtGvbva2i9+nYL1EVKm1SUJIDdpz0f5KlgxlOCIyNy/t2ZAcBPh9DJmJmOUkkxM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RukS4DFH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RukS4DFH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E11E5C4CEF1;
	Fri, 21 Nov 2025 13:39:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763732373;
	bh=A2zbbmwzLZdrwFM/P32AbVOWNe0rBWTMcKBJxCZO2e8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RukS4DFHV3f/HN+/l1MGLjzG5SUC2ZnawgsUdel8Agx0kB3JxOdYUwOMu+tnjIkHy
	 Wb1OLz6QYkHCw6rcKNu/RTcMrsLpD72RDx8xt29N5JzdZvPkRiw6LUlW/z9pd/ZFgE
	 hpvy6fC5eJnGn2yY8JukWgtioxltSGhoHZmM+xcg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Gleixner <tglx@linutronix.de>,
	Inochi Amaoto <inochiama@gmail.com>,
	Nam Cao <namcao@linutronix.de>,
	Chen Wang <unicorn_wang@outlook.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 065/529] irqchip/sifive-plic: Respect mask state when setting affinity
Date: Fri, 21 Nov 2025 14:06:04 +0100
Message-ID: <20251121130233.340150317@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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
index 2d20cf9d84cea..a8f5cfad16f7d 100644
--- a/drivers/irqchip/irq-sifive-plic.c
+++ b/drivers/irqchip/irq-sifive-plic.c
@@ -176,12 +176,14 @@ static int plic_set_affinity(struct irq_data *d,
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



