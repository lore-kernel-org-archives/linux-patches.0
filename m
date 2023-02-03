Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 020C91FB4
	for <patches@lists.linux.dev>; Fri,  3 Feb 2023 10:23:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 365ABC4339B;
	Fri,  3 Feb 2023 10:23:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675419800;
	bh=tfqkFwdSGSs2pUHF3ZMa11LzL7JgNr+nwO7nifF8Q1g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=STsRSyKsjZLYX4NkfiM9JSAOnnL2O/G2lwn9FcVkPcneeKeAN9R1NLHHa2S4X3M+2
	 8ft6pV/G3xiIyz+9LMWxdVJdRJFLQNptxT74rDJYq5Jn+sVH9/s42uJ10vQgwIXGrl
	 BD7BLLSITAea5Ji2A1gWq7OUPC2O0M5tZIpTPcwE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Kuai <yukuai3@huawei.com>,
	Tejun Heo <tj@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 5/9] blk-cgroup: fix missing pd_online_fn() while activating policy
Date: Fri,  3 Feb 2023 11:13:34 +0100
Message-Id: <20230203101006.654834566@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230203101006.422534094@linuxfoundation.org>
References: <20230203101006.422534094@linuxfoundation.org>
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

[ Upstream commit e3ff8887e7db757360f97634e0d6f4b8e27a8c46 ]

If the policy defines pd_online_fn(), it should be called after
pd_init_fn(), like blkg_create().

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Acked-by: Tejun Heo <tj@kernel.org>
Link: https://lore.kernel.org/r/20230103112833.2013432-1-yukuai1@huaweicloud.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-cgroup.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index 484c6b2dd264..c623632c1cda 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -1370,6 +1370,10 @@ int blkcg_activate_policy(struct request_queue *q,
 		list_for_each_entry_reverse(blkg, &q->blkg_list, q_node)
 			pol->pd_init_fn(blkg->pd[pol->plid]);
 
+	if (pol->pd_online_fn)
+		list_for_each_entry_reverse(blkg, &q->blkg_list, q_node)
+			pol->pd_online_fn(blkg->pd[pol->plid]);
+
 	__set_bit(pol->plid, q->blkcg_pols);
 	ret = 0;
 
-- 
2.39.0



