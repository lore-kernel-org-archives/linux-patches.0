Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12C9A446C9;
	Tue, 20 Feb 2024 21:38:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708465095; cv=none; b=AG5RoU8pYIQheuzYyq2ijNk4/I0it6f8zYspjlb7175LeIuZW1Ey2/s4SxHCU2sEF4YoG5L1eBxV9grbHElLHff6DbYUCRWO9/f8TATHs9NW1FLRdAYGSEEIv8/F5pyhOoN742kKnhJlwjjo9NeMrTKsdRQ4pFl/M+EzeZLSRBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708465095; c=relaxed/simple;
	bh=qSglAj94h3vPXXHkfs5TiY2K6CNadqTGidPVvPnX2AY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WywnrdkAYwSnsE2VUdvvKZmQFJyoC20ZzI6t/PSgdpqfp51gOcZblWo9Y3id46G0tK18hkvxstkFwe0o+nLthnI7bAyVK4/Yxj634ksbnG5MYoEl8lougIWanIwfnuTU3J0AaQKM9uIIHIZtqMpA61ity/tV25urmewhdPugI+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m43ThUcU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m43ThUcU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86A61C433C7;
	Tue, 20 Feb 2024 21:38:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708465094;
	bh=qSglAj94h3vPXXHkfs5TiY2K6CNadqTGidPVvPnX2AY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m43ThUcUI0n5AvspdnRHc2LvNzcNAqkohsjLFlC++YCJIXekDl3Ue0sUuENQk64t+
	 BQsVEhTsXPsjmhYbykRhrFh90Jfql1+bJY35rNgYe69uTL1l5amgxIAiJfSjRrld6U
	 aQiYoNlzPZvJbzJANVcT4inpQOoDlT3tKkKw8sKo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Steve Wahl <steve.wahl@hpe.com>,
	Dave Hansen <dave.hansen@linux.intel.com>
Subject: [PATCH 6.7 235/309] x86/mm/ident_map: Use gbpages only where full GB page should be mapped.
Date: Tue, 20 Feb 2024 21:56:34 +0100
Message-ID: <20240220205640.505488441@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205633.096363225@linuxfoundation.org>
References: <20240220205633.096363225@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steve Wahl <steve.wahl@hpe.com>

commit d794734c9bbfe22f86686dc2909c25f5ffe1a572 upstream.

When ident_pud_init() uses only gbpages to create identity maps, large
ranges of addresses not actually requested can be included in the
resulting table; a 4K request will map a full GB.  On UV systems, this
ends up including regions that will cause hardware to halt the system
if accessed (these are marked "reserved" by BIOS).  Even processor
speculation into these regions is enough to trigger the system halt.

Only use gbpages when map creation requests include the full GB page
of space.  Fall back to using smaller 2M pages when only portions of a
GB page are included in the request.

No attempt is made to coalesce mapping requests. If a request requires
a map entry at the 2M (pmd) level, subsequent mapping requests within
the same 1G region will also be at the pmd level, even if adjacent or
overlapping such requests could have been combined to map a full
gbpage.  Existing usage starts with larger regions and then adds
smaller regions, so this should not have any great consequence.

[ dhansen: fix up comment formatting, simplifty changelog ]

Signed-off-by: Steve Wahl <steve.wahl@hpe.com>
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/all/20240126164841.170866-1-steve.wahl%40hpe.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/mm/ident_map.c |   23 ++++++++++++++++++-----
 1 file changed, 18 insertions(+), 5 deletions(-)

--- a/arch/x86/mm/ident_map.c
+++ b/arch/x86/mm/ident_map.c
@@ -26,18 +26,31 @@ static int ident_pud_init(struct x86_map
 	for (; addr < end; addr = next) {
 		pud_t *pud = pud_page + pud_index(addr);
 		pmd_t *pmd;
+		bool use_gbpage;
 
 		next = (addr & PUD_MASK) + PUD_SIZE;
 		if (next > end)
 			next = end;
 
-		if (info->direct_gbpages) {
-			pud_t pudval;
+		/* if this is already a gbpage, this portion is already mapped */
+		if (pud_large(*pud))
+			continue;
+
+		/* Is using a gbpage allowed? */
+		use_gbpage = info->direct_gbpages;
 
-			if (pud_present(*pud))
-				continue;
+		/* Don't use gbpage if it maps more than the requested region. */
+		/* at the begining: */
+		use_gbpage &= ((addr & ~PUD_MASK) == 0);
+		/* ... or at the end: */
+		use_gbpage &= ((next & ~PUD_MASK) == 0);
+
+		/* Never overwrite existing mappings */
+		use_gbpage &= !pud_present(*pud);
+
+		if (use_gbpage) {
+			pud_t pudval;
 
-			addr &= PUD_MASK;
 			pudval = __pud((addr - info->offset) | info->page_flag);
 			set_pud(pud, pudval);
 			continue;


