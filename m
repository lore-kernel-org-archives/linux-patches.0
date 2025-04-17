Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A85F262802;
	Thu, 17 Apr 2025 17:53:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744912437; cv=none; b=DqVXzMHKVIepuVGlpYhRRvOXSa11nQbk6HLjJNDILqU7WfmPNovpuuvbfN55glaiwlR0/7Qf2ZGY2tGt8xI/7ZBIvh7Ko+t71jNiGkbu+kGqeClHAUCgwdmhVeRgm+ARslup0p7cvWtjNp+5aU/ZMs1u5cUPcK+6Y2dehBMJlPU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744912437; c=relaxed/simple;
	bh=CS/e7Pz5VnWxSncfGpOpzbzJguQyAL77/I8TgoRhE/M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DftcyC8IaxVFt1+nS+L32Cnpf4mAwEY/0My8hinz6BElM++D2JPp1OqMjkSDEDn854PrDywIe5Qb9fTuWYqrDOlFIov4Or3w6oECbTG1HTiWyu8ISLkeRAW759BCksYliQBVKfsQwGRCpnpa+luGiAo2lPl+doG3+FykOv0nkGY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eNMjyA8o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eNMjyA8o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A34D8C4CEE4;
	Thu, 17 Apr 2025 17:53:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744912437;
	bh=CS/e7Pz5VnWxSncfGpOpzbzJguQyAL77/I8TgoRhE/M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eNMjyA8odwAMi3YM8ryrNi9b3PEHitKhjF6bot2VfOF0uwnMnFxhw6qa9zdMHQFRA
	 RV5ltfXVV7Fq/7hNH6BXfIOiDKM/Jue1HpIywkZbRELFAxl1xujqxssMsU3VbVkHlv
	 X+iAdL01kPxP+Oe7PoRUZj5vFundg4Zw0TL5QPoI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Petr=20Van=C4=9Bk?= <arkamar@atlas.cz>,
	Thomas Gleixner <tglx@linutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 011/449] x86/acpi: Dont limit CPUs to 1 for Xen PV guests due to disabled ACPI
Date: Thu, 17 Apr 2025 19:44:59 +0200
Message-ID: <20250417175118.442797760@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175117.964400335@linuxfoundation.org>
References: <20250417175117.964400335@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Petr Vaněk <arkamar@atlas.cz>

[ Upstream commit 8b37357a78d7fa13d88ea822b35b40137da1c85e ]

Xen disables ACPI for PV guests in DomU, which causes acpi_mps_check() to
return 1 when CONFIG_X86_MPPARSE is not set. As a result, the local APIC is
disabled and the guest is later limited to a single vCPU, despite being
configured with more.

This regression was introduced in version 6.9 in commit 7c0edad3643f
("x86/cpu/topology: Rework possible CPU management"), which added an
early check that limits CPUs to 1 if apic_is_disabled.

Update the acpi_mps_check() logic to return 0 early when running as a Xen
PV guest in DomU, preventing APIC from being disabled in this specific case
and restoring correct multi-vCPU behaviour.

Fixes: 7c0edad3643f ("x86/cpu/topology: Rework possible CPU management")
Signed-off-by: Petr Vaněk <arkamar@atlas.cz>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Link: https://lore.kernel.org/all/20250407132445.6732-2-arkamar@atlas.cz
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/acpi/boot.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index dae6a73be40e1..9fa321a95eb33 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -23,6 +23,8 @@
 #include <linux/serial_core.h>
 #include <linux/pgtable.h>
 
+#include <xen/xen.h>
+
 #include <asm/e820/api.h>
 #include <asm/irqdomain.h>
 #include <asm/pci_x86.h>
@@ -1729,6 +1731,15 @@ int __init acpi_mps_check(void)
 {
 #if defined(CONFIG_X86_LOCAL_APIC) && !defined(CONFIG_X86_MPPARSE)
 /* mptable code is not built-in*/
+
+	/*
+	 * Xen disables ACPI in PV DomU guests but it still emulates APIC and
+	 * supports SMP. Returning early here ensures that APIC is not disabled
+	 * unnecessarily and the guest is not limited to a single vCPU.
+	 */
+	if (xen_pv_domain() && !xen_initial_domain())
+		return 0;
+
 	if (acpi_disabled || acpi_noirq) {
 		pr_warn("MPS support code is not built-in, using acpi=off or acpi=noirq or pci=noacpi may have problem\n");
 		return 1;
-- 
2.39.5



