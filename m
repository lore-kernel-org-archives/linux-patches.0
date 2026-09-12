Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57FA047C0F7;
	Sat, 12 Sep 2026 12:20:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789215642; cv=none; b=hMY3zo1s/mvO3rha+V3S6Ioukdo/jgv8jBtor1DWtAIPOnd/Jiw1zmOYmbrWuwR3tknkxADFPoP0ACU/0gA/DjiGwCILzlmTfmLe/Cm8IjzfHyFDg90KpH0C+NQ6VWw/9UZQyvF1LptoM898S4vPHB4/gZFGCRL0CbJZkPPi3ks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789215642; c=relaxed/simple;
	bh=x++HSP0FClkREL6SUxSoI1o+hQblqn8f7iOLh9tJNFo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rvq5yYZnEMFuDJvXHPozHHsQ5GrnuwuCwMIYHlq9mlETJdIcUCQ4ink+X1A+QWKF86ydp8tzjhO0YZMg1XkNDwCtrgamOGBvLHo3X6DvQjFkR8cc9ALx8K07wp7EA2R/gfBbF8ifr8Ggqzy0UsiOY8OvBj5UMhDOarja+qG/ZnQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p/CJ4Rit; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p/CJ4Rit"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE4E51F000FF;
	Sat, 12 Sep 2026 12:20:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789215639;
	bh=FGdTISCib2HzqtIxINfLQeLK6DKwJ4ETT8OCublHUoU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=p/CJ4RitHTjexUdtyAVskKUfvd9C8qPxQYdUny9DIMenYpDdHG1kE0PH1r1V+tcDF
	 itJOp9TATXFILvtLGFPjnL8Xj7jEUvXDfuSW2GJlxcc+b+sJ8srSJzP+KUK+iSWEYg
	 mER5AaYLNqKsmFUxavcmn30r33dpKv4o6sgxafik=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sudeep Holla <sudeep.holla@kernel.org>,
	Huisong Li <lihuisong@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0574/1376] ACPI: processor: idle: Expand _LPI package sanity checks
Date: Sat, 12 Sep 2026 08:50:00 +0200
Message-ID: <20260912065620.322135075@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index b8a8cbf8fafd6..6ecf784cf6b5c 100644
--- a/drivers/acpi/processor_idle.c
+++ b/drivers/acpi/processor_idle.c
@@ -950,6 +950,13 @@ static int acpi_processor_evaluate_lpi(acpi_handle handle,
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
@@ -966,13 +973,6 @@ static int acpi_processor_evaluate_lpi(acpi_handle handle,
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
@@ -995,6 +995,20 @@ static int acpi_processor_evaluate_lpi(acpi_handle handle,
 
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



