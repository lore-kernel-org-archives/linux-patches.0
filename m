Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21FDB472F83;
	Tue, 21 Jul 2026 20:28:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784665699; cv=none; b=sYNzu0vhNn1s/mcaT1pd+SDL5sF0PK4JoIbzjlsWUoER3mLxzYIxtakouiVHhjNSysAIM313wFWIzKh3rH2QBQ7Z1fBUwVOswGaaP9ZiboDXtmIyLkPO/HKG4F/YZAqxgH+6X/3hQwSVfJh1zKUvb9xU4VKjNwvLEEzg1lJcuxU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784665699; c=relaxed/simple;
	bh=tN5faJOjBa2rHJ56pzGJaX0+lAPRc45L/ZozSV2xrNU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E/KVBrOcUhNZxKcC4bgqTI002TlT8EkQQJ2MX7za8arPe26OT+6x2uALWYj/poaGcK8tMHlSJIr6jN38o83BivayY0M2OISL6GmL1Tm/bnM7nllFmoRw6E1sfl/31vuguLHD1x1TC+9TPD0kuF4PcxiOxm+F9N+or3bZV7TmMC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=elpX2Jaa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="elpX2Jaa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B72CD1F00A3D;
	Tue, 21 Jul 2026 20:28:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784665692;
	bh=zV1B/geho5UyrIeBOEgg1mDmF45p1R94j1GmQLdsios=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=elpX2JaaemyZ2qlGc/5pAsKt6EdpsT/Esu2E61ppQeiDwsP7mVtFJfP+EUGVINubg
	 Ix0xsXKOqfv45/h/Xzu2IPyPM4TXo7aHbrXEtoF+WkqF2c29ETduLGtIGdzcfgoJDm
	 YWuzj5BhO18FRmy53v7c5pgBGfaquc9Fi64ZY/7Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0399/1266] thermal: hwmon: Fix critical temperature attribute removal
Date: Tue, 21 Jul 2026 17:13:56 +0200
Message-ID: <20260721152450.759981297@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

[ Upstream commit c2114dbda05354dbcf4dfbb30a2c623e8611c43a ]

Since the return value of thermal_zone_crit_temp_valid() depends on
the behavior of the thermal zone .get_crit_temp() callback which
may change over time in theory, thermal_remove_hwmon_sysfs() may
attempt to remove a critical temperature attribute that has not
been created, passing a pointer to an uninitialized attribute
structure to device_remove_file().

To avoid that, set a flag in struct thermal_hwmon_temp after creating
a critical temperature attribute and use the value of that flag to
decide whether or not the attribute needs to be removed.

Fixes: e8db5d6736a7 ("thermal: hwmon: Make the check for critical temp valid consistent")
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Link: https://patch.msgid.link/2437056.ElGaqSPkdT@rafael.j.wysocki
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thermal/thermal_hwmon.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/thermal/thermal_hwmon.c b/drivers/thermal/thermal_hwmon.c
index c3ae44659b8170..0e0c4061792cc5 100644
--- a/drivers/thermal/thermal_hwmon.c
+++ b/drivers/thermal/thermal_hwmon.c
@@ -40,6 +40,7 @@ struct thermal_hwmon_temp {
 	struct thermal_zone_device *tz;
 	struct thermal_hwmon_attr temp_input;	/* hwmon sys attr */
 	struct thermal_hwmon_attr temp_crit;	/* hwmon sys attr */
+	bool temp_crit_present;
 };
 
 static LIST_HEAD(thermal_hwmon_list);
@@ -197,6 +198,8 @@ int thermal_add_hwmon_sysfs(struct thermal_zone_device *tz)
 					    &temp->temp_crit.attr);
 		if (result)
 			goto unregister_input;
+
+		temp->temp_crit_present = true;
 	}
 
 	mutex_lock(&thermal_hwmon_list_lock);
@@ -241,7 +244,7 @@ void thermal_remove_hwmon_sysfs(struct thermal_zone_device *tz)
 	}
 
 	device_remove_file(hwmon->device, &temp->temp_input.attr);
-	if (thermal_zone_crit_temp_valid(tz))
+	if (temp->temp_crit_present)
 		device_remove_file(hwmon->device, &temp->temp_crit.attr);
 
 	mutex_lock(&thermal_hwmon_list_lock);
-- 
2.53.0



