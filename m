Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A04F325736;
	Tue, 16 Dec 2025 12:13:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765887204; cv=none; b=lkF9xSwuQAo+D4bY1fYxoFrf0Cx0gVXGpe+nRieTl1apZjrUkbwuTljZ3MJZdpPMBGtbULgxCoLnl1E/j7EaBQ4aKP92BiIqX8CuelZrZlieekSfuqQYtzQK/knHZF+LvcLiHG/AS+qMQzoi6pdK3dgyaC8KAfBv257IE3xL10s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765887204; c=relaxed/simple;
	bh=yDiQO3+he43LRnEhUR86t08/pL7K4xxIfy8ztTNKVtU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aL5gS39nMTeGqedqbJmczy0gSvftG7/jUKAHu7CnkfetJMpTrelWgktiChW2KM9qDNN0qK0WQ2G7nQFOznfn1vwnvr2E5VCgqt6uybddwNjNrhAOwR5ItS+5LVhp66WT3t2gEymY4zGO3frkFBigJQGsAeItBDLEMVcm1go2K8w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vVGcCEQR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vVGcCEQR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06E97C4CEF1;
	Tue, 16 Dec 2025 12:13:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765887204;
	bh=yDiQO3+he43LRnEhUR86t08/pL7K4xxIfy8ztTNKVtU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vVGcCEQRIFcY22Qps5Z+nFSjEC08QELmLLPE4kuRctMP4lb9xMk1E8bVGuz27dxoB
	 ww+uekUjWZnyJtV0w0S02Bzr7hNjQExxJh6tVOm3KS3F6XI6jsNikUE6l/ZPGPcyIu
	 4/wJDLSbDyRiCiOy9DW86lczhVBeVWiM8HuK+JOA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	"Jason A. Donenfeld" <Jason@zx2c4.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 158/614] random: use offstack cpumask when necessary
Date: Tue, 16 Dec 2025 12:08:45 +0100
Message-ID: <20251216111407.060859596@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 5d49f1a5bd358d24e5f88b23b46da833de1dbec8 ]

The entropy generation function keeps a local cpu mask on the stack,
which can trigger warnings in configurations with a large number of
CPUs:

    drivers/char/random.c:1292:20: error: stack frame size (1288)
    exceeds limit (1280) in 'try_to_generate_entropy' [-Werror,-Wframe-larger-than]

Use the cpumask interface to dynamically allocate it in those
configurations.

Fixes: 1c21fe00eda7 ("random: spread out jitter callback to different CPUs")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/random.c | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index b8b24b6ed3fe4..4ba5f0c4c8b24 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -1296,6 +1296,7 @@ static void __cold try_to_generate_entropy(void)
 	struct entropy_timer_state *stack = PTR_ALIGN((void *)stack_bytes, SMP_CACHE_BYTES);
 	unsigned int i, num_different = 0;
 	unsigned long last = random_get_entropy();
+	cpumask_var_t timer_cpus;
 	int cpu = -1;
 
 	for (i = 0; i < NUM_TRIAL_SAMPLES - 1; ++i) {
@@ -1310,13 +1311,15 @@ static void __cold try_to_generate_entropy(void)
 
 	atomic_set(&stack->samples, 0);
 	timer_setup_on_stack(&stack->timer, entropy_timer, 0);
+	if (!alloc_cpumask_var(&timer_cpus, GFP_KERNEL))
+		goto out;
+
 	while (!crng_ready() && !signal_pending(current)) {
 		/*
 		 * Check !timer_pending() and then ensure that any previous callback has finished
 		 * executing by checking timer_delete_sync_try(), before queueing the next one.
 		 */
 		if (!timer_pending(&stack->timer) && timer_delete_sync_try(&stack->timer) >= 0) {
-			struct cpumask timer_cpus;
 			unsigned int num_cpus;
 
 			/*
@@ -1326,19 +1329,19 @@ static void __cold try_to_generate_entropy(void)
 			preempt_disable();
 
 			/* Only schedule callbacks on timer CPUs that are online. */
-			cpumask_and(&timer_cpus, housekeeping_cpumask(HK_TYPE_TIMER), cpu_online_mask);
-			num_cpus = cpumask_weight(&timer_cpus);
+			cpumask_and(timer_cpus, housekeeping_cpumask(HK_TYPE_TIMER), cpu_online_mask);
+			num_cpus = cpumask_weight(timer_cpus);
 			/* In very bizarre case of misconfiguration, fallback to all online. */
 			if (unlikely(num_cpus == 0)) {
-				timer_cpus = *cpu_online_mask;
-				num_cpus = cpumask_weight(&timer_cpus);
+				*timer_cpus = *cpu_online_mask;
+				num_cpus = cpumask_weight(timer_cpus);
 			}
 
 			/* Basic CPU round-robin, which avoids the current CPU. */
 			do {
-				cpu = cpumask_next(cpu, &timer_cpus);
+				cpu = cpumask_next(cpu, timer_cpus);
 				if (cpu >= nr_cpu_ids)
-					cpu = cpumask_first(&timer_cpus);
+					cpu = cpumask_first(timer_cpus);
 			} while (cpu == smp_processor_id() && num_cpus > 1);
 
 			/* Expiring the timer at `jiffies` means it's the next tick. */
@@ -1354,6 +1357,8 @@ static void __cold try_to_generate_entropy(void)
 	}
 	mix_pool_bytes(&stack->entropy, sizeof(stack->entropy));
 
+	free_cpumask_var(timer_cpus);
+out:
 	timer_delete_sync(&stack->timer);
 	timer_destroy_on_stack(&stack->timer);
 }
-- 
2.51.0



