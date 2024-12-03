Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1EEE1DA4E;
	Tue,  3 Dec 2024 15:03:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733238195; cv=none; b=j/csgNHf9U1q8ha/LEs2KTvfB/kY9pnjaDQ1DFA5icCnDX8yttdOwaWh7PrdkBWKltvRoa1RvEtF2cSYe9LohwEm4QxxqascmLF4jAWH/dadg6KDMZt6B0+6ehpee2Fjc19tofgTP3XJHKnVr5CJQ6OPaeIPOuFQc5pHrmplIQc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733238195; c=relaxed/simple;
	bh=C3peOVNc0EkB97m/okxQ77xZcb3/cKDpDCI75bJjKhg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EDbq7uXcmBIlzivilIQkpxR+5ow4I2ATTgg7Y+M06TvQVGRYHYwnQdqqZ/PjACT+AsTi8rBngUnuxwOOwCGKaUegl7ZVULKqmP9XQF81s8znEYODTxDw/7EzCFBFgXSOIYOeW/F32VYqGu+Ys1S61OMtvOKSzh3PrjJmKANZN8w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J+4AlJN8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J+4AlJN8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 504F3C4CECF;
	Tue,  3 Dec 2024 15:03:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733238195;
	bh=C3peOVNc0EkB97m/okxQ77xZcb3/cKDpDCI75bJjKhg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J+4AlJN8DEB+zX4V6G0EhXzNkBNtk1KJqKI7u3JSc/y/mpJBblJPb0hpcgu2tl/Qo
	 LqnjhsB2sfYQfxsy5AyE1p8ntIhMwsTkjZMUfdHYS0z0X/atHnv+l5YWn97ot/8qJL
	 PhA0aN8bHWlSqB6E+w0aO4IKiY2oFPeFLVm4a6KY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 194/817] regmap: irq: Set lockdep class for hierarchical IRQ domains
Date: Tue,  3 Dec 2024 15:36:06 +0100
Message-ID: <20241203144003.312362986@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
index d3ec1345b5b53..250b2cc1e5d87 100644
--- a/drivers/base/regmap/regmap-irq.c
+++ b/drivers/base/regmap/regmap-irq.c
@@ -514,12 +514,16 @@ static irqreturn_t regmap_irq_thread(int irq, void *d)
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



