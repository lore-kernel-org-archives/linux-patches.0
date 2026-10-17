Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACB933BFE34;
	Sat, 17 Oct 2026 16:41:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792255315; cv=none; b=MetmTAxXHJmfoJDHbTKyHeRJzRNWho3csraievvIP65q4ZVcgzVx+K2BOF/Jlo4A7KrpAnIC8bn1p/EvQFOr9L8/EjbHaAOkvp2duMngiD9014wfmvzeyPqZDRYUMKwpWyyRXe9AVBGzGjKqJAkU5MnUn1F9qGPwmtGYC1zoJ/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792255315; c=relaxed/simple;
	bh=Ys/9S7gHp0FCxymSIheMQpv7Za8g8+z3yS4nyl9T5+4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dmJ9Zl45Lg9Uit1ai++MSw0QuEsJiCW/gyLFXMMx4DqGKAJGEZZ232N9Z3xKOci3Bn0H60TsxnE/DBDUQxl/mQ7JrC8dpeUkcUQ20sbSRxRh1lyAG8CfM0scWVnzaDx6DGYNvhyzMhYHIPSAXWJcJYP60/yqjc+CbLS3wIpCXaA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AxpyquRJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AxpyquRJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DD071F000C8;
	Sat, 17 Oct 2026 16:41:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792255314;
	bh=kmstrLaV3dA6KXzrW9a1MQ0bvW4XVSMJQgXp/V6C9Yo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AxpyquRJU0WjOxcvOT1ic80DdBst6MrgV02sf4ryg/YA8k12cPROvqJ590T7vRjro
	 qHvEd6XyAeglQULjUbQbeCxBGMsTve4iKWXPdl6z7LD9xLwm/wshwjIPBxIl1Vt85c
	 1gdSay5BcYtc01RKAxVnRhAyyYlUqgl43gAlPRnY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jon Hunter <jonathanh@nvidia.com>,
	Johan Hovold <johan+linaro@kernel.org>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 734/869] PM: sleep: core: Restrict power.set_active propagation
Date: Sat, 17 Oct 2026 17:59:35 +0200
Message-ID: <20261017160055.766908279@linuxfoundation.org>
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

[ Upstream commit 7585946243d614bd2cd4e13377be2c711c9539e0 ]

Commit 3775fc538f53 ("PM: sleep: core: Synchronize runtime PM status of
parents and children") exposed an issue related to simple_pm_bus_pm_ops
that uses pm_runtime_force_suspend() and pm_runtime_force_resume() as
bus type PM callbacks for the noirq phases of system-wide suspend and
resume.

The problem is that pm_runtime_force_suspend() does not distinguish
runtime-suspended devices from devices for which runtime PM has never
been enabled, so if it sees a device with runtime PM status set to
RPM_ACTIVE, it will assume that runtime PM is enabled for that device
and so it will attempt to suspend it with the help of its runtime PM
callbacks which may not be ready for that.  As it turns out, this
causes simple_pm_bus_runtime_suspend() to crash due to a NULL pointer
dereference.

Another problem related to the above commit and simple_pm_bus_pm_ops is
that setting runtime PM status of a device handled by the latter to
RPM_ACTIVE will actually prevent it from being resumed because
pm_runtime_force_resume() only resumes devices with runtime PM status
set to RPM_SUSPENDED.

To mitigate these issues, do not allow power.set_active to propagate
beyond the parent of the device with DPM_FLAG_SMART_SUSPEND set that
will need to be resumed, which should be a sufficient stop-gap for the
time being, but they will need to be properly addressed in the future
because in general during system-wide resume it is necessary to resume
all devices in a dependency chain in which at least one device is going
to be resumed.

Fixes: 3775fc538f53 ("PM: sleep: core: Synchronize runtime PM status of parents and children")
Closes: https://lore.kernel.org/linux-pm/1c2433d4-7e0f-4395-b841-b8eac7c25651@nvidia.com/
Reported-by: Jon Hunter <jonathanh@nvidia.com>
Tested-by: Johan Hovold <johan+linaro@kernel.org>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Link: https://patch.msgid.link/6137505.lOV4Wx5bFT@rjwysocki.net
Stable-dep-of: 36d74f17e03f ("driver core: Avoid warning when removing a device while its supplier is unbinding")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/power/main.c | 21 +++++++++------------
 1 file changed, 9 insertions(+), 12 deletions(-)

diff --git a/drivers/base/power/main.c b/drivers/base/power/main.c
index 71489b46a07bb..34645758b2f1b 100644
--- a/drivers/base/power/main.c
+++ b/drivers/base/power/main.c
@@ -1189,24 +1189,18 @@ static pm_message_t resume_event(pm_message_t sleep_state)
 	return PMSG_ON;
 }
 
-static void dpm_superior_set_must_resume(struct device *dev, bool set_active)
+static void dpm_superior_set_must_resume(struct device *dev)
 {
 	struct device_link *link;
 	int idx;
 
-	if (dev->parent) {
+	if (dev->parent)
 		dev->parent->power.must_resume = true;
-		if (set_active)
-			dev->parent->power.set_active = true;
-	}
 
 	idx = device_links_read_lock();
 
-	list_for_each_entry_rcu_locked(link, &dev->links.suppliers, c_node) {
+	list_for_each_entry_rcu_locked(link, &dev->links.suppliers, c_node)
 		link->supplier->power.must_resume = true;
-		if (set_active)
-			link->supplier->power.set_active = true;
-	}
 
 	device_links_read_unlock(idx);
 }
@@ -1284,9 +1278,12 @@ static int device_suspend_noirq(struct device *dev, pm_message_t state, bool asy
 		dev->power.must_resume = true;
 
 	if (dev->power.must_resume) {
-		dev->power.set_active = dev->power.set_active ||
-			dev_pm_test_driver_flags(dev, DPM_FLAG_SMART_SUSPEND);
-		dpm_superior_set_must_resume(dev, dev->power.set_active);
+		if (dev_pm_test_driver_flags(dev, DPM_FLAG_SMART_SUSPEND)) {
+			dev->power.set_active = true;
+			if (dev->parent && !dev->parent->power.ignore_children)
+				dev->parent->power.set_active = true;
+		}
+		dpm_superior_set_must_resume(dev);
 	}
 
 Complete:
-- 
2.53.0



