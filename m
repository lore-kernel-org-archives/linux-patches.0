Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B46DF356A12;
	Tue, 21 Jul 2026 20:45:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784666729; cv=none; b=ZxT3q8MOnWIGAoIPOfACyZuXhsX/EXYmthdTow75VS8u2wCPPzuaMlsnQ7QOnqzbB67v9Sd4vi1Hgu5p/cfqZHCvd2Nu6cFYtpefcSJurLsB5whv2jAc17J5fCksUgjXHj5907yzkADafTtOiqRof+saRsqQolHEqWjTh0s3I8M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784666729; c=relaxed/simple;
	bh=Ukihh6OD4cP1m2UNkVaDYhYma1Ug+1Mfn0AFq66v948=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MK69sqLv/gWQijHLc4w7lpxYGh7X6PPKXR1QfcRyBqW532EmDWvNtMV8xaXeDPSEIrdLs54Ys/T1KwJjxW2IeyF0IFGd45ANLpRJ0s839g0/heSxqPBeMP7Kme4zzy4CaJ51yBErjfgZQcxwFtNj+xuHaged/hN3Dam6JGNfff0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xtvz77W+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xtvz77W+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 269F71F000E9;
	Tue, 21 Jul 2026 20:45:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784666728;
	bh=Y5bbp2hJk7DFuTjlz0tgTDqwpwA5XO0nPX0RbIbyX/Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Xtvz77W+E4CsYTKw+WzWI95bXOuxl9HuZUftd/nQPRG9UEUHUQHnhcwM/Ns8SYpUS
	 bFAESP65S1OJ/8XmWDlkUbQQycgdMpXYkhNrfAsnT+UcqXCI2DbtBJMX+EQJh3os9Z
	 DX3eNyMOLYJiH4R7LQOVN6QpXdTdvBk4/KHRHZCU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yun Zhou <yun.zhou@windriver.com>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0794/1266] net: mvneta: re-enable percpu interrupt on resume
Date: Tue, 21 Jul 2026 17:20:31 +0200
Message-ID: <20260721152459.626951326@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 2941721b65152e..eb7b13b66ea35b 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -5866,6 +5866,9 @@ static int mvneta_resume(struct device *device)
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



