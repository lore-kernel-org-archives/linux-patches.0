Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DA8820CCED;
	Sat,  7 Jun 2025 10:08:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749290890; cv=none; b=jLibr7krp0QWE2BOTdyEWXiGDzx5FsVzZlpgZX4zZ3sDNLx56VKQbOlv+r/EPE/ur5yWf0S1eSBTcLiDviXuga0LXbAkb/C8gF4V/Z7RgitHSgXjH92vLzg8Gr69AlTiTZW8a04pF/dzJWN+bQ3w9AuFtLWgM3LHVsJDMilQqSM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749290890; c=relaxed/simple;
	bh=3TzKhnP0yNNHqKO87vRY3O2UB2CVrT+vwiYbr/99U2M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SHRPBgHkaqvLDv6ouxOVEKKnDwuim1WXH/tdTGuTiz3u1on22854j3m7LAOCH5+TkfG0YQhGaY3ehNMHwLaxAX8uH3UE2g5Yh4wDyn3nwElkzhs5be/+8znH1IZNKo1E0VuYJlA7McxMXO3bz5+5GmHHh/aYnBm0vWGLbJyDXLc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vh9Nrf5+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vh9Nrf5+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8244FC4CEE4;
	Sat,  7 Jun 2025 10:08:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1749290889;
	bh=3TzKhnP0yNNHqKO87vRY3O2UB2CVrT+vwiYbr/99U2M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vh9Nrf5+9SS3CvNmgBwT5AyoIGA+zNLGe2lXL6hf7U+3QE+MavTkou9gx9gySBtH+
	 LzPrShQQXHT1/uE7qi9hJyfYZJsdWAuDtUA3Tb7rh06fGB0AVe01rSq9F9mBdN70hG
	 YPynBxUA7dh/wx0QYhBOF8l0dz2+hok6wlTdyB/4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kundan Kumar <kundan.kumar@samsung.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Christoph Hellwig <hch@lst.de>,
	Luis Chamberlain <mcgrof@kernel.org>,
	Gavin Shan <gshan@redhat.com>,
	Ming Lei <ming.lei@redhat.com>,
	Jens Axboe <axboe@kernel.dk>,
	Alva Lan <alvalan9@foxmail.com>
Subject: [PATCH 6.12 12/24] block: fix adding folio to bio
Date: Sat,  7 Jun 2025 12:07:43 +0200
Message-ID: <20250607100718.386011321@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250607100717.910797456@linuxfoundation.org>
References: <20250607100717.910797456@linuxfoundation.org>
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

From: Ming Lei <ming.lei@redhat.com>

commit 26064d3e2b4d9a14df1072980e558c636fb023ea upstream.

>4GB folio is possible on some ARCHs, such as aarch64, 16GB hugepage
is supported, then 'offset' of folio can't be held in 'unsigned int',
cause warning in bio_add_folio_nofail() and IO failure.

Fix it by adjusting 'page' & trimming 'offset' so that `->bi_offset` won't
be overflow, and folio can be added to bio successfully.

Fixes: ed9832bc08db ("block: introduce folio awareness and add a bigger size from folio")
Cc: Kundan Kumar <kundan.kumar@samsung.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Luis Chamberlain <mcgrof@kernel.org>
Cc: Gavin Shan <gshan@redhat.com>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Link: https://lore.kernel.org/r/20250312145136.2891229-1-ming.lei@redhat.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
[ The follow-up fix fbecd731de05 ("xfs: fix zoned GC data corruption due to
  wrong bv_offset") addresses issues in the file fs/xfs/xfs_zone_gc.c.  This
  file was first introduced in version v6.15-rc1. So don't backport the follow
  up fix to 6.12.y. ]
Signed-off-by: Alva Lan <alvalan9@foxmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 block/bio.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

--- a/block/bio.c
+++ b/block/bio.c
@@ -1156,9 +1156,10 @@ EXPORT_SYMBOL(bio_add_page);
 void bio_add_folio_nofail(struct bio *bio, struct folio *folio, size_t len,
 			  size_t off)
 {
+	unsigned long nr = off / PAGE_SIZE;
+
 	WARN_ON_ONCE(len > UINT_MAX);
-	WARN_ON_ONCE(off > UINT_MAX);
-	__bio_add_page(bio, &folio->page, len, off);
+	__bio_add_page(bio, folio_page(folio, nr), len, off % PAGE_SIZE);
 }
 EXPORT_SYMBOL_GPL(bio_add_folio_nofail);
 
@@ -1179,9 +1180,11 @@ EXPORT_SYMBOL_GPL(bio_add_folio_nofail);
 bool bio_add_folio(struct bio *bio, struct folio *folio, size_t len,
 		   size_t off)
 {
-	if (len > UINT_MAX || off > UINT_MAX)
+	unsigned long nr = off / PAGE_SIZE;
+
+	if (len > UINT_MAX)
 		return false;
-	return bio_add_page(bio, &folio->page, len, off) > 0;
+	return bio_add_page(bio, folio_page(folio, nr), len, off % PAGE_SIZE) > 0;
 }
 EXPORT_SYMBOL(bio_add_folio);
 


