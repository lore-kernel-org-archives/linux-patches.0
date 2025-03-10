Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23D301BBBFD;
	Mon, 10 Mar 2025 18:20:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741630839; cv=none; b=TUENez+Jw+gU6RkoWVE//M7FvVkKEHCHBlr9g07KWh91M57j4VBZZrQ3zDjJvvXuOCvgf9KvwX9l8mmw0NNNEwZWCSaXxzD+B3u403EIJ5CzbRqVujQ1Xa4sk4lgDq2aTJTMZBXYtQ4EPTPpEx5tTu8aWtQIIZzqBaoOuC8s8Yw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741630839; c=relaxed/simple;
	bh=8+o09/tUdQZZIy6qgV18tcdtJv9UhjX8rPX+uhucWSM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OhkV3+GyXOsUri53RBPgNbc8E6CYGMmfqNmdObez6CYUChd4wmdoUNJr3j4RuH5HNX5n2QhgEsVBQtqRGRbOpTL142lyZs0xcsEmcz2edKnREoiOvkEkXpmR4AWIHxaH1Xb+WERSnl9D3EZ0FXp07NJs6j3RwO/X4AIdSCUJ9kE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aMx5rcF5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aMx5rcF5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0B18C4CEE5;
	Mon, 10 Mar 2025 18:20:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741630839;
	bh=8+o09/tUdQZZIy6qgV18tcdtJv9UhjX8rPX+uhucWSM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aMx5rcF5vqAWFZPGIxY/e1PRQZaZ0BFoz5RPKMdrZsOFkU4NzcUQb7GH6sJtSgChL
	 pZCj1F+5OsltDpl1CDtFSv8wvNhAsSDFiHhSf1RobGhBl6lWzsujQxxRjIQbNdLiiI
	 ih+ab/SM2KSaAxvKGa5h8othjCpnieFDTv4Z6J3Y=
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
Subject: [PATCH 5.15 551/620] mm: dont skip arch_sync_kernel_mappings() in error paths
Date: Mon, 10 Mar 2025 18:06:37 +0100
Message-ID: <20250310170607.292006566@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2713,8 +2713,10 @@ static int __apply_to_page_range(struct
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
@@ -556,13 +556,13 @@ static int vmap_small_pages_range_noflus
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


