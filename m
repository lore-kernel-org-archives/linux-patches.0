Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DF6A1DE3AE;
	Tue,  8 Oct 2024 12:28:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728390496; cv=none; b=dDjMt/g7Yo6baF7RjMNfj9hRhsYUBqL+Qa5W6CqoKyuNPm+Eas9YUWgfGleP+Xsx/fZFJB21ifAiXBb+X6bN9+4OqzZDD/YzuXhGaVSPMdsi2oxOaT1LdFceZERdCd69Li3Ta64wvpTooHROH/ymRLBuUDqbonHTJTa0wmJggXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728390496; c=relaxed/simple;
	bh=gzueCPlRjqTcB5Ada1PS5YK9y1MyYJrPUX6BPfGz9OE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CK/DeXAJCN57jgQZe4O3o18dOLmG+2L7xomPWhHVXrJI9A9t169e2+PcxH43DWXEvEIaTPFRg3ai9LlQ85hXW8+d7L0xZq6zT4fQCb1+bM2vgAY62ZinpCMJ8jf6u8oKwWAVNOFV7b+CNS+LEtKN/b+gsR4lewj41XYh2Td7njo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fO/tG8z6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fO/tG8z6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 887EAC4CEC7;
	Tue,  8 Oct 2024 12:28:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728390495;
	bh=gzueCPlRjqTcB5Ada1PS5YK9y1MyYJrPUX6BPfGz9OE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fO/tG8z6YNhBaTtpkFFYY0m7rLpk2EmwVwxAddlXSa3zIxtQ4eTMz2WOX9ZOi0UuW
	 TjVKbmrUQ+skHG1ZbVa+BaDiAxEg2Htdz7AEPtVfD4G8UlioYkFysUpNRIVzf1hezZ
	 7QumlJK0rPdhKkZOs3CKH7BQUmqfNTjvP7rTbGs0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hdegoede@redhat.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>
Subject: [PATCH 6.10 307/482] power: supply: hwmon: Fix missing temp1_max_alarm attribute
Date: Tue,  8 Oct 2024 14:06:10 +0200
Message-ID: <20241008115700.516159384@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115648.280954295@linuxfoundation.org>
References: <20241008115648.280954295@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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


