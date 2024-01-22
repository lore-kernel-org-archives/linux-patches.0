Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9CF864CCB;
	Tue, 23 Jan 2024 01:57:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975054; cv=none; b=iclt+oTHcecVCHeqISv17qK2D8st+bocb1lXfXjxtMnOos0MAu6wehJrRCoIeyQzqsvcMPLaC2YD0BKb9CDLZmdvq8TeEquiBfcs3eN3EbEOeHQjo/ICFz3T2Me8TwzPgC9NuAC5aE/FPVBYOAayJimMThLs59AtBn7slEqI91k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975054; c=relaxed/simple;
	bh=R+4fE9Rjy5idG9PKPGFc4P9EtODzT0OKWNuJv+PVBKM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EDcUzS/PxghUam7glo4GInoQDtHPTV8XDoNqnpzYi6EuWOOs7/CkezB9N0dgYtS6XLGiBHpIG6XSwwJ1fpmreTG/tdOdAv5mZX2CJum+95Go5WwnCwll8m0aFrkd+nlUJIpR8i+0Mf7KMVm/sR26tq/zsSTMvoRTeiGujYOMEG8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ux/kMbHa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ux/kMbHa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93266C433C7;
	Tue, 23 Jan 2024 01:57:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975054;
	bh=R+4fE9Rjy5idG9PKPGFc4P9EtODzT0OKWNuJv+PVBKM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ux/kMbHamOn6/mm+XXsZWJobrf5sVwtl45PM5Phm5RfmRdv/9Gzb4yITfGfGhPDKR
	 eAj38OPEU2JPa2PeI5g7pBaI2dhCUDSm4TyCanxyxZbcQjim7eqNIPlyNN5POdGgBi
	 gZkp+IgNlDPxPPC0eLXn+Z+vvfug/HC4X04Fxgy4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Changhui Zhong <czhong@redhat.com>,
	Ming Lei <ming.lei@redhat.com>,
	Yu Kuai <yukuai3@huawei.com>,
	Tejun Heo <tj@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 215/583] blk-cgroup: fix rcu lockdep warning in blkg_lookup()
Date: Mon, 22 Jan 2024 15:54:26 -0800
Message-ID: <20240122235818.592454802@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ming Lei <ming.lei@redhat.com>

[ Upstream commit 393cd8ffd832f23eec3a105553eff622e8198918 ]

blkg_lookup() is called with either queue_lock or rcu read lock, so
use rcu_dereference_check(lockdep_is_held(&q->queue_lock)) for
retrieving 'blkg', which way models the check exactly for covering
queue lock or rcu read lock.

Fix lockdep warning of "block/blk-cgroup.h:254 suspicious rcu_dereference_check() usage!"
from blkg_lookup().

Tested-by: Changhui Zhong <czhong@redhat.com>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Reviewed-by: Yu Kuai <yukuai3@huawei.com>
Fixes: 83462a6c971c ("blkcg: Drop unnecessary RCU read [un]locks from blkg_conf_prep/finish()")
Acked-by: Tejun Heo <tj@kernel.org>
Link: https://lore.kernel.org/r/20231219012833.2129540-1-ming.lei@redhat.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-cgroup.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/block/blk-cgroup.h b/block/blk-cgroup.h
index fd482439afbc..b927a4a0ad03 100644
--- a/block/blk-cgroup.h
+++ b/block/blk-cgroup.h
@@ -252,7 +252,8 @@ static inline struct blkcg_gq *blkg_lookup(struct blkcg *blkcg,
 	if (blkcg == &blkcg_root)
 		return q->root_blkg;
 
-	blkg = rcu_dereference(blkcg->blkg_hint);
+	blkg = rcu_dereference_check(blkcg->blkg_hint,
+			lockdep_is_held(&q->queue_lock));
 	if (blkg && blkg->q == q)
 		return blkg;
 
-- 
2.43.0



