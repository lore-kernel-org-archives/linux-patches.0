Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 636E4218EBF;
	Mon, 23 Jun 2025 22:19:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750717180; cv=none; b=dWy818Bp8lK8Quh3GpXEgjKgYNQPJ13LtDXcQjxkqaoiKRfK4qtCJqWcaLiMQ74jkT53H1YzXXRcNTivjrzv7lorbMV9c66HgEALGRewfTrojNraUQHy356ZQ3kj2cY1+4sPGp7GMkKpN1AdOAcMq5XFTLS9NDFVUQw+ucY23A8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750717180; c=relaxed/simple;
	bh=V/qMPKHgljwQ6/Qviu79aGt6FgbT5YGBK8H94RnU9xY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bsa3ddL7AfmRlW9EaPO3EQVjDDPU1T6R679zuWYHh9WKW4TWHr9do3pcOfPWvzgffqffjgtvWJdsPN+mKUYdaBg1Ddc7ANltrXgLeFrYygOX9FGY5jxVnitUGg2x/4ADDMR5fb6u3oUeNhCE3rCxhtU6EthEXmFSJz51dc41VnU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VXmMPd16; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VXmMPd16"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F09B9C4CEEA;
	Mon, 23 Jun 2025 22:19:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750717180;
	bh=V/qMPKHgljwQ6/Qviu79aGt6FgbT5YGBK8H94RnU9xY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VXmMPd16/WqWzoZ0H47PXX4cEvYttK1QIQUt0yIdaaJyiFCfIxDVD5Jj3ZXqikq94
	 DZLQ9ZQONbEDpZb7Fw8JByQ+crlCrlh9dnYZU0MqJa0fnMau2x9eb2aIOTOzrfMlwq
	 Rc9rEEt5Ljpr5TTjXV71hRcaontj0I67HfYnCHsg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thadeu Lima de Souza Cascardo <cascardo@igalia.com>,
	"Guilherme G. Piccoli" <gpiccoli@igalia.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 376/508] clocksource: Fix the CPUs choice in the watchdog per CPU verification
Date: Mon, 23 Jun 2025 15:07:01 +0200
Message-ID: <20250623130654.575195660@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130645.255320792@linuxfoundation.org>
References: <20250623130645.255320792@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guilherme G. Piccoli <gpiccoli@igalia.com>

[ Upstream commit 08d7becc1a6b8c936e25d827becabfe3bff72a36 ]

Right now, if the clocksource watchdog detects a clocksource skew, it might
perform a per CPU check, for example in the TSC case on x86.  In other
words: supposing TSC is detected as unstable by the clocksource watchdog
running at CPU1, as part of marking TSC unstable the kernel will also run a
check of TSC readings on some CPUs to be sure it is synced between them
all.

But that check happens only on some CPUs, not all of them; this choice is
based on the parameter "verify_n_cpus" and in some random cpumask
calculation. So, the watchdog runs such per CPU checks on up to
"verify_n_cpus" random CPUs among all online CPUs, with the risk of
repeating CPUs (that aren't double checked) in the cpumask random
calculation.

But if "verify_n_cpus" > num_online_cpus(), it should skip the random
calculation and just go ahead and check the clocksource sync between
all online CPUs, without the risk of skipping some CPUs due to
duplicity in the random cpumask calculation.

Tests in a 4 CPU laptop with TSC skew detected led to some cases of the per
CPU verification skipping some CPU even with verify_n_cpus=8, due to the
duplicity on random cpumask generation. Skipping the randomization when the
number of online CPUs is smaller than verify_n_cpus, solves that.

Suggested-by: Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
Signed-off-by: Guilherme G. Piccoli <gpiccoli@igalia.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Paul E. McKenney <paulmck@kernel.org>
Link: https://lore.kernel.org/all/20250323173857.372390-1-gpiccoli@igalia.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/time/clocksource.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/time/clocksource.c b/kernel/time/clocksource.c
index 9e221a97d2274..e89fd0bbc3b35 100644
--- a/kernel/time/clocksource.c
+++ b/kernel/time/clocksource.c
@@ -285,7 +285,7 @@ static void clocksource_verify_choose_cpus(void)
 {
 	int cpu, i, n = verify_n_cpus;
 
-	if (n < 0) {
+	if (n < 0 || n >= num_online_cpus()) {
 		/* Check all of the CPUs. */
 		cpumask_copy(&cpus_chosen, cpu_online_mask);
 		cpumask_clear_cpu(smp_processor_id(), &cpus_chosen);
-- 
2.39.5



