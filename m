Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EDDD46D0A4;
	Tue, 21 Jul 2026 18:29:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784658559; cv=none; b=CQcvHGAvmds7Mwy/KJbm76ZRGfqmrQMdsw+I4xIg2ojA3JZLP1MtryHtLBDbjp5UJ4Td60nM8ybkJ5kHlC0hKjayNAFquJxJg/CWk/+Oh5hnmUwqvW+229cW+zCdi9Pr2Yz/LCEjQCr9dpaMhxboldZPgT+qVMEnjKB+K9ja6lg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784658559; c=relaxed/simple;
	bh=JgplKLEcgfSOpcXohCTIBoRCHw4xgNA0RZd+InDkM4s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tT/WGBQg47SiRPjLMecBkpmUcPyL0geRdEVW+e1a2+peKQa0QHZeHpl2pBvHteL8C8bH8YXed+xlchuEJqufhTnS7z8j+dNwVbVFsyyeRbKAWl8tdb4C6/Hw1ntRN7EXCWwmp2gU3gKsz7SAH9nHOXShD1FurgDjvPJnAxpCrYs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Lu+KzH1I; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Lu+KzH1I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4C471F000E9;
	Tue, 21 Jul 2026 18:29:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784658558;
	bh=B0qZdksHA80AAhMAEiLv7AieGet1Fg5CUGILTQvFTYk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Lu+KzH1I0ZRn9DFcVypn2Oq1yH5HFpvTVgrEcfAQlPlhmaSSCZDXZAeC5KtCZeLKb
	 6CMBgH8WSu+shopX+UxFC6AJBixf650ZB0ZkyQ2tr3trcb0USNaIIXVBH0SjIOJZHr
	 Fza+vNYkwPAcmn5nRvh2MwLJGRZWMxfvfWIZsszo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@linux.dev>,
	"Borislav Petkov (AMD)" <bp@alien8.de>
Subject: [PATCH 6.18 1188/1611] x86/boot: Reject too long acpi_rsdp= values
Date: Tue, 21 Jul 2026 17:21:44 +0200
Message-ID: <20260721152542.154491271@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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


