Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38F671DF272;
	Tue,  8 Oct 2024 13:21:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728393670; cv=none; b=BswPsh/duWDoAKl3crFZ8iP/xfv6iYfSaSSBtogbpjB05/6MaHIlAMYuHu8LFkSzDcEA0qMRGOvP8rhsAII9YN0O0S0C9ykHyLfo8KuByHgBQN90ZLuUNgCniEnGYy0csTeialEcKi83NOIY/3g47LKo73nrzjEuYwBfYeSBM3Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728393670; c=relaxed/simple;
	bh=dlWOYLuZ1nNlrUmq8nhz4UuNAZtPazbpxI/6neD3VPU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NoLrOGB0i5GrauafTL7bfcNvWoqDcmaBRpBg+v3o2sD3CEb4ECUkI8v4KjIhf0wGqfbu2jScp6NuUA8/DwFC+FxGaaCRz/eRhVXml8xiyl/e8wOOa8HvQOYm72Ohyo5gEgpoPvzJU5g+9I5+d87F1m7S3LtBy0JO52f32l5k/aY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HsBE1c6l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HsBE1c6l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43D09C4CEC7;
	Tue,  8 Oct 2024 13:21:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728393669;
	bh=dlWOYLuZ1nNlrUmq8nhz4UuNAZtPazbpxI/6neD3VPU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HsBE1c6lvTN4Eo3uFXf52WzDizpOamAvMk4nqWCS3CXUlPifTVTG6k+iBWKIpAGfP
	 4OShiQ6t9+2f7nU9vsGk59rW0YWb0imsOOzfdHa9cbm31x7hZ+0NJm0Wn8T4qgJgrm
	 +rddzKWzsyi8AqixE99Fe4X/lkUg9lc5rACgjIQY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hdegoede@redhat.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>
Subject: [PATCH 6.6 219/386] power: supply: hwmon: Fix missing temp1_max_alarm attribute
Date: Tue,  8 Oct 2024 14:07:44 +0200
Message-ID: <20241008115638.025674764@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115629.309157387@linuxfoundation.org>
References: <20241008115629.309157387@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


