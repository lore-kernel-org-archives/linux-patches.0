Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3348824FBFF;
	Mon, 23 Jun 2025 13:35:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750685734; cv=none; b=arQShDSUPyv1CHAwTU7QX9beW7RvYFWG31mx+W5/H1jM/zjukPK6KHUhQ0yT6FmjzlDFgEynaPneRTjS79YCTKuu8SSLZQU2nDC8s9aR3jQZJ4Npemvattk4e9zPGuEvUdp0hzO7rzCd2+bUaQpj5LXU7ZtW093U30kzaJ8pgHg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750685734; c=relaxed/simple;
	bh=34dNVMtLXGlQljIbSiNLr1zymEz06oXqS7ARNtuik5g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=olGKygIXyeWEjy1nt+8fEnb9pLL4N+J47VCVRANALEkXC9wXa4JLkz5IJGSY0BQm/78aH8SyYyUvUd+pklAJvTsOh9jBtK5eQUUgEgxcGWdDpzInCK3fQY8I/y+zBYNRm8lCGHP46QSEyakztlJeHhuiLUcUv09Sj9k1V5EpJGI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wwcEC3hf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wwcEC3hf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7287C4CEEA;
	Mon, 23 Jun 2025 13:35:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750685734;
	bh=34dNVMtLXGlQljIbSiNLr1zymEz06oXqS7ARNtuik5g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wwcEC3hfzmewbj8Kmd6VyeEabnHGtAayG1kGRo2YX3fNv+3IarcHCTNt4QIsWzrft
	 eztghMB0g8/vuc5aHeLhVYSNTSsuTTP3ecxrKZE1FDqGCFIzGsbgp2z+4tgr+pKQ/g
	 CULH5uzw2ZatwI+Bnv+asfFmb7AtcejzIlKsLxGc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Marheine <pmarheine@chromium.org>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 233/592] ACPI: battery: negate current when discharging
Date: Mon, 23 Jun 2025 15:03:11 +0200
Message-ID: <20250623130705.833933504@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Marheine <pmarheine@chromium.org>

[ Upstream commit 234f71555019d308c6bc6f98c78c5551cb8cd56a ]

The ACPI specification requires that battery rate is always positive,
but the kernel ABI for POWER_SUPPLY_PROP_CURRENT_NOW
(Documentation/ABI/testing/sysfs-class-power) specifies that it should
be negative when a battery is discharging. When reporting CURRENT_NOW,
massage the value to match the documented ABI.

This only changes the sign of `current_now` and not `power_now` because
documentation doesn't describe any particular meaning for `power_now` so
leaving `power_now` unchanged is less likely to confuse userspace
unnecessarily, whereas becoming consistent with the documented ABI is
worth potentially confusing clients that read `current_now`.

Signed-off-by: Peter Marheine <pmarheine@chromium.org>
Link: https://patch.msgid.link/20250508024146.1436129-1-pmarheine@chromium.org
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/battery.c | 19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

diff --git a/drivers/acpi/battery.c b/drivers/acpi/battery.c
index 6760330a8af55..93bb1f7d90986 100644
--- a/drivers/acpi/battery.c
+++ b/drivers/acpi/battery.c
@@ -243,10 +243,23 @@ static int acpi_battery_get_property(struct power_supply *psy,
 		break;
 	case POWER_SUPPLY_PROP_CURRENT_NOW:
 	case POWER_SUPPLY_PROP_POWER_NOW:
-		if (battery->rate_now == ACPI_BATTERY_VALUE_UNKNOWN)
+		if (battery->rate_now == ACPI_BATTERY_VALUE_UNKNOWN) {
 			ret = -ENODEV;
-		else
-			val->intval = battery->rate_now * 1000;
+			break;
+		}
+
+		val->intval = battery->rate_now * 1000;
+		/*
+		 * When discharging, the current should be reported as a
+		 * negative number as per the power supply class interface
+		 * definition.
+		 */
+		if (psp == POWER_SUPPLY_PROP_CURRENT_NOW &&
+		    (battery->state & ACPI_BATTERY_STATE_DISCHARGING) &&
+		    acpi_battery_handle_discharging(battery)
+				== POWER_SUPPLY_STATUS_DISCHARGING)
+			val->intval = -val->intval;
+
 		break;
 	case POWER_SUPPLY_PROP_CHARGE_FULL_DESIGN:
 	case POWER_SUPPLY_PROP_ENERGY_FULL_DESIGN:
-- 
2.39.5



