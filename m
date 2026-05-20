Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C08413F4DDB;
	Wed, 20 May 2026 18:01:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779300069; cv=none; b=AGL2BkBGmz3FHTh+o4kWdwoqzyCm/GfsgYyH/DokzK6AaSc738iXz1gw2fw8Tybsbcvmfqqn+akatVYygcW7E1k+Xkc2Ipu6iyBvJM6m85h64kT9c2NZZtj4u6ovVdmwsPytAS35BEF7PtpIxneoJwwLumUmC5CRPHgBn1rlSG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779300069; c=relaxed/simple;
	bh=xHbWFv8EUsgmbxQTnIBNoJ3y8Npc5BwaqoLPOIoW4RQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SvqrLQICW+YuHbPZUB16wK7ZuoQxZyflkf42S3vnUlmqrDFTUNOhrVWjyfDvSezMAQgsCExp4enfOfiR7DO0hxfduVS5Y/OsWEpJSoDfG7oY/TB025TI6JcmIADoJKhNzDoqf98Xi4Kt3E1jJvfQSLhwiazjlboPKJZZpIu24iU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q/P1VM01; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q/P1VM01"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30EDA1F000E9;
	Wed, 20 May 2026 18:01:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779300068;
	bh=x3xJkkK9BUWZZNcfUIzMKvLmOu4isYhrzL+yP2EOR28=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=q/P1VM01s9iXO3j8WEwywMja3Xe2r0MNKdGxkzMhm6geuGQGH43T3flZA4sv8xrv6
	 WR96i4MqlpSRiQ+Gxt2cJcaX/xv7HE+U1HAe7By/BdNAh02gD2AnlI4BMLgeBnypiC
	 ZQ8GoRbakspX9L7mM8B+jS/IXGWiUmIGRVdXSiDU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jackie Liu <liuyun01@kylinos.cn>,
	Tejun Heo <tj@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 009/666] blk-cgroup: fix disk reference leak in blkcg_maybe_throttle_current()
Date: Wed, 20 May 2026 18:13:40 +0200
Message-ID: <20260520162111.433555719@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 9a198001cfa56..a0fbb427a7a62 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -1985,6 +1985,7 @@ void blkcg_maybe_throttle_current(void)
 	return;
 out:
 	rcu_read_unlock();
+	put_disk(disk);
 }
 
 /**
-- 
2.53.0



