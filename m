Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C23A4086A;
	Tue, 11 Nov 2025 00:55:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822541; cv=none; b=gOVJAYDPn1NmoEKyM9EcMY6Bl3n98Q3PijWare79hmVmxA9XYV1iT9clZLlhYdTqkPCIsAdA0s+UwhFVazmoxlq092UP1c2nkoZFcwCx4lD+yBntYw6h7ztpc/h+v0AAFJRcXYt7hf8l4ElamgBbvzEGtuv74ROVX+8CpkoFqFs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822541; c=relaxed/simple;
	bh=tk2Ch+T4Xc2VD7EeQBL0HdyErkvHYOCoubrp0dAQxho=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qrFrP4v9yxdVp8xGnyebMetYTH5V5sY/Sg5YdBH39t2NYna4YdTqeOMuByVxPiid883+NUgOjBXOXe9Fb2lCGcpUqvAvOOae0S1EXwb/1uq7DonwoM0UtN6cvbA9Xqgr/fbDhHvNEaGp0f525Y/3xEFyUzChF+7ob5JHXSojNbQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PDHghWkH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PDHghWkH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09683C113D0;
	Tue, 11 Nov 2025 00:55:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822541;
	bh=tk2Ch+T4Xc2VD7EeQBL0HdyErkvHYOCoubrp0dAQxho=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PDHghWkHmfg8MX8Qxif+MGuJphKLyVX7s3P7s0sD3O2IqhXTjtyXVu08rMsITH1fv
	 aA3KR5Fv6HL8Zi4U/BOHlMlmeQnjUpv41ZpVV4LnYPgB2TI4fn90Ou6oKSDjvTQ6+l
	 TKMVJYsuBZRPIWqBYafdspW1J4Cnwn59asPhERMY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Gleixner <tglx@linutronix.de>,
	Inochi Amaoto <inochiama@gmail.com>,
	Nam Cao <namcao@linutronix.de>,
	Chen Wang <unicorn_wang@outlook.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 133/849] irqchip/sifive-plic: Respect mask state when setting affinity
Date: Tue, 11 Nov 2025 09:35:03 +0900
Message-ID: <20251111004539.613572863@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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



