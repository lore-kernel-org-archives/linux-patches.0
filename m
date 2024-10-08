Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0C881DF720;
	Tue,  8 Oct 2024 12:19:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728389981; cv=none; b=rkRJTal43iunWVaBqrsrWXQXzigMdH2yhP3j204/ia6Q2hvt7vO7LEPazbwqRODS3xO5UQY+y/QZQSG+I7bGwsgTYjkKP0lvUl9ounTPeK8RPINQy9lIvCwNPckkkPBhtbHrqrjZJJyy3uzvhElvjdEpQdd0YesyIxuSnks8AMY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728389981; c=relaxed/simple;
	bh=e+UOOwUgaSAGwvZ95Qe6qANAJLjWZxbuBgBE3VI23eI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aVKzSL2n8CFxe3Mr8YtUQt6dwwPX0vIP5T6lJj2NFjP/f0xurRPJHAxC4UWD7NUx5qpcp99/7EX/vNA7/Zp4+Irqc5H92c9fBJcH3E3TmJhnWJR9ypcSqoXw3lXz1EbYbkyk8xbEAm6WoPq/laHc3odEmQRH1Xiia57WkOyRzos=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jbEGCTLy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jbEGCTLy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CB88C4CECC;
	Tue,  8 Oct 2024 12:19:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728389981;
	bh=e+UOOwUgaSAGwvZ95Qe6qANAJLjWZxbuBgBE3VI23eI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jbEGCTLyICZ4Fk5N5whovoe1RgUHmS5MfEymiJHmb9bTR89VIbQ2uHSDyBWsOzuWr
	 iX/5ahPPsm4qMGuAbNDnC2qHKHCfYnlLmVA2P3Hthmq/B4xdfM1+OdLsw4d8vM6bFr
	 ShZmmEZyqyWh2/1qEA8jCmyJ0MLDaesK8oH3xBrU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Steve Wahl <steve.wahl@hpe.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Pavin Joseph <me@pavinjoseph.com>,
	Sarah Brofeldt <srhb@dbc.dk>,
	Eric Hagberg <ehagberg@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 153/482] x86/mm/ident_map: Use gbpages only where full GB page should be mapped.
Date: Tue,  8 Oct 2024 14:03:36 +0200
Message-ID: <20241008115654.327782334@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115648.280954295@linuxfoundation.org>
References: <20241008115648.280954295@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steve Wahl <steve.wahl@hpe.com>

[ Upstream commit cc31744a294584a36bf764a0ffa3255a8e69f036 ]

When ident_pud_init() uses only GB pages to create identity maps, large
ranges of addresses not actually requested can be included in the resulting
table; a 4K request will map a full GB.  This can include a lot of extra
address space past that requested, including areas marked reserved by the
BIOS.  That allows processor speculation into reserved regions, that on UV
systems can cause system halts.

Only use GB pages when map creation requests include the full GB page of
space.  Fall back to using smaller 2M pages when only portions of a GB page
are included in the request.

No attempt is made to coalesce mapping requests. If a request requires a
map entry at the 2M (pmd) level, subsequent mapping requests within the
same 1G region will also be at the pmd level, even if adjacent or
overlapping such requests could have been combined to map a full GB page.
Existing usage starts with larger regions and then adds smaller regions, so
this should not have any great consequence.

Signed-off-by: Steve Wahl <steve.wahl@hpe.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Tested-by: Pavin Joseph <me@pavinjoseph.com>
Tested-by: Sarah Brofeldt <srhb@dbc.dk>
Tested-by: Eric Hagberg <ehagberg@gmail.com>
Link: https://lore.kernel.org/all/20240717213121.3064030-3-steve.wahl@hpe.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/mm/ident_map.c | 23 ++++++++++++++++++-----
 1 file changed, 18 insertions(+), 5 deletions(-)

diff --git a/arch/x86/mm/ident_map.c b/arch/x86/mm/ident_map.c
index 968d7005f4a72..a204a332c71fc 100644
--- a/arch/x86/mm/ident_map.c
+++ b/arch/x86/mm/ident_map.c
@@ -26,18 +26,31 @@ static int ident_pud_init(struct x86_mapping_info *info, pud_t *pud_page,
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
+		if (pud_leaf(*pud))
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
-- 
2.43.0



