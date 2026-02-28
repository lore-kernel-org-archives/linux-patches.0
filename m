Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B0BB36C9D8
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:11:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302310; cv=none; b=u2/6RsDCjHGea1WrGmXNXGgWWqNU3QSu5QZJrAsYS2DZqfAwYmOM4jLn5kMIarSjET2hvpe3h0+hRAvREWmky7xKXKTJwDdeoTdc83SjUmuPsvxw5weqPeiqlrV5QlKLpyAHz/6Hhx02vO0HhqStq/W4qO+CNnHTBkBA8j3111k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302310; c=relaxed/simple;
	bh=/zuPoRkDO8nBTZkEw1fBz7MEaw+E1dr18iIHalF/zQY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uPGkB4VFpHY083aG5IifKCnXdVoZssaXwli0tFyqBsGtBEIsHIYKCGHWc4sCGN9+PXe5CISHXe7R3XtPjQ2R+siSV+7tLpetnJ93NZ5QHEqjBLM78sUmTYOyR7yOBaYhn4pqrG7s9owHV/8JrR/MTbClpvFkc49ZUtKcUt3OZMU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DNHTFOYs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DNHTFOYs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA7FBC116D0;
	Sat, 28 Feb 2026 18:11:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302310;
	bh=/zuPoRkDO8nBTZkEw1fBz7MEaw+E1dr18iIHalF/zQY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DNHTFOYshociOlc0Xq3f+tdwTUZcPkciT9aMMz2gDqqJRjSjOJWqpDtWyl1lv8gg6
	 MFT/0bbGHlky2tt3Bn6cAvfdgTckzyRGfPRlsoXbiw0rKOH8XZpjoNKLVvEjqkg0Gi
	 BRo16YuTAfGQ63abdcMe2jVz3OlBTqhdZPZtmZ1pLQRCtVavPWTRlFy4bCAqq62W+K
	 PfDRyx9y6npKZ+07pQvSXb5OLz2iSil/RCEstYU4qwcOvNYciKWEqcgMV3BsWvUpti
	 ugItLPIKuzS2A0wEBYACAaDI+91woGOtZpd4e2Fck81N+u+M+QseMmjU3dacyU19jh
	 4HPz5L9vxEN2Q==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Gui-Dong Han <hanguidong02@gmail.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 026/232] PM: sleep: wakeirq: harden dev_pm_clear_wake_irq() against races
Date: Sat, 28 Feb 2026 13:07:59 -0500
Message-ID: <20260228181127.1592657-26-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181127.1592657-1-sashal@kernel.org>
References: <20260228181127.1592657-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Gui-Dong Han <hanguidong02@gmail.com>

[ Upstream commit 5c9ecd8e6437cd55a38ea4f1e1d19cee8e226cb8 ]

dev_pm_clear_wake_irq() currently uses a dangerous pattern where
dev->power.wakeirq is read and checked for NULL outside the lock.
If two callers invoke this function concurrently, both might see
a valid pointer and proceed. This could result in a double-free
when the second caller acquires the lock and tries to release the
same object.

Address this by removing the lockless check of dev->power.wakeirq.
Instead, acquire dev->power.lock immediately to ensure the check and
the subsequent operations are atomic. If dev->power.wakeirq is NULL
under the lock, simply unlock and return. This guarantees that
concurrent calls cannot race to free the same object.

Based on a quick scan of current users, I did not find an actual bug as
drivers seem to rely on their own synchronization. However, since
asynchronous usage patterns exist (e.g., in
drivers/net/wireless/ti/wlcore), I believe a race is theoretically
possible if the API is used less carefully in the future. This change
hardens the API to be robust against such cases.

Fixes: 4990d4fe327b ("PM / Wakeirq: Add automated device wake IRQ handling")
Signed-off-by: Gui-Dong Han <hanguidong02@gmail.com>
Link: https://patch.msgid.link/20260203031943.1924-1-hanguidong02@gmail.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/power/wakeirq.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/base/power/wakeirq.c b/drivers/base/power/wakeirq.c
index ca0c092ba47fb..09a677c8007a7 100644
--- a/drivers/base/power/wakeirq.c
+++ b/drivers/base/power/wakeirq.c
@@ -83,13 +83,16 @@ EXPORT_SYMBOL_GPL(dev_pm_set_wake_irq);
  */
 void dev_pm_clear_wake_irq(struct device *dev)
 {
-	struct wake_irq *wirq = dev->power.wakeirq;
+	struct wake_irq *wirq;
 	unsigned long flags;
 
-	if (!wirq)
+	spin_lock_irqsave(&dev->power.lock, flags);
+	wirq = dev->power.wakeirq;
+	if (!wirq) {
+		spin_unlock_irqrestore(&dev->power.lock, flags);
 		return;
+	}
 
-	spin_lock_irqsave(&dev->power.lock, flags);
 	device_wakeup_detach_irq(dev);
 	dev->power.wakeirq = NULL;
 	spin_unlock_irqrestore(&dev->power.lock, flags);
-- 
2.51.0

