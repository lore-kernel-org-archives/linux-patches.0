Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 544D146D080;
	Tue, 21 Jul 2026 18:19:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784657996; cv=none; b=si43hLRVn8TXXTH22l0JDgabXPtBROufHj2uUK7eTescUsJpRKP1gYp/yibWStolH45ZqEnWsn2vwv2K86/59+XXopEnYBezOTAPGvIJYetS182koBR/QYVpQmkeXaTMOKJCGgcSzkLuZOaJzzrW7yJhP8TByfBUIf7zneTEtyo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784657996; c=relaxed/simple;
	bh=C5IDDhjw3kAPsHoUqD+TokHAgq1JirNxBUv2J+2/wlQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RhLoQTcSQDKpBboD8sd7+4wxNt/dAyFG54NxZomgAzsQ/kDPZiivs38XYWX1xSXsN2S197iT7J5trCa4h3GXVAmXI9F4qNs42sB5QUXdGSXBPukjicuE8KJ4wn7mhcawXqFqnR4UJ4B31LIav4/pPjL2mgIRM6/ntT/hGzJ90dI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pJA9rcIk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pJA9rcIk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 797281F000E9;
	Tue, 21 Jul 2026 18:19:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784657995;
	bh=tVZHVSbF9Xtifjj6IxFSLiz1D4JI8iffCwvGhm7T6QE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pJA9rcIkIptF3naXzZYsBLCsIJwcgb8V2v1SZX72jM0O7wFCcYcVgSVETROrrmJ+w
	 MSFBqsxabYrrAuqbYsaChlk2oCjHda9gHJ3f1nyTqT5QREcDcisjSqwhxR0Ny5DBHX
	 4adUj5ad2TXzXb1s/n3IIfswhaz6rZJKaOrq2TNc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yun Zhou <yun.zhou@windriver.com>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0933/1611] net: mvneta: re-enable percpu interrupt on resume
Date: Tue, 21 Jul 2026 17:17:29 +0200
Message-ID: <20260721152536.370747282@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yun Zhou <yun.zhou@windriver.com>

[ Upstream commit fd398d6480987e4c84fff0aaab6b9d6642a93343 ]

On Marvell MPIC platforms (Armada 370/XP/38x), mvneta uses a percpu
IRQ disable/enable scheme for NAPI: the ISR (mvneta_percpu_isr) calls
disable_percpu_irq() to mask the MPIC per-CPU interrupt and schedules
NAPI poll, which calls enable_percpu_irq() on completion to unmask.

If suspend occurs while NAPI poll is pending (between
disable_percpu_irq in the ISR and enable_percpu_irq in poll
completion), the interrupt is never re-enabled:

  1. mvneta_percpu_isr: disable_percpu_irq() + napi_schedule()
     => MPIC masked, percpu_enabled cpumask bit cleared
  2. NAPI poll does not complete before suspend proceeds
     (on PREEMPT_RT this is highly likely since softirqs run in
     ksoftirqd which gets frozen; on non-RT it can happen when
     softirq processing is deferred to ksoftirqd)
  3. mvneta_stop_dev => napi_disable(): cancels the pending poll
     without executing the completion path
  4. suspend_device_irqs => IRQCHIP_MASK_ON_SUSPEND: masks MPIC
     (already masked, but records IRQS_SUSPENDED)
  5. Resume: mpic_resume checks irq_percpu_is_enabled() => false
     (bit was cleared in step 1) => skips unmask
  6. mvneta_start_dev only restores device-level INTR_NEW_MASK,
     does not touch the MPIC per-CPU mask

Result: MPIC per-CPU interrupt stays masked permanently. The NIC
generates interrupts (INTR_NEW_CAUSE != 0) but the CPU never
receives them, causing complete loss of network connectivity.

Fix by calling on_each_cpu(mvneta_percpu_enable) in the resume path
to unconditionally unmask the MPIC per-CPU interrupt regardless of
pre-suspend state.

Fixes: 12bb03b436da ("net: mvneta: Handle per-cpu interrupts")
Signed-off-by: Yun Zhou <yun.zhou@windriver.com>
Reviewed-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Link: https://patch.msgid.link/20260622074350.1666290-1-yun.zhou@windriver.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/mvneta.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index 89ccb8eb82c7de..2b66e238d61bb0 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -5905,6 +5905,9 @@ static int mvneta_resume(struct device *device)
 	rtnl_unlock();
 	mvneta_set_rx_mode(dev);
 
+	if (!pp->neta_armada3700)
+		on_each_cpu(mvneta_percpu_enable, pp, true);
+
 	return 0;
 }
 #endif
-- 
2.53.0



