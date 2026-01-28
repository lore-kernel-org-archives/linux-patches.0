Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4681E21FF30;
	Wed, 28 Jan 2026 15:30:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769614212; cv=none; b=diUdszB5KnrOrb/JtMYCLXePX2mJ7i0EjBKFlnBo1tC4enGC7Z10RGcCHNjKttXmQaENs9QoXxX98nu39bY+/bJDXEsbozL60mH1zFCFS8BHf8hWwaZgnW843Y66yge1Pj0NQNl1s5BtoFemn7oi7FIQtvG0tWJGEMyocpmBrgo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769614212; c=relaxed/simple;
	bh=/WBEDbccF3kkgtXOlc9cRlBZM1iuikxxLIkDVr+q6Ps=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TUJoIbawPJbTMCqwHh5ykcy0QBb3VJEte44WVO0P73mb0PPOIt59LXXMulgBCNYHBJkDzUQxh3ECO9uksAVObsC0cccw3GwpkOiRJT3hhlXXJpnbQPLkLWtViC3JsG2/GnijDFdRGyaU1vv7POx99skdjUPb8BXPm/Lglwili/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PJrRTFeS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PJrRTFeS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4969C4CEF1;
	Wed, 28 Jan 2026 15:30:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769614212;
	bh=/WBEDbccF3kkgtXOlc9cRlBZM1iuikxxLIkDVr+q6Ps=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PJrRTFeSB5zhi+DpP9k3rHEop6PdPUQVCY4LGW1zTUR328d0g/T0POUq1zuXvQXSB
	 IhzKSyEnr0pZklgCfXvIcgRZk7DLv4VRKZrILlC6w1bIz15MAZmmGckn4NnvVDq3fR
	 pzCDLl9/HcbgH5CLOlO92yRru2RfBpbHh5NEhsyU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiaochen Shen <shenxiaochen@open-hieco.net>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 6.6 067/254] x86/resctrl: Add missing resctrl initialization for Hygon
Date: Wed, 28 Jan 2026 16:20:43 +0100
Message-ID: <20260128145347.108949102@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145344.698118637@linuxfoundation.org>
References: <20260128145344.698118637@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -755,7 +755,8 @@ static __init bool get_mem_config(void)
 
 	if (boot_cpu_data.x86_vendor == X86_VENDOR_INTEL)
 		return __get_mem_config_intel(&hw_res->r_resctrl);
-	else if (boot_cpu_data.x86_vendor == X86_VENDOR_AMD)
+	else if (boot_cpu_data.x86_vendor == X86_VENDOR_AMD ||
+		 boot_cpu_data.x86_vendor == X86_VENDOR_HYGON)
 		return __rdt_get_mem_config_amd(&hw_res->r_resctrl);
 
 	return false;
@@ -907,7 +908,8 @@ static __init void rdt_init_res_defs(voi
 {
 	if (boot_cpu_data.x86_vendor == X86_VENDOR_INTEL)
 		rdt_init_res_defs_intel();
-	else if (boot_cpu_data.x86_vendor == X86_VENDOR_AMD)
+	else if (boot_cpu_data.x86_vendor == X86_VENDOR_AMD ||
+		 boot_cpu_data.x86_vendor == X86_VENDOR_HYGON)
 		rdt_init_res_defs_amd();
 }
 


