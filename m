Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF8C460BB6;
	Tue, 14 May 2024 10:41:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715683267; cv=none; b=OO/d6E2mF8q/jsQfhkrt9qinuUfb4jGT1f8KQMD7TKrsEmvdNMvyEeXS/rzYFP3bVig/4CEPVkJpGKraKN/MSXqvkisAJ8u4ZsPyqWRN/jVl8YhixuuxXST1G+uRbU+CDbzsZSjmkEOr5toefRY+E5pIttFGay39lRkC7cs+vDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715683267; c=relaxed/simple;
	bh=OUL0YRqY9sTAEa7zcLh5r54FR+QEoYDYWR3WUiQzQJI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cjyRNUDM6gsaHVfoA4+hndIp9ArhnmB79z5+ogsiX6huqWGIIGlX1CFipmLfk0Yk3R32ScQZMCeycchmK7o+IEUOQKsjQjb5+Hgvmtogt5E6Xy1jpPWfoW6RyOhYJaf9vauxyhnbKoUrzPneyOEVCqk5gagVFj9f3XxW0y9oacQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DjkuPRc/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DjkuPRc/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85681C2BD10;
	Tue, 14 May 2024 10:41:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715683267;
	bh=OUL0YRqY9sTAEa7zcLh5r54FR+QEoYDYWR3WUiQzQJI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DjkuPRc/qhe5GTcaYKZRik9VglCBifnXJdp/dluVcGvLLODcxPPrW0g3PEw+BpQaI
	 DiQZuaS4RQEW7dF3lBL+ESSLoSsBcWAz+3LwNCG+wXmKyZyBXTois0+F2Ff0zRVfg6
	 Ft+1YCSSMlfPfBQwljfEMxwFLVRUF8YmSvKdN9dE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Nan <linan122@huawei.com>,
	Yu Kuai <yukuai3@huawei.com>,
	Tejun Heo <tj@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 193/336] blk-iocost: do not WARN if iocg was already offlined
Date: Tue, 14 May 2024 12:16:37 +0200
Message-ID: <20240514101045.893816140@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101038.595152603@linuxfoundation.org>
References: <20240514101038.595152603@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Li Nan <linan122@huawei.com>

[ Upstream commit 01bc4fda9ea0a6b52f12326486f07a4910666cf6 ]

In iocg_pay_debt(), warn is triggered if 'active_list' is empty, which
is intended to confirm iocg is active when it has debt. However, warn
can be triggered during a blkcg or disk removal, if iocg_waitq_timer_fn()
is run at that time:

  WARNING: CPU: 0 PID: 2344971 at block/blk-iocost.c:1402 iocg_pay_debt+0x14c/0x190
  Call trace:
  iocg_pay_debt+0x14c/0x190
  iocg_kick_waitq+0x438/0x4c0
  iocg_waitq_timer_fn+0xd8/0x130
  __run_hrtimer+0x144/0x45c
  __hrtimer_run_queues+0x16c/0x244
  hrtimer_interrupt+0x2cc/0x7b0

The warn in this situation is meaningless. Since this iocg is being
removed, the state of the 'active_list' is irrelevant, and 'waitq_timer'
is canceled after removing 'active_list' in ioc_pd_free(), which ensures
iocg is freed after iocg_waitq_timer_fn() returns.

Therefore, add the check if iocg was already offlined to avoid warn
when removing a blkcg or disk.

Signed-off-by: Li Nan <linan122@huawei.com>
Reviewed-by: Yu Kuai <yukuai3@huawei.com>
Acked-by: Tejun Heo <tj@kernel.org>
Link: https://lore.kernel.org/r/20240419093257.3004211-1-linan666@huaweicloud.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-iocost.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/block/blk-iocost.c b/block/blk-iocost.c
index b1c4c874d4201..f3b68b7994391 100644
--- a/block/blk-iocost.c
+++ b/block/blk-iocost.c
@@ -1439,8 +1439,11 @@ static void iocg_pay_debt(struct ioc_gq *iocg, u64 abs_vpay,
 	lockdep_assert_held(&iocg->ioc->lock);
 	lockdep_assert_held(&iocg->waitq.lock);
 
-	/* make sure that nobody messed with @iocg */
-	WARN_ON_ONCE(list_empty(&iocg->active_list));
+	/*
+	 * make sure that nobody messed with @iocg. Check iocg->pd.online
+	 * to avoid warn when removing blkcg or disk.
+	 */
+	WARN_ON_ONCE(list_empty(&iocg->active_list) && iocg->pd.online);
 	WARN_ON_ONCE(iocg->inuse > 1);
 
 	iocg->abs_vdebt -= min(abs_vpay, iocg->abs_vdebt);
-- 
2.43.0



