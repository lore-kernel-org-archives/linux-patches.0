Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591323;
	b=BmThC2LZZjItea6sYCzjcQdL2erBS3HofR7NiHKdr7sTUFR1n2+Li9bVcS2pCWPt9B3i
	 90RMdkrXTWmPS8wdM9tVywLR0AsnVsv43h3CJ0ImtN1XDnU/2hBpaLSFe5sfTYgHrMHUk
	 D2WnDfxoqBk55mrDJQq3cebOtna0nLRkksf2bd+9fnAIJqHXOyIdW9a0OXK19kPx4jtqu
	 uzasURbh56YxlhoGSQgyFSrcBKLl5T90kdFRJeioX6V6u2BOSFyzqdHBe+ts3g47ULNBW
	 qY/6gghkw+MsnFSAz5LWjtxSCvzlYI82690/2yh9KgmDPbRukBHo1p4SSM2y/lNCp+Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591323;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=j+eEiwipmqwb00dBlKgWccn1JkLUu9u0E0U9DdcdyyA=;
	b=XlvLsVczEAk/RzzeY3vOV7TGpAp+ooVU8mUgwpmODzVNx/xFEQxxcrFnxL1R9+LR028c
	 z9yNIuuIRnramPfgWPknSzllCMApISOvc8Ipz1l+Glj5t03P5ggRyOt0HvRFw4oNqZjUV
	 dqA3ua21eCOLyF37DxAfVgO7APgvGSjrFNlp0nJyOlbNKooPCXgy70fyELbBOsc+8r7f3
	 umV7lI8s8Z6beLq1SeFmzZFvqDvHVZBwFXpJIOLlC6rBmbN9Ksv3mOvT22fiX7Z4OfUR5
	 lp/GEVd75+UXw5uEPvJvOcRyubhhq3Vt0q2WjneXC67Aq/mreJnD97JkqhaCIUodebg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MQg3GBi+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30F6E60776EE;
	Fri, 13 Nov 2026 17:35:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MQg3GBi+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D82B61F000C7;
	Fri, 13 Nov 2026 17:35:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591323;
	bh=j+eEiwipmqwb00dBlKgWccn1JkLUu9u0E0U9DdcdyyA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MQg3GBi+5a/eKFkBIyUpZiNMYGdTsry3q2PoJ65NQ0N9jQanWDE27tob11ynkAVnu
	 0ssUd2eKVZkc6CGHp25BlEEmkstazDsLC7PQw/DJL+WiS85ScHH9sanIT6zU6NWMI4
	 yKYp5xS/jDQ+OH6jmaX9ZLvwdRvfwTXXc88oZFaA=
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
Subject: [PATCH 6.12 436/670] mm/page_isolation: guard compound_order() against racing
Date: Fri, 13 Nov 2026 10:50:00 -0500
Message-ID: <20261113153826.636762909@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 6989c5ffd4741..702db2e28a77c 100644
--- a/mm/page_isolation.c
+++ b/mm/page_isolation.c
@@ -401,10 +401,28 @@ static int isolate_single_pageblock(unsigned long boundary_pfn, int flags,
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



