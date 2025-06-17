Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E21C20F090;
	Tue, 17 Jun 2025 15:38:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750174704; cv=none; b=fPaQ2fufPKmE0FJnB1uuZHSpoCNmv/LkK/StaA8N23+t4wZtli00myUOuEoB7RJBaepboFuYGUIFWJBiNg1IVibnhj0+2n2tmHmVF/201qDylY7gH4/SA5iBlRBGBiAFC85gIyoGhesb9QB1e73udIEx1doHJf/ogqb5QgKy03o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750174704; c=relaxed/simple;
	bh=cxUsCSvQK5K4TuqAEArgS5Yqt4zFh1wR01mijHlAJps=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZMrIjRlFxDgAI/adL078OAePZEDSPvLH51wbT2quE/fTVHIKMnmSLetIEWGl6fwJ902tRIeB9laaDiS4OZqYO+qL2x806q7M1IDTKIwtt0+7FXq31VETym+Cd8utq+iiw4v3rE38PkvwWcO5taJFYJLhOQGpW+Dxq5c2jEoNLFE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v9KzsEu8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v9KzsEu8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E0CFC4CEE3;
	Tue, 17 Jun 2025 15:38:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750174704;
	bh=cxUsCSvQK5K4TuqAEArgS5Yqt4zFh1wR01mijHlAJps=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v9KzsEu8M7HtcDK+RIZ0peNU+T3y19kBmL9mPhr0AZJr8m849fnP8HtbSzIc98yqS
	 EZpEFW1w6F9lpOzJFtzprc/0LsKFSVcfQQKojxOOma25D/3KxAJ3j02trU09vdFPUq
	 Pt90wG+6pFkC80XkcWRy5cSNxarqazbxAGSTspcA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiaqing Zhao <jiaqing.zhao@linux.intel.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 052/512] x86/mtrr: Check if fixed-range MTRRs exist in mtrr_save_fixed_ranges()
Date: Tue, 17 Jun 2025 17:20:18 +0200
Message-ID: <20250617152421.643926260@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 7b29ebda024f4..1ececfce7a46a 100644
--- a/arch/x86/kernel/cpu/mtrr/generic.c
+++ b/arch/x86/kernel/cpu/mtrr/generic.c
@@ -591,7 +591,7 @@ static void get_fixed_ranges(mtrr_type *frs)
 
 void mtrr_save_fixed_ranges(void *info)
 {
-	if (boot_cpu_has(X86_FEATURE_MTRR))
+	if (mtrr_state.have_fixed)
 		get_fixed_ranges(mtrr_state.fixed_ranges);
 }
 
-- 
2.39.5



