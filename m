Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C9963D3308;
	Mon,  4 May 2026 14:02:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777903328; cv=none; b=rfzmqi1AT4Xdn1RRtTR3asntY/sD5tOrvV1FqJ4NXp9JVqU4c4mqedpLPfdtPF6h92SJq1+iGDaw42D9q9TZQwGgtZSO6A7YC8rCvMDMKVspEy+N7ojQNcuVsTta79d19M6n5IQxVMfj0ftV3EsWL4KeIMrVFk3NnO1hSLLstv0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777903328; c=relaxed/simple;
	bh=Kq60yY3kcM489rSxuOImQt+LbminPNdYYmJnMhRPxPQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hEa3qluTRoOURIitw/B7hxeDzB1kJgpSJ7qhi6nAxqMO2bVhXoUhuk0E5Wr988qVcIZTjwYi4iPdDT3RaIfR5rHD+0/oC9p9HxaIKYgFLzeFbR71Sugop9T+FyErj5eryUhmwV4WL2AQ6T5ge4ZcEDUpUAkuRtODY02EB7rC9/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ukb2+jQ+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ukb2+jQ+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0246FC2BCB8;
	Mon,  4 May 2026 14:02:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777903328;
	bh=Kq60yY3kcM489rSxuOImQt+LbminPNdYYmJnMhRPxPQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ukb2+jQ+4gRZTpyMxBkaGRPruqrPaHEnb6/kb/LKFTwFC9CJ8WdMb9ru0SfOkBAOl
	 qkEC73iGSPEDBEvWthyCkcd7JM5vy89QRp2OE23mTfsIubKMh/GXECa0OMicGxCYRQ
	 np2z6GMKQOyzSX1/yaw104/7O6KOn0p3s2hRjKP4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chenghao Duan <duanchenghao@kylinos.cn>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Haoran Jiang <jianghaoran@kylinos.cn>,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 7.0 191/307] mm/memfd_luo: fix physical address conversion in put_folios cleanup
Date: Mon,  4 May 2026 15:51:16 +0200
Message-ID: <20260504135150.068664104@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.814938198@linuxfoundation.org>
References: <20260504135142.814938198@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chenghao Duan <duanchenghao@kylinos.cn>

commit 3538f90ab89aaf302782b4b073a0aae66904cd67 upstream.

In memfd_luo_retrieve_folios()'s put_folios cleanup path:

1. kho_restore_folio() expects a phys_addr_t (physical address) but
   receives a raw PFN (pfolio->pfn). This causes kho_restore_page() to
   check the wrong physical address (pfn << PAGE_SHIFT instead of the
   actual physical address).

2. This loop lacks the !pfolio->pfn check that exists in the main
   retrieval loop and memfd_luo_discard_folios(), which could
   incorrectly process sparse file holes where pfn=0.

Fix by converting PFN to physical address with PFN_PHYS() and adding
the !pfolio->pfn check, matching the pattern used elsewhere in this file.

This issue was identified by the AI review.
https://sashiko.dev/#/patchset/20260323110747.193569-1-duanchenghao@kylinos.cn

Link: https://lore.kernel.org/20260326084727.118437-6-duanchenghao@kylinos.cn
Fixes: b3749f174d68 ("mm: memfd_luo: allow preserving memfd")
Signed-off-by: Chenghao Duan <duanchenghao@kylinos.cn>
Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Reviewed-by: Pratyush Yadav <pratyush@kernel.org>
Cc: Haoran Jiang <jianghaoran@kylinos.cn>
Cc: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/memfd_luo.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/mm/memfd_luo.c
+++ b/mm/memfd_luo.c
@@ -466,8 +466,13 @@ put_folios:
 	 */
 	for (long j = i + 1; j < nr_folios; j++) {
 		const struct memfd_luo_folio_ser *pfolio = &folios_ser[j];
+		phys_addr_t phys;
 
-		folio = kho_restore_folio(pfolio->pfn);
+		if (!pfolio->pfn)
+			continue;
+
+		phys = PFN_PHYS(pfolio->pfn);
+		folio = kho_restore_folio(phys);
 		if (folio)
 			folio_put(folio);
 	}


