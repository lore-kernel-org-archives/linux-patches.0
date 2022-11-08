Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3084F15CAC
	for <patches@lists.linux.dev>; Tue,  8 Nov 2022 13:52:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4CCAC433D6;
	Tue,  8 Nov 2022 13:52:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667915546;
	bh=a0O9IAWTr2P9u5Jmag+tbnMoZyrPWATfZ1XPehq+nWw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q8fMVYlb45s0uRFCdDlIDIlS2rmvKLE/4So5C0qSIPL0Uj3706OdpTsUIoy+rmhwA
	 HOmLXv1f3H6LUpPGidGYEgOt6426uAB+CJwFR67op4U6HTBdmAUiLdwaQCSSJGjgw3
	 JhMxH3dzyJS6+MhwvKFywUOQc6h1XFAAVKPE1bso=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Len Brown <len.brown@intel.com>,
	Zhang Rui <rui.zhang@intel.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 009/118] x86/topology: Fix duplicated core ID within a package
Date: Tue,  8 Nov 2022 14:38:07 +0100
Message-Id: <20221108133341.111032249@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133340.718216105@linuxfoundation.org>
References: <20221108133340.718216105@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Zhang Rui <rui.zhang@intel.com>

[ Upstream commit 71eac7063698b7d7b8fafb1683ac24a034541141 ]

Today, core ID is assumed to be unique within each package.

But an AlderLake-N platform adds a Module level between core and package,
Linux excludes the unknown modules bits from the core ID, resulting in
duplicate core ID's.

To keep core ID unique within a package, Linux must include all APIC-ID
bits for known or unknown levels above the core and below the package
in the core ID.

It is important to understand that core ID's have always come directly
from the APIC-ID encoding, which comes from the BIOS. Thus there is no
guarantee that they start at 0, or that they are contiguous.
As such, naively using them for array indexes can be problematic.

[ dhansen: un-known -> unknown ]

Fixes: 7745f03eb395 ("x86/topology: Add CPUID.1F multi-die/package support")
Suggested-by: Len Brown <len.brown@intel.com>
Signed-off-by: Zhang Rui <rui.zhang@intel.com>
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Reviewed-by: Len Brown <len.brown@intel.com>
Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/20221014090147.1836-5-rui.zhang@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/cpu/topology.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/topology.c b/arch/x86/kernel/cpu/topology.c
index 696309749d62..37d48ab3d077 100644
--- a/arch/x86/kernel/cpu/topology.c
+++ b/arch/x86/kernel/cpu/topology.c
@@ -141,7 +141,7 @@ int detect_extended_topology(struct cpuinfo_x86 *c)
 		sub_index++;
 	}
 
-	core_select_mask = (~(-1 << core_plus_mask_width)) >> ht_mask_width;
+	core_select_mask = (~(-1 << pkg_mask_width)) >> ht_mask_width;
 	die_select_mask = (~(-1 << die_plus_mask_width)) >>
 				core_plus_mask_width;
 
-- 
2.35.1



