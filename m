Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1650235B142;
	Fri,  9 Jan 2026 12:30:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767961857; cv=none; b=gIPJNH7m2GCR98yKepKcntFtLb7pyLL5fBN2x4HfiVI/H7H1uCKuBj8WK/xzXOOeEhDJKSak4V6uMdcZRx9P6lKo9yKqBFQssNFDfp6kHxjODG8OXftRTKPZGiF6d03TD8Nu2FprBhqLBcMNS42h/pwSIy386ZaRn3QsAyr1r4I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767961857; c=relaxed/simple;
	bh=exoSAMNxHSpskD8RzDcgLaY/zOWQhCB2E6V2Lb/6YlI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fzAStSAHBi1nspLBTi0kE6CLusu5A/bPomRmw+gbZWcvEgiDv66uZUIcCPWd6bJHbcF0RHN1bBX3bAheLuYMTWj54XIEd6ZDdJ/x/sNdV8vj7EDQg0/Mh9brOJ9O1nwNDlNMMz8V3iO8LBo/HgHTd2PCR7RiPLc9aLDG2BjsKjE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wtzd7m6i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wtzd7m6i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96F20C4CEF1;
	Fri,  9 Jan 2026 12:30:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767961857;
	bh=exoSAMNxHSpskD8RzDcgLaY/zOWQhCB2E6V2Lb/6YlI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wtzd7m6iRR7MlGYZ9/x7qdjoPIL2imfJ0NGGIsyXPBwTg0X/HHY0NJYfj8q9qVGMt
	 WYTF0U7beNiTgKJRYURScxHjp66SiuzoX/cr4Yhc355Afo53dtZ/X7td8S5aLSy5uX
	 pTpcKky9aFieWgCEFRlDM5jHHOw0NHBseuuw87Qw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ren=C3=A9=20Rebe?= <rene@exactco.de>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 160/634] ACPI: processor_core: fix map_x2apic_id for amd-pstate on am4
Date: Fri,  9 Jan 2026 12:37:18 +0100
Message-ID: <20260109112123.470800934@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
User-Agent: quilt/0.69
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: René Rebe <rene@exactco.de>

[ Upstream commit 17e7972979e147cc51d4a165e6b6b0f93273ca68 ]

On all AMD AM4 systems I have seen, e.g ASUS X470-i, Pro WS X570 Ace
and equivalent Gigabyte, amd-pstate does not initialize when the
x2apic is enabled in the BIOS. Kernel debug messages include:

[    0.315438] acpi LNXCPU:00: Failed to get CPU physical ID.
[    0.354756] ACPI CPPC: No CPC descriptor for CPU:0
[    0.714951] amd_pstate: the _CPC object is not present in SBIOS or ACPI disabled

I tracked this down to map_x2apic_id() checking device_declaration
passed in via the type argument of acpi_get_phys_id() via
map_madt_entry() while map_lapic_id() does not.

It appears these BIOSes use Processor statements for declaring the CPUs
in the ACPI namespace instead of processor device objects (which should
have been used). CPU declarations via Processor statements were
deprecated in ACPI 6.0 that was released 10 years ago. They should not
be used any more in any contemporary platform firmware.

I tried to contact Asus support multiple times, but never received a
reply nor did any BIOS update ever change this.

Fix amd-pstate w/ x2apic on am4 by allowing map_x2apic_id() to work with
CPUs declared via Processor statements for IDs less than 255, which is
consistent with ACPI 5.0 that still allowed Processor statements to be
used for declaring CPUs.

Fixes: 7237d3de78ff ("x86, ACPI: add support for x2apic ACPI extensions")
Signed-off-by: René Rebe <rene@exactco.de>
[ rjw: Changelog edits ]
Link: https://patch.msgid.link/20251126.165513.1373131139292726554.rene@exactco.de
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/processor_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/acpi/processor_core.c b/drivers/acpi/processor_core.c
index 2ac48cda5b201..eae7efae3b5cf 100644
--- a/drivers/acpi/processor_core.c
+++ b/drivers/acpi/processor_core.c
@@ -54,7 +54,7 @@ static int map_x2apic_id(struct acpi_subtable_header *entry,
 	if (!(apic->lapic_flags & ACPI_MADT_ENABLED))
 		return -ENODEV;
 
-	if (device_declaration && (apic->uid == acpi_id)) {
+	if (apic->uid == acpi_id && (device_declaration || acpi_id < 255)) {
 		*apic_id = apic->local_apic_id;
 		return 0;
 	}
-- 
2.51.0



