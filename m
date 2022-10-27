Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA47EAD23
	for <patches@lists.linux.dev>; Thu, 27 Oct 2022 17:07:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CB8AC433C1;
	Thu, 27 Oct 2022 17:07:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1666890458;
	bh=/5DiX3fzDhxiCvwaypMTm5GNdUQ/9JXxBImOGAswOyw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ESRp6sUdeFVMFGlPmGmueABXGowwcvkc6dKbK9k2JqV0ejwRtWmOHRet42UqooSmo
	 GYK9Ed1BB/Iwj3v8R+O3XnkEfeCJ+tZIojpujswGE2u9DTHpe3wTfyXz8LXLLzv6rJ
	 V+DcrZxAvKnb3vWVOmYbDEmeR1NtPjIbioYafI+k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <yujie.liu@intel.com>,
	Yu Kuai <yukuai3@huawei.com>,
	Ming Lei <ming.lei@redhat.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.10 78/79] blk-wbt: fix that rwb->wc is always set to 1 in wbt_init()
Date: Thu, 27 Oct 2022 18:56:28 +0200
Message-Id: <20221027165056.972279568@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221027165054.270676357@linuxfoundation.org>
References: <20221027165054.270676357@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Yu Kuai <yukuai3@huawei.com>

commit 285febabac4a16655372d23ff43e89ff6f216691 upstream.

commit 8c5035dfbb94 ("blk-wbt: call rq_qos_add() after wb_normal is
initialized") moves wbt_set_write_cache() before rq_qos_add(), which
is wrong because wbt_rq_qos() is still NULL.

Fix the problem by removing wbt_set_write_cache() and setting 'rwb->wc'
directly. Noted that this patch also remove the redundant setting of
'rab->wc'.

Fixes: 8c5035dfbb94 ("blk-wbt: call rq_qos_add() after wb_normal is initialized")
Reported-by: kernel test robot <yujie.liu@intel.com>
Link: https://lore.kernel.org/r/202210081045.77ddf59b-yujie.liu@intel.com
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Reviewed-by: Ming Lei <ming.lei@redhat.com>
Link: https://lore.kernel.org/r/20221009101038.1692875-1-yukuai1@huaweicloud.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 block/blk-wbt.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/block/blk-wbt.c
+++ b/block/blk-wbt.c
@@ -838,12 +838,11 @@ int wbt_init(struct request_queue *q)
 	rwb->last_comp = rwb->last_issue = jiffies;
 	rwb->win_nsec = RWB_WINDOW_NSEC;
 	rwb->enable_state = WBT_STATE_ON_DEFAULT;
-	rwb->wc = 1;
+	rwb->wc = test_bit(QUEUE_FLAG_WC, &q->queue_flags);
 	rwb->rq_depth.default_depth = RWB_DEF_DEPTH;
 	rwb->min_lat_nsec = wbt_default_latency_nsec(q);
 
 	wbt_queue_depth_changed(&rwb->rqos);
-	wbt_set_write_cache(q, test_bit(QUEUE_FLAG_WC, &q->queue_flags));
 
 	/*
 	 * Assign rwb and add the stats callback.


