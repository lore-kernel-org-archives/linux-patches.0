Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0178028CF64;
	Wed, 23 Apr 2025 15:26:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745421987; cv=none; b=ny0sRdLbcqYQzBmj5cSHmKMYQlmBlEPzRxxqywj9FHLVO0I/28obiBsmGGvhcrc1RSkia4sKPTFW2S1bds9hqyazZlfITThD952v07xC6DOQtVzKRuFYnSlx7WNw3+SWov+MQ2udqQ/uEBBWaU5R8JeCO68rYvvxf3f1MKNYeZs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745421987; c=relaxed/simple;
	bh=AKBrkWGm2AZHx6Br4W7WfvRgLJ1O4Wi4nd75NAvE+0c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TQ6ISqRSk/aFaeZeFzI6JTJxap3F6TcFC/GfUK3syBjLAMAu31NF5o9rqOsmsnreNf2rMYpMZKa2h5DIp9tzPiKwWMPi6HUTmncthyd8XuHA3UelWWx4YlR4BJBYyZQGMH9hTNXZm+HTulgxtGIYTGMHF3r70VSCTXuLfF4a0Aw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ljchWsQC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ljchWsQC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 886FDC4CEE2;
	Wed, 23 Apr 2025 15:26:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745421986;
	bh=AKBrkWGm2AZHx6Br4W7WfvRgLJ1O4Wi4nd75NAvE+0c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ljchWsQC2iOvK4jys3kgj7ppvHhAZsUyJsVYnDvIApnmB4Srekm/7jxJEC5xCo2J8
	 ZeR5Q6KZTWw4AGV7gxUFalNvHEi1ja54QnPyj5IVuupe35AYIXP78ondYdzNqQlFhm
	 0x2QTqPCnI2+OlxSc0YkpnA8gwX2iDhXpAscyojA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Roberto Ricci <io@r-ricci.it>,
	Myrrh Periwinkle <myrrhperiwinkle@qtmlabs.xyz>,
	Ingo Molnar <mingo@kernel.org>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Kees Cook <keescook@chromium.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	David Woodhouse <dwmw@amazon.co.uk>,
	Len Brown <len.brown@intel.com>
Subject: [PATCH 6.6 236/393] x86/e820: Fix handling of subpage regions when calculating nosave ranges in e820__register_nosave_regions()
Date: Wed, 23 Apr 2025 16:42:12 +0200
Message-ID: <20250423142653.135755841@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142643.246005366@linuxfoundation.org>
References: <20250423142643.246005366@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Myrrh Periwinkle <myrrhperiwinkle@qtmlabs.xyz>

commit f2f29da9f0d4367f6ff35e0d9d021257bb53e273 upstream.

While debugging kexec/hibernation hangs and crashes, it turned out that
the current implementation of e820__register_nosave_regions() suffers from
multiple serious issues:

 - The end of last region is tracked by PFN, causing it to find holes
   that aren't there if two consecutive subpage regions are present

 - The nosave PFN ranges derived from holes are rounded out (instead of
   rounded in) which makes it inconsistent with how explicitly reserved
   regions are handled

Fix this by:

 - Treating reserved regions as if they were holes, to ensure consistent
   handling (rounding out nosave PFN ranges is more correct as the
   kernel does not use partial pages)

 - Tracking the end of the last RAM region by address instead of pages
   to detect holes more precisely

These bugs appear to have been introduced about ~18 years ago with the very
first version of e820_mark_nosave_regions(), and its flawed assumptions were
carried forward uninterrupted through various waves of rewrites and renames.

[ mingo: Added Git archeology details, for kicks and giggles. ]

Fixes: e8eff5ac294e ("[PATCH] Make swsusp avoid memory holes and reserved memory regions on x86_64")
Reported-by: Roberto Ricci <io@r-ricci.it>
Tested-by: Roberto Ricci <io@r-ricci.it>
Signed-off-by: Myrrh Periwinkle <myrrhperiwinkle@qtmlabs.xyz>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Woodhouse <dwmw@amazon.co.uk>
Cc: Len Brown <len.brown@intel.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20250406-fix-e820-nosave-v3-1-f3787bc1ee1d@qtmlabs.xyz
Closes: https://lore.kernel.org/all/Z4WFjBVHpndct7br@desktop0a/
Signed-off-by: Myrrh Periwinkle <myrrhperiwinkle@qtmlabs.xyz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/e820.c |   17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

--- a/arch/x86/kernel/e820.c
+++ b/arch/x86/kernel/e820.c
@@ -753,22 +753,21 @@ void __init e820__memory_setup_extended(
 void __init e820__register_nosave_regions(unsigned long limit_pfn)
 {
 	int i;
-	unsigned long pfn = 0;
+	u64 last_addr = 0;
 
 	for (i = 0; i < e820_table->nr_entries; i++) {
 		struct e820_entry *entry = &e820_table->entries[i];
 
-		if (pfn < PFN_UP(entry->addr))
-			register_nosave_region(pfn, PFN_UP(entry->addr));
-
-		pfn = PFN_DOWN(entry->addr + entry->size);
-
 		if (entry->type != E820_TYPE_RAM && entry->type != E820_TYPE_RESERVED_KERN)
-			register_nosave_region(PFN_UP(entry->addr), pfn);
+			continue;
 
-		if (pfn >= limit_pfn)
-			break;
+		if (last_addr < entry->addr)
+			register_nosave_region(PFN_DOWN(last_addr), PFN_UP(entry->addr));
+
+		last_addr = entry->addr + entry->size;
 	}
+
+	register_nosave_region(PFN_DOWN(last_addr), limit_pfn);
 }
 
 #ifdef CONFIG_ACPI


