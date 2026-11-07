Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065386;
	b=g/+UGjq8ldII2SYAOnRJ50TTtXdCDhvw54Uqt7T9V7qUFoiZhKggF0hNDqFXaKR+xNwC
	 PYuB/vO1Sq0AD22YA5BXFRLKjnsw/QVfZ2JMm1ecgFsWZ4GlVGS68iOtNLZv6bCYQUC6P
	 3tAmAegtNIXspRRUomnY+Lhh/sOLNRQ3JD2RK7wxLLMdG46mWyDzqRyypA1RX5pobyre5
	 hPkrPyG2V5tKBk0iV+Cd0aaTukrCkxehelUTfgYu2r7Nz4CBRM4teIa9m6TRJqdlw/Igi
	 nOkgOg+gtP9q7vs3IBnfRaGfR0qOSg2LwWx716UlknIBaNLYPCKChk0uyl2NWMrkPfQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065386;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=LUQazszkW3uf64Sf8hCR9IPGkjMOtOmTWE8OuV5toOE=;
	b=vEVBiR/WHevKba+Hwp+0T5nLdBRm47bNc1E74F47lFukRDT/H69kC5/SgQ5y6DoeB5i+
	 ulQHi/WoBBJf0FwnbowSMZp6BBPNIkHrqu2lYPl5ahJqUTYBKg1jlYDvqSMqHGKnZ2cE+
	 WeZuWkvDPV+nFMWr3B654HXDP/LgitETZEI8WZzXW7jftv4GFjhqvOrO0CMTGc73n7j7y
	 ozcNUbg9oneUHcURFGMNmQ9btu5McVQYJG9DucL+UdVInBlmtK4tbQNVobPYWaMCVXTdB
	 Tpu8GCySVfIxdSU9ibs07hLPGhM3vcEpJkwWUelL2WyQTo/8e7Awje0EIOqRwjqGofQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PjAdZJ9x;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 030AE606A32C;
	Sat,  7 Nov 2026 15:29:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PjAdZJ9x
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2B3B1F0089F;
	Sat,  7 Nov 2026 15:29:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065385;
	bh=LUQazszkW3uf64Sf8hCR9IPGkjMOtOmTWE8OuV5toOE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PjAdZJ9x7ttjBo5qkkffP9M00BihCKeZsPrShg11j+3uNy5ZzxqQ7Y5cqX+wBPX69
	 TlIkohWzPfZaJVClZ5zFE++qCoj4pK2o2aql+TDQtiUj7KP/mBaj4On9xhSd0CrFgc
	 +JicPGcA4D70L04noxNhgmEaBRMWEn4IXsXX7XOg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frederic Weisbecker <frederic@kernel.org>,
	He Rongguang <herongguang@linux.alibaba.com>,
	Peng Wang <peng_wang@linux.alibaba.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1110/1257] tick/nohz: Reevaluate the tick for kicks flushed outside hardirq
Date: Sat,  7 Nov 2026 08:56:46 -0500
Message-ID: <20261107135009.906996990@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 6c3fea3867139..baa3ac9b48f88 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -400,9 +400,21 @@ static bool can_stop_full_tick(int cpu, struct tick_sched *ts)
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



