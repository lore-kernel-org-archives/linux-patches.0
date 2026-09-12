Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8015E36728D;
	Sat, 12 Sep 2026 09:19:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789204794; cv=none; b=tEFR67zMKgccA2SSOnGc25w/0/2Xcg5WJ3QHrEK3ITAJddoQgXsKZsCba3v/Xb9nz50mjGzVkdUK2jWGpOBdBMly8p6I4NvZmhM4VIz6YHrOaSYAqQV7GwigeuirQelcObS5rTSxJT5/qDMYYA2czyHGHg99LeLLMPz+VB6v8k8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789204794; c=relaxed/simple;
	bh=d8ePau8dpxkyuqPS7MME546X502Un0ei8zKr2CdnbA8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m1wBYswlyrOxCoLEcAWbblTPEwNGFmZqTK/PGCNKtxEoEEQHxxKR6KT40LsaamWLl8Bx3Xc+XkHRakGoGafsGamfFBqBoGOLLDaK0JJpIfpXId9vs7Zdd6IBv9PAhi9++piDtLrzG7HqEt1DwC48EwkCr5TmgdhR67dZUmBaM54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a8Uf+lfq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a8Uf+lfq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38E641F000FF;
	Sat, 12 Sep 2026 09:19:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789204793;
	bh=L5y45ApNn+0rnhYUigexVYoafeXa7NrfIlL7KW5xwaU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=a8Uf+lfqXBppFBuLZq0Gj92M7lfo+weqyNck/LYTJk4toBXTlZTtdBIq1PYlimN/4
	 88ONDQieHz9cb+4U9CKcVeEbP3rlniQSujAd1Pc+TgXJcnY8jrAJneJMetM6ThtHGF
	 s8l7rG4p4hDrG/Gr2ym5MMN+Ixl3Li9+B9ZBReJo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1649/1815] irqchip/gic-v5: Fix gicv5_init_common() error paths
Date: Sat, 12 Sep 2026 08:56:39 +0200
Message-ID: <20260912065727.707042549@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lorenzo Pieralisi <lpieralisi@kernel.org>

[ Upstream commit 183750b276c229c5253b3b11581f6cd8877b753e ]

Current code fails to disable interrupts on gicv5_starting_cpu() failure
and to set the handle_arch_irq pointer to NULL if gicv5_irs_enable() fails.

Update the respective error paths to fix them.

Fixes: 7ec80fb3f025 ("irqchip/gic-v5: Add GICv5 PPI support")
Signed-off-by: Lorenzo Pieralisi <lpieralisi@kernel.org>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Link: https://patch.msgid.link/20260812-gicv5-7-2-fixes-v1-4-3743e82c69a4@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-gic-v5.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/irqchip/irq-gic-v5.c b/drivers/irqchip/irq-gic-v5.c
index a7fae93e993e5..4f5d1eebb4fa1 100644
--- a/drivers/irqchip/irq-gic-v5.c
+++ b/drivers/irqchip/irq-gic-v5.c
@@ -1174,7 +1174,7 @@ static int __init gicv5_init_common(struct fwnode_handle *parent_domain)
 
 	ret = gicv5_starting_cpu(smp_processor_id());
 	if (ret)
-		goto out_dom;
+		goto out_int;
 
 	ret = set_handle_irq(gicv5_handle_irq);
 	if (ret)
@@ -1182,16 +1182,17 @@ static int __init gicv5_init_common(struct fwnode_handle *parent_domain)
 
 	ret = gicv5_irs_enable();
 	if (ret)
-		goto out_int;
+		goto out_handle;
 
 	gicv5_smp_init();
 
 	gicv5_irs_its_probe();
 	return 0;
 
+out_handle:
+	set_handle_irq(NULL);
 out_int:
 	gicv5_cpu_disable_interrupts();
-out_dom:
 	gicv5_free_domains();
 	return ret;
 }
-- 
2.53.0



