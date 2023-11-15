Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9425A35F19
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 20:02:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RN/lEEiW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4599DC433C7;
	Wed, 15 Nov 2023 20:02:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700078536;
	bh=abd0pCOQ8MR5U01vbY3QINH20Toq9QFkw/noQfqZGsw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RN/lEEiWSAwqemhtkBnV4umA8Ra1Vu1IsehZ8J2bibwpYlDKjuSFyELBVwOJ5jFWG
	 wBnpK7p4aWeO3aiPeWavS8mzLLQr4DiwCAQngeN9Aj0Orrx2+zGw7RMbE/5OVTNfOA
	 yd4yB5aN145fR/m/l5vblUoKoVV4RE/lns++BD60=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Kuai <yukuai3@huawei.com>,
	Ye Bin <yebin10@huawei.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 358/379] blk-core: use pr_warn_ratelimited() in bio_check_ro()
Date: Wed, 15 Nov 2023 14:27:13 -0500
Message-ID: <20231115192706.337808728@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115192645.143643130@linuxfoundation.org>
References: <20231115192645.143643130@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Yu Kuai <yukuai3@huawei.com>

[ Upstream commit 1b0a151c10a6d823f033023b9fdd9af72a89591b ]

If one of the underlying disks of raid or dm is set to read-only, then
each io will generate new log, which will cause message storm. This
environment is indeed problematic, however we can't make sure our
naive custormer won't do this, hence use pr_warn_ratelimited() to
prevent message storm in this case.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Fixes: 57e95e4670d1 ("block: fix and cleanup bio_check_ro")
Signed-off-by: Ye Bin <yebin10@huawei.com>
Link: https://lore.kernel.org/r/20231107111247.2157820-1-yukuai1@huaweicloud.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index ebb7a1689b261..6eaf2b0ad7cca 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -490,8 +490,8 @@ static inline void bio_check_ro(struct bio *bio)
 	if (op_is_write(bio_op(bio)) && bdev_read_only(bio->bi_bdev)) {
 		if (op_is_flush(bio->bi_opf) && !bio_sectors(bio))
 			return;
-		pr_warn("Trying to write to read-only block-device %pg\n",
-			bio->bi_bdev);
+		pr_warn_ratelimited("Trying to write to read-only block-device %pg\n",
+				    bio->bi_bdev);
 		/* Older lvm-tools actually trigger this */
 	}
 }
-- 
2.42.0



