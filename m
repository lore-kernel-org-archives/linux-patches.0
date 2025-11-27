Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CAA828D8E8;
	Thu, 27 Nov 2025 14:59:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764255587; cv=none; b=rmvjK39czjNU0lP1NZ05w2X2rw0SplrpcjdDAkNnL0w5V1Rft/fEwoxC9PczqlGAVdI/AiSi2wDmo+emnJnzeAx1+GSkcXGYfjAXMo3PjuRrT1qUHXlg0+boXh/AvlH0yC0bKKZmn/Dr8iE6IrKfxJz5L6hA55niE0FoHOwj+Wg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764255587; c=relaxed/simple;
	bh=8cwsD3loTqZqcwqr+38GuZPsh0BjNaeZZO4x2jb20wg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ut/MzD3u0ahZ2gI7SSX1/A5PUswi6hpc1BQV1Er5pFxdQKpujd/XX4Z9r4VhrmBOrMl3YwCTjj9CWip5amkm1STywKckaffZLfFhLE9sPOzUjP1TAa5SHim7sfpE8C4cELQnQF7WKBS4nLz5pnEMIbNlHxEDxL6dXEuXYee9/es=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FX5CSB3R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FX5CSB3R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D47BC4CEF8;
	Thu, 27 Nov 2025 14:59:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764255586;
	bh=8cwsD3loTqZqcwqr+38GuZPsh0BjNaeZZO4x2jb20wg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FX5CSB3RMqIQgthfy0GvZnsNqXP8AaWI/9ArB81RrrV44GSKil9pTIifPCRFN0pqm
	 tutWaxcl+mehmMJbHmGtMGJQwHhXDZLVChy92TCA1Fjbu54NZWfJbdw39NDeWKzAAi
	 g0s2OX2efHJaV6DBUs5pa6ZoOLPswAb5vBDmszHI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rose Wu <ya-jou.wu@mediatek.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 6.17 044/175] PM: sleep: core: Fix runtime PM enabling in device_resume_early()
Date: Thu, 27 Nov 2025 15:44:57 +0100
Message-ID: <20251127144044.573365561@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251127144042.945669935@linuxfoundation.org>
References: <20251127144042.945669935@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

commit f384497a76ed9539f70f6e8fe81a193441c943d2 upstream.

Runtime PM should only be enabled in device_resume_early() if it has
been disabled for the given device by device_suspend_late().  Otherwise,
it may cause runtime PM callbacks to run prematurely in some cases
which leads to further functional issues.

Make two changes to address this problem.

First, reorder device_suspend_late() to only disable runtime PM for a
device when it is going to look for the device's callback or if the
device is a "syscore" one.  In all of the other cases, disabling runtime
PM for the device is not in fact necessary.  However, if the device's
callback returns an error and the power.is_late_suspended flag is not
going to be set, enable runtime PM so it only remains disabled when
power.is_late_suspended is set.

Second, make device_resume_early() only enable runtime PM for the
devices with the power.is_late_suspended flag set.

Fixes: 443046d1ad66 ("PM: sleep: Make suspend of devices more asynchronous")
Reported-by: Rose Wu <ya-jou.wu@mediatek.com>
Closes: https://lore.kernel.org/linux-pm/70b25dca6f8c2756d78f076f4a7dee7edaaffc33.camel@mediatek.com/
Cc: 6.16+ <stable@vger.kernel.org> # 6.16+
Reviewed-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Link: https://patch.msgid.link/12784270.O9o76ZdvQC@rafael.j.wysocki
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/base/power/main.c | 25 ++++++++++++++++---------
 1 file changed, 16 insertions(+), 9 deletions(-)

diff --git a/drivers/base/power/main.c b/drivers/base/power/main.c
index e83503bdc1fd..1de1cd72b616 100644
--- a/drivers/base/power/main.c
+++ b/drivers/base/power/main.c
@@ -888,12 +888,15 @@ static void device_resume_early(struct device *dev, pm_message_t state, bool asy
 	TRACE_DEVICE(dev);
 	TRACE_RESUME(0);
 
-	if (dev->power.syscore || dev->power.direct_complete)
+	if (dev->power.direct_complete)
 		goto Out;
 
 	if (!dev->power.is_late_suspended)
 		goto Out;
 
+	if (dev->power.syscore)
+		goto Skip;
+
 	if (!dpm_wait_for_superior(dev, async))
 		goto Out;
 
@@ -926,11 +929,11 @@ static void device_resume_early(struct device *dev, pm_message_t state, bool asy
 
 Skip:
 	dev->power.is_late_suspended = false;
+	pm_runtime_enable(dev);
 
 Out:
 	TRACE_RESUME(error);
 
-	pm_runtime_enable(dev);
 	complete_all(&dev->power.completion);
 
 	if (error) {
@@ -1615,12 +1618,6 @@ static void device_suspend_late(struct device *dev, pm_message_t state, bool asy
 	TRACE_DEVICE(dev);
 	TRACE_SUSPEND(0);
 
-	/*
-	 * Disable runtime PM for the device without checking if there is a
-	 * pending resume request for it.
-	 */
-	__pm_runtime_disable(dev, false);
-
 	dpm_wait_for_subordinate(dev, async);
 
 	if (READ_ONCE(async_error))
@@ -1631,9 +1628,18 @@ static void device_suspend_late(struct device *dev, pm_message_t state, bool asy
 		goto Complete;
 	}
 
-	if (dev->power.syscore || dev->power.direct_complete)
+	if (dev->power.direct_complete)
 		goto Complete;
 
+	/*
+	 * Disable runtime PM for the device without checking if there is a
+	 * pending resume request for it.
+	 */
+	__pm_runtime_disable(dev, false);
+
+	if (dev->power.syscore)
+		goto Skip;
+
 	if (dev->pm_domain) {
 		info = "late power domain ";
 		callback = pm_late_early_op(&dev->pm_domain->ops, state);
@@ -1664,6 +1670,7 @@ static void device_suspend_late(struct device *dev, pm_message_t state, bool asy
 		WRITE_ONCE(async_error, error);
 		dpm_save_failed_dev(dev_name(dev));
 		pm_dev_err(dev, state, async ? " async late" : " late", error);
+		pm_runtime_enable(dev);
 		goto Complete;
 	}
 	dpm_propagate_wakeup_to_parent(dev);
-- 
2.52.0



