Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FCD81DED60;
	Tue,  8 Oct 2024 12:57:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728392265; cv=none; b=HjofCGYDnuq25AzFewis1dF7f6iN2RSehc4Hk59RyG1kqVhZsq6dY/BURxHl9fIaWIHgQqQHIK9kIVxMISon5xfUEe1c22+3fAtYzNHFTX4BEVK36Y2AuFv0vYWCIWo5eEprnB31kFNrUaYwL8v92piowX+pxdS/roo9ElLGZzw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728392265; c=relaxed/simple;
	bh=SsqLOCF1c4Jkt5i37cymNIexji/3pyVh9be3C/6klgs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e0DLLjv1kxkNKcbK09bjnEDQfqXeFyvZ5hSM7secGQR0Wo7gfK+SWrtNU6kLCjNV5XdsXgDdBtaJroM8tJ6RdmessCIX8w1KF2eq83pPYV+DBLEX5h3UlK+tTr9Rzxsi09yJKII/7iUihDdzdM/cnboyyARg6nZ2tYw3gsc9qag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DltwGjxm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DltwGjxm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CD50C4CEC7;
	Tue,  8 Oct 2024 12:57:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728392265;
	bh=SsqLOCF1c4Jkt5i37cymNIexji/3pyVh9be3C/6klgs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DltwGjxm50WwfxiZ3WzLTuDoaIFSfEm3rWOmyzNJSYbTQJuLzpF4qB04J8RCmfMLu
	 phozOY/nlcYU5UEuD0sJMAFeCl46S5I+h+y79YcUd6tfE66CS+J3H/au9i8NzW8S3P
	 tokM1QVmK3WgPbFtT1PMC6ZTEUc8J1GdYsZxiWGI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hdegoede@redhat.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>
Subject: [PATCH 6.11 364/558] power: supply: hwmon: Fix missing temp1_max_alarm attribute
Date: Tue,  8 Oct 2024 14:06:34 +0200
Message-ID: <20241008115716.621778461@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
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
@@ -318,7 +318,8 @@ static const struct hwmon_channel_info *
 			   HWMON_T_INPUT     |
 			   HWMON_T_MAX       |
 			   HWMON_T_MIN       |
-			   HWMON_T_MIN_ALARM,
+			   HWMON_T_MIN_ALARM |
+			   HWMON_T_MAX_ALARM,
 
 			   HWMON_T_LABEL     |
 			   HWMON_T_INPUT     |


