Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B5DD2676CF;
	Tue,  8 Apr 2025 12:10:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744114248; cv=none; b=cTZDARRR4jLfS+i5dI+O5Hami5HG2tRVJloG0OzC0uhV3WOeuosLB5wvmS4f7HgRoqU7kBTvsMLkylrG6nOvDTWVRzERWQLiAGvouRwX2xIB2O7hUG5ZmTRgLDhYqi2zitG/5BI5w31QQhQt+cZUdwOsYJGw0whpt8/Ue8mXWl4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744114248; c=relaxed/simple;
	bh=RX6dzWb2+LffeumDQlcjAssu1fwqVGg/nEMyCCaMLno=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L1FQxZQTp08SW2Tu2fzcF2OQ+EoswJaozH3+eJboStS+vWtVJskx8DePbAOK1RiL7w01N+rLb9k+zMwYCG93xKaQF26iMapHoC1E8nXfZZ8eVxh/brNjOPyIyZqqh7KHY1myTrUYWNFlCJPJPXipIIaXY2m6v1R9qh19cM/s0n0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dzzSPJez; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dzzSPJez"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 488A6C4CEE5;
	Tue,  8 Apr 2025 12:10:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744114247;
	bh=RX6dzWb2+LffeumDQlcjAssu1fwqVGg/nEMyCCaMLno=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dzzSPJezSOpP9xbEQetjmyEJffXIHT5TOIsgYP+9Nxd+1yytldoc5Z4C5DZ2zYSvs
	 OzTX/hWmnMLY0QVGefefOqt+RxOUp30reEtfQyBnGLoca0ky8kAoO4rOuky4ThT0UV
	 +1xvGwswzD0IvjjnJGCr/XXZcW+9E9TJgX75jp3I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Saravana Kannan <saravanak@google.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 035/499] PM: sleep: Fix handling devices with direct_complete set on errors
Date: Tue,  8 Apr 2025 12:44:07 +0200
Message-ID: <20250408104852.121094436@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104851.256868745@linuxfoundation.org>
References: <20250408104851.256868745@linuxfoundation.org>
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

[ Upstream commit 03f1444016b71feffa1dfb8a51f15ba592f94b13 ]

When dpm_suspend() fails, some devices with power.direct_complete set
may not have been handled by device_suspend() yet, so runtime PM has
not been disabled for them yet even though power.direct_complete is set.

Since device_resume() expects that runtime PM has been disabled for all
devices with power.direct_complete set, it will attempt to reenable
runtime PM for the devices that have not been processed by device_suspend()
which does not make sense.  Had those devices had runtime PM disabled
before device_suspend() had run, device_resume() would have inadvertently
enable runtime PM for them, but this is not expected to happen because
it would require ->prepare() callbacks to return positive values for
devices with runtime PM disabled, which would be invalid.

In practice, this issue is most likely benign because pm_runtime_enable()
will not allow the "disable depth" counter to underflow, but it causes a
warning message to be printed for each affected device.

To allow device_resume() to distinguish the "direct complete" devices
that have been processed by device_suspend() from those which have not
been handled by it, make device_suspend() set power.is_suspended for
"direct complete" devices.

Next, move the power.is_suspended check in device_resume() before the
power.direct_complete check in it to make it skip the "direct complete"
devices that have not been handled by device_suspend().

This change is based on a preliminary patch from Saravana Kannan.

Fixes: aae4518b3124 ("PM / sleep: Mechanism to avoid resuming runtime-suspended devices unnecessarily")
Link: https://lore.kernel.org/linux-pm/20241114220921.2529905-2-saravanak@google.com/
Reported-by: Saravana Kannan <saravanak@google.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Reviewed-by: Saravana Kannan <saravanak@google.com>
Link: https://patch.msgid.link/12627587.O9o76ZdvQC@rjwysocki.net
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/power/main.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/base/power/main.c b/drivers/base/power/main.c
index d4875c3712ede..1abe61f11525d 100644
--- a/drivers/base/power/main.c
+++ b/drivers/base/power/main.c
@@ -913,6 +913,9 @@ static void device_resume(struct device *dev, pm_message_t state, bool async)
 	if (dev->power.syscore)
 		goto Complete;
 
+	if (!dev->power.is_suspended)
+		goto Complete;
+
 	if (dev->power.direct_complete) {
 		/* Match the pm_runtime_disable() in __device_suspend(). */
 		pm_runtime_enable(dev);
@@ -931,9 +934,6 @@ static void device_resume(struct device *dev, pm_message_t state, bool async)
 	 */
 	dev->power.is_prepared = false;
 
-	if (!dev->power.is_suspended)
-		goto Unlock;
-
 	if (dev->pm_domain) {
 		info = "power domain ";
 		callback = pm_op(&dev->pm_domain->ops, state);
@@ -973,7 +973,6 @@ static void device_resume(struct device *dev, pm_message_t state, bool async)
 	error = dpm_run_callback(callback, dev, state, info);
 	dev->power.is_suspended = false;
 
- Unlock:
 	device_unlock(dev);
 	dpm_watchdog_clear(&wd);
 
@@ -1627,6 +1626,7 @@ static int device_suspend(struct device *dev, pm_message_t state, bool async)
 			pm_runtime_disable(dev);
 			if (pm_runtime_status_suspended(dev)) {
 				pm_dev_dbg(dev, state, "direct-complete ");
+				dev->power.is_suspended = true;
 				goto Complete;
 			}
 
-- 
2.39.5



