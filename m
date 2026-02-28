Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E27C735AC01
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:17:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302673; cv=none; b=EkKuyiiLI9FzE9eT3EgkXBxqBHPfQOmgo+XZhzIY0MtKTKTGAOZ8lhm+PKIkmort5NpXqtmzssJ+MB6vEvbhV0LYoXBrhXBenBjQK0hzk+Ke/Ps/Ve4GGWftYvVcWmaUTtjrk9U/1PYS/PidvFG/lNp5YN0N7schpMGl2fDOeE4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302673; c=relaxed/simple;
	bh=oUo0JdfVIbT2Q7kgvyBM1nnFui5g6bqIxkvmg+bk6XE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dv6mWpUU83cKb20hXy7sJqgCDN3E7ScAyInJsU048KrQwDj16k4BQDzWvIj/Ku78pBAp5MkBQTijv4eB1FFMQBxqe23Rl68VHMBr+rMtXNCsvpLS1gMeRe86aI+/4mqB8zSG8VJlk1Lh5FPxrdLJTR0ybRqBT0KEZfLp49Y3UGA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WkA0mgD+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WkA0mgD+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52AC2C19423;
	Sat, 28 Feb 2026 18:17:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302672;
	bh=oUo0JdfVIbT2Q7kgvyBM1nnFui5g6bqIxkvmg+bk6XE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WkA0mgD+Y2z5/lofZXhxKDDFtWmVmJZdp2ubBwdvgI2l7lzGA4sguaeu977fqSPo+
	 49z+oRs0hTLkLCSy0m9moJbQ6F0qUioPUgVYkMzK2gMAHHDlR2P5RwAVdBFx8lfRKy
	 cjBn5QvZzwM3qIULeqvNHH4n2RkyxWg6NbvtTnBRoOYsTXuw/g+lXIDbjQmQmtaCUs
	 FQDyql5c9+sGgDODvf0UpHfUuoGi3YA9U1LTmLAn2H/xtYaZrpZbaqhrqaY1ZD2Bw7
	 mhV03+P8zgf/bLYZ8WoS8jY2gitkQw8LUZI0ctFlI+1I8BTgf5Ozr6CN+NdNglS0i5
	 jlMJS8GX/m6uA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Gui-Dong Han <hanguidong02@gmail.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 021/147] PM: sleep: wakeirq: harden dev_pm_clear_wake_irq() against races
Date: Sat, 28 Feb 2026 13:15:29 -0500
Message-ID: <20260228181736.1605592-21-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181736.1605592-1-sashal@kernel.org>
References: <20260228181736.1605592-1-sashal@kernel.org>
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
index 4f4310724fee5..d22fc66a387d7 100644
--- a/drivers/base/power/wakeirq.c
+++ b/drivers/base/power/wakeirq.c
@@ -86,13 +86,16 @@ EXPORT_SYMBOL_GPL(dev_pm_set_wake_irq);
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

