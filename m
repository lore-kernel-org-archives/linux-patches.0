Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0394B36828B;
	Sat, 12 Sep 2026 19:49:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789242588; cv=none; b=EqdrQblfdg5nBVIBMPs/I95gcWqbakJxkA/nsMn08/LCOzOkgyHx8snaIvGo0/r1lM3VFZmJbojutWmZP+OXRmyu7/J4gRwqrebS/KbGiLaHG9mZg5ENDDMMUfUArGn5fF4rCnoHKXDoODtV7yCW6vbch9gwgOb7Bp6SbCzwTyA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789242588; c=relaxed/simple;
	bh=X+kG72ne3+KWXdf8LQ3UZD/Ov3E7XRoMBmmDsqbmBzk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ygt/N6/WSXpDgKsYSa0v7iX1dGh8P4H+QiZBwhI0xQKlSF4LI5+csbvT+CGn1eQNSxoCjiEq2HbB4k43bAbSZrAomyLZZ35GgdC261CKV/ZbZC7xamxB1WRzMqdonxGZvRMI/EX0R0Na6eUWQleRfxhTOwmyGQpwDhrs74TOZrM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L/TE1kK3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L/TE1kK3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1229B1F000FF;
	Sat, 12 Sep 2026 19:49:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789242586;
	bh=iAel0/0qcDDQe6+WngrRanxgVTKFaMVG4aqmDKS9Oh4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L/TE1kK3SptaKnyo0+c4CqzKJq6Fd8817ZTT6Og9CJ4PbK5t/o08hqaNzt8i/WadJ
	 sYhrcvNd9nMD2kZdAxe5uP4xhaqKiilgmGbE03Y7u3rrkicPCxNgGl4RYaLY8LZNbh
	 ft71LeY+N1sc4l+zZLm6CDD48hWXCkoGoLW2vlrk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sudeep Holla <sudeep.holla@kernel.org>,
	Huisong Li <lihuisong@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 455/798] ACPI: processor: idle: Expand _LPI package sanity checks
Date: Sat, 12 Sep 2026 09:01:23 +0200
Message-ID: <20260912065527.570933906@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index e6358b1f9ac14..1a5d8d52f11dd 100644
--- a/drivers/acpi/processor_idle.c
+++ b/drivers/acpi/processor_idle.c
@@ -948,6 +948,13 @@ static int acpi_processor_evaluate_lpi(acpi_handle handle,
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
@@ -964,13 +971,6 @@ static int acpi_processor_evaluate_lpi(acpi_handle handle,
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
@@ -993,6 +993,20 @@ static int acpi_processor_evaluate_lpi(acpi_handle handle,
 
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



