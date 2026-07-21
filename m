Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4335F46D57A;
	Tue, 21 Jul 2026 15:43:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648636; cv=none; b=Qcr5BP3W/gwyLwtJ1MIeBBl4cDYV6DYTHje0ipaf9prNC+V8vVTzHSJj8+QkcLrKX9dYvfTxmilQzLoJBpYAhwVay1gQomttbQxyfRK+//WOOC8V6O12VRJBP3mClaFCkr7rcEoJ6MsoTSYtB/hhu/K2Dn9kRzws4rrtMiLbuag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648636; c=relaxed/simple;
	bh=tQWWe8kpGQTTC9B482s8a4KeoaMpVdJPmAQ+0z/PwXI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k3DUXRK3g25zvZLUAQmjusR2+PdR41OGaWMlJvwMaZ3aFLHX+35E/P3g9X5mGn3ivPMB5FcH7uCeiOCnQKTOUL7a/Kw7LjGpzAgiz+lUA7nF23vVKSKuqui791WNDbeKM6byx1+FXqsJ6Y2qIMg1InMWvqkchQUYAkSCaEx8mL4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DzAduZxr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DzAduZxr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A5BD1F000E9;
	Tue, 21 Jul 2026 15:43:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648635;
	bh=+1vZEzqaers/obCOuRVu/AdmJWXOvqSWvPlxBnaTbt8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DzAduZxrPzxj31GVr4w5gQFvs4ZpRedLo+hVS3CdS74ka/gObI0yiuB71B9jdHuiz
	 ZowqrmKB6vKdunvhhHmIzbsfj7YlFL+nQrb8+1VQepo5vP881tC4fgowZmHa4DOFhy
	 4UjYCcrV/c1QMi23OGwmBiA2YwJxiUaeIAQ9RKhI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fengnan Chang <changfengnan@bytedance.com>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0230/2077] dm: limit target bio polling to one shot
Date: Tue, 21 Jul 2026 16:58:23 +0200
Message-ID: <20260721152558.101674989@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fengnan Chang <changfengnan@bytedance.com>

[ Upstream commit 5aa0f9231cbacade065cedd8e9b5ebd067231171 ]

dm_poll_bio() is the ->poll_bio() callback for a stacked dm device.
The caller only knows about the dm queue, so it may decide to do a
spinning poll if it thinks a single queue is being polled. Passing those
flags unchanged to the mapped clone lets blk_mq_poll() spin on a target
queue from inside dm_poll_bio().

With io_uring IOPOLL on a dm-stripe target this can keep a task in

  dm_poll_bio() -> bio_poll() -> blk_mq_poll()

long enough to trigger an RCU CPU stall, before io_uring gets back to
io_iopoll_check() and its need_resched() check.

Keep dm's ->poll_bio() bounded by forcing one-shot polling for target
bios. The caller can invoke dm_poll_bio() again if it wants to keep
polling, and it also gets a chance to reap completions or reschedule
between passes.

Fixes: f22ecf9c14c1 ("blk-mq: delete task running check in blk_hctx_poll()")
Signed-off-by: Fengnan Chang <changfengnan@bytedance.com>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index e178fe19973ea3..8f44fbbcf3da27 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -2098,8 +2098,17 @@ static bool dm_poll_dm_io(struct dm_io *io, struct io_comp_batch *iob,
 	WARN_ON_ONCE(!dm_tio_is_normal(&io->tio));
 
 	/* don't poll if the mapped io is done */
-	if (atomic_read(&io->io_count) > 1)
-		bio_poll(&io->tio.clone, iob, flags);
+	if (atomic_read(&io->io_count) > 1) {
+		/*
+		 * DM hides the target queues from the upper poller, which may
+		 * decide it is safe to spin on a single stacked queue.  Do not
+		 * pass that spinning policy down to a target queue: one slow
+		 * clone could keep the task inside dm_poll_bio() for a long
+		 * time.  Poll target bios once and let the caller decide
+		 * whether to keep polling, reap completions or reschedule.
+		 */
+		bio_poll(&io->tio.clone, iob, flags | BLK_POLL_ONESHOT);
+	}
 
 	/* bio_poll holds the last reference */
 	return atomic_read(&io->io_count) == 1;
-- 
2.53.0



