Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E96AA21D3EB;
	Wed, 19 Mar 2025 14:39:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742395160; cv=none; b=PDblWDk6t1mi6DCkbpIar+Q0bEfq2uDP/4m5225qmn+STzcd3sJb2TMD6jZMRdwaA3qLFDtjr4ccTglA/r65XZeptZfd49dU9CPKJEdG3Mxkbjp5IfqdMX5BYJf7tMqyO3RDYmnwPImjt3xu8eu+SZSR7E/mR1o2kIphsvzc5lo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742395160; c=relaxed/simple;
	bh=tvtSOvBoF/cjAKKllOJRhuRtNyyf66IoddqBH7C+Qtk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t3NtA1EO/OYUkf+JQ89wISwV7bjo5hw7P4qYiBKjMAhwW3YQBRZ9v/P4pA1kBpTn06JY9wOySTAEjStRW+Sb0yz09VJiB/0W6z7RC9nWhFBqL5Z6VwsglxeUzbisS+iI8oOgrTKGqlEv0YmcDuoy4R9bCgHf2vCD/Q3e206hQL4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nwmGX0BF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nwmGX0BF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF74AC4CEE4;
	Wed, 19 Mar 2025 14:39:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742395159;
	bh=tvtSOvBoF/cjAKKllOJRhuRtNyyf66IoddqBH7C+Qtk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nwmGX0BFTgp2UJuMsH4Z4CrZl88Fha6EtJsmYn4Mn+SDbWxHuqUyiLbEzHd4bFjX2
	 o49eIjJNvOxM8qLGZU43+IW9RUiSEf1yg1hFzFYyi2eNf1Qx8aHFkTDupDOf3bqC7G
	 XZJekBl1dIkKw4zgpUmXnbK9kz9KI4MDOy6c7Uck=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ye Li <ye.li@broadcom.com>,
	Ajay Kaher <ajay.kaher@broadcom.com>,
	Ingo Molnar <mingo@kernel.org>,
	Kevin Loughlin <kevinloughlin@google.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 219/231] x86/vmware: Parse MP tables for SEV-SNP enabled guests under VMware hypervisors
Date: Wed, 19 Mar 2025 07:31:52 -0700
Message-ID: <20250319143032.254294397@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143026.865956961@linuxfoundation.org>
References: <20250319143026.865956961@linuxfoundation.org>
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

From: Ajay Kaher <ajay.kaher@broadcom.com>

[ Upstream commit a2ab25529bbcea51b5e01dded79f45aeb94f644a ]

Under VMware hypervisors, SEV-SNP enabled VMs are fundamentally able to boot
without UEFI, but this regressed a year ago due to:

  0f4a1e80989a ("x86/sev: Skip ROM range scans and validation for SEV-SNP guests")

In this case, mpparse_find_mptable() has to be called to parse MP
tables which contains the necessary boot information.

[ mingo: Updated the changelog. ]

Fixes: 0f4a1e80989a ("x86/sev: Skip ROM range scans and validation for SEV-SNP guests")
Co-developed-by: Ye Li <ye.li@broadcom.com>
Signed-off-by: Ye Li <ye.li@broadcom.com>
Signed-off-by: Ajay Kaher <ajay.kaher@broadcom.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Tested-by: Ye Li <ye.li@broadcom.com>
Reviewed-by: Kevin Loughlin <kevinloughlin@google.com>
Acked-by: Borislav Petkov (AMD) <bp@alien8.de>
Link: https://lore.kernel.org/r/20250313173111.10918-1-ajay.kaher@broadcom.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/cpu/vmware.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/x86/kernel/cpu/vmware.c b/arch/x86/kernel/cpu/vmware.c
index 00189cdeb775f..cb3f900c46fcc 100644
--- a/arch/x86/kernel/cpu/vmware.c
+++ b/arch/x86/kernel/cpu/vmware.c
@@ -26,6 +26,7 @@
 #include <linux/export.h>
 #include <linux/clocksource.h>
 #include <linux/cpu.h>
+#include <linux/efi.h>
 #include <linux/reboot.h>
 #include <linux/static_call.h>
 #include <asm/div64.h>
@@ -429,6 +430,9 @@ static void __init vmware_platform_setup(void)
 		pr_warn("Failed to get TSC freq from the hypervisor\n");
 	}
 
+	if (cc_platform_has(CC_ATTR_GUEST_SEV_SNP) && !efi_enabled(EFI_BOOT))
+		x86_init.mpparse.find_mptable = mpparse_find_mptable;
+
 	vmware_paravirt_ops_setup();
 
 #ifdef CONFIG_X86_IO_APIC
-- 
2.39.5



