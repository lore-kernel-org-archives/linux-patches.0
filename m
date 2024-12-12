Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18AF5222D52;
	Thu, 12 Dec 2024 16:48:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734022138; cv=none; b=Tio8rjNUuXahlz0XoARfLCCySHA/b/oKiyKNTJr13kka79hhDFChNgQDAI0bLMV7VhsTWKsMqHvbv58LEErX8WQGbaZa7A6pjC6LRoxvp+EBROC8xVWbMuyngYEvNRz9y6clxUyih6/DNcSl62aaDQPzeB7/CbPmuoTGzvs7qog=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734022138; c=relaxed/simple;
	bh=OLY1s/2QhWxIhwwRWeWmPB+oG58FOt7TH6a2nrXN4pE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UmeffSPUBdw3vXyExZwwHCyDUWNiM4xIjh8dtg+rSqgmWB+PBhP+9EmS6RjNi6gD8e3JFdLVb1xveJbrJpkProyREYaIX4nVvDMW9biLUUdxSuKb9Gax9IGqBheqBAHLnknA0qRvq85gRAoWk2H3HFRoEEpbXFKUekzA+vqJxhs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E1gFTVdm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E1gFTVdm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7354DC4CECE;
	Thu, 12 Dec 2024 16:48:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734022138;
	bh=OLY1s/2QhWxIhwwRWeWmPB+oG58FOt7TH6a2nrXN4pE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E1gFTVdmYr1IEBhK6wl/KtY3UXOGZQI5gmZo1G2Wlai34MysnBDEw5W65lwdcpga8
	 vei+O9VB6Jxi795PCp0A6pYayuqRYp1NJZPZG0ssM/KKbcXplikCjx0CVoFqeW9Yvz
	 SujOyUpX8vltgh7IPMAfMUB8lV1o053BU+BjKlFw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 129/565] regmap: irq: Set lockdep class for hierarchical IRQ domains
Date: Thu, 12 Dec 2024 15:55:24 +0100
Message-ID: <20241212144316.583312174@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
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

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit 953e549471cabc9d4980f1da2e9fa79f4c23da06 ]

Lockdep gives a false positive splat as it can't distinguish the lock
which is taken by different IRQ descriptors from different IRQ chips
that are organized in a way of a hierarchy:

   ======================================================
   WARNING: possible circular locking dependency detected
   6.12.0-rc5-next-20241101-00148-g9fabf8160b53 #562 Tainted: G        W
   ------------------------------------------------------
   modprobe/141 is trying to acquire lock:
   ffff899446947868 (intel_soc_pmic_bxtwc:502:(&bxtwc_regmap_config)->lock){+.+.}-{4:4}, at: regmap_update_bits_base+0x33/0x90

   but task is already holding lock:
   ffff899446947c68 (&d->lock){+.+.}-{4:4}, at: __setup_irq+0x682/0x790

   which lock already depends on the new lock.

   -> #3 (&d->lock){+.+.}-{4:4}:
   -> #2 (&desc->request_mutex){+.+.}-{4:4}:
   -> #1 (ipclock){+.+.}-{4:4}:
   -> #0 (intel_soc_pmic_bxtwc:502:(&bxtwc_regmap_config)->lock){+.+.}-{4:4}:

   Chain exists of:
     intel_soc_pmic_bxtwc:502:(&bxtwc_regmap_config)->lock --> &desc->request_mutex --> &d->lock

    Possible unsafe locking scenario:

          CPU0                    CPU1
          ----                    ----
     lock(&d->lock);
                                  lock(&desc->request_mutex);
                                  lock(&d->lock);
     lock(intel_soc_pmic_bxtwc:502:(&bxtwc_regmap_config)->lock);

    *** DEADLOCK ***

   3 locks held by modprobe/141:
    #0: ffff8994419368f8 (&dev->mutex){....}-{4:4}, at: __driver_attach+0xf6/0x250
    #1: ffff89944690b250 (&desc->request_mutex){+.+.}-{4:4}, at: __setup_irq+0x1a2/0x790
    #2: ffff899446947c68 (&d->lock){+.+.}-{4:4}, at: __setup_irq+0x682/0x790

Set a lockdep class when we map the IRQ so that it doesn't warn about
a lockdep bug that doesn't exist.

Fixes: 4af8be67fd99 ("regmap: Convert regmap_irq to use irq_domain")
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://patch.msgid.link/20241101165553.4055617-1-andriy.shevchenko@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/regmap/regmap-irq.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/base/regmap/regmap-irq.c b/drivers/base/regmap/regmap-irq.c
index 3aac960ae30ab..e3769e70844be 100644
--- a/drivers/base/regmap/regmap-irq.c
+++ b/drivers/base/regmap/regmap-irq.c
@@ -587,12 +587,16 @@ static irqreturn_t regmap_irq_thread(int irq, void *d)
 		return IRQ_NONE;
 }
 
+static struct lock_class_key regmap_irq_lock_class;
+static struct lock_class_key regmap_irq_request_class;
+
 static int regmap_irq_map(struct irq_domain *h, unsigned int virq,
 			  irq_hw_number_t hw)
 {
 	struct regmap_irq_chip_data *data = h->host_data;
 
 	irq_set_chip_data(virq, data);
+	irq_set_lockdep_class(virq, &regmap_irq_lock_class, &regmap_irq_request_class);
 	irq_set_chip(virq, &data->irq_chip);
 	irq_set_nested_thread(virq, 1);
 	irq_set_parent(virq, data->irq);
-- 
2.43.0



