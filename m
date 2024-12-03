Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34EC81F9A9C;
	Tue,  3 Dec 2024 15:36:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733240192; cv=none; b=KjScdp0IwEMyprstBoFXvJjhBOMETmmEb9QNx9N5NZh/Q/iDbhzdtqaeNbSKMN6Mugge1/zqWHH5e0AUb0QbQn7PYqCVNPBr5gpK5JVf5csJa5RodktUjr2/aPwqt7bLkF4VbFP2OutZ+BpQsZDhu7uieEuwy/psQ8XLxF7PAb8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733240192; c=relaxed/simple;
	bh=me9TNdOq5w/izsSzaihqLczOw0tyysCps+vhm2pNApc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lu0tcjUUoaFU9/uaO/5gTZoeMvOCyXBmvS/HZiCp6tSvDr+VIN+iwiU5x/ilIIKmlaLZtT8j6rcUDd7rxX4w+4HCSM9VwP3cilZa8e4ZjJvtlupZWzKgk5dR5dFefyu84uK46AulBfVS7Pzn2oGwhDL+xDIBrcD3q+9UY/h+Pbw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ORi3DCyg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ORi3DCyg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67C0DC4CECF;
	Tue,  3 Dec 2024 15:36:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733240191;
	bh=me9TNdOq5w/izsSzaihqLczOw0tyysCps+vhm2pNApc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ORi3DCyg4xyShHlQgUKQnhJTsKEexI7zRHtUcBpgKy0Ux+RMgKpRXf6eFmJWDG9Be
	 5j0h3vVzst2qXI86smTRXvsEcfwK4BtRWmbYUpL1F54HiaxANAPvT9JXvyDkNBqi1y
	 9nVWl0N6NNLlb0lcedamyU7i1OQPT37vqZ6G2JgY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Lukasz Luba <lukasz.luba@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 054/826] thermal: core: Fix race between zone registration and system suspend
Date: Tue,  3 Dec 2024 15:36:21 +0100
Message-ID: <20241203144745.582062731@linuxfoundation.org>
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

[ Upstream commit cdf771ab476bd9acb0948f3088a277d5c3cacc6b ]

If the registration of a thermal zone takes place at the time when
system suspend is started, thermal_pm_notify() can run before the new
thermal zone is added to thermal_tz_list and its "suspended" flag will
not be set.  Consequently, if __thermal_zone_device_update() is called
for that thermal zone, it will not return early as expected which may
cause some destructive interference with the system suspend or resume
flow to occur.

To avoid that, make thermal_zone_init_complete() introduced previously
set the "suspended" flag for new thermal zones if it runs during system
suspend or resume.

Fixes: 4e814173a8c4 ("thermal: core: Fix thermal zone suspend-resume synchronization")
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Link: https://patch.msgid.link/8490245.NyiUUSuA9g@rjwysocki.net
Reviewed-by: Lukasz Luba <lukasz.luba@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thermal/thermal_core.c | 18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff --git a/drivers/thermal/thermal_core.c b/drivers/thermal/thermal_core.c
index b5538df3c4685..1d2f2b307bac5 100644
--- a/drivers/thermal/thermal_core.c
+++ b/drivers/thermal/thermal_core.c
@@ -40,6 +40,8 @@ static DEFINE_MUTEX(thermal_governor_lock);
 
 static struct thermal_governor *def_governor;
 
+static bool thermal_pm_suspended;
+
 /*
  * Governor section: set of functions to handle thermal governors
  *
@@ -1337,6 +1339,14 @@ static void thermal_zone_init_complete(struct thermal_zone_device *tz)
 	mutex_lock(&tz->lock);
 
 	tz->state &= ~TZ_STATE_FLAG_INIT;
+	/*
+	 * If system suspend or resume is in progress at this point, the
+	 * new thermal zone needs to be marked as suspended because
+	 * thermal_pm_notify() has run already.
+	 */
+	if (thermal_pm_suspended)
+		tz->state |= TZ_STATE_FLAG_SUSPENDED;
+
 	__thermal_zone_device_update(tz, THERMAL_EVENT_UNSPECIFIED);
 
 	mutex_unlock(&tz->lock);
@@ -1514,10 +1524,10 @@ thermal_zone_device_register_with_trips(const char *type,
 	list_for_each_entry(cdev, &thermal_cdev_list, node)
 		thermal_zone_cdev_bind(tz, cdev);
 
-	mutex_unlock(&thermal_list_lock);
-
 	thermal_zone_init_complete(tz);
 
+	mutex_unlock(&thermal_list_lock);
+
 	thermal_notify_tz_create(tz);
 
 	thermal_debug_tz_add(tz);
@@ -1737,6 +1747,8 @@ static int thermal_pm_notify(struct notifier_block *nb,
 	case PM_SUSPEND_PREPARE:
 		mutex_lock(&thermal_list_lock);
 
+		thermal_pm_suspended = true;
+
 		list_for_each_entry(tz, &thermal_tz_list, node)
 			thermal_zone_pm_prepare(tz);
 
@@ -1747,6 +1759,8 @@ static int thermal_pm_notify(struct notifier_block *nb,
 	case PM_POST_SUSPEND:
 		mutex_lock(&thermal_list_lock);
 
+		thermal_pm_suspended = false;
+
 		list_for_each_entry(tz, &thermal_tz_list, node)
 			thermal_zone_pm_complete(tz);
 
-- 
2.43.0



