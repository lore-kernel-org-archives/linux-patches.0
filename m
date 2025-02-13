Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 839A51D61AA;
	Thu, 13 Feb 2025 15:36:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739460995; cv=none; b=ouTmW9eJI+sNV6LvYFHY49MErVD+MHrn6EEno/9vAL20jwuAspTP+i7q5hJcAkHJjH2/l4Hp7QHHowvsE9pyHhSogJgkAk8MpLLw69wWSLpspfdPdjsU8lW9SQF8+hmapSGWg3ut44YQBI1lOF8cmPRuUTxMMxjVRb0CmnfWm/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739460995; c=relaxed/simple;
	bh=DuURNURwja/8O4mGlilQ6A8VGNIK55B7BPdPGMY7M7E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ux6RNp1DGf3QuJmXBZAm/il6zSVh3W/9CxfsPE51bmp4k+ODiBAXeeJUFKN7ZPpfPC7mNMdlxvhcwC9uFtDe1ksKwkBkgq0PoNVU/ftfP01E7pli/Xmcp0N7whinbE4IfMMPR/UwvM405P+TgfxTodN2GQapnCVTh38A1B/ADqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0RYx3QuC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0RYx3QuC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E42D4C4CED1;
	Thu, 13 Feb 2025 15:36:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739460995;
	bh=DuURNURwja/8O4mGlilQ6A8VGNIK55B7BPdPGMY7M7E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0RYx3QuC7GqHjNgY7nvXPcFBjrCJeUreqlgI4QEGzI9ZAqSqS++aS2AQA4dhpu+WS
	 oOR97aKOrLxwTq1Q+NxMOkVGJHmJ/4hmjbrkplsEHEfbzG5UJ+vwP9B5KnU1VFEG/x
	 IKO2224ajv50JUSc1I1ekpMKZuPcObXmuAJmEIRc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Steve Wahl <steve.wahl@hpe.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Pavin Joseph <me@pavinjoseph.com>,
	Sarah Brofeldt <srhb@dbc.dk>,
	Eric Hagberg <ehagberg@gmail.com>
Subject: [PATCH 6.6 270/273] x86/mm/ident_map: Use gbpages only where full GB page should be mapped.
Date: Thu, 13 Feb 2025 15:30:42 +0100
Message-ID: <20250213142418.092022439@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142407.354217048@linuxfoundation.org>
References: <20250213142407.354217048@linuxfoundation.org>
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

From: Steve Wahl <steve.wahl@hpe.com>

commit cc31744a294584a36bf764a0ffa3255a8e69f036 upstream.

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


