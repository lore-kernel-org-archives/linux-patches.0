Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13E43481FD3;
	Mon, 20 Apr 2026 13:31:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776691912; cv=none; b=rA5egFc2o1mVECndk3pgqPS4Q9Xg84vnw2eDGo2L2Jbl2Ps1BB4JFYfrDLO1b4fPkozyjwRD2qSHQnnDF7NM0DufX9l0Gq9z/v/2igdQ/VLiJ9um7L5TyKQvFPm4WC/q/I8l3NCVGmCYVO5gftXkV3FcxBluAh0kZx7E6xzms30=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776691912; c=relaxed/simple;
	bh=Urre9Ioh1Z8JaWFbwarUsfl2pNj0uaGl38E3xjK4jwA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p4CVoNXNgqYnWC1fp7LfK5OssE90AgAWJSogsccPgJY823YPZwOIjmDRTnl21QS49SgZjETnsRRU7roBds54xBrhQV55vvw5L6RlBxR9x+mhQnMIrPMOyFRdlytjpCD6Brul8BmIkTyjzmpoNVOs6SnFbBbUzbADvACKrlq6po8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HQCGd5Xp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HQCGd5Xp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E198DC19425;
	Mon, 20 Apr 2026 13:31:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776691911;
	bh=Urre9Ioh1Z8JaWFbwarUsfl2pNj0uaGl38E3xjK4jwA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HQCGd5XpUgy+9zHGxYgglbsd4NhWebHnKOoypsJw9iI87BT1Sb94vEjcNolLQINSR
	 duiVxkJELOWh2RvLK+wiZ6Tpt6AvooaOBbwUObCuotamxHOKP+UZ2qi5nIJ4F7HIsc
	 0TCh9X44/wF4/exrYq1lNsOmGMILF9WPw1+rP1YiKbaf5+D2nwu52jbrNFW3H17Kyr
	 aDWykSV8prsuHqU1JjdSdRF2vJpQqeIqaBKyi11DSJYR1J3P7rQo82/0ELRs1s5qPz
	 QIt5E6wtbsBnidNUwBXQ4njTzLHtVW3eFalpTZVIQQj6qFZEzOltvQSFDJ8qd/2lDK
	 zoOGYbnMp7KYw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Serhii Pievniev <spevnev16@gmail.com>,
	Len Brown <len.brown@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	lenb@kernel.org,
	patryk.wlazlyn@linux.intel.com,
	linux-pm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] tools/power/turbostat: Fix microcode patch level output for AMD/Hygon
Date: Mon, 20 Apr 2026 09:20:59 -0400
Message-ID: <20260420132314.1023554-265-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420132314.1023554-1-sashal@kernel.org>
References: <20260420132314.1023554-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.23
Content-Transfer-Encoding: 8bit

From: Serhii Pievniev <spevnev16@gmail.com>

[ Upstream commit a444083286434ec1fd127c5da11a3091e6013008 ]

turbostat always used the same logic to read the microcode patch level,
which is correct for Intel but not for AMD/Hygon.
While Intel stores the patch level in the upper 32 bits of MSR, AMD
stores it in the lower 32 bits, which causes turbostat to report the
microcode version as 0x0 on AMD/Hygon.

Fix by shifting right by 32 for non-AMD/Hygon, preserving the existing
behavior for Intel and unknown vendors.

Fixes: 3e4048466c39 ("tools/power turbostat: Add --no-msr option")
Signed-off-by: Serhii Pievniev <spevnev16@gmail.com>
Signed-off-by: Len Brown <len.brown@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Error: Failed to generate final synthesis

 tools/power/x86/turbostat/turbostat.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/tools/power/x86/turbostat/turbostat.c b/tools/power/x86/turbostat/turbostat.c
index 1b5ca2f4e92ff..67dfd3eaad014 100644
--- a/tools/power/x86/turbostat/turbostat.c
+++ b/tools/power/x86/turbostat/turbostat.c
@@ -8842,10 +8842,13 @@ void process_cpuid()
 	edx_flags = edx;
 
 	if (!no_msr) {
-		if (get_msr(sched_getcpu(), MSR_IA32_UCODE_REV, &ucode_patch))
+		if (get_msr(sched_getcpu(), MSR_IA32_UCODE_REV, &ucode_patch)) {
 			warnx("get_msr(UCODE)");
-		else
+		} else {
 			ucode_patch_valid = true;
+			if (!authentic_amd && !hygon_genuine)
+				ucode_patch >>= 32;
+		}
 	}
 
 	/*
@@ -8860,7 +8863,7 @@ void process_cpuid()
 		fprintf(outf, "CPUID(1): family:model:stepping 0x%x:%x:%x (%d:%d:%d)",
 			family, model, stepping, family, model, stepping);
 		if (ucode_patch_valid)
-			fprintf(outf, " microcode 0x%x", (unsigned int)((ucode_patch >> 32) & 0xFFFFFFFF));
+			fprintf(outf, " microcode 0x%x", (unsigned int)ucode_patch);
 		fputc('\n', outf);
 
 		fprintf(outf, "CPUID(0x80000000): max_extended_levels: 0x%x\n", max_extended_level);
-- 
2.53.0

