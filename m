Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FB23313520;
	Thu, 19 Feb 2026 02:05:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771466712; cv=none; b=IORq1o+tPNy5DQmQclxPKNwVDTd7CueO8rQCVFKV8DlX/SlAdJvf50XRJYWpSfWDNtTLoQ0PfAVCtPtMFxoT4WYLsKJG4KkKdIyqmDrPHhFjecqTbTPRHLku63HiSdCIe828KrR4fqdHogJA3lmCEaRJ2MbX+BGc1NFQhIR1yls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771466712; c=relaxed/simple;
	bh=O+lPbIZzEqcSqchPlf286g22Iuka4T+9cTuDFGxbZWQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gu3YyrXnIEcM+/xv3TJMa+AYkjNSOS6R87jywEB8SBTeFeiEBF1RwE20L7OkCWxiiBpxdzyqfydAXXs4umYN9r9RKZlrAW4MIHaJipnV66ZVWNSxl8MPC50SpO3kzFWgEJy3mGk0DWEp7km19QPdtdBPaGbWGOTdrv2yQndwMEU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KaYiiSAR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KaYiiSAR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E402C116D0;
	Thu, 19 Feb 2026 02:05:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771466712;
	bh=O+lPbIZzEqcSqchPlf286g22Iuka4T+9cTuDFGxbZWQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KaYiiSAR0wf3J9bbdNyS5+Pfi7BmN5oru9tL+sAgvhwQpJqIzfLBaF3YKGBtIpCRL
	 mLgxXya+Tem7pdsAn3nHB84WEtt4VxHaue+ixLvz4zscGCyGNoo9W0vHoQN9dm8Wth
	 /qu71mNkEIkVGU1LbTAYj+zszza0ogjAElTB2QWNvpCSptZ9Enb7Vhso9D0waYlSy9
	 i7cdSPI4JPUkj48Mt+UTw6agRw6Pg30bBJLsGnn8C130jhbOnS/A+w8sl5amYXqNXo
	 F1Z3TKKQV3razVgycx5h4rL9Z1tG3vUJUPo95RqJQqKL4D6OoZpbbObpHZsuaf7X3H
	 Sg729YJEnh6sw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Benson Leung <bleung@chromium.org>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>,
	linux-usb@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.19-6.1] usb: typec: ucsi: psy: Fix voltage and current max for non-Fixed PDOs
Date: Wed, 18 Feb 2026 21:04:14 -0500
Message-ID: <20260219020422.1539798-38-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260219020422.1539798-1-sashal@kernel.org>
References: <20260219020422.1539798-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19.2
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

LLM Generated explanations, may be completely bogus:

This confirms the bug mechanism: `pdo_fixed_voltage()` and
`pdo_max_current()` extract specific bit fields from a PDO. When a non-
Fixed PDO (like an APDO for PPS) is passed to these functions, the bit
fields have completely different meanings, leading to garbage values
being reported.

### Bug Assessment

**What the bug is:** When a USB PD charger advertises non-Fixed PDOs
(Battery, PPS/AVS APDOs), the UCSI power supply driver incorrectly
applies Fixed PDO bit-extraction helpers to these non-Fixed PDOs,
resulting in wrong voltage_max and current_max values reported to
userspace.

**Who is affected:** Any USB Type-C user connected to a PPS or AVS
charger. This is increasingly common with modern fast chargers (the
example is a Google Pixel charger). The incorrect values are exposed via
the power supply sysfs interface and could confuse userspace power
management tools or battery monitoring.

**The fix:** Instead of blindly using the last PDO, iterate through all
PDOs and only consider Fixed type PDOs, finding the maximum voltage and
current among them. This is correct because Fixed PDOs are always
present per the USB PD spec and represent the baseline capabilities.

### Risk Assessment

**Low risk:**
- The change is small and contained (two functions modified in one file)
- The logic is straightforward: loop over PDOs, filter by type, find max
- It only changes behavior for the PD case and only when non-Fixed PDOs
  are present
- Reviewed by Heikki Krogerus (the UCSI maintainer)
- Committed by Greg KH (USB maintainer)

**Correctness considerations:**
- The new code correctly handles `num_pdos == 0`
  (max_voltage/max_current stays 0)
- The type check `pdo_type(pdo) == PDO_TYPE_FIXED` correctly filters out
  Battery, Variable, and APDO types
- Using max() logic to find the highest fixed voltage/current is correct
  per USB PD spec where fixed PDOs increase in voltage

### Stable Kernel Criteria

1. **Obviously correct and tested:** Yes - clear logic, tested with real
   hardware (Google Pixel charger), reviewed by subsystem maintainer
2. **Fixes a real bug:** Yes - incorrect power supply values reported to
   userspace
3. **Important issue:** Moderate - incorrect power data can confuse
   userspace charging tools; not a crash but a data correctness issue
   affecting real hardware
4. **Small and contained:** Yes - about 30 lines changed in a single
   file
5. **No new features:** Correct - this only fixes the calculation logic
6. **Applies cleanly:** Likely needs checking against specific stable
   trees, but the file has been stable

### Verification

- `git log --follow --diff-filter=A -- drivers/usb/typec/ucsi/psy.c`
  confirmed the file was added in commit 992a60ed0d5e3 (v5.8 timeframe),
  present in all active stable trees
- Read `include/linux/usb/pd.h:337-355` confirmed `pdo_fixed_voltage()`
  and `pdo_max_current()` extract Fixed PDO-specific bit fields that
  produce garbage for non-Fixed PDO types
- Read the current `psy.c` and confirmed the buggy code at lines 118-123
  (voltage_max) and 179-184 (current_max) uses
  `con->src_pdos[con->num_pdos - 1]` which could be a non-Fixed PDO
- The `pdo_type()` function at line 332 of pd.h confirms the fix's type-
  checking approach is correct
- Reviewed-by from Heikki Krogerus (UCSI maintainer) and committed by
  Greg KH (USB maintainer) verified in commit message
- `git log` on the file shows 11 prior commits, indicating a mature and
  actively maintained file

**YES**

 drivers/usb/typec/ucsi/psy.c | 30 ++++++++++++++++++++----------
 1 file changed, 20 insertions(+), 10 deletions(-)

diff --git a/drivers/usb/typec/ucsi/psy.c b/drivers/usb/typec/ucsi/psy.c
index 3abe9370ffaaf..62160c4191718 100644
--- a/drivers/usb/typec/ucsi/psy.c
+++ b/drivers/usb/typec/ucsi/psy.c
@@ -112,15 +112,20 @@ static int ucsi_psy_get_voltage_max(struct ucsi_connector *con,
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
@@ -168,6 +173,7 @@ static int ucsi_psy_get_current_max(struct ucsi_connector *con,
 				    union power_supply_propval *val)
 {
 	u32 pdo;
+	int max_current = 0;
 
 	if (!UCSI_CONSTAT(con, CONNECTED)) {
 		val->intval = 0;
@@ -176,12 +182,16 @@ static int ucsi_psy_get_current_max(struct ucsi_connector *con,
 
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

