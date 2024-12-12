Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 735292210EA;
	Thu, 12 Dec 2024 17:38:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734025090; cv=none; b=airFLyU2yrRlBLoyQEEY846mSjw67g6NDzggo+Tv3c5V9gbohCCG/euARDchDlguKsEBePIdbsTJMJRY1iGB/Xw1IQo1XwPHfhn/pLVD06FHmOZHCPeCIT4fJvTftRbapYBclQv05HVXEmrQUQPx5c84uTA0TTNe5msxL+aFM9Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734025090; c=relaxed/simple;
	bh=iyX/AruZQDAmRHtzylRQLH0XvXiiEWnrjcrzA2Btplo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fXY0kh3nsVGTPUMhJsOTirZ/kwHqID2lSit9lKH2k3ysXkZ2Nk+oCOBYHdXZexGgNvbmxj5sLAHDpLURf/wweb13tqTEo1jo3PKg8ondqHeWkk2ufChRobrlZ2F9Z16/d2QxQLxRDfue5HvL0Az+JLCLoMs3DRd5dftGB9Y4SwM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RjQGG8RA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RjQGG8RA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4E05C4CECE;
	Thu, 12 Dec 2024 17:38:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734025090;
	bh=iyX/AruZQDAmRHtzylRQLH0XvXiiEWnrjcrzA2Btplo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RjQGG8RAofPbckUjbSNVmT/VU9eUHElW9T1aBiwzFEgYT0kAMCIfwnvJjnNOZ2Mhc
	 Nkmfkf6es7UCwMEk7rYUBfgklMd//skxFSIAOepP51NhcfC2HokMX5bai1rZMlW050
	 tZx8B6gnuob7afJrQ2ikWA8L5QlVxm0J92ZQt7/8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 053/321] regmap: irq: Set lockdep class for hierarchical IRQ domains
Date: Thu, 12 Dec 2024 15:59:31 +0100
Message-ID: <20241212144232.088463060@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144229.291682835@linuxfoundation.org>
References: <20241212144229.291682835@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 3c1e554df4eb2..54cb9a02254f9 100644
--- a/drivers/base/regmap/regmap-irq.c
+++ b/drivers/base/regmap/regmap-irq.c
@@ -522,12 +522,16 @@ static irqreturn_t regmap_irq_thread(int irq, void *d)
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



