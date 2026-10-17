Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C8C33B4404;
	Sat, 17 Oct 2026 16:58:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792256329; cv=none; b=L08+D0T1IyUOeMBItOZR4oxMyjlGvXvOZvprzJuzLy7wxknC/szBvqTw/31zYiJk1aTo8tn95KIsNn8YCRbsV8rx6DLmOLM6j189j7kAx/21cUQsZGYftFVioWmpiz14et0veLFv/F73xE5KOapi8JWyUiIbiSyopL8dkjhttrI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792256329; c=relaxed/simple;
	bh=WXnwgcWMA6K2Z2H6wghBnVax3xGyyf0fq10HYrb/z3Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qu222KpOzI3DYBn820XmeORUSdNaKGQkuhv6tdGCwrk/bzwRn91SKj0JuXwBAp6Bqv4EowUofjYT4wqKTHN+6RKTiaAdRNUMgLyzLA4DnfynwPwXzdKXWQ48RCsVzpf6w+qS2iNAa6PTjMaJnjuawpHE3jtOL1rhR/Eabeu8RTs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S34E6M1j; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S34E6M1j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6163B1F000C4;
	Sat, 17 Oct 2026 16:58:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792256327;
	bh=HibdkvhkbHa+rS/lGFvI2MfHHOU6nMHvxVaNRrtg2zA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=S34E6M1jrDZmBZKPkiX//CtevRNTIPub9Ur5h5XxkA1AjF4jePzYCk9AF6gWX4zSD
	 d9Wwa53AVvbis42qBRYY/iMAe2UGuLUMjL+zlJtqRw+3kxIq561r/VDYnnpPcABbIr
	 c2Kd5FgydnDtIuE8K/Go87umLegcSz2BrtZC+W2c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0163/1674] mm/damon/vaddr: avoid hw-driven pte updates during damon_hugetlb_mkold()
Date: Sat, 17 Oct 2026 17:40:35 +0200
Message-ID: <20261017160435.346201814@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: SJ Park <sj@kernel.org>

[ Upstream commit 39c0ceedd54557bdc1542de08d22b2ed33e534e4 ]

damon_hugetlb_mkold() reads the page table entry into a local variable,
unsets the accessed bit in the variable, and updates the page table entry
with the updated variable value.  If hardware updates the same page table
entry in parallel, the hw updates could be lost.  For example,
hardware-updated dirty bits might be lost.

Avoid the parallel updates by clearing the page table entry when reading
it together, using huge_ptep_get_and_clear().  If a parallel write to the
memory is made after the clearing, the hw will see the page table entry is
cleared, trigger page fault and wait until it is handled.  The page fault
handling will wait for damon_hugetlb_mkold() due to the page table lock.

Because hugetlbfs is an in-memory file system and hugetlb pages cannot be
reclaimed, no critical issue is expected to my best knowledge.  But
definitely this is a nasty bug that should be fixed sooner rather than
later.

The issue was discovered [1] by Sashiko.

Link: https://lore.kernel.org/20260907170358.100168-1-sj@kernel.org
Link: https://lore.kernel.org/20260830160545.98969-1-sj@kernel.org [1]
Fixes: 49f4203aae06 ("mm/damon: add access checking for hugetlb pages")
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: <stable@vger.kernel.org> # 5.17.x
[ preserved CONFIG_MMU_NOTIFIER guards because this branch lacks the mmu_notifier_clear_young() fallback. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/damon/vaddr.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/mm/damon/vaddr.c b/mm/damon/vaddr.c
index c74b3fd1d227a..0a9812eb1047b 100644
--- a/mm/damon/vaddr.c
+++ b/mm/damon/vaddr.c
@@ -347,6 +347,7 @@ static void damon_hugetlb_mkold(pte_t *pte, struct mm_struct *mm,
 
 	if (pte_young(entry)) {
 		referenced = true;
+		entry = huge_ptep_get_and_clear(mm, addr, pte, psize);
 		entry = pte_mkold(entry);
 		set_huge_pte_at(mm, addr, pte, entry, psize);
 	}
-- 
2.53.0



