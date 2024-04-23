Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCC94146586;
	Tue, 23 Apr 2024 21:42:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908577; cv=none; b=VUcznMycMf+CcWiVAZosVoNv9ua5HVYjO/3jkGc5zPTOqMPdBHT+ySM42ICtrag7ftjFyGARcXMz1j+wi4BL4+DLiWarxNsSp2E5/5JqDbAAiTyjutLgzB8lz2Qo0pDEKqFOUaKd4e05f/tf3HgsMGHeTaMWehUdJ75HrV1xBjw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908577; c=relaxed/simple;
	bh=EV4VYrsqVZLxGTOy3B6WJAhcz3eFFen+xoQpAGHfD9c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rwMufr/9fOgknEFfBbBOxzP7nGfFIOFogrGptub9WOWmEB2TAzQnfSu3G88iLU/n5DBTR5p4LyqJBkc9VJq9lOXmT7Eyrh9gkZpRY6LVq8hl0/E7jLY1OZDoxbDM0R2x0ZwZXuuCcn7t4kuiLJcaqnDoUf0FvJ/u2rQ/TIe04qo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JH6FP0jd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JH6FP0jd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1C32C32786;
	Tue, 23 Apr 2024 21:42:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908576;
	bh=EV4VYrsqVZLxGTOy3B6WJAhcz3eFFen+xoQpAGHfD9c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JH6FP0jdVQLT2WM1Hu0pwnuys9LLvX5MtiBoQnpgMYw5tMSUQBkX1Ob9nyrjhdMNe
	 Z/zJZLywAc7Knn3KNHYIhkQp+sdxjCiTPoT/upeTYWqF4J+ev2eGTyZUYydlN9+H5Y
	 YLRXQSadsyurq73Z9XZmUHgfi/nAG9FHpPrfxP0k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oliver Upton <oliver.upton@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Marc Zyngier <maz@kernel.org>
Subject: [PATCH 6.6 030/158] arm64/mm: Modify range-based tlbi to decrement scale
Date: Tue, 23 Apr 2024 14:37:47 -0700
Message-ID: <20240423213856.722796462@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213855.696477232@linuxfoundation.org>
References: <20240423213855.696477232@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ryan Roberts <ryan.roberts@arm.com>

commit e2768b798a197318736f00c506633cb78ff77012 upstream.

In preparation for adding support for LPA2 to the tlb invalidation
routines, modify the algorithm used by range-based tlbi to start at the
highest 'scale' and decrement instead of starting at the lowest 'scale'
and incrementing. This new approach makes it possible to maintain 64K
alignment as we work through the range, until the last op (at scale=0).
This is required when LPA2 is enabled. (This part will be added in a
subsequent commit).

This change is separated into its own patch because it will also impact
non-LPA2 systems, and I want to make it easy to bisect in case it leads
to performance regression (see below for benchmarks that suggest this
should not be a problem).

The original commit (d1d3aa98 "arm64: tlb: Use the TLBI RANGE feature in
arm64") stated this as the reason for _incrementing_ scale:

  However, in most scenarios, the pages = 1 when flush_tlb_range() is
  called. Start from scale = 3 or other proper value (such as scale
  =ilog2(pages)), will incur extra overhead. So increase 'scale' from 0
  to maximum.

But pages=1 is already special cased by the non-range invalidation path,
which will take care of it the first time through the loop (both in the
original commit and in my change), so I don't think switching to
decrement scale should have any extra performance impact after all.

Indeed benchmarking kernel compilation, a TLBI-heavy workload, suggests
that this new approach actually _improves_ performance slightly (using a
virtual machine on Apple M2):

Table shows time to execute kernel compilation workload with 8 jobs,
relative to baseline without this patch (more negative number is
bigger speedup). Repeated 9 times across 3 system reboots:

| counter   |       mean |     stdev |
|:----------|-----------:|----------:|
| real-time |      -0.6% |      0.0% |
| kern-time |      -1.6% |      0.5% |
| user-time |      -0.4% |      0.1% |

Reviewed-by: Oliver Upton <oliver.upton@linux.dev>
Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20231127111737.1897081-2-ryan.roberts@arm.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/include/asm/tlbflush.h |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

--- a/arch/arm64/include/asm/tlbflush.h
+++ b/arch/arm64/include/asm/tlbflush.h
@@ -351,14 +351,14 @@ static inline void arch_tlbbatch_flush(s
  * entries one by one at the granularity of 'stride'. If the TLB
  * range ops are supported, then:
  *
- * 1. If 'pages' is odd, flush the first page through non-range
- *    operations;
+ * 1. The minimum range granularity is decided by 'scale', so multiple range
+ *    TLBI operations may be required. Start from scale = 3, flush the largest
+ *    possible number of pages ((num+1)*2^(5*scale+1)) that fit into the
+ *    requested range, then decrement scale and continue until one or zero pages
+ *    are left.
  *
- * 2. For remaining pages: the minimum range granularity is decided
- *    by 'scale', so multiple range TLBI operations may be required.
- *    Start from scale = 0, flush the corresponding number of pages
- *    ((num+1)*2^(5*scale+1) starting from 'addr'), then increase it
- *    until no pages left.
+ * 2. If there is 1 page remaining, flush it through non-range operations. Range
+ *    operations can only span an even number of pages.
  *
  * Note that certain ranges can be represented by either num = 31 and
  * scale or num = 0 and scale + 1. The loop below favours the latter
@@ -368,12 +368,12 @@ static inline void arch_tlbbatch_flush(s
 				asid, tlb_level, tlbi_user)		\
 do {									\
 	int num = 0;							\
-	int scale = 0;							\
+	int scale = 3;							\
 	unsigned long addr;						\
 									\
 	while (pages > 0) {						\
 		if (!system_supports_tlb_range() ||			\
-		    pages % 2 == 1) {					\
+		    pages == 1) {					\
 			addr = __TLBI_VADDR(start, asid);		\
 			__tlbi_level(op, addr, tlb_level);		\
 			if (tlbi_user)					\
@@ -393,7 +393,7 @@ do {									\
 			start += __TLBI_RANGE_PAGES(num, scale) << PAGE_SHIFT; \
 			pages -= __TLBI_RANGE_PAGES(num, scale);	\
 		}							\
-		scale++;						\
+		scale--;						\
 	}								\
 } while (0)
 


