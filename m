Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585734;
	b=qN9FYTnwv+vJIuURvizEsPNNRyv61KptDWVoEYbTUszPsHt3fazELa1Dcs6aZqmIK6uF
	 9BYhIMGaRIbfwDPg+C3SK7quC/1zBnEHqjKGP22guq5sr30FaXtzA0s2ypVV5TtL0pu01
	 tAlFjhKTa2WCV9GCvhqqSQLjwp86wrn8oWL6tmppeuDvneHm35DkarMujMpmWF1nEDxl2
	 86Nqy9d/65e8IrMxTbZUIP2Vdp+ZswI97VDLmY+mIPDLmijasPIhVuYUbByGITBUiSIG/
	 4VDzOXkVGTnNxHPgDbi9vmoJl2fmlFDndDL5Rf1E1qPK/0a5gYbtZDjV8HwCKU/t9aA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585734;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=aO/Sgiq2kHVgTFIQMrLCVb9rginsFMqOOok7A49DA2g=;
	b=q26r5d7ybd6io/DhoGDhrbemnCDpV0KudTr5z/NOINeKq3NerLbYdbRuywhny0t/IwFk
	 yvGzYe91xh8JWLcT03ZSHDsA3NmTat6En+ddoufua6KjiQwi42HNgk2tN05Gx8YQTpTGf
	 X7HKkRme3YXmhtRRV9quQnSQGh26JyjNmSsg7EjYAlUbUoUWtSSppigv3aaiNPSmzECGe
	 aQOMyOkdWYgbV/QlzC0M/PanF7CFcUTbYGIXQG45Xl392TJC9Eme6iIyi+oPBVFg5y+Op
	 bUsStM6Oy/y0WxKyDkDTD/h9t5C2E4SLPoPJ+NBhrU4tESc9vLAJJn+EE42TJkwhIrA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yLYQwDT6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 045F4606EB82;
	Fri, 13 Nov 2026 16:02:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yLYQwDT6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A39971F000C4;
	Fri, 13 Nov 2026 16:02:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585733;
	bh=aO/Sgiq2kHVgTFIQMrLCVb9rginsFMqOOok7A49DA2g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yLYQwDT687X8/pnaTbln5EOa1iqcy/IaJ+PXiYVEvxkC1+6KwWkebsQF6G/WbSeRQ
	 6bTKxJK/7Q2lUAHzKjCF5TjvpzayrWcjdepmuk7dNNf5uwRg8pjcqeGNsZik6p5+Zl
	 ldXFtY+WhjU09RX1asYMrr5Wnr0SE30YsdDdcGg4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Lutomirski <luto@amacapital.net>,
	Samiullah Khawaja <skhawaja@google.com>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 334/507] mm/gup: check folio->mapping under folio lock in memfd_pin_folios()
Date: Fri, 13 Nov 2026 10:50:38 -0500
Message-ID: <20261113153806.746281948@linuxfoundation.org>
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

From: Samiullah Khawaja <skhawaja@google.com>

[ Upstream commit 71555ae8c7572fd99158013ca2e29187c5d2508d ]

memfd_pin_folios() pins folios from the page cache without taking the
folio lock. khugepaged or MADV_COLLAPSE can therefore replace a folio
after checking its refcount while memfd_pin_folios() still pins the old
folio. The caller then receives a folio which is no longer part of the
memfd.

For udmabuf and iommufd, this can cause data corruption: DMA accesses
the detached folio rather than the live memfd contents. DMA reads can
return stale data, while DMA writes update the detached copy and are
lost from the live memfd. The detached folio remains pinned, so these
accesses do not constitute a use-after-free or target another
application's memory. For memfd live update, the stale contents can
reappear in the memfd after handover.

Lock the folio and recheck folio->mapping before pinning it, like other
page cache users do. If the folio was removed, retry the folio lookup
from the index that was removed.

Fixes: 89c1905d9c14 ("mm/gup: introduce memfd_pin_folios() for pinning memfd folios")
Reported-by: Andy Lutomirski <luto@amacapital.net>
Closes: https://lore.kernel.org/all/CALCETrV5eqg6d9=+BQhCpRwBNe3aCQiut8vxPBs8b7PToqjaHg@mail.gmail.com/
Cc: stable@vger.kernel.org
Signed-off-by: Samiullah Khawaja <skhawaja@google.com>
Reviewed-by: Andy Lutomirski <luto@amacapital.net>
Link: https://patch.msgid.link/20261031203540.2282507-1-skhawaja@google.com
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/gup.c | 29 +++++++++++++++++++++--------
 1 file changed, 21 insertions(+), 8 deletions(-)

diff --git a/mm/gup.c b/mm/gup.c
index b3937aff3ad44..4f58ad22a756b 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -3446,7 +3446,7 @@ long memfd_pin_folios(struct file *memfd, loff_t start, loff_t end,
 {
 	unsigned int flags, nr_folios, nr_found;
 	unsigned int i, pgshift = PAGE_SHIFT;
-	pgoff_t start_idx, end_idx;
+	pgoff_t start_idx, end_idx, retry_idx;
 	struct folio *folio = NULL;
 	struct folio_batch fbatch;
 	struct hstate *h;
@@ -3487,6 +3487,7 @@ long memfd_pin_folios(struct file *memfd, loff_t start, loff_t end,
 			 * reason, we try to allocate them and add them to the
 			 * page cache.
 			 */
+			retry_idx = start_idx;
 			nr_found = filemap_get_folios_contig(memfd->f_mapping,
 							     &start_idx,
 							     end_idx,
@@ -3499,7 +3500,21 @@ long memfd_pin_folios(struct file *memfd, loff_t start, loff_t end,
 			for (i = 0; i < nr_found; i++) {
 				folio = fbatch.folios[i];
 
+				/*
+				 * The folio might have been removed from the
+				 * page cache (e.g., truncated or collapsed)
+				 * after the lookup. Recheck under the folio
+				 * lock.
+				 */
+				folio_lock(folio);
+				if (unlikely(folio->mapping != memfd->f_mapping)) {
+					folio_unlock(folio);
+					start_idx = retry_idx;
+					break;
+				}
+
 				if (try_grab_folio(folio, 1, FOLL_PIN)) {
+					folio_unlock(folio);
 					folio_batch_release(&fbatch);
 					ret = -EINVAL;
 					goto err;
@@ -3510,14 +3525,12 @@ long memfd_pin_folios(struct file *memfd, loff_t start, loff_t end,
 				 * page cache that were never cleared.
 				 */
 				if (!folio_test_uptodate(folio)) {
-					folio_lock(folio);
-					if (!folio_test_uptodate(folio)) {
-						folio_zero_range(folio, 0, folio_size(folio));
-						flush_dcache_folio(folio);
-						folio_mark_uptodate(folio);
-					}
-					folio_unlock(folio);
+					folio_zero_range(folio, 0, folio_size(folio));
+					flush_dcache_folio(folio);
+					folio_mark_uptodate(folio);
 				}
+				retry_idx = folio_next_index(folio);
+				folio_unlock(folio);
 
 				if (nr_folios == 0)
 					*offset = offset_in_folio(folio, start);
-- 
2.53.0



