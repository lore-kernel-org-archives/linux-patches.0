Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2103BEED8;
	Sat, 12 Sep 2026 14:50:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789224639; cv=none; b=SNWJS/wjUyS6CWOp7nXgrBqrp5UO+m+yC5zkMxYQONo4jGa6e0HLMvC1CQ9y+h5S1CSpKcxFbCBnZs/gjnzavoRSzq2Gvdw6gepoALg+rStewu+tSITLddbyezGqL2WCqwH5iTlL9Y8E27cSGAUMEs+6drzImjn/OJpdBk4yx2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789224639; c=relaxed/simple;
	bh=tjykAWJtLSbeiANsljySMNGHeMH3nahZPXpaUaN+R1Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gA0Yd7Gvn+X3dh+IErYSO5KzYfO1DvZHqE3DxZNsZARy/RUVy4EEJR10tmg2taHB+2ESXUMke4i4pdl/xj+rcKgIZr1Yz4k1162Ckqr7QHUa+PMEpbTAaCRYfIvjaO/m/c+RrZiXwcjSUxV/u6+UsEb5MB89ZsVuy54vU4j0U4k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z7uWX7Vm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z7uWX7Vm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D8201F000FF;
	Sat, 12 Sep 2026 14:50:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789224638;
	bh=NlAhoT+LT+T9FirbgopLLLt/ZhujsWDt7/CVyz9TzPE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=z7uWX7VmK3yFDXrqDvtwitTCWdRglRUZnIPTArDf/krd5jizUxhTvvA/4diSXmXCQ
	 9osZzrlhQ3juLLJ2/l+HcAnvAVVR0lrYnkBExKPC0b8bry5IqOsjXjXnzEdO4Kuxpo
	 dRKf6z+ZKs6S8leUaphaZ0bacelmkbDkHxPRN9/U=
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
Subject: [PATCH 6.6 1033/1424] blk-cgroup: skip dying blkg in blkcg_activate_policy()
Date: Sat, 12 Sep 2026 08:57:45 +0200
Message-ID: <20260912065630.445484566@linuxfoundation.org>
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
index b8d8b6b58a6c8..b108e934a1427 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -1586,6 +1586,8 @@ int blkcg_activate_policy(struct gendisk *disk, const struct blkcg_policy *pol)
 
 		if (blkg->pd[pol->plid])
 			continue;
+		if (hlist_unhashed(&blkg->blkcg_node))
+			continue;
 
 		/* If prealloc matches, use it; otherwise try GFP_NOWAIT */
 		if (blkg == pinned_blkg) {
-- 
2.53.0



