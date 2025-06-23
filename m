Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8ACD12561A8;
	Mon, 23 Jun 2025 13:30:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750685443; cv=none; b=bRibqTEQR/SRCFkkVZZMxEkMnCzzGEYoBkk9YPMObxJBxDr1TcmLRNegUd5a+M3ZzD6T4MFOryPG3ASPLjwkiqoufQqxD1dtKdBIJwn6fIOtYzR2nNjH+gqzT9ETS7dnOct5EcFvAPcXoRNLbCxkjlL8tsTcZtFEtNCdc+zm334=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750685443; c=relaxed/simple;
	bh=8/v1/soUdKqH7ew+TVHQHvIDXbY8oOEpUxv8qRA7Eh4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V67pzmSjqciUOaaL61ErXT1vl8YtB2pfJSy9iZLbxtkeRDfp8zh1LIj2+Whj8TH/upyvvV2CxFvCzcxzc74j5d0P9VV6JMsUa1Q2XtcN60HNNND+z5++jL8bebDP3dcuTaw2WxMPYPlEwe9aYPCSh0RCDy9lHccO7tsemBIgnJ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aZAsTfEo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aZAsTfEo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17251C4CEEA;
	Mon, 23 Jun 2025 13:30:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750685443;
	bh=8/v1/soUdKqH7ew+TVHQHvIDXbY8oOEpUxv8qRA7Eh4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aZAsTfEoRXoek55GwHBPR+ik4bGmUoN2ERjd4/Jb6K76j51952gVXLfFHsL9ZS+ty
	 ImhX0RZVxD4UjXFJcuaRtbbkpAvFyW2lJ7fhraZECTx+9yYh2+PuDEkj3JyA58lMY5
	 o8luopqPivLbgvLpjjsF6ysAT2yhgxR8D+qwtyw0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiaqing Zhao <jiaqing.zhao@linux.intel.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 032/508] x86/mtrr: Check if fixed-range MTRRs exist in mtrr_save_fixed_ranges()
Date: Mon, 23 Jun 2025 15:01:17 +0200
Message-ID: <20250623130646.037118987@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130645.255320792@linuxfoundation.org>
References: <20250623130645.255320792@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiaqing Zhao <jiaqing.zhao@linux.intel.com>

[ Upstream commit 824c6384e8d9275d4ec7204f3f79a4ac6bc10379 ]

When suspending, save_processor_state() calls mtrr_save_fixed_ranges()
to save fixed-range MTRRs.

On platforms without fixed-range MTRRs like the ACRN hypervisor which
has removed fixed-range MTRR emulation, accessing these MSRs will
trigger an unchecked MSR access error. Make sure fixed-range MTRRs are
supported before access to prevent such error.

Since mtrr_state.have_fixed is only set when MTRRs are present and
enabled, checking the CPU feature flag in mtrr_save_fixed_ranges() is
unnecessary.

Fixes: 3ebad5905609 ("[PATCH] x86: Save and restore the fixed-range MTRRs of the BSP when suspending")
Signed-off-by: Jiaqing Zhao <jiaqing.zhao@linux.intel.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Link: https://lore.kernel.org/20250509170633.3411169-2-jiaqing.zhao@linux.intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/cpu/mtrr/generic.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/mtrr/generic.c b/arch/x86/kernel/cpu/mtrr/generic.c
index 558108296f3cf..31549e7f6b7c6 100644
--- a/arch/x86/kernel/cpu/mtrr/generic.c
+++ b/arch/x86/kernel/cpu/mtrr/generic.c
@@ -349,7 +349,7 @@ static void get_fixed_ranges(mtrr_type *frs)
 
 void mtrr_save_fixed_ranges(void *info)
 {
-	if (boot_cpu_has(X86_FEATURE_MTRR))
+	if (mtrr_state.have_fixed)
 		get_fixed_ranges(mtrr_state.fixed_ranges);
 }
 
-- 
2.39.5



