Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590991;
	b=kBWa0sqMGAju46mScu58WFTVNyyGjuZn6Q4AjNXDq2aNMz64K7vBeUhBHuDAxGT2NKp7
	 8R9DnjWRipslytSfunacx193qeNkqM4V0nYjeD9Ip9F92qGB/FoppucVp9fiLehKfqVwC
	 CJNJVyvn7128/G7buWv60Sl1sEYRVSLyjtj726kqfrmYIdaHPtQzROHNIhvvQ9LxmFdiK
	 vxoPJlYmL3pyKiUA89sIb7quZhu0xowXy5St/0V2mIK4CMkjlz4TwSblHV0rOUdOd7a3D
	 m3g+oNnJQigt07ibhdNlvls+WF6Dz2y6VGtnBcPINRp0DD2QIL8LagXadSwvsQSclHg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590991;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zhly68NPLo17+YkhW/WMY/uyPcFlmC/HXLKh2wGPJ7M=;
	b=K5UKHZkBojiZCKAHaOABq+JjRI5fRV3dw5ni7kAFIzsQnO1cAJI5a83thOE4nxJm44VY
	 RLeEX4jB60aiaaB+sstD4014vTzxu1SofilZDKU3o+vbfnwh+rOzYyhHkFvc02dCLEstQ
	 dG6fr+24sZ/Doc1FCO+0MQMl7JzEb6TZv2cdvoMhaPZASOsbUrv9eBFNPdax4/O5EJux3
	 LNphJxopEV1ERQa4iyKgyqhkCQnS2iZMcpirEfqOf0q8BWWDDW14bae6rb6j1fs4Uw+Ab
	 nGmb5a96voXspMSP4RqNuJLlMqaP5A9I1VlOql7DKEQQw7nsI7WKDQBey7iUYduZtmw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UIoFDT+R;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 183766071401;
	Fri, 13 Nov 2026 17:29:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UIoFDT+R
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B80801F000C4;
	Fri, 13 Nov 2026 17:29:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590991;
	bh=zhly68NPLo17+YkhW/WMY/uyPcFlmC/HXLKh2wGPJ7M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UIoFDT+RKCaBa28OK1VEhFOU842ue30WymhWJ8cB0Iztt6DqSsWC5oyb5EGeDQ9EO
	 PVbjhDstgQXxGvvScFyQa32bdutF176nRGCJz8bfdP9VXXSI2stko9jUW4hPxYtlps
	 yP5xj5bXCxSdRf0TBmJJJQJaBMNsxn6QAveJgh1s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frederic Weisbecker <frederic@kernel.org>,
	He Rongguang <herongguang@linux.alibaba.com>,
	Peng Wang <peng_wang@linux.alibaba.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 165/670] tick/nohz: Reevaluate the tick for kicks flushed outside hardirq
Date: Fri, 13 Nov 2026 10:45:29 -0500
Message-ID: <20261113153817.675254594@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peng Wang <peng_wang@linux.alibaba.com>

[ Upstream commit e389ae428847a2e6a3b698b5967df68ccf90361c ]

The nohz full kick relies on interrupt exit to reevaluate the
tick. However, a remote kick can also be flushed from task context without
an interrupt exit guaranteed to follow. If a tick dependency is set or an
earlier timer is queued after the idle-exit reevaluation, the required tick
update can be delayed until another interrupt.

Reevaluate the tick directly from the callback outside hardirq context.
Keep the existing interrupt exit handling for hardirq callbacks. The
offline flush remains harmless because tick_sched_timer_dying() has already
cleared TS_FLAG_NOHZ.

Fixes: 4b44a21dd640 ("irq_work, smp: Allow irq_work on call_single_queue")
Fixes: a5183862e76f ("tick/nohz: Conditionally restart tick on idle exit")
Suggested-by: Frederic Weisbecker <frederic@kernel.org>
Co-developed-by: He Rongguang <herongguang@linux.alibaba.com>
Signed-off-by: He Rongguang <herongguang@linux.alibaba.com>
Signed-off-by: Peng Wang <peng_wang@linux.alibaba.com>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Reviewed-by: Frederic Weisbecker <frederic@kernel.org>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20261023145101.8217-1-peng_wang@linux.alibaba.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/time/tick-sched.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 88fcd439e93de..2d48720925612 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -385,9 +385,21 @@ static bool can_stop_full_tick(int cpu, struct tick_sched *ts)
 	return true;
 }
 
+static void tick_nohz_full_update_tick(struct tick_sched *ts);
+
 static void nohz_full_kick_func(struct irq_work *work)
 {
-	/* Empty, the tick restart happens on tick_nohz_irq_exit() */
+	struct tick_sched *ts = this_cpu_ptr(&tick_cpu_sched);
+
+	if (WARN_ON_ONCE(!tick_nohz_full_cpu(smp_processor_id())))
+		return;
+
+	/* Task-context flushes may not be followed by an IRQ exit. */
+	if (!in_hardirq()) {
+		if (WARN_ON_ONCE(tick_sched_flag_test(ts, TS_FLAG_INIDLE)))
+			return;
+		tick_nohz_full_update_tick(ts);
+	}
 }
 
 static DEFINE_PER_CPU(struct irq_work, nohz_full_kick_work) =
-- 
2.53.0



