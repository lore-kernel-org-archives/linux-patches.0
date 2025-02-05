Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F287DF59;
	Wed,  5 Feb 2025 15:03:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738767788; cv=none; b=YHaLdkPRilW6JXcSuhneZ0yvJ5FJFbelAw3OHGwPgeLILwcm9kPEfuB02Fxf4MPjpGtwEW19XvdQr6rWcg/yR+TDO0LcFntPS/urfW3d5iAhbnoTE4S50nGzfDXdTrcPZSU8Oq/ON/6GSxyFewLKk6LHok2XmQWBq9JYNHEuRkk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738767788; c=relaxed/simple;
	bh=spwlnPF6d+sfzYN6w3I9XtpGznjx/4kQc7YVDi0ohj0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=umJ9ODU6MpNwA+i5LwazRfRjxMFevszfG35zZe5DoIkuql9qv5qAhSv/CigS3r9EYj2347jUMVLpweLEkI0/dUZ2BsDJFKHNr5bXzltejRTXPafSSxOMAg4Nregx0lX5husN8SlWWS7Eir1E7VRN95btC2oNpfY+JB0e2YAzby0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QRPF+N6M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QRPF+N6M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A05B5C4CED1;
	Wed,  5 Feb 2025 15:03:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738767788;
	bh=spwlnPF6d+sfzYN6w3I9XtpGznjx/4kQc7YVDi0ohj0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QRPF+N6MYyaXCS2hE/7g7eJ2fNWf72U+cdCh2x0HTpU5wnjCXZuweQN6dkRNDKQRW
	 s+hW5FN04Vz/l8FPeYKE2BAVKjPmpXm0BaS1eunQuRfd9g/fcennbVGi/QWAisqpKl
	 8YuACn0rd5oc7TMCYf3HRaykc/eaHfMw5I3038uc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Johan Hovold <johan+linaro@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 509/590] PM: sleep: core: Synchronize runtime PM status of parents and children
Date: Wed,  5 Feb 2025 14:44:24 +0100
Message-ID: <20250205134514.740889749@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

[ Upstream commit 3775fc538f535a7c5adaf11990c7932a0bd1f9eb ]

Commit 6e176bf8d461 ("PM: sleep: core: Do not skip callbacks in the
resume phase") overlooked the case in which the parent of a device with
DPM_FLAG_SMART_SUSPEND set did not use that flag and could be runtime-
suspended before a transition into a system-wide sleep state.  In that
case, if the child is resumed during the subsequent transition from
that state into the working state, its runtime PM status will be set to
RPM_ACTIVE, but the runtime PM status of the parent will not be updated
accordingly, even though the parent will be resumed too, because of the
dev_pm_skip_suspend() check in device_resume_noirq().

Address this problem by tracking the need to set the runtime PM status
to RPM_ACTIVE during system-wide resume transitions for devices with
DPM_FLAG_SMART_SUSPEND set and all of the devices depended on by them.

Fixes: 6e176bf8d461 ("PM: sleep: core: Do not skip callbacks in the resume phase")
Closes: https://lore.kernel.org/linux-pm/Z30p2Etwf3F2AUvD@hovoldconsulting.com/
Reported-by: Johan Hovold <johan@kernel.org>
Tested-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Reviewed-by: Johan Hovold <johan+linaro@kernel.org>
Tested-by: Johan Hovold <johan+linaro@kernel.org>
Link: https://patch.msgid.link/12619233.O9o76ZdvQC@rjwysocki.net
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/power/main.c | 29 ++++++++++++++++++++---------
 include/linux/pm.h        |  1 +
 2 files changed, 21 insertions(+), 9 deletions(-)

diff --git a/drivers/base/power/main.c b/drivers/base/power/main.c
index 4a67e83300e16..e1b44266497d3 100644
--- a/drivers/base/power/main.c
+++ b/drivers/base/power/main.c
@@ -642,13 +642,15 @@ static void device_resume_noirq(struct device *dev, pm_message_t state, bool asy
 	 * so change its status accordingly.
 	 *
 	 * Otherwise, the device is going to be resumed, so set its PM-runtime
-	 * status to "active", but do that only if DPM_FLAG_SMART_SUSPEND is set
-	 * to avoid confusing drivers that don't use it.
+	 * status to "active" unless its power.set_active flag is clear, in
+	 * which case it is not necessary to update its PM-runtime status.
 	 */
-	if (skip_resume)
+	if (skip_resume) {
 		pm_runtime_set_suspended(dev);
-	else if (dev_pm_skip_suspend(dev))
+	} else if (dev->power.set_active) {
 		pm_runtime_set_active(dev);
+		dev->power.set_active = false;
+	}
 
 	if (dev->pm_domain) {
 		info = "noirq power domain ";
@@ -1175,18 +1177,24 @@ static pm_message_t resume_event(pm_message_t sleep_state)
 	return PMSG_ON;
 }
 
-static void dpm_superior_set_must_resume(struct device *dev)
+static void dpm_superior_set_must_resume(struct device *dev, bool set_active)
 {
 	struct device_link *link;
 	int idx;
 
-	if (dev->parent)
+	if (dev->parent) {
 		dev->parent->power.must_resume = true;
+		if (set_active)
+			dev->parent->power.set_active = true;
+	}
 
 	idx = device_links_read_lock();
 
-	list_for_each_entry_rcu_locked(link, &dev->links.suppliers, c_node)
+	list_for_each_entry_rcu_locked(link, &dev->links.suppliers, c_node) {
 		link->supplier->power.must_resume = true;
+		if (set_active)
+			link->supplier->power.set_active = true;
+	}
 
 	device_links_read_unlock(idx);
 }
@@ -1264,8 +1272,11 @@ static int device_suspend_noirq(struct device *dev, pm_message_t state, bool asy
 	      dev->power.may_skip_resume))
 		dev->power.must_resume = true;
 
-	if (dev->power.must_resume)
-		dpm_superior_set_must_resume(dev);
+	if (dev->power.must_resume) {
+		dev->power.set_active = dev->power.set_active ||
+			dev_pm_test_driver_flags(dev, DPM_FLAG_SMART_SUSPEND);
+		dpm_superior_set_must_resume(dev, dev->power.set_active);
+	}
 
 Complete:
 	complete_all(&dev->power.completion);
diff --git a/include/linux/pm.h b/include/linux/pm.h
index 97b0e23363c82..a478737115cd9 100644
--- a/include/linux/pm.h
+++ b/include/linux/pm.h
@@ -683,6 +683,7 @@ struct dev_pm_info {
 	bool			no_pm_callbacks:1;	/* Owned by the PM core */
 	bool			async_in_progress:1;	/* Owned by the PM core */
 	bool			must_resume:1;		/* Owned by the PM core */
+	bool			set_active:1;		/* Owned by the PM core */
 	bool			may_skip_resume:1;	/* Set by subsystems */
 #else
 	bool			should_wakeup:1;
-- 
2.39.5



