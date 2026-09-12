Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5627357D10;
	Sat, 12 Sep 2026 18:49:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789238947; cv=none; b=oX0tZ6sIleFFUP7cHPKlCePKqjZMX+nN4kb2H9kp5LAacjF8r4NXO/PkAhfAqI7+/cD887et/giv/3HBL3vK6vUvzUgJhbaq6pKVI7wP/4+ZgtO5Hch83imXDiDM7BuRfjMsrf3Dxhb4M+DK20pFoQiNrY82zYUsH1scZPD21lM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789238947; c=relaxed/simple;
	bh=7jqihxzi3z4doTBRSOPcjmD8sZ1b3rPz5v4/tmdZhUs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aXUb6e528RE/drol/ADe44OGknMajsghLa2wVMTiLojUZCOFrjba+lbJSVqRlxroflF/Rts8DLM4/f9fE6Nm3YGpBmXOf6lmKY5tMihxVVChnpQwQUM54+W9lDT55WYk06H8MVOnm4XroFc/FtN8WFd5vOr2WoqMOMcdKLctTRA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qt7DTK2m; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qt7DTK2m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E7DB1F000FF;
	Sat, 12 Sep 2026 18:49:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789238946;
	bh=I+Rcy54dtu+EnC17awCua6hrIzitzn4ee+inzhAuX9o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Qt7DTK2mFjczBod+OzA42k7FRQJjJw83P4soxj3T65EpRw+LL8lUKDGzv6FNmrCdD
	 9+UjLn4JhJUZcKDehIXom3eq8GYD84NAmIhEYjb/Xkt91rf0mgPQ5X64UP5zHZlVJR
	 oRvbGFa4i7bVEUaty9D2JiqvSNz01kDnj+QjlHgk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sudeep Holla <sudeep.holla@kernel.org>,
	Huisong Li <lihuisong@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 538/935] ACPI: processor: idle: Expand _LPI package sanity checks
Date: Sat, 12 Sep 2026 08:59:28 +0200
Message-ID: <20260912065539.161277257@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index bbdca25542666..ce364d317feef 100644
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



