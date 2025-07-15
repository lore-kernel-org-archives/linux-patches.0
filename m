Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A2BB2D6419;
	Tue, 15 Jul 2025 13:24:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752585899; cv=none; b=ljSZei0l77rw9EV64VjXSJ9qOisd9gDLJ47FAU1m0Dh4/aDaN8B2jfRKCEML1GwY1CztQaaqgoi9gM4KQAI1IFQ+bsTdBCaLTUGj0JyGPkKxJL5OIoSSB4VsNQad9twqWW0J9V+ahlIA9rfZVXzXgSyKB3z3tZBp1jDfYED3GEo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752585899; c=relaxed/simple;
	bh=ncbBdfLMk9PxPYWKbOboTVCazMPh/6cuRpF93sdgO1k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jBKYtCfn8PBDrqL2jxdGxj7gk6phOoOMmW3FAsduANMQbp30rt6a/nvCdGvrfx7+3cPVzbOK+j/eShoany2LbXoqkZn5PkRXQEx4Clz3py7fIfPDVpWQde2ZV8TBoXqtX0lUrc1EvXZUGhOx4E0YTtOtxr+iyHmCUVGSpOQxht0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q/JeXfcb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q/JeXfcb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2815C4CEE3;
	Tue, 15 Jul 2025 13:24:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752585899;
	bh=ncbBdfLMk9PxPYWKbOboTVCazMPh/6cuRpF93sdgO1k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q/JeXfcbrnMOQF2ML9lz0uOZ6Uc6JxUv6wbcnxfcbCGOFvKfLDoKCVCFodF4ljJa9
	 UtRxhuFbOq/ffByQBWMScyTqIc6jw5n0JnCKR3eAJQAErjWSTX2rqoXbo8XrhJv5dM
	 S3lrRAOstkcKwpY0DbLXbm7wc80G3FqWRGXH/z6g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Schwartz <matthew.schwartz@linux.dev>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 6.6 050/109] Revert "ACPI: battery: negate current when discharging"
Date: Tue, 15 Jul 2025 15:13:06 +0200
Message-ID: <20250715130800.878229913@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130758.864940641@linuxfoundation.org>
References: <20250715130758.864940641@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

commit de1675de39aa945bad5937d1fde4df3682670639 upstream.

Revert commit 234f71555019 ("ACPI: battery: negate current when
discharging") breaks not one but several userspace implementations
of battery monitoring: Steam and MangoHud. Perhaps it breaks more,
but those are the two that have been tested.

Reported-by: Matthew Schwartz <matthew.schwartz@linux.dev>
Closes: https://lore.kernel.org/linux-acpi/87C1B2AF-D430-4568-B620-14B941A8ABA4@linux.dev/
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/acpi/battery.c |   19 +++----------------
 1 file changed, 3 insertions(+), 16 deletions(-)

--- a/drivers/acpi/battery.c
+++ b/drivers/acpi/battery.c
@@ -243,23 +243,10 @@ static int acpi_battery_get_property(str
 		break;
 	case POWER_SUPPLY_PROP_CURRENT_NOW:
 	case POWER_SUPPLY_PROP_POWER_NOW:
-		if (battery->rate_now == ACPI_BATTERY_VALUE_UNKNOWN) {
+		if (battery->rate_now == ACPI_BATTERY_VALUE_UNKNOWN)
 			ret = -ENODEV;
-			break;
-		}
-
-		val->intval = battery->rate_now * 1000;
-		/*
-		 * When discharging, the current should be reported as a
-		 * negative number as per the power supply class interface
-		 * definition.
-		 */
-		if (psp == POWER_SUPPLY_PROP_CURRENT_NOW &&
-		    (battery->state & ACPI_BATTERY_STATE_DISCHARGING) &&
-		    acpi_battery_handle_discharging(battery)
-				== POWER_SUPPLY_STATUS_DISCHARGING)
-			val->intval = -val->intval;
-
+		else
+			val->intval = battery->rate_now * 1000;
 		break;
 	case POWER_SUPPLY_PROP_CHARGE_FULL_DESIGN:
 	case POWER_SUPPLY_PROP_ENERGY_FULL_DESIGN:


