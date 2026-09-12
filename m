Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E35528E0;
	Sat, 12 Sep 2026 16:31:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789230716; cv=none; b=ZSieL+VWvtujev2Y3s8p0TUSLlqqw8naJOG9lAbW6XxHsCZJScPwP7YepPNQMATSIcwGOcstgd9TGiy4SAgTmlYpoy773T5JunTcO/8LlJfdYCeMQVA3lQw4YkrIVDtlkBi+LP/hOnropnaE1BweXp5Q6MQYJIrsqJO9NimlpdE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789230716; c=relaxed/simple;
	bh=THt5Ad+PEjiLcXZe25qz7YOxEI9GdJli8ld/gMhqlno=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YchC3/+5NAToJd2/7/isxX5i+UTtfaGu+1gfnjF5rzmeo6KfiRKBAGlJjeNJf/Nm7iWkAHJOlfGJH3iObL/N+D6DCWmGdRRe+5ZuxzAvxo5vTGU7NV2kQ2JRTv0SiRqQWAAmCVrOANfgXFAD+WHFS2voxDWoCsM5tHkdCJ0xuqE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1DTwUFNl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1DTwUFNl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82D2F1F000FF;
	Sat, 12 Sep 2026 16:31:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789230715;
	bh=NLPlumHze1lv3cabfVcOx2Nkwy+oyE57w3sa+1gM4qE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1DTwUFNlV0drYs4+WhHH6DcmOtuEFb1HDF/PDBdlDL4I88g+eesyp4hlXbfnLvOS/
	 spv8NpRyCXD1qxR9azn7Kd32kvMIVsiHPsve2atyTPW2Xyv5ra/xamV9YfiQS60JrC
	 yBkOWcRIbZG7nMM1DOMOhfEt+subEQvN9UMyiFP8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zheng Qixing <zhengqixing@huawei.com>,
	Tang Yizhou <yizhou.tang@shopee.com>,
	Yu Kuai <yukuai@fygo.io>,
	Tao Cui <cuitao@kylinos.cn>,
	Nilay Shroff <nilay@linux.ibm.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0851/1191] blk-cgroup: skip dying blkg in blkcg_activate_policy()
Date: Sat, 12 Sep 2026 08:59:39 +0200
Message-ID: <20260912065607.369464430@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zheng Qixing <zhengqixing@huawei.com>

[ Upstream commit 5e9220389920f33b6a804d50c548cd0cd1b04634 ]

When switching IO schedulers on a block device, blkcg_activate_policy()
can race with concurrent blkcg deletion, leading to a use-after-free in
rcu_accelerate_cbs.

T1:                               T2:
                                  blkg_destroy
                                  kill(&blkg->refcnt) // blkg->refcnt=1->0
                                  blkg_release // call_rcu(__blkg_release)
                                  ...
                                  blkg_free_workfn
                                  ->pd_free_fn(pd)
elv_iosched_store
elevator_switch
...
iterate blkg list
blkg_get(blkg) // blkg->refcnt=0->1
                                  list_del_init(&blkg->q_node)
blkg_put(pinned_blkg) // blkg->refcnt=1->0
blkg_release // call_rcu again
rcu_accelerate_cbs // uaf

Fix this by checking hlist_unhashed(&blkg->blkcg_node) before getting
a reference to the blkg. This is the same check used in blkg_destroy()
to detect if a blkg has already been destroyed. If the blkg is already
unhashed, skip processing it since it's being destroyed.

Fixes: f1c006f1c685 ("blk-cgroup: synchronize pd_free_fn() from blkg_free_workfn() and blkcg_deactivate_policy()")
Signed-off-by: Zheng Qixing <zhengqixing@huawei.com>
Reviewed-by: Tang Yizhou <yizhou.tang@shopee.com>
Signed-off-by: Yu Kuai <yukuai@fygo.io>
Reviewed-by: Tao Cui <cuitao@kylinos.cn>
Reviewed-by: Nilay Shroff <nilay@linux.ibm.com>
Link: https://patch.msgid.link/20260802112525.3933753-4-yukuai@kernel.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-cgroup.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index 3f5be2105f43e..e88e493457519 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -1413,6 +1413,8 @@ int blkcg_activate_policy(struct request_queue *q,
 
 		if (blkg->pd[pol->plid])
 			continue;
+		if (hlist_unhashed(&blkg->blkcg_node))
+			continue;
 
 		/* If prealloc matches, use it; otherwise try GFP_NOWAIT */
 		if (blkg == pinned_blkg) {
-- 
2.53.0



