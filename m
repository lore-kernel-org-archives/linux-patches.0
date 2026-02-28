Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91FEF373BEC
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:58:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301529; cv=none; b=FAu4jqglJ3mDQbawQ8O5wuyjqDPDG659bdQYNNZKtQAgpmZW2ecWh5utdVkGBAvmgMwuKmg5t2XyGOamD3KX3hUWCfWjjaYdp+8AZMo8yM5xQgKxomgfoOGtvx/En5caQj0SvqYvkJ9JAMAmmQgMbiPdGotYU+F/cML7elJh0Ug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301529; c=relaxed/simple;
	bh=DjEEaLP6mBKwe3/JXcQr75wphCCvX2O5/yn3K2hrHDc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Tuwrpe1vsdjDt4axVYnlMJXZvaxtfZd5g0qHg/Ccmb2uStJJU/DdzbgqeBn5HNPRx+fC0f+j0t9NJX3tx5nVZwdHfeODzUmWl8BG0R8L73DvORubLvvzDJHLqTmYzlIiLltSMzBp8uJq5mDX1gTvAzbxpSyxOCHzYTEBqatW5Vw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=j4hcUPiK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="j4hcUPiK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85686C116D0;
	Sat, 28 Feb 2026 17:58:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301529;
	bh=DjEEaLP6mBKwe3/JXcQr75wphCCvX2O5/yn3K2hrHDc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j4hcUPiKCSFQd1nvaarPdpfXy2hj9E84svkHIyHQLhXxFo4V5dfPn4o0KggSsvB7f
	 p5fldLwTOIJdgaGj9M1XMhw0NujbpXKevh+lDjwQg4JGj/t+mxUUc5wSvgz7hrMhWC
	 Lh7DC+xTzQWi2/iPxsH1e7ji+3n1hASy+90S5dgfuy1Omxqhah12qDItX8WP02+DPT
	 v+mzpPuc2msJ1rMhmwdEHqZOOgKKvqfiS9Q9OODr/X/ym6Zw4jaXi9wJY+1NLPf/Kr
	 Jvz7r5HhFzmWo+m4GpG77ynXx4VIXVoTmHsbcBBoCsWCrbstpmHLgtIDeFBvefYjA4
	 ApiC/Ay0rWyqA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Duoming Zhou <duoming@zju.edu.cn>,
	stable@kernel.org,
	Jijie Shao <shaojijie@huawei.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 711/752] atm: fore200e: fix use-after-free in tasklets during device removal
Date: Sat, 28 Feb 2026 12:47:02 -0500
Message-ID: <20260228174750.1542406-711-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Duoming Zhou <duoming@zju.edu.cn>

[ Upstream commit 8930878101cd40063888a68af73b1b0f8b6c79bc ]

When the PCA-200E or SBA-200E adapter is being detached, the fore200e
is deallocated. However, the tx_tasklet or rx_tasklet may still be running
or pending, leading to use-after-free bug when the already freed fore200e
is accessed again in fore200e_tx_tasklet() or fore200e_rx_tasklet().

One of the race conditions can occur as follows:

CPU 0 (cleanup)           | CPU 1 (tasklet)
fore200e_pca_remove_one() | fore200e_interrupt()
  fore200e_shutdown()     |   tasklet_schedule()
    kfree(fore200e)       | fore200e_tx_tasklet()
                          |   fore200e-> // UAF

Fix this by ensuring tx_tasklet or rx_tasklet is properly canceled before
the fore200e is released. Add tasklet_kill() in fore200e_shutdown() to
synchronize with any pending or running tasklets. Moreover, since
fore200e_reset() could prevent further interrupts or data transfers,
the tasklet_kill() should be placed after fore200e_reset() to prevent
the tasklet from being rescheduled in fore200e_interrupt(). Finally,
it only needs to do tasklet_kill() when the fore200e state is greater
than or equal to FORE200E_STATE_IRQ, since tasklets are uninitialized
in earlier states. In a word, the tasklet_kill() should be placed in
the FORE200E_STATE_IRQ branch within the switch...case structure.

This bug was identified through static analysis.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@kernel.org
Suggested-by: Jijie Shao <shaojijie@huawei.com>
Signed-off-by: Duoming Zhou <duoming@zju.edu.cn>
Reviewed-by: Jijie Shao <shaojijie@huawei.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20260210094537.9767-1-duoming@zju.edu.cn
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/atm/fore200e.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/atm/fore200e.c b/drivers/atm/fore200e.c
index f62e385714403..fec081db36dc4 100644
--- a/drivers/atm/fore200e.c
+++ b/drivers/atm/fore200e.c
@@ -373,6 +373,10 @@ fore200e_shutdown(struct fore200e* fore200e)
 	fallthrough;
     case FORE200E_STATE_IRQ:
 	free_irq(fore200e->irq, fore200e->atm_dev);
+#ifdef FORE200E_USE_TASKLET
+	tasklet_kill(&fore200e->tx_tasklet);
+	tasklet_kill(&fore200e->rx_tasklet);
+#endif
 
 	fallthrough;
     case FORE200E_STATE_ALLOC_BUF:
-- 
2.51.0

