Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 924632F28;
	Mon, 10 Mar 2025 17:24:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741627463; cv=none; b=sv5hNnEPmBPDeBpkr/glu/dnganSqjxHEyaHxx14744t55IPBqa0+lNwzxMsBTGdI38mKz36tIyBnpq6sFeWFd5raqjQT6TQUwlp24RlSEggQw5jTzGk+/PbKI5kmEu+aJeQjwDYzj1NWsSDZ1DJhGSr5iykkb2oCNw3Dd0+OcI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741627463; c=relaxed/simple;
	bh=E0yknbkIqK01A+az61rJNTURsMnwt7A3InwSM4d31RU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fr3ykLSvmcajLJuFFkbhgjiuFpCmfsZqtDuOR1pB4rGEX7LfHe62Kwv0H+rnllz3D3Cj8mkmuvywXcaOEeNfLdPFF0ayfbx6bRTOG/5SfCoCr7U0Wrk0MD7JCKaEizC7/95FWecsAo8LMI7a3AXpGj67Y5/R4RUW0tyzhcl/vio=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JNCRueg/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JNCRueg/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A3A4C4CEE5;
	Mon, 10 Mar 2025 17:24:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741627463;
	bh=E0yknbkIqK01A+az61rJNTURsMnwt7A3InwSM4d31RU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JNCRueg/6gRcnlGU8EwPqGsWSSk9H1BD9/4AsnAzkdoyLrX6891kXTuw0ehOrAQ3r
	 KVoZ22QSvg+Gag78UhjWx5QnYwuM4YtnkcGQObv3EV08p4X9aycSoG9w4JxA4VrdKv
	 ziQ2SNbyy6XsDmNGHtRY9tETYsm6heyoemOus8Uc=
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
Subject: [PATCH 6.12 137/269] mm: dont skip arch_sync_kernel_mappings() in error paths
Date: Mon, 10 Mar 2025 18:04:50 +0100
Message-ID: <20250310170503.181967989@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170457.700086763@linuxfoundation.org>
References: <20250310170457.700086763@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2957,8 +2957,10 @@ static int __apply_to_page_range(struct
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


