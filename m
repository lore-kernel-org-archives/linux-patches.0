Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 673EA2837B;
	Mon, 24 Feb 2025 14:57:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740409027; cv=none; b=gMSkxjRSigi7GG4Jxy1w+ZOLAqnplhcwJozovMbftkTafXdzmwQoz4jYwqcnnz3pcauE5PN1rMw2BuaIXoVFTFDJaQAWFsm33xlCt914GQut2Q/HpszXhC9JXiIsaFOElUbZRiT5dImZfkPfFUmHVhJvTmIRryh3e5zIXZMUJ3Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740409027; c=relaxed/simple;
	bh=BFtE77ypvExws955kAwdoQ3+qCsMi+HgF1hb2nHJssE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=boN7tXR7oGShUF7QjXcX8VP5CXO+Q4FzNkWxLyHmc5ypo5Nkm9q0cAt+W4J3uCmjxa3idlHkm5+4HiF0tpVm4WaFmi9FyCbM90+saYXIo1UtBvxPGdmgnqfrI7Qxzb05ruGA/OuhcO6Ow0vJruWPV811EduLZZRTCyMXgs/alQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RJaN2o08; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RJaN2o08"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9322C4CED6;
	Mon, 24 Feb 2025 14:57:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740409027;
	bh=BFtE77ypvExws955kAwdoQ3+qCsMi+HgF1hb2nHJssE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RJaN2o08fOz2mTnIzXvE5LoKbyXIxEn2UTbQL1qTOrgUKRNYaL8wUoIM7e2lSeLrN
	 F/vgmOAHCa2BkJHAacWPe68lLIyRbw2MHSukKwNbpCvkrM4W1KdaPP8TX/KH4TVu2c
	 5G+SYcGTXTln1RD6NfCkZU0bg5zwzwoSW9rUFiV0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ilia Levi <ilia.levi@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 076/138] drm/xe: Make irq enabled flag atomic
Date: Mon, 24 Feb 2025 15:35:06 +0100
Message-ID: <20250224142607.462894819@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250224142604.442289573@linuxfoundation.org>
References: <20250224142604.442289573@linuxfoundation.org>
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

From: Ilia Levi <ilia.levi@intel.com>

[ Upstream commit 4d79a1266d4cc3c967bc8823502466cad1ac8514 ]

The irq.enabled flag was protected by a spin lock (irq.lock).
By making it atomic we no longer need to wait for the spin lock in
irq handlers. This will become especially useful for MSI-X irq
handlers to prevent lock contention between different interrupts.

Signed-off-by: Ilia Levi <ilia.levi@intel.com>
Reviewed-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20241210173506.202150-1-ilia.levi@intel.com
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Stable-dep-of: 0c455f3a1229 ("drm/xe: Fix error handling in xe_irq_install()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/display/ext/i915_irq.c | 13 +---------
 drivers/gpu/drm/xe/xe_device_types.h      |  2 +-
 drivers/gpu/drm/xe/xe_irq.c               | 29 ++++++-----------------
 3 files changed, 9 insertions(+), 35 deletions(-)

diff --git a/drivers/gpu/drm/xe/display/ext/i915_irq.c b/drivers/gpu/drm/xe/display/ext/i915_irq.c
index a7dbc6554d694..ac4cda2d81c7a 100644
--- a/drivers/gpu/drm/xe/display/ext/i915_irq.c
+++ b/drivers/gpu/drm/xe/display/ext/i915_irq.c
@@ -53,18 +53,7 @@ void gen2_irq_init(struct intel_uncore *uncore, struct i915_irq_regs regs,
 
 bool intel_irqs_enabled(struct xe_device *xe)
 {
-	/*
-	 * XXX: i915 has a racy handling of the irq.enabled, since it doesn't
-	 * lock its transitions. Because of that, the irq.enabled sometimes
-	 * is not read with the irq.lock in place.
-	 * However, the most critical cases like vblank and page flips are
-	 * properly using the locks.
-	 * We cannot take the lock in here or run any kind of assert because
-	 * of i915 inconsistency.
-	 * But at this point the xe irq is better protected against races,
-	 * although the full solution would be protecting the i915 side.
-	 */
-	return xe->irq.enabled;
+	return atomic_read(&xe->irq.enabled);
 }
 
 void intel_synchronize_irq(struct xe_device *xe)
diff --git a/drivers/gpu/drm/xe/xe_device_types.h b/drivers/gpu/drm/xe/xe_device_types.h
index b9ea455d6f59f..09068ea7349a8 100644
--- a/drivers/gpu/drm/xe/xe_device_types.h
+++ b/drivers/gpu/drm/xe/xe_device_types.h
@@ -345,7 +345,7 @@ struct xe_device {
 		spinlock_t lock;
 
 		/** @irq.enabled: interrupts enabled on this device */
-		bool enabled;
+		atomic_t enabled;
 	} irq;
 
 	/** @ttm: ttm device */
diff --git a/drivers/gpu/drm/xe/xe_irq.c b/drivers/gpu/drm/xe/xe_irq.c
index b7995ebd54abd..32547b6a6d1cb 100644
--- a/drivers/gpu/drm/xe/xe_irq.c
+++ b/drivers/gpu/drm/xe/xe_irq.c
@@ -348,12 +348,8 @@ static irqreturn_t xelp_irq_handler(int irq, void *arg)
 	unsigned long intr_dw[2];
 	u32 identity[32];
 
-	spin_lock(&xe->irq.lock);
-	if (!xe->irq.enabled) {
-		spin_unlock(&xe->irq.lock);
+	if (!atomic_read(&xe->irq.enabled))
 		return IRQ_NONE;
-	}
-	spin_unlock(&xe->irq.lock);
 
 	master_ctl = xelp_intr_disable(xe);
 	if (!master_ctl) {
@@ -417,12 +413,8 @@ static irqreturn_t dg1_irq_handler(int irq, void *arg)
 
 	/* TODO: This really shouldn't be copied+pasted */
 
-	spin_lock(&xe->irq.lock);
-	if (!xe->irq.enabled) {
-		spin_unlock(&xe->irq.lock);
+	if (!atomic_read(&xe->irq.enabled))
 		return IRQ_NONE;
-	}
-	spin_unlock(&xe->irq.lock);
 
 	master_tile_ctl = dg1_intr_disable(xe);
 	if (!master_tile_ctl) {
@@ -644,12 +636,8 @@ static irqreturn_t vf_mem_irq_handler(int irq, void *arg)
 	struct xe_tile *tile;
 	unsigned int id;
 
-	spin_lock(&xe->irq.lock);
-	if (!xe->irq.enabled) {
-		spin_unlock(&xe->irq.lock);
+	if (!atomic_read(&xe->irq.enabled))
 		return IRQ_NONE;
-	}
-	spin_unlock(&xe->irq.lock);
 
 	for_each_tile(tile, xe, id)
 		xe_memirq_handler(&tile->memirq);
@@ -674,10 +662,9 @@ static void irq_uninstall(void *arg)
 	struct pci_dev *pdev = to_pci_dev(xe->drm.dev);
 	int irq;
 
-	if (!xe->irq.enabled)
+	if (!atomic_xchg(&xe->irq.enabled, 0))
 		return;
 
-	xe->irq.enabled = false;
 	xe_irq_reset(xe);
 
 	irq = pci_irq_vector(pdev, 0);
@@ -724,7 +711,7 @@ int xe_irq_install(struct xe_device *xe)
 		return err;
 	}
 
-	xe->irq.enabled = true;
+	atomic_set(&xe->irq.enabled, 1);
 
 	xe_irq_postinstall(xe);
 
@@ -744,9 +731,7 @@ void xe_irq_suspend(struct xe_device *xe)
 {
 	int irq = to_pci_dev(xe->drm.dev)->irq;
 
-	spin_lock_irq(&xe->irq.lock);
-	xe->irq.enabled = false; /* no new irqs */
-	spin_unlock_irq(&xe->irq.lock);
+	atomic_set(&xe->irq.enabled, 0); /* no new irqs */
 
 	synchronize_irq(irq); /* flush irqs */
 	xe_irq_reset(xe); /* turn irqs off */
@@ -762,7 +747,7 @@ void xe_irq_resume(struct xe_device *xe)
 	 * 1. no irq will arrive before the postinstall
 	 * 2. display is not yet resumed
 	 */
-	xe->irq.enabled = true;
+	atomic_set(&xe->irq.enabled, 1);
 	xe_irq_reset(xe);
 	xe_irq_postinstall(xe); /* turn irqs on */
 
-- 
2.39.5



