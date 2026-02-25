Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4EBD24A06D;
	Wed, 25 Feb 2026 01:27:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771982844; cv=none; b=O1IN97FHWTm1lFf9LTO3PCgza7A36AFj15tr/cZJVt/nsqJhLJEym9SR+J5I/nUL2jKLf8muY27Bx87VnzwnBmh6SUpLTZk97uQ7Nb8Txg0jNNVJy1Ci+AKzKg0DKxewjvEMToWC0KcR6SrNNdGIU+Owsj+J6YV6vFWT6tS+qg8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771982844; c=relaxed/simple;
	bh=RD6T8qGDCzttzsMXuGvtgZjfSCkLiNsWRMd6V7cnUGU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NNxG6kQ0pPiKcz77g/F9V94iwsZXMGMEg+rQAWnJkcTBCl2+3Jwsuxg+PDiSBMVDB30CjiKZ7GZfnw37oCXApP7GyPcTsCGNy8kGB82ng9gjMBUM0d0/a58wJaW6psa1Ki5pXYMkqN+Y1baX9F4tyQadXvopyFZJS1ufGMlTRCs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OtlaqgSE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OtlaqgSE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81991C116D0;
	Wed, 25 Feb 2026 01:27:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771982844;
	bh=RD6T8qGDCzttzsMXuGvtgZjfSCkLiNsWRMd6V7cnUGU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OtlaqgSEe8Bc61YRCA1ShNl3leTI+9waABHZlheMuIBUbyH3kw9IvftFbL3MChB/m
	 LEx3b+zd36Uqax8lT0HbkMoMqRQiRGn5i2RH9YDfNspicUT+HRz6ubHDgwcgeEgRtA
	 18c80k5Kw18Q1e3Py/Sb6pnOgeb1W8JXMpOOTE2c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian-Ewald Mueller <florian-ewald.mueller@ionos.com>,
	Md Haris Iqbal <haris.iqbal@ionos.com>,
	Grzegorz Prajsner <grzegorz.prajsner@ionos.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 036/781] rnbd-srv: Fix server side setting of bi_size for special IOs
Date: Tue, 24 Feb 2026 17:12:25 -0800
Message-ID: <20260225012400.588288309@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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
index 2df8941a6b146..9b3fdc202e152 100644
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



