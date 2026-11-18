Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056969;
	b=cky6/Mgx7enAfyVvzcukX2CoMCgk1hznsDEUT1SDqCDrwkP7wDNmwDrdUq2vpmoYo8Xh
	 5bF1gnAfPbPDOCmb9V+q2wXw0xhsEo1+ioBu4z8hvwG7Fpq2C73Epnon8LcR37jFGDx8r
	 Kz1lUsiB7he66oeBYIvrYdVsw9eldC7SqyprWtL7dwRtQyxqL60LVsUxz7Cl+U3WxBNYd
	 XBQDaUvzsKO7FzEUdcvx1ZTn2Ya1jpV3ok2ZR3dC+W0tv2UU7BuAT0MGQLfgtnaX3uYxp
	 Y0nVGVo1Xuk63v7kZFqSujkwf6XChuUca+sDAmDSBgXUSZpO/MEbyVmToXWgYlNBfrg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056969;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nlZoRk9/kiU0LwSStnj08ZESfHxubgGwau6+A8luHug=;
	b=WkB1kvvJ1HinOx+ehc0gsFaRREjE0UVljLFeCWewm69OIbZfP0p72PqMoXsZXp+zRrFv
	 oCWCKssOpABfXQ1MkU+4RTr2sfzAxtxmM0TrV4I8QDby+pp0P/PD4m6JWHF9fenmFAGtf
	 nf9wwXjH8tY0wMWjyFTmkLqrUOddXtMVsdPc9ubzGxXDQH3x93SJHaT+9PoJD4CZ6KaL+
	 NndhTsL5HSa8aQZ5z+tZZ2fBPBtw3zwv/Ee+Dmex1hiC4WnqUUv3nco47BODi45pzWNNe
	 IzbfVL5ZABJoOeOwrO352dAinW7qOhnu6ATMBIL2QMCv4WnMIzKeuihh3H0wVxlaxDg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sXSKxpcP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 488AA606A325;
	Thu, 19 Nov 2026 02:56:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sXSKxpcP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AE8E1F000C5;
	Thu, 19 Nov 2026 02:56:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056969;
	bh=nlZoRk9/kiU0LwSStnj08ZESfHxubgGwau6+A8luHug=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sXSKxpcPoVIzpID+PNZTodqdZuW0ViS2p1gnK5tZmjy0thP0OnKZ90pU15Zx4lFNl
	 h13eqHwQxle5pVT/h6gO2S4GMEpBEredSaORLSLGz47ZowPfXJEUt9sO6FTpaSF7p+
	 FGBYpcdhXm1IRFlTJeSsUhhYru3ocr8Kc73SejAQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Jack Wang <jinpu.wang@ionons.com>,
	Jack Wang <jinpu.wang@ionos.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 2178/2214] rnbd-srv: simplify bio mapping in process_rdma
Date: Wed, 18 Nov 2026 16:04:14 +0100
Message-ID: <20261118150137.509679566@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit 1fe0640ff94feae6d21417e2f4f2829b882274b1 ]

The memory mapped in process_rdma is contiguous, so there is no need
to loop over bio_add_page.  Remove rnbd_bio_map_kern and just open code
the bio allocation and mapping in the caller.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Jack Wang <jinpu.wang@ionons.com>
Tested-by: Jack Wang <jinpu.wang@ionos.com>
Link: https://lore.kernel.org/r/20220124091107.642561-11-hch@lst.de
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Stable-dep-of: d9667ade40f9 ("block/rnbd-srv: don't free the device on a sysfs error")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/rnbd/rnbd-srv-dev.c | 57 -------------------------------
 drivers/block/rnbd/rnbd-srv-dev.h |  5 ---
 drivers/block/rnbd/rnbd-srv.c     | 23 +++++++++----
 3 files changed, 16 insertions(+), 69 deletions(-)

diff --git a/drivers/block/rnbd/rnbd-srv-dev.c b/drivers/block/rnbd/rnbd-srv-dev.c
index b241a099aeae2..98d3e591a0885 100644
--- a/drivers/block/rnbd/rnbd-srv-dev.c
+++ b/drivers/block/rnbd/rnbd-srv-dev.c
@@ -44,60 +44,3 @@ void rnbd_dev_close(struct rnbd_dev *dev)
 	blkdev_put(dev->bdev, dev->blk_open_flags);
 	kfree(dev);
 }
-
-void rnbd_dev_bi_end_io(struct bio *bio)
-{
-	struct rnbd_dev_blk_io *io = bio->bi_private;
-
-	rnbd_endio(io->priv, blk_status_to_errno(bio->bi_status));
-	bio_put(bio);
-}
-
-/**
- *	rnbd_bio_map_kern	-	map kernel address into bio
- *	@data: pointer to buffer to map
- *	@bs: bio_set to use.
- *	@len: length in bytes
- *	@gfp_mask: allocation flags for bio allocation
- *
- *	Map the kernel address into a bio suitable for io to a block
- *	device. Returns an error pointer in case of error.
- */
-struct bio *rnbd_bio_map_kern(void *data, struct bio_set *bs,
-			      unsigned int len, gfp_t gfp_mask)
-{
-	unsigned long kaddr = (unsigned long)data;
-	unsigned long end = (kaddr + len + PAGE_SIZE - 1) >> PAGE_SHIFT;
-	unsigned long start = kaddr >> PAGE_SHIFT;
-	const int nr_pages = end - start;
-	int offset, i;
-	struct bio *bio;
-
-	bio = bio_alloc_bioset(gfp_mask, nr_pages, bs);
-	if (!bio)
-		return ERR_PTR(-ENOMEM);
-
-	offset = offset_in_page(kaddr);
-	for (i = 0; i < nr_pages; i++) {
-		unsigned int bytes = PAGE_SIZE - offset;
-
-		if (len <= 0)
-			break;
-
-		if (bytes > len)
-			bytes = len;
-
-		if (bio_add_page(bio, virt_to_page(data), bytes,
-				    offset) < bytes) {
-			/* we don't support partial mappings */
-			bio_put(bio);
-			return ERR_PTR(-EINVAL);
-		}
-
-		data += bytes;
-		len -= bytes;
-		offset = 0;
-	}
-
-	return bio;
-}
diff --git a/drivers/block/rnbd/rnbd-srv-dev.h b/drivers/block/rnbd/rnbd-srv-dev.h
index 0eb23850afb95..1a14ece0be726 100644
--- a/drivers/block/rnbd/rnbd-srv-dev.h
+++ b/drivers/block/rnbd/rnbd-srv-dev.h
@@ -41,11 +41,6 @@ void rnbd_dev_close(struct rnbd_dev *dev);
 
 void rnbd_endio(void *priv, int error);
 
-void rnbd_dev_bi_end_io(struct bio *bio);
-
-struct bio *rnbd_bio_map_kern(void *data, struct bio_set *bs,
-			      unsigned int len, gfp_t gfp_mask);
-
 static inline int rnbd_dev_get_max_segs(const struct rnbd_dev *dev)
 {
 	return queue_max_segments(bdev_get_queue(dev->bdev));
diff --git a/drivers/block/rnbd/rnbd-srv.c b/drivers/block/rnbd/rnbd-srv.c
index 3af8c4e49fe4c..e9875a54e8bf0 100644
--- a/drivers/block/rnbd/rnbd-srv.c
+++ b/drivers/block/rnbd/rnbd-srv.c
@@ -114,6 +114,14 @@ rnbd_get_sess_dev(int dev_id, struct rnbd_srv_session *srv_sess)
 	return sess_dev;
 }
 
+static void rnbd_dev_bi_end_io(struct bio *bio)
+{
+	struct rnbd_dev_blk_io *io = bio->bi_private;
+
+	rnbd_endio(io->priv, blk_status_to_errno(bio->bi_status));
+	bio_put(bio);
+}
+
 static int process_rdma(struct rnbd_srv_session *srv_sess,
 			struct rtrs_srv_op *id, void *data, u32 datalen,
 			const void *usr, size_t usrlen)
@@ -144,12 +152,12 @@ static int process_rdma(struct rnbd_srv_session *srv_sess,
 	priv->sess_dev = sess_dev;
 	priv->id = id;
 
-	/* Generate bio with pages pointing to the rdma buffer */
-	bio = rnbd_bio_map_kern(data, sess_dev->rnbd_dev->ibd_bio_set, datalen, GFP_KERNEL);
-	if (IS_ERR(bio)) {
-		err = PTR_ERR(bio);
-		rnbd_srv_err(sess_dev, "Failed to generate bio, err: %d\n", err);
-		goto sess_dev_put;
+	bio = bio_alloc_bioset(GFP_KERNEL, 1, sess_dev->rnbd_dev->ibd_bio_set);
+	if (bio_add_page(bio, virt_to_page(data), datalen,
+			offset_in_page(data)) != datalen) {
+		rnbd_srv_err(sess_dev, "Failed to map data to bio\n");
+		err = -EINVAL;
+		goto bio_put;
 	}
 
 	io = container_of(bio, struct rnbd_dev_blk_io, bio);
@@ -170,7 +178,8 @@ static int process_rdma(struct rnbd_srv_session *srv_sess,
 
 	return 0;
 
-sess_dev_put:
+bio_put:
+	bio_put(bio);
 	rnbd_put_sess_dev(sess_dev);
 err:
 	kfree(priv);
-- 
2.53.0



