Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A751632B108;
	Sat, 12 Sep 2026 15:06:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789225612; cv=none; b=f+kDuLFq5/TZrI8BaHoxvu5e6Q1dLCwS/ilVQHAa9kq2JxGDTJhdbdFM1MbCorqhwNW+FGtTffpPEXhnESOitpoH4yLQZ+mYHcd1mg8Pq/JJxq3laVrPrB5ru6TS5KVNKdZ2WxNTNBbVsv2uC5f9jLOv0wPspeWzh7P81GVUqqk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789225612; c=relaxed/simple;
	bh=oEbSUzt8oEAIeFTYQUcNJ01C0kzVN1Uwx8wVasDSgnU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ave/230/+AoIdJbgM8sg7MCrxzjlAB9b+nRWt/+PywqSJYz694aztEFq+pcXxfAFzgyuCOS2sudYO1fg56/Zvu3SR7WI4IcX2W/ij7rFFfzCsBhe6tMbj4ccpRY9Q/d+paRnmFfjjLGmP1ikfUdMd3RScLp6WMm8UKk6qqFC8Hg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AyrAEbWR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AyrAEbWR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E09181F000FF;
	Sat, 12 Sep 2026 15:06:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789225609;
	bh=perKbC3PNvoEaU8FYbD3By87G3X1CcAW75m34nSAtAQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AyrAEbWRbTkddacvE1i8NcUDvkTynaYOJBvwIflf8xUQFsVhxybYRaHjP6i/7HIKZ
	 55skHmOss8BtiunqQAa0XXXDcwq2lj9AFWPKgxRJgxEfUQrK39gEacpg2fP12mdAVt
	 xiycmlKgAqEXhIOj4rXrBQNh0Nq/YZ5KOa5EoxBM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhihao Cheng <chengzhihao1@huawei.com>,
	Richard Weinberger <richard@nod.at>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1180/1424] ubi: fastmap: erase_block: Get erase counter from wl_entry rather than flash
Date: Sat, 12 Sep 2026 09:00:12 +0200
Message-ID: <20260912065633.717469827@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhihao Cheng <chengzhihao1@huawei.com>

[ Upstream commit 08a4267874164b2e9c8c50831acd466f47208acc ]

Just like sync_erase() does, getting erase counter from wl_entry is
faster than reading from flash.

Signed-off-by: Zhihao Cheng <chengzhihao1@huawei.com>
Signed-off-by: Richard Weinberger <richard@nod.at>
Stable-dep-of: 420477a84f1e ("UBI: Preserve torture flag when rescheduling failed erasures")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/ubi/fastmap.c | 27 +++++++++------------------
 1 file changed, 9 insertions(+), 18 deletions(-)

diff --git a/drivers/mtd/ubi/fastmap.c b/drivers/mtd/ubi/fastmap.c
index e7a751795832a..cbc1872588688 100644
--- a/drivers/mtd/ubi/fastmap.c
+++ b/drivers/mtd/ubi/fastmap.c
@@ -1400,36 +1400,27 @@ static int ubi_write_fastmap(struct ubi_device *ubi,
  */
 static int erase_block(struct ubi_device *ubi, struct ubi_wl_entry *e)
 {
-	int ret;
+	int err;
 	struct ubi_ec_hdr *ec_hdr;
-	long long ec;
+	long long ec = e->ec;
 
 	ec_hdr = kzalloc(ubi->ec_hdr_alsize, GFP_KERNEL);
 	if (!ec_hdr)
 		return -ENOMEM;
 
-	ret = ubi_io_read_ec_hdr(ubi, e->pnum, ec_hdr, 0);
-	if (ret < 0)
-		goto out;
-	else if (ret && ret != UBI_IO_BITFLIPS) {
-		ret = -EINVAL;
-		goto out;
-	}
-
-	ret = ubi_io_sync_erase(ubi, e->pnum, 0);
-	if (ret < 0)
+	err = ubi_io_sync_erase(ubi, e->pnum, 0);
+	if (err < 0)
 		goto out;
 
-	ec = be64_to_cpu(ec_hdr->ec);
-	ec += ret;
+	ec += err;
 	if (ec > UBI_MAX_ERASECOUNTER) {
-		ret = -EINVAL;
+		err = -EINVAL;
 		goto out;
 	}
 
 	ec_hdr->ec = cpu_to_be64(ec);
-	ret = ubi_io_write_ec_hdr(ubi, e->pnum, ec_hdr);
-	if (ret < 0)
+	err = ubi_io_write_ec_hdr(ubi, e->pnum, ec_hdr);
+	if (err < 0)
 		goto out;
 
 	e->ec = ec;
@@ -1440,7 +1431,7 @@ static int erase_block(struct ubi_device *ubi, struct ubi_wl_entry *e)
 
 out:
 	kfree(ec_hdr);
-	return ret;
+	return err;
 }
 
 /**
-- 
2.53.0



