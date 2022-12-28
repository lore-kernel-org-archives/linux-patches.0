Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E7771863
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 15:36:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A52E2C433F0;
	Wed, 28 Dec 2022 15:36:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672241813;
	bh=r5T/QLqhwEd5e6IvFyVfQ+TBmpksnfSfuadkJrqHTuM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rvz0hJTGQppfKr7MHjQHXuDgOlRUJolJ5a552iXdPXT3khhObcJVLVsRqCiWoP7vE
	 IHmKQE8tll+2Fqru92fL9qKhBgLj9io7aQznBTYvo9sPfWaFj7fNxPBZWKdMDVnkpN
	 Fqxotfs+O3jvesnk21mqqiRdKJhlnl/BF0i5xbkw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Kuai <yukuai3@huawei.com>,
	Christoph Hellwig <hch@lst.de>,
	Mike Snitzer <snitzer@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0330/1073] block: clear ->slave_dir when dropping the main slave_dir reference
Date: Wed, 28 Dec 2022 15:31:58 +0100
Message-Id: <20221228144336.967360506@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit d90db3b1c8676bc88b4309c5a571333de2263b8e ]

Zero out the pointer to ->slave_dir so that the holder code doesn't
incorrectly treat the object as alive when add_disk failed or after
del_gendisk was called.

Fixes: 89f871af1b26 ("dm: delay registering the gendisk")
Reported-by: Yu Kuai <yukuai3@huawei.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Reviewed-by: Mike Snitzer <snitzer@kernel.org>
Link: https://lore.kernel.org/r/20221115141054.1051801-2-yukuai1@huaweicloud.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/genhd.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/block/genhd.c b/block/genhd.c
index 044ff97381e3..28654723bc2b 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -522,6 +522,7 @@ int __must_check device_add_disk(struct device *parent, struct gendisk *disk,
 	rq_qos_exit(disk->queue);
 out_put_slave_dir:
 	kobject_put(disk->slave_dir);
+	disk->slave_dir = NULL;
 out_put_holder_dir:
 	kobject_put(disk->part0->bd_holder_dir);
 out_del_integrity:
@@ -618,6 +619,7 @@ void del_gendisk(struct gendisk *disk)
 
 	kobject_put(disk->part0->bd_holder_dir);
 	kobject_put(disk->slave_dir);
+	disk->slave_dir = NULL;
 
 	part_stat_set_all(disk->part0, 0);
 	disk->part0->bd_stamp = 0;
-- 
2.35.1



