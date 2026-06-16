Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3551744CF40;
	Tue, 16 Jun 2026 16:03:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781625831; cv=none; b=B2Mr2uzgxnYShqz6j6kw2gHbtHZ7s3lHyb/zhlBEr9od+9XVJ4DJE2QyLOafRpwG2jxt8SLBH0lUwgL6SgkhXoarOkfFhslsalgqCrxBFS9xGIFoQHAHsPQAaGHs1AFnMeNmLPVp+a2XMHDgdWbqSb7I35u26vjW8zh7SkeuGAs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781625831; c=relaxed/simple;
	bh=M2L1jkDksnbzm6KSk2I/A24pzOW4T1GuW/+5vULVYv8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lK6h/QmZmi/Tzi/bPqawTuhmi3DZICZrSRm+P/87kDgTt6fU7GSUjJ0SQZRFypsMjgqG74yPZ7r0op7eiKV32VOZJ07MbKsOCh4OQ5TmByuxFpSitb0NL78yW3E0dXWUTrR/BCkqeV0DzbNpe5s9W6cKChQLIw66KqgRt/O5Y3I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kBButCO+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kBButCO+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F9171F000E9;
	Tue, 16 Jun 2026 16:03:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781625830;
	bh=bOB28OeZuFWPX3h0iogA9kju60mBaupG4GztPBIWAFo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kBButCO+CSWJV5vxhc1h0etf2JBD2QHYdcrhfS43quzdPAHrtiIBu8CvVG9vdj5EC
	 2lQe9/nyOydNBqaFmxgecKl8Q+9ZLycFg6MSNBzodurSz7ybFS6lctU82o/GirmmqB
	 waQMrVko0sGXolxFy7tw1mjQgXRi3FqtA1fzjI7w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yin Tirui <yintirui@huawei.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"David Hildenbrand (arm)" <david@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Dev Jain <dev.jain@arm.com>,
	Alistair Popple <apopple@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Barry Song <baohua@kernel.org>,
	Chen Jun <chenjun102@huawei.com>,
	Kefeng Wang <wangkefeng.wang@huawei.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Zi Yan <ziy@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.18 185/325] mm/huge_memory: update file PUD counter before folio_put()
Date: Tue, 16 Jun 2026 20:29:41 +0530
Message-ID: <20260616145107.114786014@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145057.827196531@linuxfoundation.org>
References: <20260616145057.827196531@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yin Tirui <yintirui@huawei.com>

commit 40990c87a26e371594475acdc560c93cfae308a1 upstream.

__split_huge_pud_locked() updates the file/shmem RSS counter after
dropping the PUD mapping's folio reference.  If folio_put() drops the last
reference, mm_counter_file() can later read freed folio state via
folio_test_swapbacked().

Move the counter update before folio_put().

Link: https://lore.kernel.org/20260526101355.1984244-1-yintirui@huawei.com
Fixes: dbe54153296d ("mm/huge_memory: add vmf_insert_folio_pud()")
Signed-off-by: Yin Tirui <yintirui@huawei.com>
Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>
Acked-by: David Hildenbrand (arm) <david@kernel.org>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Chen Jun <chenjun102@huawei.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Nico Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/huge_memory.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2759,9 +2759,9 @@ static void __split_huge_pud_locked(stru
 	if (!folio_test_referenced(folio) && pud_young(old_pud))
 		folio_set_referenced(folio);
 	folio_remove_rmap_pud(folio, page, vma);
-	folio_put(folio);
 	add_mm_counter(vma->vm_mm, mm_counter_file(folio),
 		-HPAGE_PUD_NR);
+	folio_put(folio);
 }
 
 void __split_huge_pud(struct vm_area_struct *vma, pud_t *pud,


