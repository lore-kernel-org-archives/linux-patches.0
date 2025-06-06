Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECEC0289E3D;
	Fri,  6 Jun 2025 15:43:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749224639; cv=none; b=ZKOAN8uL+FyV3+pNL2s2LfUNcy4Ahqdj2JJOk3Njgygz/xulIKk+UdskFVfaF+guNnhpRvurOKfBJG8CjXxE68Oggqp/Jb1OXYJqI/+eCqhHPwOb37iRxOgsJYznI3kUknEVA8MLZCG7h/VZD0C5B6BSr19Li5YBixCwRmhLYHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749224639; c=relaxed/simple;
	bh=4hZWSSBiBmXgCZRjHUQHX6vSbzo+EvjVtjI/uIdFtzg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=P5Jk/IdWEjBDoTykb18RWgztM66W3b3Sg6cr9daKrtPWAJXSxF/rL0AactCWB/5cYCH4o9TjOAVdzY3WI5wYh8yqmMlCiJl4n8e2iWPyC/gyJTPWvqxQorYSNuT/DZGJ6Yz/yT/IHFV2ta2LxX7KVE2u0uj5JbUVVghbKsVYkzU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tnOqCJbx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tnOqCJbx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E3B7C4CEF0;
	Fri,  6 Jun 2025 15:43:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749224638;
	bh=4hZWSSBiBmXgCZRjHUQHX6vSbzo+EvjVtjI/uIdFtzg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tnOqCJbxjRAgV+kvNR1yMwu3Cby8ngFgnzCzZ4hxQUjCXnRfZvgly8xgal02SU8kT
	 xduT1KpuDYSZjQWunbWublfOzEusd1GCHNA+iyNM1PmDYzsQ8KH+OfAp85Iylj1e/T
	 QmGK2OHriM9gN0BqWlAxacpSsEFsHXUueY5yEoIoipbWYo3ekTTT7RXS072UGzHwor
	 Ob4Yw6fJ0S3Q++nC0+H3r+4v6qMoGOaYVTUh4MqsvTlH301L57tE/E2luKQ1JHxaED
	 qtGqTzRLF20J3MTzW0GYvkSV22nJvfXlxXqOg3JY84LPBPfAdlIuj0EKkfkwpvTOQ3
	 LoT9Z2OJ6mGNA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Peng Fan <peng.fan@nxp.com>,
	Jassi Brar <jassisinghbrar@gmail.com>,
	Sasha Levin <sashal@kernel.org>,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.1 5/9] mailbox: Not protect module_put with spin_lock_irqsave
Date: Fri,  6 Jun 2025 11:43:46 -0400
Message-Id: <20250606154350.548104-5-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250606154350.548104-1-sashal@kernel.org>
References: <20250606154350.548104-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.1.141
Content-Transfer-Encoding: 8bit

From: Peng Fan <peng.fan@nxp.com>

[ Upstream commit dddbd233e67e792bb0a3f9694a4707e6be29b2c6 ]

&chan->lock is not supposed to protect 'chan->mbox'.
And in __mbox_bind_client, try_module_get is also not protected
by &chan->lock. So move module_put out of the lock protected
region.

Signed-off-by: Peng Fan <peng.fan@nxp.com>
Signed-off-by: Jassi Brar <jassisinghbrar@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

**YES** This commit should be backported to stable kernel trees.
**Analysis:** 1. **Clear Bug Fix**: The commit fixes an improper use of
`module_put()` under a spinlock in `mbox_free_channel()`. Looking at the
current code in `/home/sasha/linux/drivers/mailbox/mailbox.c:489`,
`module_put()` is called while holding `&chan->lock` with
`spin_lock_irqsave()`. 2. **Locking Inconsistency**: The commit message
correctly identifies that `&chan->lock` is not supposed to protect
`chan->mbox`. In `__mbox_bind_client()` (line 324),
`try_module_get(chan->mbox->dev->driver->owner)` is called **outside**
the spinlock protection, making the current `module_put()` placement
inconsistent. 3. **Minimal Risk Change**: The fix is extremely simple
and low-risk - it just moves one line (`module_put()`) outside the
spinlock region. This maintains the same operation order but fixes the
locking issue. 4. **No Side Effects**: Moving `module_put()` outside the
lock doesn't change the functionality or introduce new race conditions.
The `module_put()` implementation uses `atomic_dec_if_positive()`, so
it's safe to call without additional locking. 5. **Follows Stable
Rules**: This commit: - Fixes a real locking issue that could
potentially cause problems - Is small and contained (single line move) -
Has minimal regression risk - Doesn't introduce new features or
architectural changes 6. **Similar Pattern**: Looking at similar commits
in the historical references, commits that fix locking issues (like
Similar Commit #5 which fixed a locking bug in mailbox-test) were marked
as YES for backporting. The commit addresses a legitimate kernel locking
violation where `module_put()` should not be called under a spinlock,
making it a suitable candidate for stable tree backporting.

 drivers/mailbox/mailbox.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mailbox/mailbox.c b/drivers/mailbox/mailbox.c
index 6f54501dc7762..cb31ad917b352 100644
--- a/drivers/mailbox/mailbox.c
+++ b/drivers/mailbox/mailbox.c
@@ -459,8 +459,8 @@ void mbox_free_channel(struct mbox_chan *chan)
 	if (chan->txdone_method == TXDONE_BY_ACK)
 		chan->txdone_method = TXDONE_BY_POLL;
 
-	module_put(chan->mbox->dev->driver->owner);
 	spin_unlock_irqrestore(&chan->lock, flags);
+	module_put(chan->mbox->dev->driver->owner);
 }
 EXPORT_SYMBOL_GPL(mbox_free_channel);
 
-- 
2.39.5

