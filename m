Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FF77374A12;
	Sat, 12 Sep 2026 09:22:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789204921; cv=none; b=R8trXUD90fF/9TbHpBnFMPMi66gpafWOM7RT64DBptwXs8Y6LXDqKoXB31Um+I6kyf43+OTVhfaqkAqAdp9XXs7+zcJsCuYphrT+zm+WSmsum7bWdLlSbBZVtmo1SC7uFHDqmwSMD15KaE/6OrpjxXDi6/S0attWXXb2WHF2gcA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789204921; c=relaxed/simple;
	bh=aJg1rNzy4AralSPRSxutL1VeX9rZA+LyYqo9ZCMrxGQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PZIrmXYIb8kKNlaUSYBxUroGi4ly5XfE70Nm1ec+ZlN83Y5yUrcrpYEtynW24u5JQTIFlbD0kzEbyEdIHSFswL8cu+jkyihwWuzUScoSyecEFnxs16sGGdiuVRcm71CQ3+KSQLX/GHc71koJEQQGX0OrwYnyjJEmbHezbqt+hhM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vzStB7sz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vzStB7sz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 016141F00898;
	Sat, 12 Sep 2026 09:21:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789204920;
	bh=iMj2tURFZnqMdBn0/hOl+mP7GfPX1HRHkBashTIt9QU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vzStB7szz0BMlgCvs8QmErq9l2gIrJ+7UTa3qpgD4xvq9Q8rBI3VSTUyMwqfpaIwe
	 7Nz/PqMWV2sJoZ1nUwr0aaEHY3u8sxO9bdEEZFcHhTdm1M7OajGtSKCmZoA4YI8vPf
	 332zrDtH43az90GCcElf+RKwqmugkmBHcs5jTZ/I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wei-Lin Chang <weilin.chang@arm.com>,
	Marc Zyngier <maz@kernel.org>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1712/1815] arm64: ptdump: Make note_page_flush() range aware
Date: Sat, 12 Sep 2026 08:57:42 +0200
Message-ID: <20260912065729.165805218@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wei-Lin Chang <weilin.chang@arm.com>

[ Upstream commit 902caade3cfd60f99bf71b355e7c86344bd831e5 ]

note_page_flush() calls note_page() with addr == 0 and level == -1 to
dump the last row of a ptdump. addr == 0 (1 << 64 wrapped around)
renders a huge region with enormous size for address spaces with
IA bits < 64. For example the stage-2 page tables and the EFI runtime
page table.

More importantly, the last region of the address space and everything
after the address space up to 1 << 64 are merged into one row of
output. If the last region within the address space is valid, it will
appear to remain valid up to 1 << 64 with the same attributes.

Currently only the EFI runtime ptdump is affected by this, but KVM will
soon fix its stage-2 ptdump by using note_page_flush(). Here is an
example of an EFI runtime ptdump (last row):

0x0000008000000000-0x0000000000000000   17179868672G PGD

With this patch:

0x0000008000000000-0x0001000000000000      261632G PGD

To fix this, cache the end address of a ptdump in ptdump_pg_state so
note_page_flush() can call the final note_page() with the correct end
address.

Fixes: 9d80448ac92b ("efi/arm64: Add debugfs node to dump UEFI runtime page tables")
Signed-off-by: Wei-Lin Chang <weilin.chang@arm.com>
Reviewed-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/include/asm/ptdump.h |  2 ++
 arch/arm64/mm/ptdump.c          | 14 +++++++++++++-
 2 files changed, 15 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/ptdump.h b/arch/arm64/include/asm/ptdump.h
index 50a195eda8ed2..3aa8fa2fcec76 100644
--- a/arch/arm64/include/asm/ptdump.h
+++ b/arch/arm64/include/asm/ptdump.h
@@ -50,6 +50,8 @@ struct ptdump_pg_state {
 	const struct addr_marker *marker;
 	const struct mm_struct *mm;
 	unsigned long start_address;
+	/* exclusive end, ULONG_MAX represents an end at 1 << 64 */
+	unsigned long end_address;
 	int level;
 	ptval_t current_prot;
 	bool check_wx;
diff --git a/arch/arm64/mm/ptdump.c b/arch/arm64/mm/ptdump.c
index 5a76c59b5ada5..9d9bcb6738f4c 100644
--- a/arch/arm64/mm/ptdump.c
+++ b/arch/arm64/mm/ptdump.c
@@ -278,9 +278,19 @@ void note_page_pgd(struct ptdump_state *pt_st, unsigned long addr, pgd_t pgd)
 
 void note_page_flush(struct ptdump_state *pt_st)
 {
+	struct ptdump_pg_state *st = container_of(pt_st, struct ptdump_pg_state, ptdump);
+	unsigned long end = st->end_address;
 	pte_t pte_zero = {0};
 
-	note_page(pt_st, 0, -1, pte_val(pte_zero));
+	/*
+	 * Address spaces that end at 1 << 64 have end_address == ULONG_MAX,
+	 * but note_page() expects the exclusive end. In this case adjust end
+	 * to the wraparound value 0.
+	 */
+	if (end == ULONG_MAX)
+		end = 0;
+
+	note_page(pt_st, end, -1, pte_val(pte_zero));
 }
 
 void ptdump_walk(struct seq_file *s, struct ptdump_info *info)
@@ -296,6 +306,7 @@ void ptdump_walk(struct seq_file *s, struct ptdump_info *info)
 		.marker = info->markers,
 		.mm = info->mm,
 		.pg_level = &kernel_pg_levels[0],
+		.end_address = end,
 		.level = -1,
 		.ptdump = {
 			.note_page_pte = note_page_pte,
@@ -337,6 +348,7 @@ bool ptdump_check_wx(void)
 			{ -1, NULL},
 		},
 		.pg_level = &kernel_pg_levels[0],
+		.end_address = ~0UL,
 		.level = -1,
 		.check_wx = true,
 		.ptdump = {
-- 
2.53.0



