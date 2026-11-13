Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585783;
	b=QR/eXafsmwMYjOn8YyyKs2B+qG50FPuOV3QTLoQCkVlMtR6LTF17GQTFvZeL1PGUSPw0
	 K0NDdqjGFRJo33+M00zy4ZmkHM33d1Ym60Yzkmv0ygRE9dn1vEARlhFFuNShmJQljW8lu
	 T/99ZDfzKeohVgbF7UAZct5NzDv+wuln88NQ/cqxjTLKcl5mPvSYVh7/ML2BWbsrvlnZS
	 IdhcShGEB78ZbLMsc553Y7PPf78larEOOLtwTlUjPnt7R/F6qsHCw97Fwee4MmOwU/whf
	 NGBFETfp+UDl+HIKxRWCj/GXb32Bh3Nv/UwJUbU5veT0PeWObPm3hQSSf1HJMI0/Z8Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585783;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=z+osz3h8dTmpg+DY3HBMNMtuC4G84Z1gP3KFODO7bsM=;
	b=OArn2TTLsIR+/Yyiif3KNZUE8Xrm10cF6TT/j6RFlIgmtwVSpwYCcBYtSiOUK0sroTcy
	 nNwq6PeHfj0asRqSRxOh31ctoNpRh0jzV0VfKY0pQ7Lqsl1OusNrHIGqXKZGHjb3t79iP
	 QK5zIoy/ZGn31KrPg57ZTAXqjtNqqek6jrGYBR7ZdIgHlM4n1PDgYtMUWZaZcR0Uss0EG
	 Yth4kKYYP9ZM4BKRxj41Gu4+oRyFLgBpyoiekyjbhNdD7anJmBvjEmw1D6/KOAU4Nfu+4
	 pszEcgOTy3dPW6D9mAD61/wOIMmk6A9ELdqDevapahxwJF8yqnmFF7ZLNKs7ZweZDqA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=q4xqaLob;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A163606BA81;
	Fri, 13 Nov 2026 16:03:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=q4xqaLob
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE4A31F000C4;
	Fri, 13 Nov 2026 16:03:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585782;
	bh=z+osz3h8dTmpg+DY3HBMNMtuC4G84Z1gP3KFODO7bsM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=q4xqaLob8oAgUK2gTEehMWEY154bohja0nwY+HePEnm04WTy0/nc/ODQBhvJyf0g9
	 FRfmHGRiCAIdNwqgfU2wIh5krHgDwWnBbyMEsxzicoTrd+I1ezXQd1zspknOc0Vnvr
	 XFAOCYuD3XhS6Hr7M0cJlBpnk+k3/NuSSWaaM+7s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rik van Riel <riel@surriel.com>,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Muhammad Usama Anjum <usama.anjum@arm.com>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 330/507] mm/cma: dont release CMA pages still in use
Date: Fri, 13 Nov 2026 10:50:34 -0500
Message-ID: <20261113153806.597608431@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rik van Riel <riel@surriel.com>

[ Upstream commit e8abc61d8a549a91c8fa639f68be2ef13d5fa63b ]

When a driver calls dma_free_contiguous() before quiescing DMA, the
page might still have a reference from the device.
put_page_testzero() there returns false, WARN fires, but the code proceeds
to free_contig_frozen_range() putting a live page onto buddy and clearing
the bitmap. A subsequent allocation can hand the same PFN to a new
owner while the original holder still references it.

A concurrent put_page() that drops the last reference between the
testzero loop and free_contig_frozen_range() can double-queue the page
via page->lru, corrupting buddy lists.

Avoid the corruption by not freeing a CMA region if any of the
pages inside are still in use.

Make it explicit in the warning that the driver allowed a leak.

While at it, use page_ref_freeze() to make the semantics clearer and
switch to pr_warn_ratelimited().

Fixes: 9bda131c6093 ("mm: cma: add cma_alloc_frozen{_compound}()")
Cc: stable@vger.kernel.org
Signed-off-by: Rik van Riel <riel@surriel.com>
Link: https://patch.msgid.link/20260811132045.5f114772@fangorn
[ david: use page_ref_freeze() + pr_warn_ratelimited() ]
Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Acked-by: Muchun Song <muchun.song@linux.dev>
Tested-by: Muhammad Usama Anjum <usama.anjum@arm.com>
Link: https://patch.msgid.link/20261031-fixes_core-v3-45-d6437171ecc3@kernel.org
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/cma.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/mm/cma.c b/mm/cma.c
index f61d52796f4ef..9ec1d1fd5dff5 100644
--- a/mm/cma.c
+++ b/mm/cma.c
@@ -1024,7 +1024,7 @@ bool cma_release(struct cma *cma, const struct page *pages,
 		 unsigned long count)
 {
 	struct cma_memrange *cmr;
-	unsigned long ret = 0;
+	unsigned long leaked = 0;
 	unsigned long i, pfn;
 
 	cmr = find_cma_memrange(cma, pages, count);
@@ -1033,9 +1033,13 @@ bool cma_release(struct cma *cma, const struct page *pages,
 
 	pfn = page_to_pfn(pages);
 	for (i = 0; i < count; i++, pfn++)
-		ret += !put_page_testzero(pfn_to_page(pfn));
+		leaked += !page_ref_freeze(pfn_to_page(pfn), 1);
 
-	WARN(ret, "%lu pages are still in use!\n", ret);
+	if (leaked) {
+		pr_warn_ratelimited("%lu pages are still in use, not freeing CMA region!\n",
+				   leaked);
+		return true;
+	}
 
 	__cma_release_frozen(cma, cmr, pages, count);
 
-- 
2.53.0



