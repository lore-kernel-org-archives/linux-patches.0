Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 641731519B4;
	Wed,  5 Feb 2025 15:13:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738768387; cv=none; b=Pu8gQUtVmb8HYltF9nQwdU/P5dMNH6u3wlWYetOX8anHBAZCkzYqdbP/VlwwX6xkhv05sfqsccrp3htL8zVCy+aMK0v52ZQPD6hTbYPkNKIMHSewm1Yzu0T7wFgISzmNXf8m9Oyea3RDT8fnOlgVUxTqXQFZ7UNvNwT1F5FcMgY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738768387; c=relaxed/simple;
	bh=Kn8UN0AwiUt8mg/cjvAzaCMThNGZPgoyK6xksmhh1Y8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HUycV2ae0O7C20fUnq1BKgGQk9z11TgcdOsM4WigEzBsF4ccr4ICC6Helrtjbbpt6GlDd7VQ4Y0U3606zVjzzG+iFXRGuB+6Xwibpmd2oZiCWkOFI8K7Ejxf8VKbhbWlVgzh/kQPvM+3nz4vVPHo5LXw+mrDqIepm8ymnbDargk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X2tm2i3w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X2tm2i3w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4461C4CED1;
	Wed,  5 Feb 2025 15:13:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738768387;
	bh=Kn8UN0AwiUt8mg/cjvAzaCMThNGZPgoyK6xksmhh1Y8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X2tm2i3wVCuNr1oWBbbX0Hw4S4HqDsWXGyluuODs03M84WNF1fEmJ4olQ9uhOlJtZ
	 NiWdK++RwoXhhIcYduZtDKYsK8s1pRn0cz66S2a5xhWJdXZxnDTMjDJLGF5/XSROD6
	 o87lZpghNsRfO922fW8HVxPX4mDC24hFNuRbUp/A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Johan Hovold <johan+linaro@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 541/623] PM: sleep: core: Synchronize runtime PM status of parents and children
Date: Wed,  5 Feb 2025 14:44:43 +0100
Message-ID: <20250205134516.919594202@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
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
index e7f0260f15ad5..514cafcd21951 100644
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



