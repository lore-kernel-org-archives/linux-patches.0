Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E8ED375AC1
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:00:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301634; cv=none; b=vBy7B9UOaMJoJkrsaSdtjFF5x1ABPHGWRTT9al0ugiKDDSrVVnM93X6f4OmISFetyvtmAp87KiX7Xx8DBG+z2hX07224XOudp+TuEEyK7cLTIHbqYtvT5EhcIcQaI3uejZ4sV4GYLPUMfeflqMU7T2lKltNimBIkM1FWenyGPUw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301634; c=relaxed/simple;
	bh=6qbgEPZKo8/d3a0HllNAmUiFpzMB6mQRDqH62Zw4LOo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M0yBNphwpbRLizj7zncGWGVedsCLIc2sKR9WQoNFMaUhScDdRjJaFQ3hEOPhD97OKeGETSlzwQSjPAdjjR9zMrLOS+eTalkivLdUN13eChhUyDHpxDMCfgPM+U9rx8RPaescN0WBD1xWRLCMK30AedSpy6k4b9YjM+zntV/MnYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fKojgSKe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fKojgSKe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CB70C116D0;
	Sat, 28 Feb 2026 18:00:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301634;
	bh=6qbgEPZKo8/d3a0HllNAmUiFpzMB6mQRDqH62Zw4LOo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fKojgSKeHTRWjgtcjRVEcsLEpsCiJG4xmdEwUZmEgLOklJT0gE6YM9oO7o6W3lA+W
	 WExRU8Pu1k3FDZo5+DaWxVS6VkR9ecMlRJR5X+CN3+thQ2g/LnN72LIxt8Zdel3Gjw
	 8OYF3rVf5U3/0nvrL0hBqkKI7tNCbO5/W8OrmuwykpNgSmG5wwO3Z7Mg61MOyQ6MrF
	 qTGHyb7EIlUJ5im4D/dlfOiCvAtR83f5PcodreZ5sWctWFjGD++MDfZb+5s36yHZbq
	 f6r6AHN10k9qtQKmqOda/O9HLroChQxTOS6nyqwI8A6/mUaKvNgOghGwZo+d0zK9y5
	 kOg5x5YUMx1Lg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Florian-Ewald Mueller <florian-ewald.mueller@ionos.com>,
	Md Haris Iqbal <haris.iqbal@ionos.com>,
	Grzegorz Prajsner <grzegorz.prajsner@ionos.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 026/385] rnbd-srv: Fix server side setting of bi_size for special IOs
Date: Sat, 28 Feb 2026 12:54:08 -0500
Message-ID: <20260228180011.1568201-26-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Florian-Ewald Mueller <florian-ewald.mueller@ionos.com>

[ Upstream commit 4ac9690d4b9456ca1d5276d86547fa2e7cd47684 ]

On rnbd-srv, the bi_size of the bio is set during the bio_add_page
function, to which datalen is passed. But for special IOs like DISCARD
and WRITE_ZEROES, datalen is 0, since there is no data to write. For
these special IOs, use the bi_size of the rnbd_msg_io.

Fixes: f6f84be089c9 ("block/rnbd-srv: Add sanity check and remove redundant assignment")
Signed-off-by: Florian-Ewald Mueller <florian-ewald.mueller@ionos.com>
Signed-off-by: Md Haris Iqbal <haris.iqbal@ionos.com>
Signed-off-by: Grzegorz Prajsner <grzegorz.prajsner@ionos.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/rnbd/rnbd-srv.c | 33 +++++++++++++++++++++++----------
 1 file changed, 23 insertions(+), 10 deletions(-)

diff --git a/drivers/block/rnbd/rnbd-srv.c b/drivers/block/rnbd/rnbd-srv.c
index dd4d813718fd2..ba44018b00af5 100644
--- a/drivers/block/rnbd/rnbd-srv.c
+++ b/drivers/block/rnbd/rnbd-srv.c
@@ -145,18 +145,30 @@ static int process_rdma(struct rnbd_srv_session *srv_sess,
 	priv->sess_dev = sess_dev;
 	priv->id = id;
 
-	bio = bio_alloc(file_bdev(sess_dev->bdev_file), 1,
+	bio = bio_alloc(file_bdev(sess_dev->bdev_file), !!datalen,
 			rnbd_to_bio_flags(le32_to_cpu(msg->rw)), GFP_KERNEL);
-	bio_add_virt_nofail(bio, data, datalen);
-
-	bio->bi_opf = rnbd_to_bio_flags(le32_to_cpu(msg->rw));
-	if (bio_has_data(bio) &&
-	    bio->bi_iter.bi_size != le32_to_cpu(msg->bi_size)) {
-		rnbd_srv_err_rl(sess_dev, "Datalen mismatch:  bio bi_size (%u), bi_size (%u)\n",
-				bio->bi_iter.bi_size, msg->bi_size);
-		err = -EINVAL;
-		goto bio_put;
+	if (unlikely(!bio)) {
+		err = -ENOMEM;
+		goto put_sess_dev;
 	}
+
+	if (!datalen) {
+		/*
+		 * For special requests like DISCARD and WRITE_ZEROES, the datalen is zero.
+		 */
+		bio->bi_iter.bi_size = le32_to_cpu(msg->bi_size);
+	} else {
+		bio_add_virt_nofail(bio, data, datalen);
+		bio->bi_opf = rnbd_to_bio_flags(le32_to_cpu(msg->rw));
+		if (bio->bi_iter.bi_size != le32_to_cpu(msg->bi_size)) {
+			rnbd_srv_err_rl(sess_dev,
+					"Datalen mismatch:  bio bi_size (%u), bi_size (%u)\n",
+					bio->bi_iter.bi_size, msg->bi_size);
+			err = -EINVAL;
+			goto bio_put;
+		}
+	}
+
 	bio->bi_end_io = rnbd_dev_bi_end_io;
 	bio->bi_private = priv;
 	bio->bi_iter.bi_sector = le64_to_cpu(msg->sector);
@@ -170,6 +182,7 @@ static int process_rdma(struct rnbd_srv_session *srv_sess,
 
 bio_put:
 	bio_put(bio);
+put_sess_dev:
 	rnbd_put_sess_dev(sess_dev);
 err:
 	kfree(priv);
-- 
2.51.0

