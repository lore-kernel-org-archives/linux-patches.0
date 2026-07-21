Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5302646C4A6;
	Tue, 21 Jul 2026 15:42:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648567; cv=none; b=d1h8dCWWqtqeaAO3r9AMG3/8od9OWXtLX6IWvKz7C22kmHdhnX6fd0BLLJXT+PrJwgj1udal/RbMP7lpjnCwOTya+en7tA/XkYul7r62P0B07gtPzVf9QhVXoepiKRGpb9S+mS5B+K6mZsZvekbIdasx0GHnbTP6/D7ga2JeBYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648567; c=relaxed/simple;
	bh=zKu142VcnHW60J3gg9RUmlTw6/KUuXsEOAarXegmT2E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ELfQqoyrYnWD+600cvvg/XSS6rM1r00LzAjMacSfJQe0fxHcNonk7FYtvZMCgqJhagZClrA9mJ1cQCpjnUDuNOWSbha3HosjrekxOQ40UmrUI7SemYz5A3n5v+P5jKQqlPrzAH7rS2ZQqI+mT2vYyZxAFuKHa/vmTSzy4yR2jD4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1wc2r38w; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1wc2r38w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 788431F00ACA;
	Tue, 21 Jul 2026 15:42:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648566;
	bh=ZioUON/QZn21IH1u2WTJ7wj+6EZaalrfn5QRpyXs9+A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1wc2r38w9XR+RbodiImLsZWHUPvVWb9xNZybQ8/HlESPm12kja7jFRFxx57vgaHbo
	 Bn5L/pkufxN75mq5zWckqkBTqymv6/OZgq13YbJ7mM6KFs2X5/Yd7izzPZ8YEz09z9
	 J37fZvV4ISQEFhlQJjr3NQcaq0gEYMlu3cohGyKE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andre Przywara <andre.przywara@arm.com>,
	Sudeep Holla <sudeep.holla@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0248/2077] firmware: smccc: Fix Arm SMCCC SOC_ID name call
Date: Tue, 21 Jul 2026 16:58:41 +0200
Message-ID: <20260721152558.530844763@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andre Przywara <andre.przywara@arm.com>

[ Upstream commit 70492cfce2a4d41e87bf46989028a90f4bc6b38f ]

Commit 5f9c23abc477 ("firmware: smccc: Support optional Arm SMCCC SOC_ID
name") introduced the SOC_ID name string call, which reports a human
readable string describing the SoC, as returned by firmware.

The SMCCC spec v1.6 describes this feature as AArch64 only, since we rely
on 8 characters to be transmitted per register. Consequently the SMCCC
call must use the AArch64 calling convention, which requires bit 30 of
the FID to be set. The spec is a bit confusing here, since it mentions
that in the parameter description ("2: SoC name (optionally implemented for
SMC64 calls, ..."), but still prints the FID explicitly as 0x80000002.

But as this FID is using the SMC32 calling convention (correct for the
other two calls), it will not match what any SMCCC conformant firmware is
expecting, so any call would return NOT_SUPPORTED.

Add a 64-bit version of the ARCH_SOC_ID FID macro, and use that for the
SoC name version of the call to fix the issue.

Fixes: 5f9c23abc477 ("firmware: smccc: Support optional Arm SMCCC SOC_ID name")
Signed-off-by: Andre Przywara <andre.przywara@arm.com>
Link: https://patch.msgid.link/20250902172053.304911-1-andre.przywara@arm.com
Signed-off-by: Sudeep Holla <sudeep.holla@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/smccc/soc_id.c | 2 +-
 include/linux/arm-smccc.h       | 5 +++++
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/firmware/smccc/soc_id.c b/drivers/firmware/smccc/soc_id.c
index 2f7475e66b3ca9..a909d5e6dee509 100644
--- a/drivers/firmware/smccc/soc_id.c
+++ b/drivers/firmware/smccc/soc_id.c
@@ -60,7 +60,7 @@ static char __init *smccc_soc_name_init(void)
 	 * to the ARM_SMCCC_ARCH_SOC_ID function.  Fetch it if
 	 * available.
 	 */
-	args.a0 = ARM_SMCCC_ARCH_SOC_ID;
+	args.a0 = ARM_SMCCC_ARCH_SOC_ID64;
 	args.a1 = 2;    /* SOC_ID name */
 	arm_smccc_1_2_invoke(&args, &res);
 
diff --git a/include/linux/arm-smccc.h b/include/linux/arm-smccc.h
index e7195750d21bb4..4de81848fe2eec 100644
--- a/include/linux/arm-smccc.h
+++ b/include/linux/arm-smccc.h
@@ -90,6 +90,11 @@
 			   ARM_SMCCC_SMC_32,				\
 			   0, 2)
 
+#define ARM_SMCCC_ARCH_SOC_ID64						\
+	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,				\
+			   ARM_SMCCC_SMC_64,				\
+			   0, 2)
+
 #define ARM_SMCCC_ARCH_WORKAROUND_1					\
 	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,				\
 			   ARM_SMCCC_SMC_32,				\
-- 
2.53.0



