Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FC9F46A5FD;
	Tue, 21 Jul 2026 17:44:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655896; cv=none; b=Yu4Qty8dZPC/PwRR+x2bqNV14k0mVSa8/ytRsaWu1p8qanGGot7Gb4zws5O9FNeBygs2vG94mJwt08B2GvBIS9J5JgrlTKAvTweKwD5zAPQxMpF6PCdStYCVqp2gomL6rVWIVvqlDVU6HbFQs6DWnyMM9aqmKkYH3ATJCbSy8Pc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655896; c=relaxed/simple;
	bh=OtlvJnDrftchIs4h/LKhida6wmdXPd1bsGhpp/PPkyY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tVVXJkZj5GOljpu7S9vL/7Bm/SeXs/h1LcF4TL+GAs8sgwMAHgkuokAzOHgT57CWWy45QgEs5vVoISy2/fk+7PGPwYnIH4B7aYcVQh5kAAvv8o2lEb/B24vFB5A2gu4Qzf1/X3ukPK1uoBR4ZDUJ6o3rbGexsZmZxo7NpkmBBg8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x2nygpYV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x2nygpYV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6CED1F000E9;
	Tue, 21 Jul 2026 17:44:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784655895;
	bh=9HZVaD+VQrRudV6cjqJpUyH5NqscOxul8eSlI+k6ZQc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=x2nygpYVuTD3M/IfP/nkBobhkbSTwYf9+D7hD3dZ9fASRgehCHpXIuwHD8rwMs2r5
	 KizTOkUubh8y//+Mjkt0upeScZdUu5EcsQ61p02R0N37Zm+DB8QQ7KvZMEvY0+q/5J
	 3RHekMZ1miOf45bonhOm0tuM6MWs7EVBAqHplpW0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0145/1611] thermal: hwmon: Fix critical temperature attribute removal
Date: Tue, 21 Jul 2026 17:04:21 +0200
Message-ID: <20260721152518.139254879@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 64cc3ab949fed4..c68b27b2fb0274 100644
--- a/drivers/thermal/thermal_hwmon.c
+++ b/drivers/thermal/thermal_hwmon.c
@@ -40,6 +40,7 @@ struct thermal_hwmon_temp {
 	struct thermal_zone_device *tz;
 	struct thermal_hwmon_attr temp_input;	/* hwmon sys attr */
 	struct thermal_hwmon_attr temp_crit;	/* hwmon sys attr */
+	bool temp_crit_present;
 };
 
 static LIST_HEAD(thermal_hwmon_list);
@@ -191,6 +192,8 @@ int thermal_add_hwmon_sysfs(struct thermal_zone_device *tz)
 					    &temp->temp_crit.attr);
 		if (result)
 			goto unregister_input;
+
+		temp->temp_crit_present = true;
 	}
 
 	mutex_lock(&thermal_hwmon_list_lock);
@@ -235,7 +238,7 @@ void thermal_remove_hwmon_sysfs(struct thermal_zone_device *tz)
 	}
 
 	device_remove_file(hwmon->device, &temp->temp_input.attr);
-	if (thermal_zone_crit_temp_valid(tz))
+	if (temp->temp_crit_present)
 		device_remove_file(hwmon->device, &temp->temp_crit.attr);
 
 	mutex_lock(&thermal_hwmon_list_lock);
-- 
2.53.0



