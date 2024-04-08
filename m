Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 129E078286;
	Mon,  8 Apr 2024 13:14:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712582043; cv=none; b=cn5IMkswFuBwpdal3NqIHHN6rUoLOZhE1yQIrlV9JlNlHmZB+NqJH0k7C9JZsEbcgqUHBYmolUMt8cXH2mNG8gHcy1pGXSwGEY6aAMy0THRY0wN43tFN/4t13o9uPdwk1l+Ytch1FHbBCckh7STPZZgCzbTzQV2B9x3QxmfxPF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712582043; c=relaxed/simple;
	bh=iQ8SuZBRjs//ydz2iou0ljkkC2Gfe1hj6ONyuhcWJBI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L7LVVvkZEp/3dR5RTJ2JhnyDYA2RDMzvySHqA9GqvpMwrHCa/734u6qZGarZ+mTx+aAaPKSlRTKBiPIgZM0HFa9xZuRxqRqwzEkt8vU4ORRd9oBKVSLF0oZatHteRNLeXRxyzRHr+eZRHUv9KRBwlVKz4YsePHVvxgA7IPuhOW0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W2XYz1Tb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W2XYz1Tb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EC22C43390;
	Mon,  8 Apr 2024 13:14:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712582042;
	bh=iQ8SuZBRjs//ydz2iou0ljkkC2Gfe1hj6ONyuhcWJBI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W2XYz1TbyOe1GjsPrwxPhs1hun2tbPQodsCI3QXZLhS22111d8mNAuB092kiVCpmz
	 BFaHoj3gHyJHvhMpcUnjTITVGsm+CU10Vp1OjUs/WF40mEMxh9OiIGgxWYSwgCDcDz
	 b2fVqMajQsaxK3QZ1RknJAcb4lPn6MrKhS9484+c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 059/252] x86/CPU/AMD: Move Zenbleed check to the Zen2 init function
Date: Mon,  8 Apr 2024 14:55:58 +0200
Message-ID: <20240408125308.471440155@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125306.643546457@linuxfoundation.org>
References: <20240408125306.643546457@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Borislav Petkov (AMD) <bp@alien8.de>

[ Upstream commit f69759be251dce722942594fbc62e53a40822a82 ]

Prefix it properly so that it is clear which generation it is dealing
with.

No functional changes.

Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Link: http://lore.kernel.org/r/20231120104152.13740-8-bp@alien8.de
Stable-dep-of: c7b2edd8377b ("perf/x86/amd/core: Update and fix stalled-cycles-* events for Zen 2 and later")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/cpu/amd.c | 16 +++-------------
 1 file changed, 3 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index 71503181bffd0..d8a0dc01a7db2 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -70,12 +70,6 @@ static const int amd_erratum_383[] =
 static const int amd_erratum_1054[] =
 	AMD_LEGACY_ERRATUM(AMD_MODEL_RANGE(0x17, 0, 0, 0x2f, 0xf));
 
-static const int amd_zenbleed[] =
-	AMD_LEGACY_ERRATUM(AMD_MODEL_RANGE(0x17, 0x30, 0x0, 0x4f, 0xf),
-			   AMD_MODEL_RANGE(0x17, 0x60, 0x0, 0x7f, 0xf),
-			   AMD_MODEL_RANGE(0x17, 0x90, 0x0, 0x91, 0xf),
-			   AMD_MODEL_RANGE(0x17, 0xa0, 0x0, 0xaf, 0xf));
-
 static const int amd_div0[] =
 	AMD_LEGACY_ERRATUM(AMD_MODEL_RANGE(0x17, 0x00, 0x0, 0x2f, 0xf),
 			   AMD_MODEL_RANGE(0x17, 0x50, 0x0, 0x5f, 0xf));
@@ -1073,11 +1067,8 @@ static bool cpu_has_zenbleed_microcode(void)
 	return true;
 }
 
-static void zenbleed_check(struct cpuinfo_x86 *c)
+static void zen2_zenbleed_check(struct cpuinfo_x86 *c)
 {
-	if (!cpu_has_amd_erratum(c, amd_zenbleed))
-		return;
-
 	if (cpu_has(c, X86_FEATURE_HYPERVISOR))
 		return;
 
@@ -1095,6 +1086,7 @@ static void zenbleed_check(struct cpuinfo_x86 *c)
 static void init_amd_zen2(struct cpuinfo_x86 *c)
 {
 	fix_erratum_1386(c);
+	zen2_zenbleed_check(c);
 }
 
 static void init_amd_zen3(struct cpuinfo_x86 *c)
@@ -1219,8 +1211,6 @@ static void init_amd(struct cpuinfo_x86 *c)
 	    cpu_has(c, X86_FEATURE_AUTOIBRS))
 		WARN_ON_ONCE(msr_set_bit(MSR_EFER, _EFER_AUTOIBRS));
 
-	zenbleed_check(c);
-
 	if (cpu_has_amd_erratum(c, amd_div0)) {
 		pr_notice_once("AMD Zen1 DIV0 bug detected. Disable SMT for full protection.\n");
 		setup_force_cpu_bug(X86_BUG_DIV0);
@@ -1385,7 +1375,7 @@ static void zenbleed_check_cpu(void *unused)
 {
 	struct cpuinfo_x86 *c = &cpu_data(smp_processor_id());
 
-	zenbleed_check(c);
+	zen2_zenbleed_check(c);
 }
 
 void amd_check_microcode(void)
-- 
2.43.0



