Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B30C359FB9;
	Wed,  3 Dec 2025 16:21:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764778905; cv=none; b=lNjhXO7qpUemQBjV8rkYyadaf6VIml5qWf2zY8nI6bEgjbAbhIBazNQeQ/0M2x3lUqbvrLvri4zJa1iT32fL8cJ77FZwXN9axkkhN7W+7RTHXk/M50q8qU6keNDXJYhBHjh5e+k2ebqKjCJz215pIq/ZUNrcpe36vA9jVQqThC4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764778905; c=relaxed/simple;
	bh=QbnsS+krradYWdEKWMjZiGdrsG0U4gMbTWxqAMPX+8M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s4BiEbiFmlGZoDh4+eV4NdODFLZS0tGcOBrBVSWGfyMgEgjv/2C+DO3Wp8ruCV4vrcaskw+LoajkRJyU3zr8YfqUwJVqd+6GBBflCLz8gB40P6Xr27vEmhcLEdfCdfvdcwbVXwlRBXbc1q/yGMaDE/p2+Cnh4r+5gcpAkNBOio8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KQXMLtwf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KQXMLtwf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5FF7C4CEF5;
	Wed,  3 Dec 2025 16:21:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764778905;
	bh=QbnsS+krradYWdEKWMjZiGdrsG0U4gMbTWxqAMPX+8M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KQXMLtwf4OncHjjpNEQxi3g0syByMxy+KVPM+mZJLv98VixtsO6EDuzI7Kz8MNy98
	 MfLsUcO4YZC+QnGixTT4Y2nwABIvp7AEAoJRjWKkL/RCwoycalXSVoUlWTnBp7Rl7L
	 2LospCL3C8FMD+pcsdv0bTOBsICuSqzjvZ3S7TH8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Gleixner <tglx@linutronix.de>,
	Inochi Amaoto <inochiama@gmail.com>,
	Nam Cao <namcao@linutronix.de>,
	Chen Wang <unicorn_wang@outlook.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 095/568] irqchip/sifive-plic: Respect mask state when setting affinity
Date: Wed,  3 Dec 2025 16:21:37 +0100
Message-ID: <20251203152444.217386781@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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
index 164c3e71ea70c..36de764ee2b61 100644
--- a/drivers/irqchip/irq-sifive-plic.c
+++ b/drivers/irqchip/irq-sifive-plic.c
@@ -172,12 +172,14 @@ static int plic_set_affinity(struct irq_data *d,
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



