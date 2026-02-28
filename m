Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF160375222;
	Sat, 28 Feb 2026 17:59:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301551; cv=none; b=l8bh/BmWVNt6COaBeJlKdU9RlrnL3iqrkcETh7Yd6R8sTjyPK3D5I1IH45OMFJA4D6eiPkiC7k6n9o9JgN0v4cIuC7ORJblJXGzc5QaLW/y6wC5lME12N5uRk76ma8VXKp5EdxIapPUfx4xkfpiZBKANWXRWy5x1S7/uoKyjWRo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301551; c=relaxed/simple;
	bh=49oIs/oTGfxRNFYKoZCt0EzCE9469vwMbZg/yGgoTnM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uxsFI3Zffg6x7ClxIjto/37KZmCvFtqOZj12Whcna+LXjLgbFbCUa5YP/VFXhCR2qbU78P02liZJz3tabVRCnrCXPZhQIQIfE705ZTEmQkcmvu/tEDxTzgZ6fm1aWRrexWv9ksiBP9l1W1LvUjkW+kPU0ZGquiEthAzAPmg2G+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=f0lTAYzc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="f0lTAYzc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A6BEC19424;
	Sat, 28 Feb 2026 17:59:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301551;
	bh=49oIs/oTGfxRNFYKoZCt0EzCE9469vwMbZg/yGgoTnM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f0lTAYzcA/ETPFib4LyUstSZwOhf0nUaJXR1zMhQfGyt+CYvNV9JUNvlYiBpWrB6s
	 m4vsiMYK03h/xO4fmNzuy5wWkANtfYz8FPJnwk2JOYw9hEew5eUCT5+bF15/lRBclr
	 UHfXJkSP7btXhWzq0Fl+kMh3hgw1Dt0MuppJSnlVqz2xe2Vsiwj6riJZsX8EJB6R9X
	 sklCJvy3hAi8Tf6BrisshffC4HokQJwZGgsPkCOEkFIVIIQfdaJQYkIugs0HQp7pVs
	 DvsrdKYeR30+vS28KCiuKWm7xrVkCpG89E1Tq1hlOEIE2bWf2ovKQAKQ0axKG6S1or
	 96DLosdhERxsg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Ard Biesheuvel <ardb@kernel.org>,
	stable@vger.kernel.org,
	Dave Young <dyoung@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 735/752] x86/kexec: Copy ACPI root pointer address from config table
Date: Sat, 28 Feb 2026 12:47:26 -0500
Message-ID: <20260228174750.1542406-735-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Ard Biesheuvel <ardb@kernel.org>

[ Upstream commit e00ac9e5afb5d80c0168ec88d8e8662a54af8249 ]

Dave reports that kexec may fail when the first kernel boots via the EFI
stub but without EFI runtime services, as in that case, the RSDP address
field in struct bootparams is never assigned. Kexec copies this value
into the version of struct bootparams that it provides to the incoming
kernel, which may have no other means to locate the ACPI root pointer.

So take the value from the EFI config tables if no root pointer has been
set in the first kernel's struct bootparams.

Fixes: a1b87d54f4e4 ("x86/efistub: Avoid legacy decompressor when doing EFI boot")
Cc: <stable@vger.kernel.org> # v6.1
Reported-by: Dave Young <dyoung@redhat.com>
Tested-by: Dave Young <dyoung@redhat.com>
Link: https://lore.kernel.org/linux-efi/aZQg_tRQmdKNadCg@darkstar.users.ipa.redhat.com/
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/kexec-bzimage64.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/x86/kernel/kexec-bzimage64.c b/arch/x86/kernel/kexec-bzimage64.c
index c3244ac680d14..f3b451eb49be1 100644
--- a/arch/x86/kernel/kexec-bzimage64.c
+++ b/arch/x86/kernel/kexec-bzimage64.c
@@ -192,6 +192,13 @@ setup_efi_state(struct boot_params *params, unsigned long params_load_addr,
 	struct efi_info *current_ei = &boot_params.efi_info;
 	struct efi_info *ei = &params->efi_info;
 
+	if (!params->acpi_rsdp_addr) {
+		if (efi.acpi20 != EFI_INVALID_TABLE_ADDR)
+			params->acpi_rsdp_addr = efi.acpi20;
+		else if (efi.acpi != EFI_INVALID_TABLE_ADDR)
+			params->acpi_rsdp_addr = efi.acpi;
+	}
+
 	if (!efi_enabled(EFI_RUNTIME_SERVICES))
 		return 0;
 
-- 
2.51.0

