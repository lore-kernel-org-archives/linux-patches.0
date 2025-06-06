Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC4BA28A3E4;
	Fri,  6 Jun 2025 15:42:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749224556; cv=none; b=aRUNYh965ngmPcpFKCxPixnEEwOnmAZgvgRAXmL7rNtRYvdqnQPrRGrHa9Fgt803479b33ur52TuVcSnus5IhUBmgwQkDIOYXNLxjd1OVJ8xrUpDkTK4dqoHRa5YEOfbEYPxfPzu248zoDoGENiur7G/SbjqRMXZ8EmVXMVRBWU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749224556; c=relaxed/simple;
	bh=JvxKiUvZup5FCydVPN8K3QMiW0hQscyESTJprVJQzbg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=aIczj2JJJuJdXO61281a3DCc+Snr9UOLEcAL5qJnXm64XxtMNOGUJeCjRe168qA/5Z5xbOpsL9m1SB5E9QhF89aIE0Qb8UQbY3ySeIEdJjtc8W4psLrLz7ZP3TfvnyXA75n5gBXKZQil2n0wn04Nz5lzUW31/+j6bt8wDItOEAk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tLrDY8Jb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tLrDY8Jb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C69E2C4CEEB;
	Fri,  6 Jun 2025 15:42:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749224556;
	bh=JvxKiUvZup5FCydVPN8K3QMiW0hQscyESTJprVJQzbg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tLrDY8JbjeNoVk8DVJ6ZNyhX5fDvG3Uvo4VAP9rTlltytl2/6fVIhp9z8/ASMLJ+s
	 eEsarX1hCZsVRMc9JGxfhHe+b/5Gub+7mHzydC7yvgEt93kofgfJk1Th6XJZ34CTLW
	 WNfRggRuRcoT4TFZlncQk9UimNY9BpOMN9i4HQKcWWzL3Z1eBF/GQlo3pJkjA106BM
	 g4jDP8dQtGlb4eIbi+gfYaHtZecHwLtW2X8SkPK6bLf9UiYEpYyNJV2PNqxo1uCz7A
	 gMjJhmWsDXN3TRMFHvfGmKzmx8LWY0XcFA1gTlYqwdPLcXWnijEuxS6gn7x+HC87a7
	 0AC3CnODB1EKA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Peng Fan <peng.fan@nxp.com>,
	Jassi Brar <jassisinghbrar@gmail.com>,
	Sasha Levin <sashal@kernel.org>,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.14 07/19] mailbox: Not protect module_put with spin_lock_irqsave
Date: Fri,  6 Jun 2025 11:42:13 -0400
Message-Id: <20250606154225.546969-7-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250606154225.546969-1-sashal@kernel.org>
References: <20250606154225.546969-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.14.10
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
index cb174e788a96c..92c2fb618c8e1 100644
--- a/drivers/mailbox/mailbox.c
+++ b/drivers/mailbox/mailbox.c
@@ -490,8 +490,8 @@ void mbox_free_channel(struct mbox_chan *chan)
 	if (chan->txdone_method == TXDONE_BY_ACK)
 		chan->txdone_method = TXDONE_BY_POLL;
 
-	module_put(chan->mbox->dev->driver->owner);
 	spin_unlock_irqrestore(&chan->lock, flags);
+	module_put(chan->mbox->dev->driver->owner);
 }
 EXPORT_SYMBOL_GPL(mbox_free_channel);
 
-- 
2.39.5

