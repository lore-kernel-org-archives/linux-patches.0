Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6FAB1DE2A1;
	Tue,  3 Dec 2024 15:00:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733238001; cv=none; b=AX6S/729Gt97nE1YGv8niuC9BexqulVptnkMghNauZyq21VHvZGRSQIBhnL6d9SDePoLsJpzZUcSz3yjcCTwlNfZ76g7XWDeKzGWbeyAxvVKolBepKTJFqLZQ3Teyxnw+9fXnCfbHY5AH/71iXKhD9KfmyHYkU3bCE1Mkkg8994=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733238001; c=relaxed/simple;
	bh=jE7E3HKo319g+UOAe1WMpIAugO5uNnDF2S0MrEVNCdg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jGXs6vtPBRnM+MXELeuydpGMofvb59gSxmayx/J20I8cjN43H14fWxlfH1lruTaZDKlBzLeWD88pUA2OPD6lTly8to+nIvFH2k9flf/eMMgPgJCb8W+mvSRxRMzYJnDOmZGuO5tam3vR/n8JNtV4NaSe0QHML+73y3LKRAYhDmw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qyhnQiio; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qyhnQiio"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4647AC4CECF;
	Tue,  3 Dec 2024 15:00:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733238001;
	bh=jE7E3HKo319g+UOAe1WMpIAugO5uNnDF2S0MrEVNCdg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qyhnQiio1ZswJVPSNK9bw3dW0gyM0BMw3Y6YW8i4TOE/xfBdL6eF+5vM14UH5nxhG
	 LAUYTr3+Xa/73TvVf/AS4pHDZuZP2vuPpPx8xrUTsQyHhVCk3n259rv3ELCuy0FEbC
	 sOvqjnr8e2TqOFTkp0xzIR+u6uNbStBp0wswEjjs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Lukasz Luba <lukasz.luba@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 103/817] thermal: core: Fix race between zone registration and system suspend
Date: Tue,  3 Dec 2024 15:34:35 +0100
Message-ID: <20241203143959.727978046@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
index 91512a8cb49d9..a674469adad19 100644
--- a/drivers/thermal/thermal_core.c
+++ b/drivers/thermal/thermal_core.c
@@ -40,6 +40,8 @@ static DEFINE_MUTEX(thermal_governor_lock);
 
 static struct thermal_governor *def_governor;
 
+static bool thermal_pm_suspended;
+
 /*
  * Governor section: set of functions to handle thermal governors
  *
@@ -1356,6 +1358,14 @@ static void thermal_zone_init_complete(struct thermal_zone_device *tz)
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
@@ -1544,10 +1554,10 @@ thermal_zone_device_register_with_trips(const char *type,
 		}
 	}
 
-	mutex_unlock(&thermal_list_lock);
-
 	thermal_zone_init_complete(tz);
 
+	mutex_unlock(&thermal_list_lock);
+
 	thermal_notify_tz_create(tz);
 
 	thermal_debug_tz_add(tz);
@@ -1768,6 +1778,8 @@ static int thermal_pm_notify(struct notifier_block *nb,
 	case PM_SUSPEND_PREPARE:
 		mutex_lock(&thermal_list_lock);
 
+		thermal_pm_suspended = true;
+
 		list_for_each_entry(tz, &thermal_tz_list, node)
 			thermal_zone_pm_prepare(tz);
 
@@ -1778,6 +1790,8 @@ static int thermal_pm_notify(struct notifier_block *nb,
 	case PM_POST_SUSPEND:
 		mutex_lock(&thermal_list_lock);
 
+		thermal_pm_suspended = false;
+
 		list_for_each_entry(tz, &thermal_tz_list, node)
 			thermal_zone_pm_complete(tz);
 
-- 
2.43.0



