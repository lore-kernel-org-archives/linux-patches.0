Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 645BA3AD50F;
	Fri,  7 Aug 2026 14:43:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786113813; cv=none; b=GgflCKPZNt7BBokrUkJrCjcIfrLU5mkjn2SL6jhoq25NN/A0WGJHwSFVVLW1Qa+nWm4/vQIKAb4RsQx57+yJZtG/N2P1EkJwstEOWtYWxzFoBtBjPvDrGMaXK1hm9l1QT9yxqILJuZ0sf9yD1IEToNpjkGbsge+y3qp0qk8L0O0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786113813; c=relaxed/simple;
	bh=bWky3KRCACMSsdJ8L4iJLJqIDbK+OaOjcdUrPwJ2MSs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TV7kI1w2+03bYPhQV3rpPd9Vs4034yIxYMtcXF6kLgt1VCyExO+NxI+P09tl5qNz2pCNtL7Ajkz4SOK8bmGq2RBiFrNxxwp9uW19ARGmB8O77tnixggfklt6MpBIu1Fc956rvKb4wBvaEc4ZbBg64Edqc8KxhvM7+bbxyb+4lVo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZQMalMIL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZQMalMIL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D4221F00A3D;
	Fri,  7 Aug 2026 14:43:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786113799;
	bh=wWpPv12nhr/sVcqqVVoYXW+EheXCC1MeBvlvJHCQwaI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZQMalMILWSdgPMtxR5eswRItlwnZtQd1GL+4dnR7ibLqQ8o3hSgrkewIHOEI8WCfd
	 XUs0HhwvVFeaLdGvBu7l3RBXgg1G8RA/B+4Ewb1IMYWYIWxfj6cgBAMmGlznxDlwpx
	 +m9oHET/Vz5R3Uhwv0KDl21pYZwuAoHNjxdeSNTY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Michael Kelley <mhklinux@outlook.com>,
	Wei Liu <wei.liu@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 040/337] Drivers: hv: vmbus: Replace lockdep_hardirq_threaded() with lockdep annotation
Date: Fri,  7 Aug 2026 16:34:03 +0200
Message-ID: <20260807143419.383706873@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143418.516897842@linuxfoundation.org>
References: <20260807143418.516897842@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 83f3215bc5bd5..db1c71832f2a8 100644
--- a/drivers/hv/vmbus_drv.c
+++ b/drivers/hv/vmbus_drv.c
@@ -1320,8 +1320,19 @@ static void vmbus_isr(void)
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
 
-- 
2.53.0



