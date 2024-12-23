Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5C841AF0CE;
	Mon, 23 Dec 2024 16:08:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734970136; cv=none; b=twzuvbDllg1XPKJLxGFhhftMvnVV7sPBXLWqmxeuDAl1YphiTdheZxHRULmyTVjtw9A+9EndF/oAirOV6ilbmh1Pb+TJhprap088QKbZ3BjkIYUm0b58LOcHB/axp1hk1/KIO+MrtlPOz2OCq625ssoQwkDE5x9J7cLCmz4c8Q0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734970136; c=relaxed/simple;
	bh=BzStACEq2xd8MfVTsEoNkTBxzYQZQv0yMyVV8A/Qk18=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rPUx6thrW/eTINkqb/4TWSVjjdwFBMC1m0N2Tz3hPxBib9M2TrIi+6OEVt29FE2vnoa6zRSKrDzsAfA0u2ldmpLhoL4KXPW5e1k4slCP6AHK4CXD0BDnw1LVjscBwecYRnT7pd5nmzdfU8fTWB1qbEPRET2lVM9b2aPlpvqdVaY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lRYCG++a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lRYCG++a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98FC0C4CED3;
	Mon, 23 Dec 2024 16:08:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734970135;
	bh=BzStACEq2xd8MfVTsEoNkTBxzYQZQv0yMyVV8A/Qk18=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lRYCG++a2FQjD1UYsNLryh62aiYyNEqeU7YUon/aJjWIAdB1HIEsuV+ShNAqgocYf
	 TDXjBhd3plx5h+SIrx2fgUfXFnKXeU/+tKmBlleDilL9c8ewfictGFmLpwZ7K0cf3C
	 OmYMvpn0nfVptbbXygPVIFUsnCpM+8lgTkBd3xEs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kefeng Wang <wangkefeng.wang@huawei.com>,
	"Huang, Ying" <ying.huang@intel.com>,
	David Hildenbrand <david@redhat.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.12 156/160] mm: use aligned address in clear_gigantic_page()
Date: Mon, 23 Dec 2024 16:59:27 +0100
Message-ID: <20241223155414.842344061@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241223155408.598780301@linuxfoundation.org>
References: <20241223155408.598780301@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kefeng Wang <wangkefeng.wang@huawei.com>

commit 8aca2bc96c833ba695ede7a45ad7784c836a262e upstream.

In current kernel, hugetlb_no_page() calls folio_zero_user() with the
fault address.  Where the fault address may be not aligned with the huge
page size.  Then, folio_zero_user() may call clear_gigantic_page() with
the address, while clear_gigantic_page() requires the address to be huge
page size aligned.  So, this may cause memory corruption or information
leak, addtional, use more obvious naming 'addr_hint' instead of 'addr' for
clear_gigantic_page().

Link: https://lkml.kernel.org/r/20241028145656.932941-1-wangkefeng.wang@huawei.com
Fixes: 78fefd04c123 ("mm: memory: convert clear_huge_page() to folio_zero_user()")
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Reviewed-by: "Huang, Ying" <ying.huang@intel.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/hugetlbfs/inode.c |    2 +-
 mm/memory.c          |    3 ++-
 2 files changed, 3 insertions(+), 2 deletions(-)

--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -893,7 +893,7 @@ static long hugetlbfs_fallocate(struct f
 			error = PTR_ERR(folio);
 			goto out;
 		}
-		folio_zero_user(folio, ALIGN_DOWN(addr, hpage_size));
+		folio_zero_user(folio, addr);
 		__folio_mark_uptodate(folio);
 		error = hugetlb_add_to_page_cache(folio, mapping, index);
 		if (unlikely(error)) {
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -6780,9 +6780,10 @@ static inline int process_huge_page(
 	return 0;
 }
 
-static void clear_gigantic_page(struct folio *folio, unsigned long addr,
+static void clear_gigantic_page(struct folio *folio, unsigned long addr_hint,
 				unsigned int nr_pages)
 {
+	unsigned long addr = ALIGN_DOWN(addr_hint, folio_size(folio));
 	int i;
 
 	might_sleep();


