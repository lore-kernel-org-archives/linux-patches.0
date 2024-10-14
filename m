Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D4A21AC887;
	Mon, 14 Oct 2024 15:21:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728919261; cv=none; b=vA5rzk0m4ycqztfsyInVEfJv48wkc5RGUtfhkJZzNFjYgQkZ2AL7XoMs8qer0s4M7EOIvqCoAopW3H91i3ZHa3abpv/tOIi97JcRFXLOoZgBOai+v5WYCg70E3/nUCh9bW8YjRkpS9jYZSuU6NEVsBG1FKqlabOg7FnagI0GxN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728919261; c=relaxed/simple;
	bh=csEL9vhWq+vvlMJQ/y4Q7HVTwNoT7gmgGmRcnE1BxpI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dN5E05Gj6XJHshvb0WlMrFIOjvWqBe4KeUDAK4ycETSOPbJlTFowf+2gFsD+1zzD+ShBfmRVMAZX9BcYqmWnMNzT1EwhDw3iRqPC8H2a8C4GlVzYXE7s8nOkpITatTWI53MIrcrPeocV0bRzerqDOT/TRLchoDc80jb5MBjaua8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rAxaPZBX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rAxaPZBX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1EA2C4CECF;
	Mon, 14 Oct 2024 15:21:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728919261;
	bh=csEL9vhWq+vvlMJQ/y4Q7HVTwNoT7gmgGmRcnE1BxpI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rAxaPZBX5RpLf2cvVXd9rgM2EinVBnDv5DUC6nW/Y5TidGFXbihx0NgYbuTqoPbPF
	 KCmwkfIPORShJvkIb0OLeMK7dgx2qaeZl2O14zws83bTl4LUGV28mgWtj6k2SLz8My
	 vyN4imsac8bUoVd2qEtTGk7E8odAH2cZbPRaij+8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hdegoede@redhat.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>
Subject: [PATCH 6.1 531/798] power: supply: hwmon: Fix missing temp1_max_alarm attribute
Date: Mon, 14 Oct 2024 16:18:05 +0200
Message-ID: <20241014141238.851605962@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <hdegoede@redhat.com>

commit e50a57d16f897e45de1112eb6478577b197fab52 upstream.

Temp channel 0 aka temp1 can have a temp1_max_alarm attribute for
power_supply devices which have a POWER_SUPPLY_PROP_TEMP_ALERT_MAX
property.

HWMON_T_MAX_ALARM was missing from power_supply_hwmon_info for
temp channel 0, causing the hwmon temp1_max_alarm attribute to be
missing from such power_supply devices.

Add this to power_supply_hwmon_info to fix this.

Fixes: f1d33ae806ec ("power: supply: remove duplicated argument in power_supply_hwmon_info")
Cc: stable@vger.kernel.org
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20240908185337.103696-2-hdegoede@redhat.com
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/power/supply/power_supply_hwmon.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/power/supply/power_supply_hwmon.c
+++ b/drivers/power/supply/power_supply_hwmon.c
@@ -299,7 +299,8 @@ static const struct hwmon_channel_info *
 			   HWMON_T_INPUT     |
 			   HWMON_T_MAX       |
 			   HWMON_T_MIN       |
-			   HWMON_T_MIN_ALARM,
+			   HWMON_T_MIN_ALARM |
+			   HWMON_T_MAX_ALARM,
 
 			   HWMON_T_LABEL     |
 			   HWMON_T_INPUT     |


