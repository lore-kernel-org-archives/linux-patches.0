Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 572EF1B1402;
	Thu,  6 Jun 2024 14:16:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683367; cv=none; b=lgelJKPkSCOz4jFACVF3iAap529AzDOPx79zwkqjxHVzolYlbAsPLKttYlC3NjyCaIAQSEhbyukf8J0DP8YwH3+9z9QyTaLLQ/mUn8LC1mZI1XABUNDuDgN++Z3rnQeBgaKUZE1/tsE+zYzP0A0hOLtsF/Y9odWIItMNqsX2O0k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683367; c=relaxed/simple;
	bh=O6t+p78Oq7zx0Xj7uidvztq64+lsyIp9O5FxXh9iyrA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=m+icC06jHr6YkMTVvoD0Ay5hDq/V+YVMxfi/+Das12N6qp/GPENjyGEm3W6pPfq1RhEhu+u3a3N0w+F6m/TLDLYcR3hQA1RJKRpjbcIaM7/W4HTYCd65ahuXJq/S+rsFteEnqJPOUlkykKI2gGabUU1ih1MnPBvm36MXkXHu9bI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=18HNBr/l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="18HNBr/l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34048C32781;
	Thu,  6 Jun 2024 14:16:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683367;
	bh=O6t+p78Oq7zx0Xj7uidvztq64+lsyIp9O5FxXh9iyrA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=18HNBr/lV0AZHtynp+dKBa5+ZPpgfzubmEzbLL9CWn0pzjWK+LVeeWuX+vsdA6lV3
	 Lr23cZ6Hpqes1Ke5fXCp13bSAKHU/CGW+xVWJQLDOEl/2Ll3UhBXvkFRH59mol4lJH
	 GQwrZS/6PGXoiOBD5nk0OjMHDEsUTnoA9v54CQU8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Duoming Zhou <duoming@zju.edu.cn>,
	=?UTF-8?q?J=C3=A9r=C3=B4me=20Glisse?= <jglisse@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 251/473] lib/test_hmm.c: handle src_pfns and dst_pfns allocation failure
Date: Thu,  6 Jun 2024 16:03:00 +0200
Message-ID: <20240606131708.280097665@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131659.786180261@linuxfoundation.org>
References: <20240606131659.786180261@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Duoming Zhou <duoming@zju.edu.cn>

[ Upstream commit c2af060d1c18beaec56351cf9c9bcbbc5af341a3 ]

The kcalloc() in dmirror_device_evict_chunk() will return null if the
physical memory has run out.  As a result, if src_pfns or dst_pfns is
dereferenced, the null pointer dereference bug will happen.

Moreover, the device is going away.  If the kcalloc() fails, the pages
mapping a chunk could not be evicted.  So add a __GFP_NOFAIL flag in
kcalloc().

Finally, as there is no need to have physically contiguous memory, Switch
kcalloc() to kvcalloc() in order to avoid failing allocations.

Link: https://lkml.kernel.org/r/20240312005905.9939-1-duoming@zju.edu.cn
Fixes: b2ef9f5a5cb3 ("mm/hmm/test: add selftest driver for HMM")
Signed-off-by: Duoming Zhou <duoming@zju.edu.cn>
Cc: Jérôme Glisse <jglisse@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/test_hmm.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/lib/test_hmm.c b/lib/test_hmm.c
index 67e6f83fe0f82..be50a1fdba70b 100644
--- a/lib/test_hmm.c
+++ b/lib/test_hmm.c
@@ -1232,8 +1232,8 @@ static void dmirror_device_evict_chunk(struct dmirror_chunk *chunk)
 	unsigned long *src_pfns;
 	unsigned long *dst_pfns;
 
-	src_pfns = kcalloc(npages, sizeof(*src_pfns), GFP_KERNEL);
-	dst_pfns = kcalloc(npages, sizeof(*dst_pfns), GFP_KERNEL);
+	src_pfns = kvcalloc(npages, sizeof(*src_pfns), GFP_KERNEL | __GFP_NOFAIL);
+	dst_pfns = kvcalloc(npages, sizeof(*dst_pfns), GFP_KERNEL | __GFP_NOFAIL);
 
 	migrate_device_range(src_pfns, start_pfn, npages);
 	for (i = 0; i < npages; i++) {
@@ -1256,8 +1256,8 @@ static void dmirror_device_evict_chunk(struct dmirror_chunk *chunk)
 	}
 	migrate_device_pages(src_pfns, dst_pfns, npages);
 	migrate_device_finalize(src_pfns, dst_pfns, npages);
-	kfree(src_pfns);
-	kfree(dst_pfns);
+	kvfree(src_pfns);
+	kvfree(dst_pfns);
 }
 
 /* Removes free pages from the free list so they can't be re-allocated */
-- 
2.43.0



