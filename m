Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D33F72512E9;
	Tue, 20 May 2025 14:19:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747750742; cv=none; b=XXmvLk55erd1b92yn38AvXFfUWM/MMLcubU33HriY2c0sNoVdL2dzwBuK8NC6vOpsWOOFZVrugoQJgpfp9a76b8f8ltw2h2Yc0vO8FAyNxcm2yfFTjn4duN0xZLF0Zf/5kDMg5ho+vW5kEfVtxwPTdLyj5KRIXz3fArIMMch1Tg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747750742; c=relaxed/simple;
	bh=8bdRJ4oLSxq76BQvy8tMflB/oevOc4yb3VOIlib820w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qq3+N42FG61ZGyl2mG0+7eIHUxJwdyiLQeqLCKCfjiNtAHxNiKj5yboosY4kG0lfZXv6MI5Q1HhjA4M4wRW9hFoutnPLQGccozSddeo22t1JE3LeAuH8I2waFk/Cnxai4FU0SYGI0Ba4SvlQl1O4K9Skf7eNpZSx4v5OEJi+xwo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1PMLQx23; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1PMLQx23"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 510B0C4CEEA;
	Tue, 20 May 2025 14:19:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747750742;
	bh=8bdRJ4oLSxq76BQvy8tMflB/oevOc4yb3VOIlib820w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1PMLQx23MEzyLXjS2j9C+uMwN6DK83ma3C3Oy3SI3I6XCrqjQ1EF/XW4/d0ITOhYD
	 T97SsJv+tiqDnk9XYRn9Mpj2LfPlG8cC/m1jti3VkScapwc8XzHNDgoSqA1925IuuL
	 EEybPifl3FPwUH5ma0R6PeMGsRTiWYsM/eg5PW2M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ashish Kalra <ashish.kalra@amd.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Srikanth Aithal <sraithal@amd.com>
Subject: [PATCH 6.14 105/145] x86/sev: Make sure pages are not skipped during kdump
Date: Tue, 20 May 2025 15:51:15 +0200
Message-ID: <20250520125814.673418179@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125810.535475500@linuxfoundation.org>
References: <20250520125810.535475500@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ashish Kalra <ashish.kalra@amd.com>

commit 82b7f88f2316c5442708daeb0b5ec5aa54c8ff7f upstream.

When shared pages are being converted to private during kdump, additional
checks are performed. They include handling the case of a GHCB page being
contained within a huge page.

Currently, this check incorrectly skips a page just below the GHCB page from
being transitioned back to private during kdump preparation.

This skipped page causes a 0x404 #VC exception when it is accessed later while
dumping guest memory for vmcore generation.

Correct the range to be checked for GHCB contained in a huge page.  Also,
ensure that the skipped huge page containing the GHCB page is transitioned
back to private by applying the correct address mask later when changing GHCBs
to private at end of kdump preparation.

  [ bp: Massage commit message. ]

Fixes: 3074152e56c9 ("x86/sev: Convert shared memory back to private on kexec")
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
Tested-by: Srikanth Aithal <sraithal@amd.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/20250506183529.289549-1-Ashish.Kalra@amd.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/coco/sev/core.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/arch/x86/coco/sev/core.c b/arch/x86/coco/sev/core.c
index 41060ba41b5c..36beaac713c1 100644
--- a/arch/x86/coco/sev/core.c
+++ b/arch/x86/coco/sev/core.c
@@ -1101,7 +1101,8 @@ static void unshare_all_memory(void)
 			data = per_cpu(runtime_data, cpu);
 			ghcb = (unsigned long)&data->ghcb_page;
 
-			if (addr <= ghcb && ghcb <= addr + size) {
+			/* Handle the case of a huge page containing the GHCB page */
+			if (addr <= ghcb && ghcb < addr + size) {
 				skipped_addr = true;
 				break;
 			}
@@ -1213,8 +1214,8 @@ static void shutdown_all_aps(void)
 void snp_kexec_finish(void)
 {
 	struct sev_es_runtime_data *data;
+	unsigned long size, addr;
 	unsigned int level, cpu;
-	unsigned long size;
 	struct ghcb *ghcb;
 	pte_t *pte;
 
@@ -1242,8 +1243,10 @@ void snp_kexec_finish(void)
 		ghcb = &data->ghcb_page;
 		pte = lookup_address((unsigned long)ghcb, &level);
 		size = page_level_size(level);
-		set_pte_enc(pte, level, (void *)ghcb);
-		snp_set_memory_private((unsigned long)ghcb, (size / PAGE_SIZE));
+		/* Handle the case of a huge page containing the GHCB page */
+		addr = (unsigned long)ghcb & page_level_mask(level);
+		set_pte_enc(pte, level, (void *)addr);
+		snp_set_memory_private(addr, (size / PAGE_SIZE));
 	}
 }
 
-- 
2.49.0



