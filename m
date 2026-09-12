Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E217035DA40;
	Sat, 12 Sep 2026 18:33:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789238016; cv=none; b=lbowSauQn3yP9bxsWF2X7wS5jfo6gBfuq+WUjZr7L7Cs+JGWDievjoHdF5iJFTyfSjVzTm7H0EpBxvW5N4a4zPkYL+hcVMClz6Y6Pc94GMcYDfow+qnjjYnza5N3HKITSf9zIB/b3z9Lg9pcscVwvjg4bZhVgdXfwN1MY+tZbUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789238016; c=relaxed/simple;
	bh=TYkPkuxzCjgTdwye8WC7InNXt99ROumig4vb7mTI3ho=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K+25YMZfTGkwM10GvhUTf9M+S8Wur+swmI7UHCdulB2qI5rIBm+GLs+mjgZLWgSqwYcAMwgbwaF3EFVaLsCdwjAWbi1tONJ8kX7jPNd+QQDoHG5bTNXfAlhFo4nyKhE5ey7oOyUTzZqx37HycWb2JWUk2XMCa21E9yPSS8/bB+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YL+w7376; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YL+w7376"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7FD41F000FF;
	Sat, 12 Sep 2026 18:33:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789238014;
	bh=46rCirSWciLWZ3D0MOxRbdXmO96tHF05QQJLzxC5Rn4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YL+w73769ebk/qqNypAqgo+R6+JQZWBCjEf+S6bUMt9sXjjm8d3fG3DfkeX5H3vcn
	 9MZBDTRhUdMcWZVwfEZylZxQrcyuasxAEw7j9udFdgPqeWcxy4xkdCI4lmLP3Q/TqU
	 Kr6zsL6W0yeng+KtU7azk6i1v1Dug+5Fp2A+N1Us=
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
Subject: [PATCH 5.15 376/935] x86/mm/ident_map: Use gbpages only where full GB page should be mapped.
Date: Sat, 12 Sep 2026 08:56:46 +0200
Message-ID: <20260912065535.440003659@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
2.53.0



