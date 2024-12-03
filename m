Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65DC7200B9B;
	Tue,  3 Dec 2024 15:36:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733240180; cv=none; b=ZcQzRjICzSwqJM72auuEx90RcdHMAnZ67ccrsfGQPvkGqhSLe1vx3gR4DfpV2/Rk3HzXddXLkIi8Nq1U3qacMosib1FEqRYdziAsHKZctBnH4Wl+rPuzdHPBg8ADCW4t0j1aTXAmVCPZzDLG/NnJoZ+o4p5wQEahOa3M+2iZetA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733240180; c=relaxed/simple;
	bh=0sKiZ4g9VsPmHaDMRQn80Nz4rTgyCpotg6REG4aBEho=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OT5VlylaaoazAKoTGmf8dEc0uXyvm0Jfapn0SNKPD5XlvZsskbhqfxL9FU9KmUHu7Ow+EQxlWbnGuqlOIybKsV/ddUck6PuRojd6MPkd50oay/ocGKZ45TKXlYGSsB0DQC95qE4faAZJb2nicXFR3ZiW76JqV9HiWc5bvmqtQxU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c9i5+gA8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c9i5+gA8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E28F1C4CECF;
	Tue,  3 Dec 2024 15:36:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733240180;
	bh=0sKiZ4g9VsPmHaDMRQn80Nz4rTgyCpotg6REG4aBEho=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c9i5+gA8j26cbCGUcUULHRPftTDNqL5uIgr7jAPPqiz4Lvjisxy1WZvs1DLHcysl1
	 uTw50+Yihn87DUXYnP3cofF6r/xrfpPshV0HMWQWgfGCVTF7mmsizmv+eWOXhaU4Gt
	 cghYea9g8aLAAfdma2AzlkM43Nt3XVnXcdleCR7I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Lukasz Luba <lukasz.luba@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 051/826] thermal: core: Rearrange PM notification code
Date: Tue,  3 Dec 2024 15:36:18 +0100
Message-ID: <20241203144745.464923160@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

[ Upstream commit 7ddca5885718c2683d75689aa065c9a3bb317e5a ]

Move the code run for each thermal zone by the thermal PM notify
handler to separate functions.

This will help to make some subsequent changes look somewhat more
straightforward, among other things.

No intentional functional impact.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Link: https://patch.msgid.link/2299090.iZASKD2KPV@rjwysocki.net
Reviewed-by: Lukasz Luba <lukasz.luba@arm.com>
Stable-dep-of: 7837fa8115e0 ("thermal: core: Mark thermal zones as initializing to start with")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thermal/thermal_core.c | 88 ++++++++++++++++++----------------
 1 file changed, 46 insertions(+), 42 deletions(-)

diff --git a/drivers/thermal/thermal_core.c b/drivers/thermal/thermal_core.c
index 7a138bd5d8841..9198861916969 100644
--- a/drivers/thermal/thermal_core.c
+++ b/drivers/thermal/thermal_core.c
@@ -1675,6 +1675,48 @@ static void thermal_zone_device_resume(struct work_struct *work)
 	mutex_unlock(&tz->lock);
 }
 
+static void thermal_zone_pm_prepare(struct thermal_zone_device *tz)
+{
+	mutex_lock(&tz->lock);
+
+	if (tz->resuming) {
+		/*
+		 * thermal_zone_device_resume() queued up for this zone has not
+		 * acquired the lock yet, so release it to let the function run
+		 * and wait util it has done the work.
+		 */
+		mutex_unlock(&tz->lock);
+
+		wait_for_completion(&tz->resume);
+
+		mutex_lock(&tz->lock);
+	}
+
+	tz->suspended = true;
+
+	mutex_unlock(&tz->lock);
+}
+
+static void thermal_zone_pm_complete(struct thermal_zone_device *tz)
+{
+	mutex_lock(&tz->lock);
+
+	cancel_delayed_work(&tz->poll_queue);
+
+	reinit_completion(&tz->resume);
+	tz->resuming = true;
+
+	/*
+	 * Replace the work function with the resume one, which will restore the
+	 * original work function and schedule the polling work if needed.
+	 */
+	INIT_DELAYED_WORK(&tz->poll_queue, thermal_zone_device_resume);
+	/* Queue up the work without a delay. */
+	mod_delayed_work(system_freezable_power_efficient_wq, &tz->poll_queue, 0);
+
+	mutex_unlock(&tz->lock);
+}
+
 static int thermal_pm_notify(struct notifier_block *nb,
 			     unsigned long mode, void *_unused)
 {
@@ -1686,27 +1728,8 @@ static int thermal_pm_notify(struct notifier_block *nb,
 	case PM_SUSPEND_PREPARE:
 		mutex_lock(&thermal_list_lock);
 
-		list_for_each_entry(tz, &thermal_tz_list, node) {
-			mutex_lock(&tz->lock);
-
-			if (tz->resuming) {
-				/*
-				 * thermal_zone_device_resume() queued up for
-				 * this zone has not acquired the lock yet, so
-				 * release it to let the function run and wait
-				 * util it has done the work.
-				 */
-				mutex_unlock(&tz->lock);
-
-				wait_for_completion(&tz->resume);
-
-				mutex_lock(&tz->lock);
-			}
-
-			tz->suspended = true;
-
-			mutex_unlock(&tz->lock);
-		}
+		list_for_each_entry(tz, &thermal_tz_list, node)
+			thermal_zone_pm_prepare(tz);
 
 		mutex_unlock(&thermal_list_lock);
 		break;
@@ -1715,27 +1738,8 @@ static int thermal_pm_notify(struct notifier_block *nb,
 	case PM_POST_SUSPEND:
 		mutex_lock(&thermal_list_lock);
 
-		list_for_each_entry(tz, &thermal_tz_list, node) {
-			mutex_lock(&tz->lock);
-
-			cancel_delayed_work(&tz->poll_queue);
-
-			reinit_completion(&tz->resume);
-			tz->resuming = true;
-
-			/*
-			 * Replace the work function with the resume one, which
-			 * will restore the original work function and schedule
-			 * the polling work if needed.
-			 */
-			INIT_DELAYED_WORK(&tz->poll_queue,
-					  thermal_zone_device_resume);
-			/* Queue up the work without a delay. */
-			mod_delayed_work(system_freezable_power_efficient_wq,
-					 &tz->poll_queue, 0);
-
-			mutex_unlock(&tz->lock);
-		}
+		list_for_each_entry(tz, &thermal_tz_list, node)
+			thermal_zone_pm_complete(tz);
 
 		mutex_unlock(&thermal_list_lock);
 		break;
-- 
2.43.0



