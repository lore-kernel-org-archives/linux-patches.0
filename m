Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6F08BA32
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 17:07:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BF7BC433D2;
	Tue,  7 Mar 2023 17:07:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678208863;
	bh=Ti9D8/N2bvprk1D2kU2ST7isFhuvl0uOeemMqS7HW0c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gB5l7gprxzAqFUZ1tuAP0NMliGs5t90XR7ZtIJSOUIk0AX5okKUla1D0PpZyKtBrL
	 +W71oCTfih4Y1MgkZQb6WOGhuHJW+47fcnLbeaX7kBonIyc5mtKVQ8MJR5Nxkt0t+A
	 SeLgC3E0OfD4UZPJLwgwdaecWjeph8NODjDAc02o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leo Duran <leo.duran@amd.com>,
	Kishon Vijay Abraham I <kvijayab@amd.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Zhang Rui <rui.zhang@intel.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0035/1001] x86/acpi/boot: Do not register processors that cannot be onlined for x2APIC
Date: Tue,  7 Mar 2023 17:46:47 +0100
Message-Id: <20230307170023.656669998@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Kishon Vijay Abraham I <kvijayab@amd.com>

[ Upstream commit e2869bd7af608c343988429ceb1c2fe99644a01f ]

Section 5.2.12.12 Processor Local x2APIC Structure in the ACPI v6.5
spec mandates that both "enabled" and "online capable" Local APIC Flags
should be used to determine if the processor is usable or not.

However, Linux doesn't use the "online capable" flag for x2APIC to
determine if the processor is usable. As a result, cpu_possible_mask has
incorrect value and results in more memory getting allocated for per_cpu
variables than it is going to be used.

Make sure Linux parses both "enabled" and "online capable" flags for
x2APIC to correctly determine if the processor is usable.

Fixes: aa06e20f1be6 ("x86/ACPI: Don't add CPUs that are not online capable")
Reported-by: Leo Duran <leo.duran@amd.com>
Signed-off-by: Kishon Vijay Abraham I <kvijayab@amd.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Reviewed-by: Borislav Petkov (AMD) <bp@alien8.de>
Reviewed-by: Zhang Rui <rui.zhang@intel.com>
Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Link: https://lore.kernel.org/r/20230105041059.39366-1-kvijayab@amd.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/acpi/boot.c | 19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index 907cc98b19380..518bda50068cb 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -188,6 +188,17 @@ static int acpi_register_lapic(int id, u32 acpiid, u8 enabled)
 	return cpu;
 }
 
+static bool __init acpi_is_processor_usable(u32 lapic_flags)
+{
+	if (lapic_flags & ACPI_MADT_ENABLED)
+		return true;
+
+	if (acpi_support_online_capable && (lapic_flags & ACPI_MADT_ONLINE_CAPABLE))
+		return true;
+
+	return false;
+}
+
 static int __init
 acpi_parse_x2apic(union acpi_subtable_headers *header, const unsigned long end)
 {
@@ -212,6 +223,10 @@ acpi_parse_x2apic(union acpi_subtable_headers *header, const unsigned long end)
 	if (apic_id == 0xffffffff)
 		return 0;
 
+	/* don't register processors that cannot be onlined */
+	if (!acpi_is_processor_usable(processor->lapic_flags))
+		return 0;
+
 	/*
 	 * We need to register disabled CPU as well to permit
 	 * counting disabled CPUs. This allows us to size
@@ -250,9 +265,7 @@ acpi_parse_lapic(union acpi_subtable_headers * header, const unsigned long end)
 		return 0;
 
 	/* don't register processors that can not be onlined */
-	if (acpi_support_online_capable &&
-	    !(processor->lapic_flags & ACPI_MADT_ENABLED) &&
-	    !(processor->lapic_flags & ACPI_MADT_ONLINE_CAPABLE))
+	if (!acpi_is_processor_usable(processor->lapic_flags))
 		return 0;
 
 	/*
-- 
2.39.2



