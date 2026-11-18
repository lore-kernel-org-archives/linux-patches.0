Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032873;
	b=ouLmsjmqUlN3GINYBn5Ky4CNwwfQK/4U2RRKajfP1W9+rl+Z9H+M/e/9nDoOhm1qWBz4
	 RGrV8nEFOosaMSmZQV6rvE85LN5SmZN+mmfbkYePs05eZOxrA6G9qEqbZDZ72zTDblXvN
	 wtAHQaV5YedQDKrFzbylDsP3DGDe1c4xuPeP/ojX717y8QKnSpqgLBxK1Ei/V7yYPyYI3
	 ZDZwBgX6c+dVnAYxJd8dZY+XkiLN47QOLgnnwwGN+uhpY6zCeq8N6mdNNdNy0MRENGduk
	 b7RP0mtF8gq8J2IRBVpG8ToReFoIDrCT4PCa7xDGX0J8WwzbaGtVLMkQapETwfW3o6A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032873;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ezV/0mOSlXTUgb4cfhTUzjYPMXN2kzRDXiRG8/S6aLY=;
	b=JgZ1/oydRWSqvwRV+U0iHk24myJnJBXSsrjb6ia+jAX9jkkfXFQdY1x+LtaXtOcwDmRL
	 NnmMHtbBQiMuU50I/sy+JBBtQ4RELgd+RE7pT2oJPFtareOJA2yJSDUVBGNcISyd9rCUc
	 E1x9UmwrqSJrJ0UTWw8VQgrAo7/j+4R2Myty1uROsm1Gfh1BAfc60/1lWt09wwGmTiPY3
	 UM5rXlboNbQCAwCePCUW3c/jfpj+wHn7DcLGfXwRS5TPDxT2yyqY9LoOTeqm5oz4KRboB
	 NVnUKl1tpRzgHPsHpyP+2Wkky89Tqx+cmnfeM0t+qBGaYU/Z4IPfhGU0IhgimVeL5+A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VnyR4Z9c;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53FFA60A2634;
	Wed, 18 Nov 2026 20:14:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VnyR4Z9c
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72BDD1F000C6;
	Wed, 18 Nov 2026 20:14:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032873;
	bh=ezV/0mOSlXTUgb4cfhTUzjYPMXN2kzRDXiRG8/S6aLY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VnyR4Z9cD5Hd1papNcq/3IOX5CN/YnUQ1ExWGZWqEHGTJ1xvJR/Z34ei3uNlAKL68
	 5anoJfkY+FykJ4QHeg6rxyQ0eODMyR/kl6pa/hAm/O608hzo0XBj6KEFllJO3IrtU5
	 KPTVMrG7eo5eg9Z0ooW6ZDy2uncBx9lZ7P0IOgmQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Tal Zussman <tz2294@columbia.edu>,
	Alex Markuze <amarkuze@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1567/1756] ceph: fix error handling when the OSD client is stopping in ceph_submit_write()
Date: Wed, 18 Nov 2026 16:01:34 +0100
Message-ID: <20261118150111.987637581@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tal Zussman <tz2294@columbia.edu>

[ Upstream commit ad67b498de17b709f050d7ebf84749b1fc6a242d ]

When ceph_inc_osd_stopping_blocker() fails, ceph_submit_write()
redirties and unlocks the folios remaining in ceph_wbc->fbatch.
However, none of those folios are locked at this point: locked folios
were moved to ceph_wbc->pages[] and removed from the fbatch by
ceph_process_folio_batch(). Unlocking them triggers
VM_BUG_ON_FOLIO(!folio_test_locked(folio)) in folio_unlock(), or
unlocks a folio locked by another task.

This error path also returns -EIO without fully cleaning up the folios in
ceph_wbc->pages[]: their references are never dropped, fscrypt bounce
pages are never freed, the writeback congestion count is never
decremented, and the pages array is leaked. ceph_wbc->locked_pages is
also left non-zero, so ceph_writepages_start() loops back around and
hits BUG_ON(ceph_wbc.locked_pages).

Leave the fbatch folios alone, as ceph_writepages_start() drops their
references when releasing the batch, and unwind ceph_wbc->pages[] the
same way writepages_finish() would have. Abort writeback in
ceph_writepages_start() instead of continuing, matching the handling
of ceph_inc_osd_stopping_blocker() failure on entry, as the OSD
client is being torn down and further writeback cannot make progress.

An LLM was used to verify that the cleanup was comprehensive, and
suggested aborting the writeback instead of continuing.

Fixes: 1551ec61dc55 ("ceph: introduce ceph_submit_write() method")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Link: https://sashiko.dev/#/patchset/20260804-remove-wait-on-page-writeback-v2-0-81f0ab065284%40columbia.edu?part=5
Assisted-by: Claude:fable-5
Signed-off-by: Tal Zussman <tz2294@columbia.edu>
Reviewed-by: Alex Markuze <amarkuze@redhat.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ceph/addr.c | 37 ++++++++++++++++++++++---------------
 1 file changed, 22 insertions(+), 15 deletions(-)

diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index 9e3706e0a06f6..e9fa0b9afcc13 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -1478,26 +1478,30 @@ int ceph_submit_write(struct address_space *mapping,
 	BUG_ON(len < ceph_fscrypt_page_offset(page) + thp_size(page) - offset);
 
 	if (!ceph_inc_osd_stopping_blocker(fsc->mdsc)) {
-		for (i = 0; i < folio_batch_count(&ceph_wbc->fbatch); i++) {
-			struct folio *folio = ceph_wbc->fbatch.folios[i];
+		for (i = 0; i < ceph_wbc->locked_pages; i++) {
+			page = ceph_wbc->pages[i];
+			if (fscrypt_is_bounce_page(page)) {
+				page = fscrypt_pagecache_page(page);
+				fscrypt_free_bounce_page(ceph_wbc->pages[i]);
+			}
 
-			if (!folio)
-				continue;
+			if (atomic_long_dec_return(&fsc->writeback_count) <
+			    CONGESTION_OFF_THRESH(fsc->mount_options->congestion_kb))
+				fsc->write_congested = false;
 
-			page = &folio->page;
 			redirty_page_for_writepage(wbc, page);
 			unlock_page(page);
+			put_page(page);
 		}
 
-		for (i = 0; i < ceph_wbc->locked_pages; i++) {
-			page = ceph_fscrypt_pagecache_page(ceph_wbc->pages[i]);
-
-			if (!page)
-				continue;
-
-			redirty_page_for_writepage(wbc, page);
-			unlock_page(page);
+		if (ceph_wbc->from_pool) {
+			mempool_free(ceph_wbc->pages, ceph_wb_pagevec_pool);
+			ceph_wbc->from_pool = false;
+		} else {
+			kfree(ceph_wbc->pages);
 		}
+		ceph_wbc->pages = NULL;
+		ceph_wbc->locked_pages = 0;
 
 		ceph_osdc_put_request(req);
 		return -EIO;
@@ -1731,8 +1735,11 @@ static int ceph_writepages_start(struct address_space *mapping,
 		}
 
 		rc = ceph_submit_write(mapping, wbc, &ceph_wbc);
-		if (rc)
-			goto release_folios;
+		if (rc) {
+			/* the OSD client is being torn down, don't retry */
+			folio_batch_release(&ceph_wbc.fbatch);
+			goto dec_osd_stopping_blocker;
+		}
 
 		ceph_wbc.locked_pages = 0;
 		ceph_wbc.strip_unit_end = 0;
-- 
2.53.0



