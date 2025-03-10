Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8E59233126;
	Mon, 10 Mar 2025 17:12:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741626773; cv=none; b=fOlwJnlrdNHDmVIntUD6KJvNl4UCRKYGsbh1tZwfCQAM32h3Po9t/ievKRIlafphFnQcZRLLUAupfPuR5SjzqZt+f/lfehal4VAjqPaGveqMFk4uzCvYJJE2PoATZFMtTE+KpA76Fe8Ma2xiWQILuoV8dZsPL7wh1rmaMsS+EJI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741626773; c=relaxed/simple;
	bh=TkESV19F+EsOLyLAAAd2A4Rlqtb7907BNtd0yBbKy/A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XQor9m/QqUBwiOHfvDDxz/qfmoK6zxPPkOsxwxP+U1RCg7U+r+jsQ2rXHVqSB12ra8cV59rF5daK0p4KttJ3+GkuJydnzT7O/0lNmoDwh9iOnXNhKmGSjFBh3wFe9FZ/ukYNcSEtnCBEGm15ZPyHExohwRMOeCVXWzZsLzXO21I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iBxqZbVO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iBxqZbVO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0E2FC4CEE5;
	Mon, 10 Mar 2025 17:12:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741626773;
	bh=TkESV19F+EsOLyLAAAd2A4Rlqtb7907BNtd0yBbKy/A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iBxqZbVOyQZrcfBXSg73xb7NhZhILxFCBvT1+UfRj6HWH1MK8eQhveBwQICz4fmOU
	 ytWUoxViOMU3TRR6fBvg88848Gn7ToZWWCB1s7kQFRg22+pUxrM4RSyP5ZlnH8MqZ1
	 a7bJ326l6GGbTcxIV0jbtF3h5xRIWqqnAV7ePDh8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ryan Roberts <ryan.roberts@arm.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Christop Hellwig <hch@infradead.org>,
	"Uladzislau Rezki (Sony)" <urezki@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.13 077/207] mm: dont skip arch_sync_kernel_mappings() in error paths
Date: Mon, 10 Mar 2025 18:04:30 +0100
Message-ID: <20250310170450.825781706@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170447.729440535@linuxfoundation.org>
References: <20250310170447.729440535@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ryan Roberts <ryan.roberts@arm.com>

commit 3685024edd270f7c791f993157d65d3c928f3d6e upstream.

Fix callers that previously skipped calling arch_sync_kernel_mappings() if
an error occurred during a pgtable update.  The call is still required to
sync any pgtable updates that may have occurred prior to hitting the error
condition.

These are theoretical bugs discovered during code review.

Link: https://lkml.kernel.org/r/20250226121610.2401743-1-ryan.roberts@arm.com
Fixes: 2ba3e6947aed ("mm/vmalloc: track which page-table levels were modified")
Fixes: 0c95cba49255 ("mm: apply_to_pte_range warn and fail if a large pte is encountered")
Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christop Hellwig <hch@infradead.org>
Cc: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/memory.c  |    6 ++++--
 mm/vmalloc.c |    4 ++--
 2 files changed, 6 insertions(+), 4 deletions(-)

--- a/mm/memory.c
+++ b/mm/memory.c
@@ -2971,8 +2971,10 @@ static int __apply_to_page_range(struct
 		next = pgd_addr_end(addr, end);
 		if (pgd_none(*pgd) && !create)
 			continue;
-		if (WARN_ON_ONCE(pgd_leaf(*pgd)))
-			return -EINVAL;
+		if (WARN_ON_ONCE(pgd_leaf(*pgd))) {
+			err = -EINVAL;
+			break;
+		}
 		if (!pgd_none(*pgd) && WARN_ON_ONCE(pgd_bad(*pgd))) {
 			if (!create)
 				continue;
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -586,13 +586,13 @@ static int vmap_small_pages_range_noflus
 			mask |= PGTBL_PGD_MODIFIED;
 		err = vmap_pages_p4d_range(pgd, addr, next, prot, pages, &nr, &mask);
 		if (err)
-			return err;
+			break;
 	} while (pgd++, addr = next, addr != end);
 
 	if (mask & ARCH_PAGE_TABLE_SYNC_MASK)
 		arch_sync_kernel_mappings(start, end);
 
-	return 0;
+	return err;
 }
 
 /*


