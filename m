Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BADA1A8F7B;
	Sat, 12 Sep 2026 10:06:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789207562; cv=none; b=VZkIGJAsD9l4dLvPVYhFJLRz3ydipkPD6AssdP4XXwA7Z8QToLshXzIfToHsEMCoH0ASUqEpdJIZBHiY/kBLy3ENnPbVAJ07v/3z0gSn7NRLDcc5SFZBHZAXPxDV9h/ajd+7rtGS6DvB6tPJHCAZrMjHkjIx17ztS6xOEe/kVyU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789207562; c=relaxed/simple;
	bh=0PCkb+TA6OfrAh0sOe8+bczHcJGWpUH7JL3E2FppJns=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YA4U4OgN/yNreK5LtaIpmZHGwqME3nlGcswZTXza6ZIgtMb8TdH3CjQTb8PueuKmL2MDi9pdNcYxPVKvRcupZjtTvOyf8beRHPbe3fvA01XbT8BvUtGB7cT8fKTVz/xOx9DMDUTLu09j4icibnxXvPsGndZx2p5OoZAppfiILDA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1c9rIe3p; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1c9rIe3p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 618D71F000FF;
	Sat, 12 Sep 2026 10:05:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789207560;
	bh=KDyKewZu50bO6fW4mBu+9BNDl+UNA60xKttYXRPmJsE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1c9rIe3pElhQS1P90mg6KECMEDRFqzUCuz9K9MYs682B8VgOL4qYxQxw/+G1xUYal
	 v8czbv7skRWjM/c8fG8vxI4oDSYHUQADdb/Og/rCoELOSwS1Nkfd6U8Dp976t0wNeS
	 629TAj8xGoCnwtxcvaOgsVWY9xnFPLO27Nf2Cq3M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sudeep Holla <sudeep.holla@kernel.org>,
	Huisong Li <lihuisong@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0437/1518] ACPI: processor: idle: Expand _LPI package sanity checks
Date: Sat, 12 Sep 2026 08:43:26 +0200
Message-ID: <20260912065633.334125602@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

[ Upstream commit d5c13047a132162d2649be876906ead691d12948 ]

The _LPI package sanity checks in acpi_processor_evaluate_lpi() miss
a couple of things, so expand them by adding a buffer size check
before retrieving a struct acpi_power_register from it (and skip the
given state if the buffer is not large enough to hold a register
structure) and making the function avoid copying the state description
from the ACPI table if there are too few elements in the package
supposed to hold it.

While at it, relocate and rephrase a comment about skipping _LPI state
package elements [7-8].

Fixes: a36a7fecfe60 ("ACPI / processor_idle: Add support for Low Power Idle(LPI) states")
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Reviewed-by: Sudeep Holla <sudeep.holla@kernel.org>
Acked-by: Huisong Li <lihuisong@huawei.com>
Link: https://patch.msgid.link/5084143.GXAFRqVoOG@rafael.j.wysocki
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/processor_idle.c | 28 +++++++++++++++++++++-------
 1 file changed, 21 insertions(+), 7 deletions(-)

diff --git a/drivers/acpi/processor_idle.c b/drivers/acpi/processor_idle.c
index 2468c1d971e74..99e0a14a6201a 100644
--- a/drivers/acpi/processor_idle.c
+++ b/drivers/acpi/processor_idle.c
@@ -945,6 +945,13 @@ static int acpi_processor_evaluate_lpi(acpi_handle handle,
 		if (obj->type == ACPI_TYPE_BUFFER) {
 			struct acpi_power_register *reg;
 
+			if (obj->buffer.length < sizeof(*reg)) {
+				acpi_handle_debug(handle,
+					"Invalid register data for _LPI state %d\n",
+					state_idx);
+				continue;
+			}
+
 			reg = (struct acpi_power_register *)obj->buffer.pointer;
 			if (reg->space_id != ACPI_ADR_SPACE_SYSTEM_IO &&
 			    reg->space_id != ACPI_ADR_SPACE_FIXED_HARDWARE)
@@ -961,13 +968,6 @@ static int acpi_processor_evaluate_lpi(acpi_handle handle,
 			continue;
 		}
 
-		/* elements[7,8] skipped for now i.e. Residency/Usage counter*/
-
-		obj = pkg_elem + 9;
-		if (obj->type == ACPI_TYPE_STRING)
-			strscpy(lpi_state->desc, obj->string.pointer,
-				ACPI_CX_DESC_LEN);
-
 		lpi_state->index = state_idx;
 		if (obj_get_integer(pkg_elem + 0, &lpi_state->min_residency)) {
 			pr_debug("No min. residency found, assuming 10 us\n");
@@ -990,6 +990,20 @@ static int acpi_processor_evaluate_lpi(acpi_handle handle,
 
 		if (obj_get_integer(pkg_elem + 5, &lpi_state->enable_parent_state))
 			lpi_state->enable_parent_state = 0;
+
+		/* Skip elements [7-8] i.e. Residency/Usage counters. */
+
+		/*
+		 * Avoid out-of-bounds access if the size of the package is less
+		 * than expected.
+		 */
+		if (element->package.count < 10)
+			continue;
+
+		obj = pkg_elem + 9;
+		if (obj->type == ACPI_TYPE_STRING)
+			strscpy(lpi_state->desc, obj->string.pointer,
+				ACPI_CX_DESC_LEN);
 	}
 
 	acpi_handle_debug(handle, "Found %d power states\n", state_idx);
-- 
2.53.0



