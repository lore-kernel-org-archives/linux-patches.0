Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A95633FE26
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:48:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772300937; cv=none; b=rJR+IsiWXtDBvuqD7VTLGOA+MTbD9V107bQ34N+HTeE/ndK1Z0r3BeeYoXLUvzve6EU5NvcrfJLz3Z8UjcmUF6w+zyEOAZUsBE0S5Xs8+P5bN4NcesXn/nhOOv55Tu2CsRDD+C8G/vm8kAnEbNsIwXj9TxIFmJ21XheLLHjboV8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772300937; c=relaxed/simple;
	bh=BrE/nUq19xa+JatKpg2di0H3+n6ik0XyUYvDeY1PfEU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bEL1g52RDwO9fOjtmeRYRFYzgKpkqQj2zSROl3JH8xcpHhNopep6TyzOsa81q0gxPOeefWv91bde8KiHeHGIqDbXqRlenFgOK4GFIRRlC4L+wzwUEpFqdFxrTIt9Z5PKvF7iURY5xF88as0FxbsA/YmNAWutkMg0T/flw2x9uC0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TYkCOSZp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TYkCOSZp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BD07C116D0;
	Sat, 28 Feb 2026 17:48:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772300937;
	bh=BrE/nUq19xa+JatKpg2di0H3+n6ik0XyUYvDeY1PfEU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TYkCOSZp5GBUwNEmRYM5tX6cTzBUetBKy0xf1B8ZoF1T/9U5tk7EobgdCINHwx+pS
	 /1mew2c+zE5X7TVjPE86pYDBnQbRYpX7K7u9uIsW4KWt+tdOgD5bC7ZyI2Yo/LD0fW
	 GzSs35irzQCgBZkJl+vBkjVIOZfFycGhi8lIfnFFWFVeXnz4S2+jK32+VlDvvYUxCl
	 D65+67sc2g5BYneQtmpZmLsjaniJhy01BjMP4ExxbDehkfYMrbfTFdErtqrDxqgtjB
	 V3aB0zoRCTY8r985OYL7P+59JXbIPrC2j7u/znTnSgpr89xMTbNb+5vaSLgltH2GbO
	 lFBU5GPZf5Q8Q==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Armin Wolf <W_Armin@gmx.de>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 057/752] ACPICA: Abort AML bytecode execution when executing AML_FATAL_OP
Date: Sat, 28 Feb 2026 12:36:08 -0500
Message-ID: <20260228174750.1542406-57-sashal@kernel.org>
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

From: Armin Wolf <W_Armin@gmx.de>

[ Upstream commit 026ad376a6a48538b576f3589331daa94daae6f0 ]

The ACPI specification states that when executing AML_FATAL_OP,
the OS should log the fatal error event and shutdown in a timely
fashion.

Windows complies with this requirement by immediatly entering a
Bso_d, effectively aborting the execution of the AML bytecode in
question.

ACPICA however might continue with the AML bytecode execution
should acpi_os_signal() simply return AE_OK. This will cause issues
because ACPI BIOS implementations might assume that the Fatal()
operator does not return.

Fix this by aborting the AML bytecode execution in such a case
by returning AE_ERROR. Also turn struct acpi_signal_fatal_info into a
local variable because of its small size (12 bytes) and to ensure
that acpi_os_signal() always receives valid information about the
fatal ACPI BIOS error.

Link: https://github.com/acpica/acpica/commit/d516c7758ba6
Signed-off-by: Armin Wolf <W_Armin@gmx.de>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Link: https://patch.msgid.link/3325491.5fSG56mABF@rafael.j.wysocki
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/acpica/exoparg3.c | 46 +++++++++++++---------------------
 1 file changed, 18 insertions(+), 28 deletions(-)

diff --git a/drivers/acpi/acpica/exoparg3.c b/drivers/acpi/acpica/exoparg3.c
index bf08110ed6d25..c8c8c4e49563e 100644
--- a/drivers/acpi/acpica/exoparg3.c
+++ b/drivers/acpi/acpica/exoparg3.c
@@ -10,6 +10,7 @@
 #include <acpi/acpi.h>
 #include "accommon.h"
 #include "acinterp.h"
+#include <acpi/acoutput.h>
 #include "acparser.h"
 #include "amlcode.h"
 
@@ -51,8 +52,7 @@ ACPI_MODULE_NAME("exoparg3")
 acpi_status acpi_ex_opcode_3A_0T_0R(struct acpi_walk_state *walk_state)
 {
 	union acpi_operand_object **operand = &walk_state->operands[0];
-	struct acpi_signal_fatal_info *fatal;
-	acpi_status status = AE_OK;
+	struct acpi_signal_fatal_info fatal;
 
 	ACPI_FUNCTION_TRACE_STR(ex_opcode_3A_0T_0R,
 				acpi_ps_get_opcode_name(walk_state->opcode));
@@ -60,28 +60,23 @@ acpi_status acpi_ex_opcode_3A_0T_0R(struct acpi_walk_state *walk_state)
 	switch (walk_state->opcode) {
 	case AML_FATAL_OP:	/* Fatal (fatal_type fatal_code fatal_arg) */
 
-		ACPI_DEBUG_PRINT((ACPI_DB_INFO,
-				  "FatalOp: Type %X Code %X Arg %X "
-				  "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<\n",
-				  (u32)operand[0]->integer.value,
-				  (u32)operand[1]->integer.value,
-				  (u32)operand[2]->integer.value));
-
-		fatal = ACPI_ALLOCATE(sizeof(struct acpi_signal_fatal_info));
-		if (fatal) {
-			fatal->type = (u32) operand[0]->integer.value;
-			fatal->code = (u32) operand[1]->integer.value;
-			fatal->argument = (u32) operand[2]->integer.value;
-		}
+		fatal.type = (u32)operand[0]->integer.value;
+		fatal.code = (u32)operand[1]->integer.value;
+		fatal.argument = (u32)operand[2]->integer.value;
 
-		/* Always signal the OS! */
+		ACPI_BIOS_ERROR((AE_INFO,
+				 "Fatal ACPI BIOS error (Type 0x%X Code 0x%X Arg 0x%X)\n",
+				 fatal.type, fatal.code, fatal.argument));
 
-		status = acpi_os_signal(ACPI_SIGNAL_FATAL, fatal);
+		/* Always signal the OS! */
 
-		/* Might return while OS is shutting down, just continue */
+		acpi_os_signal(ACPI_SIGNAL_FATAL, &fatal);
 
-		ACPI_FREE(fatal);
-		goto cleanup;
+		/*
+		 * Might return while OS is shutting down, so abort the AML execution
+		 * by returning an error.
+		 */
+		return_ACPI_STATUS(AE_ERROR);
 
 	case AML_EXTERNAL_OP:
 		/*
@@ -93,21 +88,16 @@ acpi_status acpi_ex_opcode_3A_0T_0R(struct acpi_walk_state *walk_state)
 		 * wrong if an external opcode ever gets here.
 		 */
 		ACPI_ERROR((AE_INFO, "Executed External Op"));
-		status = AE_OK;
-		goto cleanup;
+
+		return_ACPI_STATUS(AE_OK);
 
 	default:
 
 		ACPI_ERROR((AE_INFO, "Unknown AML opcode 0x%X",
 			    walk_state->opcode));
 
-		status = AE_AML_BAD_OPCODE;
-		goto cleanup;
+		return_ACPI_STATUS(AE_AML_BAD_OPCODE);
 	}
-
-cleanup:
-
-	return_ACPI_STATUS(status);
 }
 
 /*******************************************************************************
-- 
2.51.0

