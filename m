Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5B211C57B1;
	Tue, 15 Oct 2024 12:01:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728993714; cv=none; b=nU1Qotvqi2ZT+zM4OX6MXu8KHdt5h5lr9udOTJ6sa+PFI8cN2+dI9V0z+H4ZWyErkYWNt2kndDfGyx59JYyIGY6Q9zk7we4gtgqUkcy8gQt58gKSYd32GcTiCm2tHdDtmTVCE/A9di7LB7nv1W4KkEdgdlMZMdOtMEStJvX6PZs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728993714; c=relaxed/simple;
	bh=B5ztk8n7MiNAjFmgbBiCIAoOXxYUBz3kLcI34n4bMoY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oG43vDlnDy8ervbYT35xeEHKxddxl70v+n1D5/e7fOqAhEZVXM5Wq2hT2g0ujcaJMU0wqnFQtbhJAAUGjH9Khe+VgcdGBoorKHs9gqZEW4hMM6J/d9ym4hkeskhyHLPvqZnvZtXMPmH9DnVNfm5q9aGDx1wOOYPRTwt8F3ackDA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w2sZ0e/S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w2sZ0e/S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CB81C4CEC6;
	Tue, 15 Oct 2024 12:01:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728993714;
	bh=B5ztk8n7MiNAjFmgbBiCIAoOXxYUBz3kLcI34n4bMoY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w2sZ0e/SCVcIfIHMH3ENcTAlGb8Zh7+ftYlbPXrq4BRsAsGZjVSWBwhcX+sxZPxIh
	 lJMYlaiQVh2TGknZyRLtKLu/+x3sr5kf7AhDRoZ0ZZGWIYsCYI63QLnf8271g0nGAx
	 0EEaiq9KYCkUi9lkMfk+0TBEpWRwDQ9ENKbn8w1c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hdegoede@redhat.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>
Subject: [PATCH 5.15 494/691] power: supply: hwmon: Fix missing temp1_max_alarm attribute
Date: Tue, 15 Oct 2024 13:27:22 +0200
Message-ID: <20241015112459.950017083@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


