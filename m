Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 050B1280331;
	Fri,  7 Aug 2026 15:30:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786116650; cv=none; b=KsJICf+FYT+89gEH2H7630S7X1N7VjUI4qtTdvp3Z9cv8WEVVOEvcPcBvb6rYceIr3OadVwHfOCQKIXLxyGGv6LpLGO12Q2b9XypKK5bH5Oheh9wDe7RNPGzwqFoDO8X1wHPKSfX0CRw48eSzEtWpl0Hio4XHJBi6n4fIavUUTg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786116650; c=relaxed/simple;
	bh=TKfwrsc/HblnfzkDlxU80cBBVbYXbbj4W6G1rJtNGNk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YEGRe7crkaQv9NB/rYhFwOuORjes2KzLJvFJ7tCQnLxmVtqenPQIp5veL4wNX44hzvCbJfSYO1ZkvnmQUwrZM/1lqlqpgnx3J/98HJHWC1ZIvkhd78fxzkw0vNWcgggngpmMTYYamL81grImfj3EqP3Xl9cTFxANTq5FAhwIQVw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=07msQxz7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="07msQxz7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CD881F00A3A;
	Fri,  7 Aug 2026 15:30:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786116648;
	bh=+1ENjGobDY1UW6eO5IDVHEeYKvzV5MxWh21QmyVqo2I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=07msQxz7vYSG337Moz+AuHRN9nAniEdA97EwxBApAO3aHmcxiuFqM3GzcLich76uA
	 eZauRmOv9vwvoCDP/ySvdK1AmAByn5luQ++VDOybdIomYs/V8WNTFt3IIsE+5MPrbA
	 ZMpNBk/yFx3TttH14CSdXZM+XLFYTsvsJPWxlx0k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Michael Kelley <mhklinux@outlook.com>,
	Wei Liu <wei.liu@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 042/438] Drivers: hv: vmbus: Replace lockdep_hardirq_threaded() with lockdep annotation
Date: Fri,  7 Aug 2026 16:33:58 +0200
Message-ID: <20260807143428.896614321@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
References: <20260807143428.008222056@linuxfoundation.org>
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

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

[ Upstream commit 8c7ab779c8850f4dab8473463cca9a7d52fdaecc ]

lockdep_hardirq_threaded() is supposed to be used within IRQ core code
and not within drivers. It is not obvious from within the driver, that
this is the only interrupt service routing and that it is not shared
handler.

Replace lockdep_hardirq_threaded() with a lockdep annotation limiting
threaded context on PREEMPT_RT to __vmbus_isr().

Fixes: f8e6343b7a89c ("Drivers: hv: vmbus: Use kthread for vmbus interrupts on PREEMPT_RT")
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Reviewed-by: Michael Kelley <mhklinux@outlook.com>
Signed-off-by: Wei Liu <wei.liu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hv/vmbus_drv.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/hv/vmbus_drv.c b/drivers/hv/vmbus_drv.c
index 23206640c6139..44877664d9d08 100644
--- a/drivers/hv/vmbus_drv.c
+++ b/drivers/hv/vmbus_drv.c
@@ -1384,8 +1384,19 @@ void vmbus_isr(void)
 	if (IS_ENABLED(CONFIG_PREEMPT_RT)) {
 		vmbus_irqd_wake();
 	} else {
-		lockdep_hardirq_threaded();
+		static DEFINE_WAIT_OVERRIDE_MAP(vmbus_map, LD_WAIT_CONFIG);
+
+		/*
+		 * vmbus_isr is never force-threaded and always invoked at hard
+		 * IRQ level. __vmbus_isr() below can acquire a spinlock_t
+		 * which becomes a sleeping lock and must not be acquired in
+		 * this context. Therefore on PREEMPT_RT this will be threaded
+		 * via vmbus_irqd_wake(). On non-PREEMPT the annotation lets
+		 * lockdep know that acquiring a spinlock_t is not an issue.
+		 */
+		lock_map_acquire_try(&vmbus_map);
 		__vmbus_isr();
+		lock_map_release(&vmbus_map);
 	}
 }
 EXPORT_SYMBOL_FOR_MODULES(vmbus_isr, "mshv_vtl");
-- 
2.53.0



