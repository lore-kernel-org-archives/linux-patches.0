Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DEC16453
	for <patches@lists.linux.dev>; Tue, 22 Mar 2022 21:39:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67512C340EE;
	Tue, 22 Mar 2022 21:39:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1647985166;
	bh=xC2cZqPNFzyjybznmsAmzD/7GWHjCHD+MjNDI4Fd8cE=;
	h=Date:To:From:In-Reply-To:Subject:From;
	b=g9SB1ZKKafzmjd4WG2tsKL9guNHYWxfWhn6RLlRFzmYeJ5+jnqZJENe/6LnbCYhLE
	 1Ruzkr9m3mLSFR3PXIt736hGVGUcjQEeVQwVZA3jyCANUhqSQJNfMLfzcoQApSbE2V
	 sW9OvG6EYdVAluL4N4jckJfiqzZi2cJ80yVwNQmA=
Date: Tue, 22 Mar 2022 14:39:25 -0700
To: songmuchun@bytedance.com,linmiaohe@huawei.com,akpm@linux-foundation.org,patches@lists.linux.dev,linux-mm@kvack.org,mm-commits@vger.kernel.org,torvalds@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220322143803.04a5e59a07e48284f196a2f9@linux-foundation.org>
Subject: [patch 018/227] mm/memremap: avoid calling kasan_remove_zero_shadow() for device private memory
Message-Id: <20220322213926.67512C340EE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/memremap: avoid calling kasan_remove_zero_shadow() for device private memory

For device private memory, we do not create a linear mapping for the
memory because the device memory is un-accessible.  Thus we do not add
kasan zero shadow for it.  So it's unnecessary to do
kasan_remove_zero_shadow() for it.

Link: https://lkml.kernel.org/r/20220126092602.1425-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memremap.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/memremap.c~mm-memremap-avoid-calling-kasan_remove_zero_shadow-for-device-private-memory
+++ a/mm/memremap.c
@@ -282,7 +282,8 @@ static int pagemap_range(struct dev_page
 	return 0;
 
 err_add_memory:
-	kasan_remove_zero_shadow(__va(range->start), range_len(range));
+	if (!is_private)
+		kasan_remove_zero_shadow(__va(range->start), range_len(range));
 err_kasan:
 	untrack_pfn(NULL, PHYS_PFN(range->start), range_len(range));
 err_pfn_remap:
_
