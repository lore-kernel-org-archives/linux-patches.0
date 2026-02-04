Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B2CD22E3F0;
	Wed,  4 Feb 2026 15:08:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770217695; cv=none; b=hYBnMod2H18MzZtJPbzyOQUCdFcdASzX8whZjHJeFQAErRGeolHxFKG2DGmiEVfFtGTdi+FydYpyRjEWHvGM6pjVaEk1taigv6ulR6GafEf7nBcGfNFbW59t486iOvB2SDNqfctf7r1GJ1q/Yhm0PX8PEVwL0oW5oje5TWZ+cxc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770217695; c=relaxed/simple;
	bh=KWL1KqVl7e3EEF5YpFF4RFQLM1kvw/57qqG4P3FiWak=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pnK/jXJNwXQVo1Kl78Mk56SYsxuWBVf6s8tx3qhlMRSB6GHCGZ57icGijG7jbO5dZ6FxyhtvbdWi/qunajVAwcg//QS9UOOY/XLIk1fhio1E5kJt3QD1um0s4xV6w3fkTmQy87rERBxnEl3ZEzn+H8T71kNlNfNozwj2zO6/Jj4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mtvn0BX2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mtvn0BX2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEAAFC4CEF7;
	Wed,  4 Feb 2026 15:08:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770217695;
	bh=KWL1KqVl7e3EEF5YpFF4RFQLM1kvw/57qqG4P3FiWak=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mtvn0BX2Um2+CENIk+fV1MdpNfngIGeHSxewPuUv6cir3yvH3CHtxLbpAy+vAhDQ4
	 wnrkurxBxjrRJC/i4jJ45RYjwMfbJi7uA6s6H8RlZ7+w2dEhXiBlHC9W0RgF1dagVL
	 2MXuYJWHrljJlTjevmyWXNAQKY/u2evjgINmHfqs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiaochen Shen <shenxiaochen@open-hieco.net>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 6.1 057/280] x86/resctrl: Add missing resctrl initialization for Hygon
Date: Wed,  4 Feb 2026 15:37:11 +0100
Message-ID: <20260204143911.704734226@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143909.614719725@linuxfoundation.org>
References: <20260204143909.614719725@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -728,7 +728,8 @@ static __init bool get_mem_config(void)
 
 	if (boot_cpu_data.x86_vendor == X86_VENDOR_INTEL)
 		return __get_mem_config_intel(&hw_res->r_resctrl);
-	else if (boot_cpu_data.x86_vendor == X86_VENDOR_AMD)
+	else if (boot_cpu_data.x86_vendor == X86_VENDOR_AMD ||
+		 boot_cpu_data.x86_vendor == X86_VENDOR_HYGON)
 		return __rdt_get_mem_config_amd(&hw_res->r_resctrl);
 
 	return false;
@@ -863,7 +864,8 @@ static __init void rdt_init_res_defs(voi
 {
 	if (boot_cpu_data.x86_vendor == X86_VENDOR_INTEL)
 		rdt_init_res_defs_intel();
-	else if (boot_cpu_data.x86_vendor == X86_VENDOR_AMD)
+	else if (boot_cpu_data.x86_vendor == X86_VENDOR_AMD ||
+		 boot_cpu_data.x86_vendor == X86_VENDOR_HYGON)
 		rdt_init_res_defs_amd();
 }
 


