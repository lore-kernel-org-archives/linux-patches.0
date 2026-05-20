Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1438D369D61;
	Wed, 20 May 2026 16:26:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779294362; cv=none; b=epltWK/eWiPN3gkMohEzQJQM7QG23cLOhZHnGAERzU/tEDFnp7OtGroLLzkfM8xZm+1ng8tNI68x5Mm1QuFnNTf9G708PEBVsCq41QYvTIHtU8gGJrKq+qZVkkXLz6aFgMeVM1E+oZYjkutfDjU1xucwg65wyAYTO6BEf413INY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779294362; c=relaxed/simple;
	bh=rU6fVmKAE0AMkT/DHzh49toCzxC8q0O9OyBVjAW4wDM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eFej2cbvpdm5OyOTFNCc86nGAXN0IEjKzZgjC5+JSNo/6VCKeM9K3NlzGrUcNq9lBtZbT/vBjjOV5P6A9KxFwd1t5kz1hzx0vZ8MoX0Gi8bKQL+3YoNWmToGHnrUcVDXsC7pFef6uZkrLfw73/4TuVceS/QzNqBYYpmcJg/V0AY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2V/UiYBY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2V/UiYBY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FA721F000E9;
	Wed, 20 May 2026 16:26:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779294360;
	bh=l0/iqkfm17sqItn90IuWiDsJPsLnrusj4DatOy3TjBI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2V/UiYBYtOJk+wURp9KHtBmFR90zQjghbDxandaYp4dHVeRX9dhI0ongEeRrCtUJy
	 ZKD6Wh+eLkDBBZaXf/O5wwckgu5vRp6ph/bVDdzFAJOS5B3SRlnrrphPVbrCsrUQSx
	 NNaQAsfdZ9UGNUu44JLhtYy8dzbHlp5gFKobJygk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jackie Liu <liuyun01@kylinos.cn>,
	Tejun Heo <tj@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0011/1146] blk-cgroup: fix disk reference leak in blkcg_maybe_throttle_current()
Date: Wed, 20 May 2026 18:04:21 +0200
Message-ID: <20260520162148.647931375@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
index 2d7b18eb72915..554c87bb4a865 100644
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



