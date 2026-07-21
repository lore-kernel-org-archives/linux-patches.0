Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F0E9430CDC;
	Tue, 21 Jul 2026 19:54:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784663683; cv=none; b=kPogK2jvSW1hI60RLPWmwGYEEOmPECRBYoY/tXUTOqT943oj3Jy32nhdV2Gf3l/YVoJoTBKIxmcW0u3allNPMqoaajZPt86uNoXlaOP0fsrFP1MyVEyXax+6f7gNaQvJG0bo5uOssWI+Q6fHgyGG7/ZvWD36DYiqKv4hPW1CjmQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784663683; c=relaxed/simple;
	bh=5PgdvOlsvWKwjI7ynagnhc34mKeRuw8l0ly/wse7yOY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZWFnD5o6E8EWiZ4G6+QKm6fz1GwZ2UR91k6Z88ky6Cbw6dCQ+CcZuysq+MtAHU0KvXLRvLvaEhcIx4e7BOf//qVLHqn5wZH0GJsbLkfuck81Nv+QFQ8/ngu+aGI15ElxedWFYigoZOHn9ZE5EyHPBj2g+4hDFYrR7QfKK4mTmQ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pO8BiCdi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pO8BiCdi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 881611F000E9;
	Tue, 21 Jul 2026 19:54:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784663682;
	bh=7L/8T2yxIumH2ymrGILKV47GycJ47rafyPqmterBdX0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pO8BiCdiCxj8dl6BixWguV3bvZPZitVcQbhqfKvU+EFWkGt7coIjFR4rT+7mBdYrF
	 PqV3/1pzK7LnQXdy47O+CKRb/yskdkxFdBqybHRgS04gavHjrweif4TMs2CbWZTHbC
	 RisR7j9JwZerjYmXVdPDWoepGAwxO6ZGHapMo+aE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@linux.dev>,
	"Borislav Petkov (AMD)" <bp@alien8.de>
Subject: [PATCH 6.12 0878/1276] x86/boot: Reject too long acpi_rsdp= values
Date: Tue, 21 Jul 2026 17:22:01 +0200
Message-ID: <20260721152505.700715447@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thorsten Blum <thorsten.blum@linux.dev>

commit d130041a7b96f79cd4c7079a6c2431a6db4c9619 upstream.

cmdline_find_option() returns the full length of the parsed acpi_rsdp=
value. get_cmdline_acpi_rsdp() then silently truncates values which do
not fit in the val[] buffer.

Prevent boot_kstrtoul() from parsing a truncated value and then the
kernel from silently using the wrong RSDP address, see discussion in
Link:.

Issue a warning so that the user is aware that s/he supplied a malformed
value and can get feedback instead of silent crashes.

  [ bp: Make commit message more precise. ]

Fixes: 3c98e71b42a7 ("x86/boot: Add "acpi_rsdp=" early parsing")
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/all/20260617130417.36651-4-thorsten.blum@linux.dev
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/boot/compressed/acpi.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/arch/x86/boot/compressed/acpi.c
+++ b/arch/x86/boot/compressed/acpi.c
@@ -184,10 +184,15 @@ static unsigned long get_cmdline_acpi_rs
 	char val[MAX_ADDR_LEN] = { };
 	int ret;
 
-	ret = cmdline_find_option("acpi_rsdp", val, MAX_ADDR_LEN);
+	ret = cmdline_find_option("acpi_rsdp", val, sizeof(val));
 	if (ret < 0)
 		return 0;
 
+	if (ret >= sizeof(val)) {
+		warn("acpi_rsdp= value too long; ignoring");
+		return 0;
+	}
+
 	if (boot_kstrtoul(val, 16, &addr))
 		return 0;
 #endif


