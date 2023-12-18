Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21AF85BFBE;
	Mon, 18 Dec 2023 14:04:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GGPMT5XY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D3F7C433CD;
	Mon, 18 Dec 2023 14:04:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702908242;
	bh=KQZzmAwb1+LDnObROPfRfVJuif9LlwqkSsMPi+NTaUw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GGPMT5XYbo9Z0Bpo5r0tjwph7EdTTZHQgJ5FbcdGIAIiQOiPYUxENOBeh32KFjTGY
	 ZB6PCP9bLjjBcgBMNrCC7tgF1DUj4HYUKn44zB6mqYSHej1lEufh3qbc0g0EFEjNFG
	 1nJN/aerzj0anbU2yP3ldyb6acuaP1VGb3nDo5t4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	WANG Xuerui <git@xen0n.name>,
	Bibo Mao <maobibo@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 105/166] LoongArch: Implement constant timer shutdown interface
Date: Mon, 18 Dec 2023 14:51:11 +0100
Message-ID: <20231218135109.715986205@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231218135104.927894164@linuxfoundation.org>
References: <20231218135104.927894164@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Bibo Mao <maobibo@loongson.cn>

[ Upstream commit d43f37b73468c172bc89ac4824a1511b411f0778 ]

When a cpu is hot-unplugged, it is put in idle state and the function
arch_cpu_idle_dead() is called. The timer interrupt for this processor
should be disabled, otherwise there will be pending timer interrupt for
the unplugged cpu, so that vcpu is prevented from giving up scheduling
when system is running in vm mode.

This patch implements the timer shutdown interface so that the constant
timer will be properly disabled when a CPU is hot-unplugged.

Reviewed-by: WANG Xuerui <git@xen0n.name>
Signed-off-by: Bibo Mao <maobibo@loongson.cn>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/loongarch/kernel/time.c | 23 +++++++++--------------
 1 file changed, 9 insertions(+), 14 deletions(-)

diff --git a/arch/loongarch/kernel/time.c b/arch/loongarch/kernel/time.c
index 3064af94db9c2..e7015f7b70e37 100644
--- a/arch/loongarch/kernel/time.c
+++ b/arch/loongarch/kernel/time.c
@@ -58,14 +58,16 @@ static int constant_set_state_oneshot(struct clock_event_device *evt)
 	return 0;
 }
 
-static int constant_set_state_oneshot_stopped(struct clock_event_device *evt)
+static int constant_set_state_periodic(struct clock_event_device *evt)
 {
+	unsigned long period;
 	unsigned long timer_config;
 
 	raw_spin_lock(&state_lock);
 
-	timer_config = csr_read64(LOONGARCH_CSR_TCFG);
-	timer_config &= ~CSR_TCFG_EN;
+	period = const_clock_freq / HZ;
+	timer_config = period & CSR_TCFG_VAL;
+	timer_config |= (CSR_TCFG_PERIOD | CSR_TCFG_EN);
 	csr_write64(timer_config, LOONGARCH_CSR_TCFG);
 
 	raw_spin_unlock(&state_lock);
@@ -73,16 +75,14 @@ static int constant_set_state_oneshot_stopped(struct clock_event_device *evt)
 	return 0;
 }
 
-static int constant_set_state_periodic(struct clock_event_device *evt)
+static int constant_set_state_shutdown(struct clock_event_device *evt)
 {
-	unsigned long period;
 	unsigned long timer_config;
 
 	raw_spin_lock(&state_lock);
 
-	period = const_clock_freq / HZ;
-	timer_config = period & CSR_TCFG_VAL;
-	timer_config |= (CSR_TCFG_PERIOD | CSR_TCFG_EN);
+	timer_config = csr_read64(LOONGARCH_CSR_TCFG);
+	timer_config &= ~CSR_TCFG_EN;
 	csr_write64(timer_config, LOONGARCH_CSR_TCFG);
 
 	raw_spin_unlock(&state_lock);
@@ -90,11 +90,6 @@ static int constant_set_state_periodic(struct clock_event_device *evt)
 	return 0;
 }
 
-static int constant_set_state_shutdown(struct clock_event_device *evt)
-{
-	return 0;
-}
-
 static int constant_timer_next_event(unsigned long delta, struct clock_event_device *evt)
 {
 	unsigned long timer_config;
@@ -161,7 +156,7 @@ int constant_clockevent_init(void)
 	cd->rating = 320;
 	cd->cpumask = cpumask_of(cpu);
 	cd->set_state_oneshot = constant_set_state_oneshot;
-	cd->set_state_oneshot_stopped = constant_set_state_oneshot_stopped;
+	cd->set_state_oneshot_stopped = constant_set_state_shutdown;
 	cd->set_state_periodic = constant_set_state_periodic;
 	cd->set_state_shutdown = constant_set_state_shutdown;
 	cd->set_next_event = constant_timer_next_event;
-- 
2.43.0



