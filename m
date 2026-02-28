Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D59733F38A
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:52:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301163; cv=none; b=kmZmQOLr2vEL+Pcc3S9zP7ai+RlBHJLcwPvboPnbBXfg5RisGnsli5F9AYMj54fPnyRYPCwsngjoN/u0Kq/L/ioov/yd1vxUq4HgfEUmJai5WE6sEyJ3DpfVEwYYXqZ2BaFa3BZYWrbQo+QwLMEu9umSo8yf117aolSeeFHePso=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301163; c=relaxed/simple;
	bh=8zAMf0U81YEL1qf39ogZMH308pvSfd9zxfu9uVwtPU8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jl6zExA2zJp+ALbMBZW8I6l9TSJYsn7kDSWYiccMcDeoefkdpE6J6bZER8fVz2umhANI1njavzyC9tAsP76rNOUa96VB9O0uT+mhvd2fqx/fwpkR6jpesJYOA15jSHrO8Mq8cV2bTxQCl/aOZraHOvesl3eR/V9Nx3nBdrMYqRs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ngAQp3XH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ngAQp3XH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C39BC116D0;
	Sat, 28 Feb 2026 17:52:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301163;
	bh=8zAMf0U81YEL1qf39ogZMH308pvSfd9zxfu9uVwtPU8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ngAQp3XHlX9SZbyFvRmFBb+q2Pq9bko6l+j7lH6ylHMP3+M7Q1mlQ0PXM58HRQ9m1
	 YQoRF4IwAy2mzr2bl+u5CioJXYVqnVtgRXvSQQ71Kwhgey6eHpLAbb3umzUT9lOiow
	 8vcBO/goljb6GHXTWRoTw2/Io+KfGTxcx0y1Uj55ShRm7w4J0aDyKgnM1EfmSdlV2c
	 bU9g/KnQ6nQvHmRq8mQ33VFUPw3Kxh+xFZDKs6/QaWxDfFQXnW3A0gMrF/nfN0DOmS
	 xknmQMifUpDekf88kuDyerRVv9Oh6nwef6USvDc2pIgGM/Jk1bgw/Jqo2ujzIZ4ftx
	 RU0TQob7/418g==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Benson Leung <bleung@chromium.org>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 328/752] usb: typec: ucsi: psy: Fix voltage and current max for non-Fixed PDOs
Date: Sat, 28 Feb 2026 12:40:39 -0500
Message-ID: <20260228174750.1542406-328-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Benson Leung <bleung@chromium.org>

[ Upstream commit 6811e0a08bdce6b2767414caf17fda24c2e4e032 ]

ucsi_psy_get_voltage_max and ucsi_psy_get_current_max are calculated
using whichever pdo is in the last position of the src_pdos array, presuming
it to be a fixed pdo, so the pdo_fixed_voltage or pdo_max_current
helpers are used on that last pdo.

However, non-Fixed PDOs such as Battery PDOs, Augmented PDOs (used for AVS and
for PPS) may exist, and are always at the end of the array if they do.
In the event one of these more advanced chargers are attached the helpers for
fixed return mangled values.

Here's an example case of a Google Pixel Flex Dual Port 67W USB-C Fast Charger
with PPS support:
POWER_SUPPLY_NAME=ucsi-source-psy-cros_ec_ucsi.4.auto2
POWER_SUPPLY_TYPE=USB
POWER_SUPPLY_CHARGE_TYPE=Standard
POWER_SUPPLY_USB_TYPE=C [PD] PD_PPS PD_DRP
POWER_SUPPLY_ONLINE=1
POWER_SUPPLY_VOLTAGE_MIN=5000000
POWER_SUPPLY_VOLTAGE_MAX=13400000
POWER_SUPPLY_VOLTAGE_NOW=20000000
POWER_SUPPLY_CURRENT_MAX=5790000
POWER_SUPPLY_CURRENT_NOW=3250000

Voltage Max is reading as 13.4V, but that's an incorrect decode of the PPS
APDO in the last position. Same goes for CURRENT_MAX. 5.79A is incorrect.

Instead, enumerate through the src_pdos and filter just for Fixed PDOs for
now, and find the one with the highest voltage and current respectively.

After, from the same charger:
POWER_SUPPLY_NAME=ucsi-source-psy-cros_ec_ucsi.4.auto2
POWER_SUPPLY_TYPE=USB
POWER_SUPPLY_CHARGE_TYPE=Standard
POWER_SUPPLY_USB_TYPE=C [PD] PD_PPS PD_DRP
POWER_SUPPLY_ONLINE=1
POWER_SUPPLY_VOLTAGE_MIN=5000000
POWER_SUPPLY_VOLTAGE_MAX=20000000
POWER_SUPPLY_VOLTAGE_NOW=20000000
POWER_SUPPLY_CURRENT_MAX=4000000
POWER_SUPPLY_CURRENT_NOW=3250000

Signed-off-by: Benson Leung <bleung@chromium.org>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://patch.msgid.link/20251208174918.289394-3-bleung@chromium.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/typec/ucsi/psy.c | 30 ++++++++++++++++++++----------
 1 file changed, 20 insertions(+), 10 deletions(-)

diff --git a/drivers/usb/typec/ucsi/psy.c b/drivers/usb/typec/ucsi/psy.c
index 8ae900c8c1321..525c6fc2217da 100644
--- a/drivers/usb/typec/ucsi/psy.c
+++ b/drivers/usb/typec/ucsi/psy.c
@@ -88,15 +88,20 @@ static int ucsi_psy_get_voltage_max(struct ucsi_connector *con,
 				    union power_supply_propval *val)
 {
 	u32 pdo;
+	int max_voltage = 0;
 
 	switch (UCSI_CONSTAT(con, PWR_OPMODE)) {
 	case UCSI_CONSTAT_PWR_OPMODE_PD:
-		if (con->num_pdos > 0) {
-			pdo = con->src_pdos[con->num_pdos - 1];
-			val->intval = pdo_fixed_voltage(pdo) * 1000;
-		} else {
-			val->intval = 0;
+		for (int i = 0; i < con->num_pdos; i++) {
+			int pdo_voltage = 0;
+
+			pdo = con->src_pdos[i];
+			if (pdo_type(pdo) == PDO_TYPE_FIXED)
+				pdo_voltage = pdo_fixed_voltage(pdo) * 1000;
+			max_voltage = (pdo_voltage > max_voltage) ? pdo_voltage
+								  : max_voltage;
 		}
+		val->intval = max_voltage;
 		break;
 	case UCSI_CONSTAT_PWR_OPMODE_TYPEC3_0:
 	case UCSI_CONSTAT_PWR_OPMODE_TYPEC1_5:
@@ -144,6 +149,7 @@ static int ucsi_psy_get_current_max(struct ucsi_connector *con,
 				    union power_supply_propval *val)
 {
 	u32 pdo;
+	int max_current = 0;
 
 	if (!UCSI_CONSTAT(con, CONNECTED)) {
 		val->intval = 0;
@@ -152,12 +158,16 @@ static int ucsi_psy_get_current_max(struct ucsi_connector *con,
 
 	switch (UCSI_CONSTAT(con, PWR_OPMODE)) {
 	case UCSI_CONSTAT_PWR_OPMODE_PD:
-		if (con->num_pdos > 0) {
-			pdo = con->src_pdos[con->num_pdos - 1];
-			val->intval = pdo_max_current(pdo) * 1000;
-		} else {
-			val->intval = 0;
+		for (int i = 0; i < con->num_pdos; i++) {
+			int pdo_current = 0;
+
+			pdo = con->src_pdos[i];
+			if (pdo_type(pdo) == PDO_TYPE_FIXED)
+				pdo_current = pdo_max_current(pdo) * 1000;
+			max_current = (pdo_current > max_current) ? pdo_current
+								  : max_current;
 		}
+		val->intval = max_current;
 		break;
 	case UCSI_CONSTAT_PWR_OPMODE_TYPEC1_5:
 		val->intval = UCSI_TYPEC_1_5_CURRENT * 1000;
-- 
2.51.0

