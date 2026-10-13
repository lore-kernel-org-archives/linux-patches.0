Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C89C4F7CD4;
	Tue, 13 Oct 2026 11:58:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791892736; cv=none; b=iwG4x8JY6tgznFRKyKohSAtxdn+vjLpl6yEdrw9apI1pz2im2hHWa9pS2xq9YiGVB9uwWgur0YROz+VLCNfql8j7rzfCSRsmGxRqzPZLm/JIEnuKyxZSjJK6CD8e9SKwXrxRmvp9NRcspQ9TYqkP7fy7MxrjqgB2WmB11NNyttM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791892736; c=relaxed/simple;
	bh=cEzUOzcfmznssXmFMYZvUa7bD71xhGvFVfArhmZfoqM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lbo0U7vl67eZrZe+JlO+MP+/gJXP5xbW3CjAGG/Xti3LrV3IA6tEVg0FpzJJPfg5hoRLaGiujQkqdgu9ssQTwjUjfr/ldHgtp9cuyp+jgXnJOvLE/7sMEPAXudpHOE+M04fSCm1omYadAypvtO9lNgtw35fq8z3Eg4eCMq/C8k8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aHCZyhBv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aHCZyhBv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82ED01F00893;
	Tue, 13 Oct 2026 11:58:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791892734;
	bh=/gIb8ypzg9dBaPCtcoWDAcCXsLA/cD1Eukc8u3bgERI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aHCZyhBvCAo5EG5lxqZiv9COyOV4d/IPSM+xgRAhe+0eunTMsXGsoIWCLr41Ok58i
	 tHugp4zjPJ1AoIDN/Y1SJty/82Oda/dTq0idOIZQddPXtJ2i7W1/+HrwrLsrkKpCnb
	 f3K3z3G/KYbwPZoBGyMA435nlJ6D1EfhWXqu+s/8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Iago Toral Quiroga <itoral@igalia.com>,
	=?UTF-8?q?Ma=C3=ADra=20Canal?= <mcanal@igalia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 273/281] drm/vc4: Disable the V3D interrupt across runtime suspend
Date: Tue, 13 Oct 2026 13:39:49 +0200
Message-ID: <20261013112901.764415416@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112855.045212108@linuxfoundation.org>
References: <20261013112855.045212108@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maíra Canal <mcanal@igalia.com>

[ Upstream commit 6abc8e4dcfbc1d26a94c0ac037dfb3716f686b1f ]

vc4_irq_disable() masks the V3D interrupt sources and then calls
synchronize_irq() before the V3D is powered down. However, by itself,
this is not enough to quiesce the interrupt handler.

synchronize_irq() waits for handlers that have already set
IRQD_IRQ_INPROGRESS, and for irqchips reporting IRQCHIP_STATE_ACTIVE.
A GIC interrupt chip is able to mark an interrupt active as soon as a
CPU acknowledges it, so there these checks cover the whole dispatch path.
On RPi 0-3, however, the interrupt controller is ARMCTRL, which has no
active state. A CPU that has read the hwirq out of the pending register
but has not yet reached handle_level_irq() stays invisible to
synchronize_irq().

During a power transition, vc4_irq() may therefore run after the power
domain is off, where every V3D register read will return 0xdeadbeef.
0xdeadbeef has FLDONE, FRDONE and OUTOMEM set. This problem doesn't
trigger NULL pointer dereference issues only because the functions
vc4_irq_finish_bin_job() and vc4_irq_finish_render_job() return early
when there is no job pointer, but OUTOMEM is still able to schedule
vc4_overflow_mem_work() after vc4_irq_disable() has already cancelled it.

Therefore, fix the spurious interrupts by disabling the interrupt line
across the PM transition. To preserve the enable/disable balance, move
vc4_irq_install() and request the IRQ line disabled before the first
runtime resume.

Fixes: 9b6f461582e6 ("drm/vc4: v3d: Stop disabling interrupts")
Reviewed-by: Iago Toral Quiroga <itoral@igalia.com>
Link: https://patch.msgid.link/20260925191318.541938-1-mcanal@igalia.com
Signed-off-by: Maíra Canal <mcanal@igalia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vc4/vc4_irq.c | 18 +++---------------
 drivers/gpu/drm/vc4/vc4_v3d.c | 13 +++++++------
 2 files changed, 10 insertions(+), 21 deletions(-)

diff --git a/drivers/gpu/drm/vc4/vc4_irq.c b/drivers/gpu/drm/vc4/vc4_irq.c
index 7877d493d80e6..98a8db7200917 100644
--- a/drivers/gpu/drm/vc4/vc4_irq.c
+++ b/drivers/gpu/drm/vc4/vc4_irq.c
@@ -276,7 +276,7 @@ vc4_irq_disable(struct drm_device *dev)
 	V3D_WRITE(V3D_INTCTL, V3D_DRIVER_IRQS);
 
 	/* Finish any interrupt handler still in flight. */
-	synchronize_irq(vc4->irq);
+	disable_irq(vc4->irq);
 
 	cancel_work_sync(&vc4->overflow_mem_work);
 }
@@ -284,7 +284,6 @@ vc4_irq_disable(struct drm_device *dev)
 int vc4_irq_install(struct drm_device *dev, int irq)
 {
 	struct vc4_dev *vc4 = to_vc4_dev(dev);
-	int ret;
 
 	if (WARN_ON_ONCE(vc4->gen > VC4_GEN_4))
 		return -ENODEV;
@@ -298,19 +297,8 @@ int vc4_irq_install(struct drm_device *dev, int irq)
 	init_waitqueue_head(&vc4->job_wait_queue);
 	INIT_WORK(&vc4->overflow_mem_work, vc4_overflow_mem_work);
 
-	/* Clear any pending interrupts someone might have left around
-	 * for us.
-	 */
-	V3D_WRITE(V3D_INTCTL, V3D_DRIVER_IRQS);
-
-	ret = devm_request_irq(dev->dev, irq, vc4_irq, 0,
-			       dev_name(dev->dev), dev);
-	if (ret)
-		return ret;
-
-	vc4_irq_enable(dev);
-
-	return 0;
+	return devm_request_irq(dev->dev, irq, vc4_irq, IRQF_NO_AUTOEN,
+				dev_name(dev->dev), dev);
 }
 
 void vc4_irq_uninstall(struct drm_device *dev)
diff --git a/drivers/gpu/drm/vc4/vc4_v3d.c b/drivers/gpu/drm/vc4/vc4_v3d.c
index 0f0c090afa6e2..8ca0f4dde04bd 100644
--- a/drivers/gpu/drm/vc4/vc4_v3d.c
+++ b/drivers/gpu/drm/vc4/vc4_v3d.c
@@ -397,6 +397,7 @@ static int vc4_v3d_runtime_resume(struct device *dev)
 	vc4_v3d_init_hw(&vc4->base);
 
 	vc4_irq_enable(&vc4->base);
+	enable_irq(vc4->irq);
 
 	return 0;
 }
@@ -453,6 +454,12 @@ static int vc4_v3d_bind(struct device *dev, struct device *master, void *data)
 		return ret;
 	vc4->irq = ret;
 
+	ret = vc4_irq_install(drm, vc4->irq);
+	if (ret) {
+		drm_err(drm, "Failed to install IRQ handler\n");
+		return ret;
+	}
+
 	ret = devm_pm_runtime_enable(dev);
 	if (ret)
 		return ret;
@@ -474,12 +481,6 @@ static int vc4_v3d_bind(struct device *dev, struct device *master, void *data)
 	V3D_WRITE(V3D_BPOA, 0);
 	V3D_WRITE(V3D_BPOS, 0);
 
-	ret = vc4_irq_install(drm, vc4->irq);
-	if (ret) {
-		drm_err(drm, "Failed to install IRQ handler\n");
-		goto err_put_runtime_pm;
-	}
-
 	pm_runtime_use_autosuspend(dev);
 	pm_runtime_set_autosuspend_delay(dev, 40); /* a little over 2 frames. */
 	pm_runtime_put_autosuspend(dev);
-- 
2.53.0



