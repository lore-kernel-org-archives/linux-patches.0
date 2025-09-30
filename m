Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2BEB2FC881;
	Tue, 30 Sep 2025 15:09:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759244977; cv=none; b=KBvlkJT7H91Us83wEIED2ptEbdiGjJtMJ43xuvKE3hVigj4FGvmXgQuqlD0LwcxpMFG6QcgdAAUMLke7c/uX9SPDxZTGJsJSKzWUROoe4RQL7H77NFjvpkthiaoJhgO4qZvB9dWuPnYVFfLKiHYvSx1x2ke3nmAIWWTlCsMEaeo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759244977; c=relaxed/simple;
	bh=hYNZ8FqANgdLMCor8HUBcK2QZ3cA8gm4M+ogxN6sgZU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mWch9dcT+ZD3M6DegolKJs8LqH22rCZdDs2L0lMj4CwrYu8IBLJlVUkQ57txNEv34R6tLqHA9Z4DxRKLDGIvxORTpodJu6fbpOod1HQfEJjfoxPIsJEM3Z5qDbv8cFkg0SLT3oB0N+HM9YmlNzJpemlZgaIOPSLnJfkS4rBSNGc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ls3hrpWU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ls3hrpWU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C783C113D0;
	Tue, 30 Sep 2025 15:09:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759244977;
	bh=hYNZ8FqANgdLMCor8HUBcK2QZ3cA8gm4M+ogxN6sgZU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ls3hrpWUnrt1X6Hj9QZ0SwKycykdaIgV2Fanqgh7ZorVuK7Rov031uEn4+2TU1p9c
	 v/MWX3feidJlllPUVy5YeLDAabwDXVohh9BlFcy3+9qkFrhz/9o2m0zgJo0ysJKOgJ
	 aBxLnAvkUYCtE5oWWSePW1exREhkNVXQyoA4DB/Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wei Yang <richard.weiyang@gmail.com>,
	Dev Jain <dev.jain@arm.com>,
	Zi Yan <ziy@nvidia.com>,
	David Hildenbrand <david@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Barry Song <baohua@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5.15 028/151] mm/khugepaged: fix the address passed to notifier on testing young
Date: Tue, 30 Sep 2025 16:45:58 +0200
Message-ID: <20250930143828.739641895@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143827.587035735@linuxfoundation.org>
References: <20250930143827.587035735@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wei Yang <richard.weiyang@gmail.com>

commit 394bfac1c7f7b701c2c93834c5761b9c9ceeebcf upstream.

Commit 8ee53820edfd ("thp: mmu_notifier_test_young") introduced
mmu_notifier_test_young(), but we are passing the wrong address.
In xxx_scan_pmd(), the actual iteration address is "_address" not
"address".  We seem to misuse the variable on the very beginning.

Change it to the right one.

[akpm@linux-foundation.org fix whitespace, per everyone]
Link: https://lkml.kernel.org/r/20250822063318.11644-1-richard.weiyang@gmail.com
Fixes: 8ee53820edfd ("thp: mmu_notifier_test_young")
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Nico Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Barry Song <baohua@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/khugepaged.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -1358,7 +1358,7 @@ static int khugepaged_scan_pmd(struct mm
 		}
 		if (pte_young(pteval) ||
 		    page_is_young(page) || PageReferenced(page) ||
-		    mmu_notifier_test_young(vma->vm_mm, address))
+		    mmu_notifier_test_young(vma->vm_mm, _address))
 			referenced++;
 	}
 	if (!writable) {


