Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEB9533FE12
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:49:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772300945; cv=none; b=uahmjrMRCO4pjzf8mog7kG9RDsgGRB51NLtgYT0LBTT/TOsgelAylTB1D/fc7yFfOJK2cYS1OZSudWo/tmqtSm7FbnBGIpP7hXIpQ0xTWA84jbJY8L8KKLZlxoxI6pBb3GjfVdqr185kUtNssgkm8USZebrGeDIng/J4Tggaetw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772300945; c=relaxed/simple;
	bh=V+50dztDbAqm/7fXgq20C1io7D2TwnP/KrkB9weyZH4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BSWaSRShGPSEHIFjDX5Fdgyjup+/xhjH9ucUXPGBWsgwFNZ//HeaKiVbAaxY2V3+HT5XlRxSKh9OUOxpwT0JXxWMaskriPZIcIoJTDqq1aomxZcT65f5iKjeonHq6F6JyYVbujOyD5JhLEfjFxbQvuru4XVIuDCXsBZ/vBMAAo4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Wnb2O1qh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Wnb2O1qh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E10FC19423;
	Sat, 28 Feb 2026 17:49:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772300945;
	bh=V+50dztDbAqm/7fXgq20C1io7D2TwnP/KrkB9weyZH4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Wnb2O1qhBM1F4oeDvKRD/GGRb3oAIFcLGSigkw1Uz5/gKiXtR6zLRQaabWeShFhQ0
	 2sP6KMS3EbrC96eeQRV4XHzKv7lH544cw3OgXjAAjpXQnXWVhL3Gp8LYSSkfRoFoav
	 R5kD3UZ8hfFdy8SFbuBbWPhP9yMj+gTJDYCblnO0RXk5MfrheyTIG28l/5aEGMEy+d
	 WB7SDmLqW0iAEyusGgA4/h43QNWvZR1l/4Ztixr70B6yBR8TDBWrM7WSyUn3ooIxNV
	 Q81KvAdJPt6XoJnlwyHqbwwWI55o8WXDtOCHs0iTcmQTZUynA3LaYF0wXEmVFHUj8f
	 G1Ti6G91981aw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: =?UTF-8?q?Ata=20=C4=B0lhan=20K=C3=B6kt=C3=BCrk?= <atailhan2006@gmail.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 068/752] ACPI: battery: fix incorrect charging status when current is zero
Date: Sat, 28 Feb 2026 12:36:19 -0500
Message-ID: <20260228174750.1542406-68-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Ata İlhan Köktürk <atailhan2006@gmail.com>

[ Upstream commit bb1256e0ddc7e9e406164319769b9f8d8389f056 ]

On some laptops, such as the Huawei Matebook series, the embedded
controller continues to report "Charging" status even when the
charge threshold is reached and no current is being drawn.

This incorrect reporting prevents the system from switching to battery
power profiles, leading to significantly higher power (e.g., 18W instead
of 7W during browsing) and missed remaining battery time estimation.

Validate the "Charging" state by checking if rate_now is zero. If the
hardware reports charging but the current is zero, report "Not Charging"
to user space.

Signed-off-by: Ata İlhan Köktürk <atailhan2006@gmail.com>
[ rjw: Whitespace fix, braces added to an inner if (), new comment rewrite ]
[ rjw: Changelog edits ]
Link: https://patch.msgid.link/20260129144856.43058-1-atailhan2006@gmail.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/battery.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/acpi/battery.c b/drivers/acpi/battery.c
index 67b76492c839c..8196c17b5a970 100644
--- a/drivers/acpi/battery.c
+++ b/drivers/acpi/battery.c
@@ -212,7 +212,14 @@ static int acpi_battery_get_property(struct power_supply *psy,
 		if (battery->state & ACPI_BATTERY_STATE_DISCHARGING)
 			val->intval = acpi_battery_handle_discharging(battery);
 		else if (battery->state & ACPI_BATTERY_STATE_CHARGING)
-			val->intval = POWER_SUPPLY_STATUS_CHARGING;
+			/* Validate the status by checking the current. */
+			if (battery->rate_now != ACPI_BATTERY_VALUE_UNKNOWN &&
+			    battery->rate_now == 0) {
+				/* On charge but no current (0W/0mA). */
+				val->intval = POWER_SUPPLY_STATUS_NOT_CHARGING;
+			} else {
+				val->intval = POWER_SUPPLY_STATUS_CHARGING;
+			}
 		else if (battery->state & ACPI_BATTERY_STATE_CHARGE_LIMITING)
 			val->intval = POWER_SUPPLY_STATUS_NOT_CHARGING;
 		else if (acpi_battery_is_charged(battery))
-- 
2.51.0

