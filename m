Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD80E43C7B1;
	Tue, 21 Jul 2026 22:03:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784671409; cv=none; b=h2pJVGGDpXFmVgi1aXjraB4ua5mKZjdFkfAL59ifQOB3Gk8cY+Rv8C0ny8vbChHcpFdiA1GNpaLF9/22Uhq98zhdf1hoonST/7ckqTvQR5DlhkTdYs8TlR4udrgas2sMN4a59464Z1K1A0dMt4LS7JVB+mRv0OGFmF1ou2LRIm4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784671409; c=relaxed/simple;
	bh=V0K20Wj7iGPTNnkX83PC+2U69D1pxDxjKfd06iUsvDs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AfZzxTpxg/vewca41Y4Boxu/T4P7JHUbs1ezg/R3dXqE42k9ZglndCF2/nujZdLQv26S3+fKTbJ92REOK7QTDhRSQ+0cpwKZ7DPpox7txfZJq9NoKV1WwuM3KFiH3DNw1mYl/55POCiGNXmGdXJnUaMzXCyC+yfSXH0ymoSGxf4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SzrxTBaw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SzrxTBaw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DEF51F00A3D;
	Tue, 21 Jul 2026 22:03:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784671408;
	bh=zCGxmWG3QzmfzDQKWmSRAHKIcUUbtil1fPvpFdVRZNg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SzrxTBaw//aDiRx7pWXBU71/Voej5SE3JjK2ZZuBh20l8KCWYa46OjDBdNzekfFxx
	 si2a11wULatd4jyjeLXXVsFAsueY7kMBAJDMBszgKr1DjYh4olMP8mxai0EnO8J3cf
	 QCzYs4bzMBfQrAqZmzSdRQR21vtrRvLTsyuZwmXk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 236/843] thermal: hwmon: Fix critical temperature attribute removal
Date: Tue, 21 Jul 2026 17:17:51 +0200
Message-ID: <20260721152411.325344388@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index ad03262cca5692..131c1cf6ab9cad 100644
--- a/drivers/thermal/thermal_hwmon.c
+++ b/drivers/thermal/thermal_hwmon.c
@@ -39,6 +39,7 @@ struct thermal_hwmon_temp {
 	struct thermal_zone_device *tz;
 	struct thermal_hwmon_attr temp_input;	/* hwmon sys attr */
 	struct thermal_hwmon_attr temp_crit;	/* hwmon sys attr */
+	bool temp_crit_present;
 };
 
 static LIST_HEAD(thermal_hwmon_list);
@@ -188,6 +189,8 @@ int thermal_add_hwmon_sysfs(struct thermal_zone_device *tz)
 					    &temp->temp_crit.attr);
 		if (result)
 			goto unregister_input;
+
+		temp->temp_crit_present = true;
 	}
 
 	mutex_lock(&thermal_hwmon_list_lock);
@@ -232,7 +235,7 @@ void thermal_remove_hwmon_sysfs(struct thermal_zone_device *tz)
 	}
 
 	device_remove_file(hwmon->device, &temp->temp_input.attr);
-	if (thermal_zone_crit_temp_valid(tz))
+	if (temp->temp_crit_present)
 		device_remove_file(hwmon->device, &temp->temp_crit.attr);
 
 	mutex_lock(&thermal_hwmon_list_lock);
-- 
2.53.0



