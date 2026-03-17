Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0BAE3F23AA;
	Tue, 17 Mar 2026 16:54:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773766443; cv=none; b=d86lm4W1ovJLWGz6L1g0j/jA0JLzJtqon+CfyxQuE+SmtD7h9H6BcE03ZQNXl3MvD7IwiTN09pUdoK/kLB6nKPWJg2JFc0viDHuovKOEaBjSlOXnlOP76vx55zhSC0Xk44cjlwfYkvpbYbCF/b586Mey2ZuPFqh2Sml8bQbLf0U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773766443; c=relaxed/simple;
	bh=IxWM7XapqTu/N1PQkZbsswifDkStzDx4qvefoRMwI5g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jGASj2GMCS3L3FgMTP9ifCvqNROZF282xcO7dfecHKV9LuJO7bayJZVuh2SVL2mCTKrbHT0USUpa2kcsGIpqSqp/qlXLIKCWPps8+9iEnoE0Ih35kVA+b7Pqi2fGzXplNOf+3aKTDqBi2ol3/3rYztq8/BkoAKwzcUTcIAmijLo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sfiVV0E7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sfiVV0E7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AFAEC19424;
	Tue, 17 Mar 2026 16:54:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773766443;
	bh=IxWM7XapqTu/N1PQkZbsswifDkStzDx4qvefoRMwI5g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sfiVV0E75/j/Mz8Yf757uLU5gg6yStvLCSI1pKvSVPASL0OKlihMBGO9SOiTn5286
	 0xqCz73A2uBBxRnq2tE5WRDyJS3UPI5cCDZNSn19MM3/eGOgmiLUY7OFN+f2merthW
	 UMss8IWw9A2mTASo8w+kUjUQERehlbjCGC+u4Vj4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Pratyush Yadav (Google)" <pratyush@kernel.org>,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.19 248/378] mm: memfd_luo: always make all folios uptodate
Date: Tue, 17 Mar 2026 17:33:25 +0100
Message-ID: <20260317163016.144722662@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317163006.959177102@linuxfoundation.org>
References: <20260317163006.959177102@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pratyush Yadav (Google) <pratyush@kernel.org>

commit 50d7b4332f27762d24641970fc34bb68a2621926 upstream.

Patch series "mm: memfd_luo: fixes for folio flag preservation".

This series contains a couple fixes for flag preservation for memfd live
update.

The first patch fixes memfd preservation when fallocate() was used to
pre-allocate some pages.  For these memfds, all the writes to fallocated
pages touched after preserve were lost.

The second patch fixes dirty flag tracking.  If the dirty flag is not
tracked correctly, the next kernel might incorrectly reclaim some folios
under memory pressure, losing user data.  This is a theoretical bug that I
observed when reading the code, and haven't been able to reproduce it.


This patch (of 2):

When a folio is added to a shmem file via fallocate, it is not zeroed on
allocation.  This is done as a performance optimization since it is
possible the folio will never end up being used at all.  When the folio is
used, shmem checks for the uptodate flag, and if absent, zeroes the folio
(and sets the flag) before returning to user.

With LUO, the flags of each folio are saved at preserve time.  It is
possible to have a memfd with some folios fallocated but not uptodate.
For those, the uptodate flag doesn't get saved.  The folios might later
end up being used and become uptodate.  They would get passed to the next
kernel via KHO correctly since they did get preserved.  But they won't
have the MEMFD_LUO_FOLIO_UPTODATE flag.

This means that when the memfd is retrieved, the folios will be added to
the shmem file without the uptodate flag.  They will be zeroed before
first use, losing the data in those folios.

Since we take a big performance hit in allocating, zeroing, and pinning
all folios at prepare time anyway, take some more and zero all
non-uptodate ones too.

Later when there is a stronger need to make prepare faster, this can be
optimized.

To avoid racing with another uptodate operation, take the folio lock.

Link: https://lkml.kernel.org/r/20260223173931.2221759-2-pratyush@kernel.org
Fixes: b3749f174d68 ("mm: memfd_luo: allow preserving memfd")
Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/memfd_luo.c | 25 +++++++++++++++++++++++--
 1 file changed, 23 insertions(+), 2 deletions(-)

diff --git a/mm/memfd_luo.c b/mm/memfd_luo.c
index e485b828d173..1c9510289312 100644
--- a/mm/memfd_luo.c
+++ b/mm/memfd_luo.c
@@ -152,10 +152,31 @@ static int memfd_luo_preserve_folios(struct file *file,
 		if (err)
 			goto err_unpreserve;
 
+		folio_lock(folio);
+
 		if (folio_test_dirty(folio))
 			flags |= MEMFD_LUO_FOLIO_DIRTY;
-		if (folio_test_uptodate(folio))
-			flags |= MEMFD_LUO_FOLIO_UPTODATE;
+
+		/*
+		 * If the folio is not uptodate, it was fallocated but never
+		 * used. Saving this flag at prepare() doesn't work since it
+		 * might change later when someone uses the folio.
+		 *
+		 * Since we have taken the performance penalty of allocating,
+		 * zeroing, and pinning all the folios in the holes, take a bit
+		 * more and zero all non-uptodate folios too.
+		 *
+		 * NOTE: For someone looking to improve preserve performance,
+		 * this is a good place to look.
+		 */
+		if (!folio_test_uptodate(folio)) {
+			folio_zero_range(folio, 0, folio_size(folio));
+			flush_dcache_folio(folio);
+			folio_mark_uptodate(folio);
+		}
+		flags |= MEMFD_LUO_FOLIO_UPTODATE;
+
+		folio_unlock(folio);
 
 		pfolio->pfn = folio_pfn(folio);
 		pfolio->flags = flags;
-- 
2.53.0



