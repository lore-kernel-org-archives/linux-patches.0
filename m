Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DF9C1C5D77;
	Wed,  4 Feb 2026 14:46:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770216369; cv=none; b=S2lL4kkYYqLFSeV4j2zMLNBveDcDPpTVlwzoQaGOskv07YYxpKb/jn19sZ9f6jhxvHfQH+3ohEWBSE5sXkxBoEUzMHGMmLkqlv8N48HwrbxO2njTacvM7I7KkvfA/7f6FqqTWItyhJlbwr4OnFTr5jSg0fjuQCct7C9t8aFa6Sc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770216369; c=relaxed/simple;
	bh=29kNnOFL4HCYowHuqAq2JR8pRcPNUJ2fK0msuWkhxJ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IehLE5vrnMILUi2mH98HFRQWst1Dhb0OqFULaAT/2srbP9oZfmFY4fA0Aitr8YHJ23TUWJJjxXEirEnNYjxmmdwRJoteQg/AX2twNFh7Ya1rw0gXqAMKJBP3vEB9hphovbb+gjxGzjdeFGY/wLHM3yca/GgiEvR7CCtWPLdCty0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2fU1PSU3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2fU1PSU3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2E65C4CEF7;
	Wed,  4 Feb 2026 14:46:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770216369;
	bh=29kNnOFL4HCYowHuqAq2JR8pRcPNUJ2fK0msuWkhxJ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2fU1PSU3XONogDz3P1qQ/oqyq5bDtoj37/V597PU1YDH2aqqH0iZUu3pudcQdRq6Z
	 S8e9NH8NypnTZI37GINBazJIw7B6inbOqsxx9DZSunXWWCQdr+XKGPAxvVfwHWuK1n
	 jQ4ogX1/0uCsDhYBOy3bd27VWS0XgKdrDUkmi+68=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiaochen Shen <shenxiaochen@open-hieco.net>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 5.10 033/161] x86/resctrl: Add missing resctrl initialization for Hygon
Date: Wed,  4 Feb 2026 15:38:16 +0100
Message-ID: <20260204143852.950566156@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143851.755002596@linuxfoundation.org>
References: <20260204143851.755002596@linuxfoundation.org>
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

From: Xiaochen Shen <shenxiaochen@open-hieco.net>

commit 6ee98aabdc700b5705e4f1833e2edc82a826b53b upstream.

Hygon CPUs supporting Platform QoS features currently undergo partial resctrl
initialization through resctrl_cpu_detect() in the Hygon BSP init helper and
AMD/Hygon common initialization code. However, several critical data
structures remain uninitialized for Hygon CPUs in the following paths:

 - get_mem_config()-> __rdt_get_mem_config_amd():
     rdt_resource::membw,alloc_capable
     hw_res::num_closid

 - rdt_init_res_defs()->rdt_init_res_defs_amd():
     rdt_resource::cache
     hw_res::msr_base,msr_update

Add the missing AMD/Hygon common initialization to ensure proper Platform QoS
functionality on Hygon CPUs.

Fixes: d8df126349da ("x86/cpu/hygon: Add missing resctrl_cpu_detect() in bsp_init helper")
Signed-off-by: Xiaochen Shen <shenxiaochen@open-hieco.net>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20251209062650.1536952-2-shenxiaochen@open-hieco.net
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/cpu/resctrl/core.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/arch/x86/kernel/cpu/resctrl/core.c
+++ b/arch/x86/kernel/cpu/resctrl/core.c
@@ -834,7 +834,8 @@ static __init bool get_mem_config(void)
 
 	if (boot_cpu_data.x86_vendor == X86_VENDOR_INTEL)
 		return __get_mem_config_intel(&rdt_resources_all[RDT_RESOURCE_MBA]);
-	else if (boot_cpu_data.x86_vendor == X86_VENDOR_AMD)
+	else if (boot_cpu_data.x86_vendor == X86_VENDOR_AMD ||
+		 boot_cpu_data.x86_vendor == X86_VENDOR_HYGON)
 		return __rdt_get_mem_config_amd(&rdt_resources_all[RDT_RESOURCE_MBA]);
 
 	return false;
@@ -960,7 +961,8 @@ static __init void rdt_init_res_defs(voi
 {
 	if (boot_cpu_data.x86_vendor == X86_VENDOR_INTEL)
 		rdt_init_res_defs_intel();
-	else if (boot_cpu_data.x86_vendor == X86_VENDOR_AMD)
+	else if (boot_cpu_data.x86_vendor == X86_VENDOR_AMD ||
+		 boot_cpu_data.x86_vendor == X86_VENDOR_HYGON)
 		rdt_init_res_defs_amd();
 }
 


