Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFDFE183CA6;
	Mon, 12 Aug 2024 16:22:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723479743; cv=none; b=mB9gOW4pRR6vX5dKIZnOnGi7WPn0tYdJiWOOCQRCoR4hr6C5uVrOT553sHtcsf2TO7FJRchcxlScHNmix1Y8dJTPPDIBb5VWini72Ws+z4pU+fcJVizuQ+dA33gWUlX0YuMGq7J2T+S92ASlVGtPOYfcL2EKHkavMZwrNWewydM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723479743; c=relaxed/simple;
	bh=5EbgAV3bjjBWfqPYxblcSthcVdvg6AXDg/KRVF+W8SU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mzyNfOdKTtZMIrq1hztj+YVB9sTSl3YZ6RvxpCor+dKUudfH8xGDwjHvnIlLeA7Kl8sv/A5kC181O/rT4/NoJAKWnJjFfMPW8sMrLqSAGjrvxqVyNe0CcCo2rVSDaaILfWqLUnqiGt5yLaKW3z1tHygGs3lbcVDiWRkwWGFhUZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DGt1aAl5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DGt1aAl5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 679EFC32782;
	Mon, 12 Aug 2024 16:22:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723479742;
	bh=5EbgAV3bjjBWfqPYxblcSthcVdvg6AXDg/KRVF+W8SU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DGt1aAl5Rkl/jeylVMUl1S2XTBFVAQnJQ903S8qgR/lh92OBSCtqNP5rLppkrepxx
	 6ftLxQYRxomHhI84c5PEjhw1Ngm0quQFVEMcQIQRqPShHxphTsCuemuh1VVz5ratov
	 7XO3nHzC+cZr12p0+SiN7yQwKNGSNCQl4GgTS9dI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miaohe Lin <linmiaohe@huawei.com>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.6 179/189] mm/hugetlb: fix potential race in __update_and_free_hugetlb_folio()
Date: Mon, 12 Aug 2024 18:03:55 +0200
Message-ID: <20240812160139.036711671@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160132.135168257@linuxfoundation.org>
References: <20240812160132.135168257@linuxfoundation.org>
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

From: Miaohe Lin <linmiaohe@huawei.com>

commit 5596d9e8b553dacb0ac34bcf873cbbfb16c3ba3e upstream.

There is a potential race between __update_and_free_hugetlb_folio() and
try_memory_failure_hugetlb():

 CPU1					CPU2
 __update_and_free_hugetlb_folio	try_memory_failure_hugetlb
					 folio_test_hugetlb
					  -- It's still hugetlb folio.
  folio_clear_hugetlb_hwpoison
  					  spin_lock_irq(&hugetlb_lock);
					   __get_huge_page_for_hwpoison
					    folio_set_hugetlb_hwpoison
					  spin_unlock_irq(&hugetlb_lock);
  spin_lock_irq(&hugetlb_lock);
  __folio_clear_hugetlb(folio);
   -- Hugetlb flag is cleared but too late.
  spin_unlock_irq(&hugetlb_lock);

When the above race occurs, raw error page info will be leaked.  Even
worse, raw error pages won't have hwpoisoned flag set and hit
pcplists/buddy.  Fix this issue by deferring
folio_clear_hugetlb_hwpoison() until __folio_clear_hugetlb() is done.  So
all raw error pages will have hwpoisoned flag set.

Link: https://lkml.kernel.org/r/20240708025127.107713-1-linmiaohe@huawei.com
Fixes: 32c877191e02 ("hugetlb: do not clear hugetlb dtor until allocating vmemmap")
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Acked-by: Muchun Song <muchun.song@linux.dev>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/hugetlb.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -1770,13 +1770,6 @@ static void __update_and_free_hugetlb_fo
 	}
 
 	/*
-	 * Move PageHWPoison flag from head page to the raw error pages,
-	 * which makes any healthy subpages reusable.
-	 */
-	if (unlikely(folio_test_hwpoison(folio)))
-		folio_clear_hugetlb_hwpoison(folio);
-
-	/*
 	 * If vmemmap pages were allocated above, then we need to clear the
 	 * hugetlb destructor under the hugetlb lock.
 	 */
@@ -1787,6 +1780,13 @@ static void __update_and_free_hugetlb_fo
 	}
 
 	/*
+	 * Move PageHWPoison flag from head page to the raw error pages,
+	 * which makes any healthy subpages reusable.
+	 */
+	if (unlikely(folio_test_hwpoison(folio)))
+		folio_clear_hugetlb_hwpoison(folio);
+
+	/*
 	 * Non-gigantic pages demoted from CMA allocated gigantic pages
 	 * need to be given back to CMA in free_gigantic_folio.
 	 */


