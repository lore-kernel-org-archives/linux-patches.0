Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9BBB2F7477;
	Tue, 12 Aug 2025 17:40:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755020453; cv=none; b=h45z+hNyRgwiTo3knKYy4xOpvpIoCdO/mxAFM5DpLnyyCE4/XtRBECXebFO+rAcyWkGe2Zw/VO5RmX6f5ZZ2As+9RzleZQinLfrIeuJDTt0daVjw8fG0UbMvKsDs+bsYN5n74zex/Xi2Lhlvxo1cRe8eBw1Ss/bjXv0RqDQM0l0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755020453; c=relaxed/simple;
	bh=9W9XsEOL3I9XOZqVzJBJgNwsmolxySWL2FPNI4RaaJE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KFofSkyicRm5LIQcaFhEMys4Cr89JulRN2L2s+GDRQuQxYs7Jjo0u16ahJge1i54683igdBCDYeyI3Tx1mMMCTrPuiiJcC0TPdnKo1hQJo/QEfBdOGQEHKoU51C9OEfX0s2mRKLF1DLMcZDv9DR9T0/B9ejwTYfgqaoozv+Qr6Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z3qpZxwI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z3qpZxwI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE2F6C4CEF0;
	Tue, 12 Aug 2025 17:40:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755020452;
	bh=9W9XsEOL3I9XOZqVzJBJgNwsmolxySWL2FPNI4RaaJE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z3qpZxwITWql6gueUgHRngzNs/CarfzXuJ1wbaTRYJoFlvYe4EcYlccv6yWGgPZk5
	 eZ26S/YW+E7sV12kFZE62SuXXdkPwXAWMwa6O/UWViNRIp1ka9GBvzPoEN4nSf+jsM
	 QuI8k8HAP16yqrVUNhkfk51Oxc5pbuezkpVZ+aQ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kiszka <jan.kiszka@siemens.com>,
	Stefan Kerkmann <s.kerkmann@pengutronix.de>,
	Gao Xiang <hsiangkao@linux.alibaba.com>
Subject: [PATCH 6.1 058/253] erofs: address D-cache aliasing
Date: Tue, 12 Aug 2025 19:27:26 +0200
Message-ID: <20250812172951.195444718@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812172948.675299901@linuxfoundation.org>
References: <20250812172948.675299901@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gao Xiang <hsiangkao@linux.alibaba.com>

commit 27917e8194f91dffd8b4825350c63cb68e98ce58 upstream.

Flush the D-cache before unlocking folios for compressed inodes, as
they are dirtied during decompression.

Avoid calling flush_dcache_folio() on every CPU write, since it's more
like playing whack-a-mole without real benefit.

It has no impact on x86 and arm64/risc-v: on x86, flush_dcache_folio()
is a no-op, and on arm64/risc-v, PG_dcache_clean (PG_arch_1) is clear
for new page cache folios.  However, certain ARM boards are affected,
as reported.

Fixes: 3883a79abd02 ("staging: erofs: introduce VLE decompression support")
Closes: https://lore.kernel.org/r/c1e51e16-6cc6-49d0-a63e-4e9ff6c4dd53@pengutronix.de
Closes: https://lore.kernel.org/r/38d43fae-1182-4155-9c5b-ffc7382d9917@siemens.com
Tested-by: Jan Kiszka <jan.kiszka@siemens.com>
Tested-by: Stefan Kerkmann <s.kerkmann@pengutronix.de>
Link: https://lore.kernel.org/r/20250709034614.2780117-2-hsiangkao@linux.alibaba.com
Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/erofs/decompressor.c |    6 ++----
 fs/erofs/zdata.c        |   32 +++++++++++++++++++-------------
 2 files changed, 21 insertions(+), 17 deletions(-)

--- a/fs/erofs/decompressor.c
+++ b/fs/erofs/decompressor.c
@@ -342,14 +342,12 @@ static int z_erofs_transform_plain(struc
 
 	if (outpages > inpages) {
 		DBG_BUGON(!rq->out[outpages - 1]);
-		if (rq->out[outpages - 1] != rq->in[inpages - 1]) {
+		if (rq->out[outpages - 1] != rq->in[inpages - 1])
 			memcpy_to_page(rq->out[outpages - 1], 0, src +
 					(interlaced_offset ? 0 : righthalf),
 				       lefthalf);
-		} else if (!interlaced_offset) {
+		else if (!interlaced_offset)
 			memmove(src, src + righthalf, lefthalf);
-			flush_dcache_page(rq->in[inpages - 1]);
-		}
 	}
 	kunmap_local(src);
 	return 0;
--- a/fs/erofs/zdata.c
+++ b/fs/erofs/zdata.c
@@ -123,9 +123,11 @@ static inline unsigned int z_erofs_pclus
 
 /*
  * bit 30: I/O error occurred on this page
+ * bit 29: CPU has dirty data in D-cache (needs aliasing handling);
  * bit 0 - 29: remaining parts to complete this page
  */
-#define Z_EROFS_PAGE_EIO			(1 << 30)
+#define Z_EROFS_ONLINEPAGE_EIO		30
+#define Z_EROFS_ONLINEPAGE_DIRTY	29
 
 static inline void z_erofs_onlinepage_init(struct page *page)
 {
@@ -144,7 +146,7 @@ static inline void z_erofs_onlinepage_sp
 	atomic_inc((atomic_t *)&page->private);
 }
 
-static void z_erofs_onlinepage_endio(struct page *page, int err)
+static void z_erofs_onlinepage_end(struct page *page, int err, bool dirty)
 {
 	int orig, v;
 
@@ -152,16 +154,20 @@ static void z_erofs_onlinepage_endio(str
 
 	do {
 		orig = atomic_read((atomic_t *)&page->private);
-		v = (orig - 1) | (err ? Z_EROFS_PAGE_EIO : 0);
+		DBG_BUGON(orig <= 0);
+		v = dirty << Z_EROFS_ONLINEPAGE_DIRTY;
+		v |= (orig - 1) | (!!err << Z_EROFS_ONLINEPAGE_EIO);
 	} while (atomic_cmpxchg((atomic_t *)&page->private, orig, v) != orig);
 
-	if (!(v & ~Z_EROFS_PAGE_EIO)) {
-		set_page_private(page, 0);
-		ClearPagePrivate(page);
-		if (!(v & Z_EROFS_PAGE_EIO))
-			SetPageUptodate(page);
-		unlock_page(page);
-	}
+	if (v & (BIT(Z_EROFS_ONLINEPAGE_DIRTY) - 1))
+		return;
+	set_page_private(page, 0);
+	ClearPagePrivate(page);
+	if (v & BIT(Z_EROFS_ONLINEPAGE_DIRTY))
+		flush_dcache_page(page);
+	if (!(v & BIT(Z_EROFS_ONLINEPAGE_EIO)))
+		SetPageUptodate(page);
+	unlock_page(page);
 }
 
 #define Z_EROFS_ONSTACK_PAGES		32
@@ -925,7 +931,7 @@ next_part:
 		goto repeat;
 
 out:
-	z_erofs_onlinepage_endio(page, err);
+	z_erofs_onlinepage_end(page, err, false);
 	return err;
 }
 
@@ -1028,7 +1034,7 @@ static void z_erofs_fill_other_copies(st
 			cur += len;
 		}
 		kunmap_local(dst);
-		z_erofs_onlinepage_endio(bvi->bvec.page, err);
+		z_erofs_onlinepage_end(bvi->bvec.page, err, true);
 		list_del(p);
 		kfree(bvi);
 	}
@@ -1196,7 +1202,7 @@ out:
 		/* recycle all individual short-lived pages */
 		if (z_erofs_put_shortlivedpage(be->pagepool, page))
 			continue;
-		z_erofs_onlinepage_endio(page, err);
+		z_erofs_onlinepage_end(page, err, true);
 	}
 
 	if (be->decompressed_pages != be->onstack_pages)


