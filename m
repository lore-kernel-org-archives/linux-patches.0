Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E37D6BA32
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 17:12:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C834C433D2;
	Tue,  7 Mar 2023 17:12:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678209163;
	bh=SR5GGAjnjRTbljJp+bT/tA8WRvkhJjjGC5XvychYUdI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PviwvCGA1AI+WkROGYyl0FDD5yiXmSyeNJpMZ3iXGZo0yuMc0I0mubwaoXWrUxf/T
	 aPPuFBGvaYmE8K8fTXUAHs/5TUmJ4XXP7tqqTaYPucpv1aKeuJ8jGXQjdCrqdIZW8L
	 +JiXWdYjidBmDt2FqcGCcCj/YPC2eNajNQ9FVo0E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0131/1001] block: use proper return value from bio_failfast()
Date: Tue,  7 Mar 2023 17:48:23 +0100
Message-Id: <20230307170027.750593873@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jens Axboe <axboe@kernel.dk>

[ Upstream commit f3ca73862453ac1e64fc6968a14bf66d839cd2d8 ]

kernel test robot complains about a type mismatch:

   block/blk-merge.c:984:42: sparse:     expected restricted blk_opf_t const [usertype] ff
   block/blk-merge.c:984:42: sparse:     got unsigned int
   block/blk-merge.c:1010:42: sparse: sparse: incorrect type in initializer (different base types) @@     expected restricted blk_opf_t const [usertype] ff @@     got unsigned int @@
   block/blk-merge.c:1010:42: sparse:     expected restricted blk_opf_t const [usertype] ff
   block/blk-merge.c:1010:42: sparse:     got unsigned int

because bio_failfast() is return an unsigned int rather than the
appropriate blk_opt_f type. Fix it up.

Fixes: 3ce6a115980c ("block: sync mixed merged request's failfast with 1st bio's")
Reported-by: kernel test robot <lkp@intel.com>
Link: https://lore.kernel.org/oe-kbuild-all/202302170743.GXypM9Rt-lkp@intel.com/
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-merge.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/block/blk-merge.c b/block/blk-merge.c
index 30e4a99c2276b..808b58129d3e4 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -757,7 +757,7 @@ void blk_rq_set_mixed_merge(struct request *rq)
 	rq->rq_flags |= RQF_MIXED_MERGE;
 }
 
-static inline unsigned int bio_failfast(const struct bio *bio)
+static inline blk_opf_t bio_failfast(const struct bio *bio)
 {
 	if (bio->bi_opf & REQ_RAHEAD)
 		return REQ_FAILFAST_MASK;
-- 
2.39.2



