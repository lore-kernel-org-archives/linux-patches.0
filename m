Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027906;
	b=PwouBI5akE8oo1Tl+28Q4UJExARTwjHxJn0fYRIRA7L8kidaZZmEKST8FakWrHxoIBMt
	 FoWnzNFpb0CwdVG1V1qrvpoeJqO0p1I1hWG3pgicXtuM0gVtLKHgdGS8xBTFXFfo0GDJT
	 YDykipXXq+XUefTBLwBIga36JsliBXIv0t6RM89HvMGlO+LdvfsmqWD45WAkrer0u2a2i
	 KszA9+YTFz+oMi4eUAJMbOMY5lf1McCcecJoO8t8JDu962c1pqxKfBTSFzgMD25Na/oEU
	 N3GX96LKtq4cfISuxE1GP0z3KoMRpVrn4sB8mV1lktJR/JSKHO9YSAHK+Iuy6w3ZXMw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027906;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ULKhursswxFauYfBKVq07PwHm0JE70WrpJLiik7MObE=;
	b=xNzUdR/ZuvEDWxOyodUKAnobCpM/nNVWlpFAKnvjNa5wxgLQuPheW7OuAnjLyQTQjfce
	 fF4ncDtA1tvFVp2qZkfl6i5OElufS2mDMxF1tgY9pojKJg/A/YCC1qpS4Me7oqEbSlWLw
	 vvdK1/eRS8gRENUjC7bBMCtO5oLDe2X1E2KZLXdk5dsJaNZax2l2HA+JIafjaAdG8N32h
	 3PEOQ66Vfdb2x/G59vyx+j2y6BxKITTo4bavMd/QIgCPHzcRjQSDn6PaztSbAFPNetQn5
	 Nvi+69Ka1teLrlnfDw5QN5E+1RET7QQPyEszStnC7eqv4ylmGlLIRvk0UGPnxytdSIA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FDY2dXMO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29D9A606A325;
	Wed, 18 Nov 2026 18:51:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FDY2dXMO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DFE01F000C4;
	Wed, 18 Nov 2026 18:51:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027906;
	bh=ULKhursswxFauYfBKVq07PwHm0JE70WrpJLiik7MObE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FDY2dXMOYZxE0tvE5oAa3GU/lhFIkhUpAVUT+R3LoJiugHG602BrqlIDx1QNjc1zk
	 fWweVLCYr6Tt08q/OaxTksVYFWcr4zo4B3sdNWtI0siKwTff8X1RC4Fv9R8jJH1lIP
	 BS3NiTjbFwSI11MlV3uG9wdioER724AaGEEC8G4w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Tal Zussman <tz2294@columbia.edu>,
	Alex Markuze <amarkuze@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1953/2151] ceph: fix error handling when the OSD client is stopping in ceph_submit_write()
Date: Wed, 18 Nov 2026 16:01:28 +0100
Message-ID: <20261118150232.908106460@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
 fs/ceph/addr.c | 39 +++++++++++++++++++++++----------------
 1 file changed, 23 insertions(+), 16 deletions(-)

diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index 2ca479647c320..0046f9261cf01 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -1496,27 +1496,31 @@ int ceph_submit_write(struct address_space *mapping,
 	BUG_ON(len < ceph_fscrypt_page_offset(page) + thp_size(page) - offset);
 
 	if (!ceph_inc_osd_stopping_blocker(fsc->mdsc)) {
-		for (i = 0; i < folio_batch_count(&ceph_wbc->fbatch); i++) {
-			struct folio *folio = ceph_wbc->fbatch.folios[i];
-
-			if (!folio)
-				continue;
-
-			page = &folio->page;
-			redirty_page_for_writepage(wbc, page);
-			unlock_page(page);
-		}
-
 		for (i = 0; i < ceph_wbc->locked_pages; i++) {
-			page = ceph_fscrypt_pagecache_page(ceph_wbc->pages[i]);
+			page = ceph_wbc->pages[i];
+			if (fscrypt_is_bounce_page(page)) {
+				page = fscrypt_pagecache_page(page);
+				fscrypt_free_bounce_page(ceph_wbc->pages[i]);
+			}
 
-			if (!page)
-				continue;
+			if (atomic_long_dec_return(&fsc->writeback_count) <
+			    CONGESTION_OFF_THRESH(fsc->mount_options->congestion_kb))
+				fsc->write_congested = false;
 
 			ceph_undo_wrbuffer_claim(inode, page_folio(page));
 			redirty_page_for_writepage(wbc, page);
 			unlock_page(page);
+			put_page(page);
+		}
+
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
@@ -1750,8 +1754,11 @@ static int ceph_writepages_start(struct address_space *mapping,
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



