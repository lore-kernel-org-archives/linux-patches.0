Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B815E3BFAC8;
	Sat, 17 Oct 2026 16:41:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792255312; cv=none; b=OCbYe6lrf3HUg4bWG+CUopmSFtGzNIoy7lgQj0czyYHLTkkG1v/q+ylhWlEE/4qU+iLHcaEo2nwBgkrD69104ij8eTXr9AtwnJeUHpozZ1YkUkwG3Lc4h6DQ4rPNJSh294YpsLT5hUGMvHhIgTXEaOFLbQvv9u9dxZOm7dkcbi0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792255312; c=relaxed/simple;
	bh=75dujK0sH9R/1oN0At8wW3XrVOVLU8cK0uwCClee9xA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bywWysLXqxl0aC99tHN9Xqc7kYE00+e7Zy5Y3fiLwbpODK0jJKoS9ZZBTIFtVmCQj2YFiWazx5UNz2uPm3TxMjRyB8sRhbiCj9sr4NQhW/Mgh+lw25XQfBlreMdE2hst8t3ZQy/9KmLwIsVXTHO8MkY6j5AVNGF+UurU+PjCqzg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1EEvUM01; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1EEvUM01"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0ED4D1F000C4;
	Sat, 17 Oct 2026 16:41:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792255311;
	bh=m7aLbNtUWN8F3Zj6K2MxLCiiM59NBeoYOUVyVAbFVY0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1EEvUM01ZbDNhTu4Y3z59nJklOIdvd/Oa7AMJQskOhkAZ7fUZEP9mEtRT9lbcnL34
	 ez13Zvo/skn8va/PqGhOmPGMzdpX05hMnAetXf2WG/UsUDzCWH46h+lHnM8epZiuBs
	 DMA2J53h/zlUVpldEyYdkg7cUTsvF+py0IGFvgeE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Johan Hovold <johan+linaro@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 733/869] PM: sleep: core: Synchronize runtime PM status of parents and children
Date: Sat, 17 Oct 2026 17:59:34 +0200
Message-ID: <20261017160055.742707455@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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
Stable-dep-of: 36d74f17e03f ("driver core: Avoid warning when removing a device while its supplier is unbinding")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/power/main.c | 29 ++++++++++++++++++++---------
 include/linux/pm.h        |  1 +
 2 files changed, 21 insertions(+), 9 deletions(-)

diff --git a/drivers/base/power/main.c b/drivers/base/power/main.c
index abb16a5bb7967..71489b46a07bb 100644
--- a/drivers/base/power/main.c
+++ b/drivers/base/power/main.c
@@ -654,13 +654,15 @@ static void device_resume_noirq(struct device *dev, pm_message_t state, bool asy
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
@@ -1187,18 +1189,24 @@ static pm_message_t resume_event(pm_message_t sleep_state)
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
@@ -1275,8 +1283,11 @@ static int device_suspend_noirq(struct device *dev, pm_message_t state, bool asy
 	      dev->power.may_skip_resume) || !pm_runtime_need_not_resume(dev))
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
2.53.0



