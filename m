Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A04663594D;
	Thu, 17 Apr 2025 18:17:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744913840; cv=none; b=AfQEEpb/J8N5TC+Ek5uJQtI6vZxUfCyJuQ1pchSrV5NMKq75zdKafMi5z49DpHG6L4hob10Bw5Q7fDjOlO0x3YU9Huh5sz9d50XjAkbJO4G2BiOdfjabXbRqdJ9VApiQ3p3W3xPiDHpleAsuKK0oOcnRjIzsSsiGsqqMqX5bWaA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744913840; c=relaxed/simple;
	bh=LZC4bIhV/i1aEAKnlum3DSORtEmSpYE2zyigNYJITq8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eQtMCBRsd77yNMuOMlZKt+ErgadcdbjVwGuOYTVnwqIfEGbUXMj8Sj+vZR+Ta7IgR9zxbLjtk9AyjparEckzou7spzgN+Wh69HSoS6Uri49wXQf/ANdEhEOR+KQwhdG5ACyb8k8aLpZ0mqnI1XHfceo9z8PqNZqXGQZKX3RxgZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=grC7kwDW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="grC7kwDW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA20DC4CEEA;
	Thu, 17 Apr 2025 18:17:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744913840;
	bh=LZC4bIhV/i1aEAKnlum3DSORtEmSpYE2zyigNYJITq8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=grC7kwDWJAUBR0vsyEPPDwH1cdASa3P7vEsTd76flB09XkJ2+UJsVlIje/nDiKq4m
	 S8uAunjub+XTWiJDxQ/J2AZHWMJG9I5xkUFB5VUH7EmOLkIKoWjBYVLEurIQ+l882T
	 5ZgVwfjSOotbshhuPhqJ2S4hl0u7nmb6mv0vlQao=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Petr=20Van=C4=9Bk?= <arkamar@atlas.cz>,
	Thomas Gleixner <tglx@linutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 009/414] x86/acpi: Dont limit CPUs to 1 for Xen PV guests due to disabled ACPI
Date: Thu, 17 Apr 2025 19:46:07 +0200
Message-ID: <20250417175111.777387673@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175111.386381660@linuxfoundation.org>
References: <20250417175111.386381660@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
index 18485170d51b4..619de9109e7a7 100644
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
@@ -1732,6 +1734,15 @@ int __init acpi_mps_check(void)
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



