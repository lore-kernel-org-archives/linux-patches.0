Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 685D235C1A0;
	Wed, 20 May 2026 17:17:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779297466; cv=none; b=dF0uyxWSwyDKTGcg68Y4aQvkiseemlFa4e9nXT4hjzcxuY82HQW3hjcl1AQ3teVO1x4PAhVSOquwi4bKwVkFnJZV+j8IUIUTJwxFX5JlnIscKrMSWvPkzgnpreHMb4E9UKY4UzCYnDIdWS+38gH+MWszxuWmYQ2rtW0SQlAbdJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779297466; c=relaxed/simple;
	bh=jl9dyrxqp5PehHyV/uS5Bs+k2vtbIg6xIuLFiPvbDFQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PQQJjX2o14HKiojFtX859RZIEO7HQYf2g9OcR12GgmUjCa+7JeG0dhoW9RgluvYAR9rEwzNCUIMOc3u/JvRsSC37knrf2QxOgrQq9gUCyLSV4CjpOiy8rmdrvpJikSqRzP6yu7GtMgvdZx3u/hwIoWBqTWO4Ko7N2J81VRz0748=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VHfDGXN0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VHfDGXN0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B4201F00893;
	Wed, 20 May 2026 17:17:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779297465;
	bh=+w20QF/NvZiPFsBLz7IUwYEpudDneapEJrYj60Cqr1c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VHfDGXN05Z3Bmg5/0DNLcnL69x5hC36HxVcjXOiLiSEpQW+J49xtR3siRWr89a4Kh
	 D1AO8nkdb4L/HER/CgA/EqYTNVX7LpZn8gjFEDJCddUyq9FMx6bEqsa7ldjm+pdzu9
	 vRSTtRvPYc35Plb4jzhbKFd4E1be542eSvb/zyKM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jackie Liu <liuyun01@kylinos.cn>,
	Tejun Heo <tj@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 008/957] blk-cgroup: fix disk reference leak in blkcg_maybe_throttle_current()
Date: Wed, 20 May 2026 18:08:11 +0200
Message-ID: <20260520162134.743185634@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jackie Liu <liuyun01@kylinos.cn>

[ Upstream commit 23308af722fefed00af5f238024c11710938fba3 ]

Add the missing put_disk() on the error path in
blkcg_maybe_throttle_current(). When blkcg lookup, blkg lookup, or
blkg_tryget() fails, the function jumps to the out label which only
calls rcu_read_unlock() but does not release the disk reference acquired
by blkcg_schedule_throttle() via get_device(). Since current->throttle_disk
is already set to NULL before the lookup, blkcg_exit() cannot release
this reference either, causing the disk to never be freed.

Restore the reference release that was present as blk_put_queue() in the
original code but was inadvertently dropped during the conversion from
request_queue to gendisk.

Fixes: f05837ed73d0 ("blk-cgroup: store a gendisk to throttle in struct task_struct")
Signed-off-by: Jackie Liu <liuyun01@kylinos.cn>
Acked-by: Tejun Heo <tj@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Link: https://patch.msgid.link/20260331085054.46857-1-liu.yun@linux.dev
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-cgroup.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index 890c161bee25e..9a8d047be580b 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -2037,6 +2037,7 @@ void blkcg_maybe_throttle_current(void)
 	return;
 out:
 	rcu_read_unlock();
+	put_disk(disk);
 }
 
 /**
-- 
2.53.0



