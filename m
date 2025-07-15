Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA065246BD7;
	Tue, 15 Jul 2025 13:49:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752587377; cv=none; b=V1qX3R2Xo05sK27IlGYoJj29XWubRsxiyCn/V9/YQxbWoe5Nh85Ej3ZERuJ1Zv2DO1oDZZnGSm6RjwA/45H2GKLw3ElXyhT62WLgm1MXGoTbXwqkSrHhqtr+kq8X+8XO+eMPDR2muiWGYF0s+Xe5QqmxEBknDb90ZyhcOB7HPt4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752587377; c=relaxed/simple;
	bh=VlDEua+0El+jkrsYAa+1RzZSy1IJQrlXdC4WSs/Nygs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RlQimbyKLL/q65tFyIxH3TFN4IA/pbd77swlHqp/3vsRLOG+2PKhZcaDJxuYuG2Zyd4AW6EO5/R5OmLnswRRVlNwvVaUmoyoZHRjEqq9wblgAr4/szytiuwq+BOcosQOWFUtYGNTdEDPoQY0iYVtaTHjE05zxRNwI239ZsWXX8Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TxAtKY/m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TxAtKY/m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32692C4CEE3;
	Tue, 15 Jul 2025 13:49:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752587376;
	bh=VlDEua+0El+jkrsYAa+1RzZSy1IJQrlXdC4WSs/Nygs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TxAtKY/mW2feJfgVvfjDUHH3LMWBoSjGLxZJi1V7opeq2SyOy3gsMi/oTNd24jXq5
	 c+ccC0eB9OpFdc3Sb4Cj2T581Sho7SdyO/mJ3ydyAhX1Tnc7LFyp7shXo/a6xCXzOL
	 XegnouXwQP2KFr0i7TK3qvxSXvM88yMbxBOa1m24=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Schwartz <matthew.schwartz@linux.dev>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 6.1 36/88] Revert "ACPI: battery: negate current when discharging"
Date: Tue, 15 Jul 2025 15:14:12 +0200
Message-ID: <20250715130755.972000236@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130754.497128560@linuxfoundation.org>
References: <20250715130754.497128560@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -241,23 +241,10 @@ static int acpi_battery_get_property(str
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


