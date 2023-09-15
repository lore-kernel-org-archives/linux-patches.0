Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30BBA1B294
	for <patches@lists.linux.dev>; Fri, 15 Sep 2023 21:33:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=2mSGek1i5EgJL9SrMaIAYJlLO6wzLTnTk7T6Som6xA4=; b=Ycrwpwu7ypuRwzODX1BDsAiH+x
	MWK9lId7QT9gWn+XlmAbxOB4bSVNOmm4G/+yV0lLPwfmgADJUAF6zlOeJAt9lnoexWN2CxXYWQlSK
	AFIPn/AhNXs/9E5DN2ZWTvC5XwMj56lS3cMbuYNaZRmtyOhukh50OezpfX13JwzSICvSlO4aVnBXE
	eJLz3FPaIhB6+mAVhKDpVdr0MWAKqnMCLIqfiPqd81Z2y5GmnlWO8EH6OpJlqSfMhlhfxniLs3CnJ
	PsDD68MzF3vYxWyk2ML392iUBym8SeaLa+cefz1Y+LbLyBi8HuhrEDG9tTGTdQ2SuIwFl3yhvSnVs
	cW26v5qg==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1qhGQq-00BQnO-0d;
	Fri, 15 Sep 2023 21:32:56 +0000
From: Luis Chamberlain <mcgrof@kernel.org>
To: hch@infradead.org,
	djwong@kernel.org,
	dchinner@redhat.com,
	kbusch@kernel.org,
	sagi@grimberg.me,
	axboe@fb.com
Cc: willy@infradead.org,
	brauner@kernel.org,
	hare@suse.de,
	ritesh.list@gmail.com,
	rgoldwyn@suse.com,
	jack@suse.cz,
	ziy@nvidia.com,
	ryan.roberts@arm.com,
	patches@lists.linux.dev,
	linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-block@vger.kernel.org,
	p.raghav@samsung.com,
	da.gomez@samsung.com,
	dan.helmick@samsung.com,
	mcgrof@kernel.org
Subject: [RFC v2 03/10] bdev: increase bdev max blocksize depending on the aops used
Date: Fri, 15 Sep 2023 14:32:47 -0700
Message-Id: <20230915213254.2724586-4-mcgrof@kernel.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230915213254.2724586-1-mcgrof@kernel.org>
References: <20230915213254.2724586-1-mcgrof@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: Luis Chamberlain <mcgrof@infradead.org>

While buffer-heads is stuck at order 0, so PAGE_SIZE, iomap support is
currently capped at MAX_PAGECACHE_ORDER as that is the cap also set on
readahead. We match parity for the max allowed block size when using
iomap.

Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
---
 block/bdev.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/block/bdev.c b/block/bdev.c
index 63b4d7dd8075..0d685270cd34 100644
--- a/block/bdev.c
+++ b/block/bdev.c
@@ -143,10 +143,17 @@ static void set_init_blocksize(struct block_device *bdev)
 	}
 }
 
+static int bdev_bsize_limit(struct block_device *bdev)
+{
+	if (bdev->bd_inode->i_data.a_ops == &def_blk_aops_iomap)
+		return 1 << (PAGE_SHIFT + MAX_PAGECACHE_ORDER);
+	return PAGE_SIZE;
+}
+
 int set_blocksize(struct block_device *bdev, int size)
 {
-	/* Size must be a power of two, and between 512 and PAGE_SIZE */
-	if (size > PAGE_SIZE || size < 512 || !is_power_of_2(size))
+	/* Size must be a power of two, and between 512 and supported order */
+	if (size > bdev_bsize_limit(bdev) || size < 512 || !is_power_of_2(size))
 		return -EINVAL;
 
 	/* Size cannot be smaller than the size supported by the device */
-- 
2.39.2

