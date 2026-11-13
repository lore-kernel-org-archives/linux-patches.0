Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590685;
	b=4vAgYfVeYfxJ9dzdAsGW7aX5L2Kwx9Z+rQM291b3elVdyJ8kObBT7ZZRnZUq+fVZ6N+C
	 3b8ZoSoAz2J/vfHZcsutrf8llXgrzeLxx0wT7UrerOnEkwZEgwNlFv4S0yRmJeoHHSoA1
	 3dnBaH5k8o1QH7TINx5kFUWLVmLryr36h6dg6CXVYuwgmfge15u/wdgqPfwLwn7yZ2s4h
	 yMoKiPh6VTRd0L7NLO5XLpgk5QpcLwVv2oUM6zvETDDp6lyR1pxSz9Qy+yIW8+oxlCNxs
	 /SG4iJSWKgMNiamow+HOTmeAS1fQDxlmucIiKNrNnhFapon1A67FFFqpMJyhl/6RsQQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590685;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=UiIrXs/jSPqDgvldoBqIyDDdQpDCDA8RTLm9yjfR9BY=;
	b=UJNMOuhUGiXa3pNQ8t+nYbuUwBizdtGoEY8/z2+cg5ijtVOk8cd5Fr2io7LSVHhEWvOb
	 jd7DfNCLipAEsjaA7C+d3b+Hn0M0EsAl3xWaLqoMJDcg8732eu2/QgqUbutsoy0G1yZTX
	 PaliyMOHIPsGrYkeUu3uV0ioQ/k2lwLP1SO7fc9Ihw6QWwIkk8DnfXSKuBNHl3QLuAnpo
	 rEaGlZ6RlCD/bTmmrz+mgMAEbp8O9XPT2EbX884nWoK2OYuZzdNfjFYPcvGNKoNTeAfG4
	 ocSRxDZOmwBgUuLmP9A244/obd8eK7YEF9mRx+vRq4wtFNBeVqJdbiEuWLgWmdYJa7w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vH3w36wf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C732606B21A;
	Fri, 13 Nov 2026 17:24:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vH3w36wf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD4471F000C7;
	Fri, 13 Nov 2026 17:24:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590685;
	bh=UiIrXs/jSPqDgvldoBqIyDDdQpDCDA8RTLm9yjfR9BY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vH3w36wfD8Cs9XEzd+NrfwEzAgr+2hNQhyGsVPc5FWatRDMi4bSLHhsnd14asgngM
	 h9UpZrNaK7EjCrY+CEUFOjP6eZWpDgJL3/S/A1oOTH6Qgu9pnOU4z30ady5ehM/xgK
	 UahpR/cAnUr1piLXDz0RHvSbLr3K30SqcHdaWFbc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pankaj Raghav <p.raghav@samsung.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 596/686] iomap: use largest_zero_folio() in iomap_dio_zero()
Date: Fri, 13 Nov 2026 10:52:09 -0500
Message-ID: <20261113153842.136269798@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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

From: Pankaj Raghav <p.raghav@samsung.com>

[ Upstream commit 10436adf9df60ae73390754b47a4bdebf728529f ]

iomap_dio_zero() uses a custom allocated memory of zeroes for padding
zeroes. This was a temporary solution until there was a way to request a
zero folio that was greater than the PAGE_SIZE.

Use largest_zero_folio() function instead of using the custom allocated
memory of zeroes. There is no guarantee from largest_zero_folio()
function that it will always return a PMD sized folio. Adapt the code so
that it can also work if largest_zero_folio() returns a ZERO_PAGE.

Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Stable-dep-of: a9fd24bcbe69 ("iomap: don't lose a failed direct I/O bio's error when zeroing the tail")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/iomap/direct-io.c | 38 +++++++++++++++-----------------------
 1 file changed, 15 insertions(+), 23 deletions(-)

diff --git a/fs/iomap/direct-io.c b/fs/iomap/direct-io.c
index bb276321c9521..5a97614507530 100644
--- a/fs/iomap/direct-io.c
+++ b/fs/iomap/direct-io.c
@@ -24,13 +24,6 @@
 #define IOMAP_DIO_WRITE		(1U << 30)
 #define IOMAP_DIO_DIRTY		(1U << 31)
 
-/*
- * Used for sub block zeroing in iomap_dio_zero()
- */
-#define IOMAP_ZERO_PAGE_SIZE (SZ_64K)
-#define IOMAP_ZERO_PAGE_ORDER (get_order(IOMAP_ZERO_PAGE_SIZE))
-static struct page *zero_page;
-
 struct iomap_dio {
 	struct kiocb		*iocb;
 	const struct iomap_dio_ops *dops;
@@ -296,24 +289,35 @@ static int iomap_dio_zero(const struct iomap_iter *iter, struct iomap_dio *dio,
 {
 	struct inode *inode = file_inode(dio->iocb->ki_filp);
 	struct bio *bio;
+	struct folio *zero_folio = largest_zero_folio();
+	int nr_vecs = max(1, i_blocksize(inode) / folio_size(zero_folio));
 
 	if (!len)
 		return 0;
+
 	/*
-	 * Max block size supported is 64k
+	 * This limit shall never be reached as most filesystems have a
+	 * maximum blocksize of 64k.
 	 */
-	if (WARN_ON_ONCE(len > IOMAP_ZERO_PAGE_SIZE))
+	if (WARN_ON_ONCE(nr_vecs > BIO_MAX_VECS))
 		return -EINVAL;
 
-	bio = iomap_dio_alloc_bio(iter, dio, 1, REQ_OP_WRITE | REQ_SYNC | REQ_IDLE);
+	bio = iomap_dio_alloc_bio(iter, dio, nr_vecs,
+				  REQ_OP_WRITE | REQ_SYNC | REQ_IDLE);
 	fscrypt_set_bio_crypt_ctx(bio, inode, pos >> inode->i_blkbits,
 				  GFP_KERNEL);
 	bio->bi_iter.bi_sector = iomap_sector(&iter->iomap, pos);
 	bio->bi_private = dio;
 	bio->bi_end_io = iomap_dio_bio_end_io;
 
-	__bio_add_page(bio, zero_page, len, 0);
+	while (len > 0) {
+		unsigned int io_len = min(len, folio_size(zero_folio));
+
+		bio_add_folio_nofail(bio, zero_folio, io_len, 0);
+		len -= io_len;
+	}
 	iomap_dio_submit_bio(iter, dio, bio, pos);
+
 	return 0;
 }
 
@@ -841,15 +845,3 @@ iomap_dio_rw(struct kiocb *iocb, struct iov_iter *iter,
 	return iomap_dio_complete(dio);
 }
 EXPORT_SYMBOL_GPL(iomap_dio_rw);
-
-static int __init iomap_dio_init(void)
-{
-	zero_page = alloc_pages(GFP_KERNEL | __GFP_ZERO,
-				IOMAP_ZERO_PAGE_ORDER);
-
-	if (!zero_page)
-		return -ENOMEM;
-
-	return 0;
-}
-fs_initcall(iomap_dio_init);
-- 
2.53.0



