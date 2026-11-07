Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063152;
	b=RlX4GOt79ZDC0uzyUo+ktbI1lLrmkISSGr4nTh95OkfcKc5AXisLv9s9k1wBXoLvTIck
	 vtXZo2iMjjeAg6lMp31U5EBLCdgnwuAP+oGXUr9w8Ux0qHMEFnn6dtSMEzTeYgJvdaZ0n
	 XjW1eS7829+f0die+T0Wtgmtn1GwEf+2fSFa8SNYLquLTJkoJpyqe69ECYgtbSJCeJH0F
	 zWKH9LLNXLK4UWjhisXzlbEpg+Bv3F7Q8Eu5GaIRxBHMSMyScs9odCGroFb2qcvcz7R2e
	 GZHuQahGtYWCFOp5vKONJqS+VKyVa92t4GiXnMAvVCBYIqAZNXqSuBrkdSFcHiGJixA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063152;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=s2blUkX7tqH9bQNhda4hbOIMH6UhuZl8rDQklCKwSFQ=;
	b=Cp9MC0JrBF0Deg7SWNBk/5HZ3GaOifNmsCcjyF7hM94WLfX+qqwCpOL02plBsRZugAWd
	 OaFip1sH34nfQBIrEVB1lWt4D4PoDdq6Z0s7D/Jpgip6L1pDaTBP+W1i2JR84dAGyfXsB
	 56Bv6KwmWfUIEuqupTx/mMG1EYM4lXhi83JHByzFnlQls7+XECbsWgryr/er7FCex/kuu
	 v5fuZklUdXGmmYIR3nWiDcIeNtiKnh54enmipXoZIdD5Rn4CEHHLYGo/uveuwVXD16Iom
	 +RiiAycD47+SRFk68veUIXgDC/lBWwQf1jjg4i8im2ZLBcKIgE3XbordqcsKQPju1RQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="C/07EYKj";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DE11606A331;
	Sat,  7 Nov 2026 14:52:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=C/07EYKj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16CB11F0089F;
	Sat,  7 Nov 2026 14:52:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063152;
	bh=s2blUkX7tqH9bQNhda4hbOIMH6UhuZl8rDQklCKwSFQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=C/07EYKji01dsK9lcDmETmS6rB0+XxMalTMiiwnccCzEph79jno7ceBbJm0gL5LTS
	 f8aLIGaRPmeZW2k++oP3nIp/PTYAlmugmjD91/P5XZWWkFHls49q1jRhMhKeCOanyG
	 7JtGPP3nXM8paGzBwIhDkHHY1MqmmjbCgcbp4Msc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qi Xi <xiqi2@huawei.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Zi Yan <ziy@nvidia.com>,
	Brendan Jackman <brendan.jackman@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Kefeng Wang <wangkefeng.wang@huawei.com>,
	Michal Hocko <mhocko@suse.com>,
	Nanyong Sun <sunnanyong@huawei.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 377/869] mm/page_isolation: guard compound_order() against racing
Date: Sat,  7 Nov 2026 08:50:59 -0500
Message-ID: <20261107134905.895506408@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qi Xi <xiqi2@huawei.com>

[ Upstream commit 4c767c5dd9bc3521fed11e6fe1d52621fe5abf7b ]

The PageCompound branch reads compound_head() without holding a reference.
A racing split or free can cause compound_head() to return a stale
pointer, and compound_nr() reads the order from that stale head, leading
to out-of-range shifts and making the skip distance meaningless.

Read the order explicitly with compound_order() and validate it is within
MAX_FOLIO_ORDER before shifting.  Also verify the derived head_pfn against
the legitimate pfn: the head must not be past pfn, must be aligned to
nr_pages, and pfn must fall within the compound page.  Bail out with
-EBUSY if any check fails.

Link: https://lore.kernel.org/20260825120549.966271-3-xiqi2@huawei.com
Fixes: b2c9e2fbba32 ("mm: make alloc_contig_range work at pageblock granularity")
Signed-off-by: Qi Xi <xiqi2@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Suggested-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Cc: Brendan Jackman <brendan.jackman@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Nanyong Sun <sunnanyong@huawei.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/page_isolation.c | 22 ++++++++++++++++++++--
 1 file changed, 20 insertions(+), 2 deletions(-)

diff --git a/mm/page_isolation.c b/mm/page_isolation.c
index 2ec974fa9726d..2e366e7bd5e93 100644
--- a/mm/page_isolation.c
+++ b/mm/page_isolation.c
@@ -411,10 +411,28 @@ static int isolate_single_pageblock(unsigned long boundary_pfn,
 		if (PageCompound(page)) {
 			struct page *head = compound_head(page);
 			unsigned long head_pfn = page_to_pfn(head);
-			unsigned long nr_pages = compound_nr(head);
+			unsigned int order = compound_order(head);
+			unsigned long nr_pages;
+
+			/* compound_order() is racy. Cap it at MAX_FOLIO_ORDER. */
+			if (order > MAX_FOLIO_ORDER)
+				goto failed;
+
+			nr_pages = 1UL << order;
+
+			/*
+			 * compound_head() is also racy, so the derived head_pfn
+			 * needs additional checks to make sure it is valid.
+			 * Otherwise, just fail the check. pfn comes from
+			 * __first_valid_page() as a legitimate PFN, so use it to
+			 * check head_pfn.
+			 */
+			if (head_pfn > pfn || !IS_ALIGNED(head_pfn, nr_pages) ||
+			    pfn - head_pfn >= nr_pages)
+				goto failed;
 
 			if (head_pfn + nr_pages <= boundary_pfn ||
-			    PageHuge(page)) {
+			    PageHuge(head)) {
 				pfn = head_pfn + nr_pages;
 				continue;
 			}
-- 
2.53.0



