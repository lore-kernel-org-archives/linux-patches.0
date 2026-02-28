Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D2D0375AC1
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:00:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301650; cv=none; b=j2y51/S38D4L81bV0t89N0ygD8x/QD3R3ct2lHxrsULRFEmAvhtO9jKTUXg7UgRUbmOlfGVPb5K9YtWQJPrqGI8cY0t/liQBOE38UFFLVPqAq/GX5h2r9DXXCERmTufk6UoRIohH+rhC0a0PblXa63l9d266a5yTExto/zM8QXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301650; c=relaxed/simple;
	bh=gwPP/rU0FUDfD4HVpfrNP3CsvnVCy5pYUrwiIjCR16g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n+eKy11YpmZAAWfSm8t8ceGnQE9fgahP8RQnJSwBvDhutH/gkdFGkb9t8G69SsS1hz22o2VUnFA4PdVIF5Zci7yhXfvdCMjT/w8sc8S5UyyYPfPK3fxyY4NsKH8mXOOv+If2B/U2vOBzZ86wp15OU8hV8Xv0z0c1CHRTnhD0bQ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bCREQTin; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bCREQTin"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90733C19425;
	Sat, 28 Feb 2026 18:00:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301650;
	bh=gwPP/rU0FUDfD4HVpfrNP3CsvnVCy5pYUrwiIjCR16g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bCREQTinCTshIZq+WnfHgMt4Ri1tzUYy2WjeEd9iXLuRAddCTCHBlCeYN61AVA8k/
	 EllDcOQXCzWWM1tJZQVLpT/l+YMsOV8BrpkD9IwEsutaWOUJSOQrmM1A/7iVwRl9lx
	 rLheDXw7PBRDRxf9GtEwwz1qFTMcocdZyeg3EXlI+AgFTgQD52r5w0RVgwT88o+BCz
	 Gddl/bLAIUsTMg58V1rw8upkJmIuhfiIGnwES9oTYE/s/qPQGiRG48ejTvd0vtayiO
	 QAiKiqap9jUv8X77elG2kMOxJ0w9ODNQIV3OBRvSs8n6pJzDZaZ3ZeSG/9lQEX+80Q
	 F/9vWmnf7b75w==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Gui-Dong Han <hanguidong02@gmail.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 046/385] PM: sleep: wakeirq: harden dev_pm_clear_wake_irq() against races
Date: Sat, 28 Feb 2026 12:54:28 -0500
Message-ID: <20260228180011.1568201-46-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
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

