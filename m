Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 041A1379EF1
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:07:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302059; cv=none; b=VdbzH+bXafdfJi3ZEnDi4wtZGYM2jj8WDJsmobZGlTQW0PndmSOHnSmY1IDKvWrRtsv+NlVAjx3TlWNmt5wfdrAM0lTkydV47sagn+JOM6IiV/u4mvmQr36WJPinlO+sFLdXpyNtzksgs4Z3y0UGwhC7U4yHBaWhJFRvKgj4GuI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302059; c=relaxed/simple;
	bh=gwPP/rU0FUDfD4HVpfrNP3CsvnVCy5pYUrwiIjCR16g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gtqFZGg6vB8Yo8YMQgx+qlaBnC6/WB0bnfKBA4Z57MGLpkDO/IlWEbArgDihdMixB/mM2JnaB+p04IN6OjhzoK4Uk0PB7DZ1NyN7fQv8bWy4iTciQrR2odwedRelDCMp87MfIGYhVNNWVeZGIvHVeIq2IhTJcRmca3YGP6zIsN0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=q5U51+Ky; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="q5U51+Ky"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C1B3C116D0;
	Sat, 28 Feb 2026 18:07:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302058;
	bh=gwPP/rU0FUDfD4HVpfrNP3CsvnVCy5pYUrwiIjCR16g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q5U51+Ky6Tv2EOp7pbt5HH4pxNu8JOPrew2Vxef149U/sQc/hlmNmd/kvCHwYF+MY
	 p9nV48aIlYu7lLYGp0kB6qfFOwHGixTEnInySlczvT5oLxoB/I2Qxdy+dkq7QYB3o9
	 upbSTY4AGUJ9uEJ9NWJfifbMSFArtyZAz4BRkhpPH2QTuxxW3yM/CZA6bsX/JZJtKF
	 Zv+Mdp6DjicPhpiC0g6+Q8qqXUf0Plw9TZJM6UkRhDrx2r3ivClOhYklrNnvS9JkKb
	 Kvt2aSD+lgZnjEL9umjZ9YyxB0DYCvD8YOqmeMZEfg89cLwxQZnBsIi80xu9fMazFJ
	 /+sY7LB4Uhdew==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Gui-Dong Han <hanguidong02@gmail.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 035/283] PM: sleep: wakeirq: harden dev_pm_clear_wake_irq() against races
Date: Sat, 28 Feb 2026 13:02:57 -0500
Message-ID: <20260228180709.1583486-35-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180709.1583486-1-sashal@kernel.org>
References: <20260228180709.1583486-1-sashal@kernel.org>
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
index 5a5a9e978e85f..ddbe9cc91d23d 100644
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

