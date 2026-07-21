Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14362415F14;
	Tue, 21 Jul 2026 19:19:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784661562; cv=none; b=YSospBmibw7P2V5QMqxSDBRnRIkLQRm2+bj1v5qJzfcCN/vP+Kys65MJe4DTe2k6plUpb+XABw1S9KaS8u+zqT5KTZyCrDCZhtiZKwOaDX0kyc5lY3dRxGs6PvVGtiaa/gWs6igiAnwqap1v/KW1ZYr2emrMWMprnEnjkHe4x0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784661562; c=relaxed/simple;
	bh=YyZn+46/N71F4UlvLgadq5Q1Z8og5sQop4xwdl8aEVM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S/r9wbZAPXf3RndhGezSOVbqj7iI8R0oAoD4EAaweSLN6m+hPfzs3QcB/L6hgkZcKkav/pAsFB3z9pGxlFDukZK590T0QCC/wUUImsQxV2UCDhGAueCjwjg9/EPRhm89CO32umNwR9pNo4ZgtZVyL3efjzwFOb+ecZ2o4V9q2W0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cqFy1yog; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cqFy1yog"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B34E1F00A3A;
	Tue, 21 Jul 2026 19:19:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784661561;
	bh=FNMcC5UTpV3Ozg19Ip0pm1sPMCMzprH+vNXxBQzBiS8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cqFy1yoglSksVUpT0vj12HFaGwS+gmtjWbbP8hskxfqN1IvULGhPuJJDD/dRWkCqZ
	 /TVM2AzLV+W0NegtNYOrkvlMaXTSRBHA5YZPpIHonG7QP67UWOg6YPhxBrh/oUId3a
	 dOi59B5pAQGO+niVoptGbgIEssKnDXdbXksq5Oo8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0113/1276] thermal: hwmon: Fix critical temperature attribute removal
Date: Tue, 21 Jul 2026 17:09:16 +0200
Message-ID: <20260721152448.627635323@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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
index f0e504fd866aeb..112188c15c30ec 100644
--- a/drivers/thermal/thermal_hwmon.c
+++ b/drivers/thermal/thermal_hwmon.c
@@ -40,6 +40,7 @@ struct thermal_hwmon_temp {
 	struct thermal_zone_device *tz;
 	struct thermal_hwmon_attr temp_input;	/* hwmon sys attr */
 	struct thermal_hwmon_attr temp_crit;	/* hwmon sys attr */
+	bool temp_crit_present;
 };
 
 static LIST_HEAD(thermal_hwmon_list);
@@ -194,6 +195,8 @@ int thermal_add_hwmon_sysfs(struct thermal_zone_device *tz)
 					    &temp->temp_crit.attr);
 		if (result)
 			goto unregister_input;
+
+		temp->temp_crit_present = true;
 	}
 
 	mutex_lock(&thermal_hwmon_list_lock);
@@ -238,7 +241,7 @@ void thermal_remove_hwmon_sysfs(struct thermal_zone_device *tz)
 	}
 
 	device_remove_file(hwmon->device, &temp->temp_input.attr);
-	if (thermal_zone_crit_temp_valid(tz))
+	if (temp->temp_crit_present)
 		device_remove_file(hwmon->device, &temp->temp_crit.attr);
 
 	mutex_lock(&thermal_hwmon_list_lock);
-- 
2.53.0



