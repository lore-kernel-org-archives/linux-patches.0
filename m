Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82D0C3988F8;
	Sat, 12 Sep 2026 20:00:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789243232; cv=none; b=gm6PIat5HanGcd2fdq9PgwGSu3e1nalPIUoQS45ptLOjfwCU+WF0YO0MWYzTEmqvoTwOrN3Bmud5Ov9G7M3bAtc5fyeomp2F8LVPXjVGGqFVwxh1RkHPzEC6yNVNSQpwxDJGVLob1CcJw5hJZq/idbE+m84CzxR1QOpSsMAa+is=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789243232; c=relaxed/simple;
	bh=ko11gQzxAxZmBbEsMkjOSwaIn0uyC88MZvhZfamAMIY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VOC1+cALsbm0WVwNaw/lly2Faf6jOQekAGR2971XXrEjbgXP8WBcUYqEfvI559+YalQIjATyoBtOJhEF2N9ZIkrZBPINQk4b8KNRdL54/cULcMASZqILqtqsRWrMsVebDhxI27ZVqUYesIMUtsM3AHujCOt0xrCwHy0x1JLI/cc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=utSmEBd8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="utSmEBd8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEF9E1F000FF;
	Sat, 12 Sep 2026 20:00:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789243231;
	bh=4r/N4304jpSG2J9NEMpvlhfGPuxTXSZr2oWP38P1odA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=utSmEBd8PZrm8lWWN20zHwgwQipbR78afg68inJtuvQ8j4Sr+uS1kQpjdl2BKKEGZ
	 5H6tN+TgUCmtAGhYb9iks8UQvuALshIklNdos5N1rrmZnAYQa6vq+oYfr2Cr9jR9jm
	 n+7frg24V9K5JsTTcLMafGVX3yOA1/luCJFToT8s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhihao Cheng <chengzhihao1@huawei.com>,
	Richard Weinberger <richard@nod.at>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 682/798] ubi: fastmap: erase_block: Get erase counter from wl_entry rather than flash
Date: Sat, 12 Sep 2026 09:05:10 +0200
Message-ID: <20260912065532.735010455@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 5dbab1237fee9..f579493b24b80 100644
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



