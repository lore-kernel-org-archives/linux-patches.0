Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFB56168D5
	for <patches@lists.linux.dev>; Mon,  9 Oct 2023 13:11:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tg1x11hH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A6BDC43391;
	Mon,  9 Oct 2023 13:11:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696857092;
	bh=mOhGOTTrmTtXy/9QNLzz6Ydxe4WYwp2UU8OEqjeRpQg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tg1x11hH7kWSH8f9iYA11bY87wZR84m/ssEZITGukGzBBFoBp8Y407vZqQKBkFz0f
	 vsPvlYXVo0tH9DbjpKv6O1wu/PK3RP5PmHoJ4gNVyV9GC5EBOxcbdTVq7/kHHb3ilF
	 X/MrMNWPKqtUwvoysN9aKAKOPlu//wYExeWyrYRY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Bristot de Oliveira <bristot@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 067/163] rtla/timerlat_aa: Fix previous IRQ delay for IRQs that happens after thread sample
Date: Mon,  9 Oct 2023 15:00:31 +0200
Message-ID: <20231009130125.899410092@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231009130124.021290599@linuxfoundation.org>
References: <20231009130124.021290599@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Bristot de Oliveira <bristot@kernel.org>

[ Upstream commit 301deca09b254965661d3e971f1a60ac2ce41f5f ]

timerlat auto-analysis takes note of all IRQs, before or after the
execution of the timerlat thread.

Because we cannot go backward in the trace (we will fix it when
moving to trace-cmd lib?), timerlat aa take note of the last IRQ
execution in the waiting for the IRQ state, and then print it
if it is executed after the expected timer IRQ starting time.

After the thread sample, the timerlat starts recording the next IRQs as
"previous" irq for the next occurrence.

However, if an IRQ happens after the thread measurement but before the
tracing stops, it is classified as a previous IRQ. That is not
wrong, as it can be "previous" for the subsequent activation. What is
wrong is considering it as a potential source for the last activation.

Ignore the IRQ interference that happens after the IRQ starting time for
now. A future improvement for timerlat can be either keeping a list of
previous IRQ execution or using the trace-cmd library. Still, it requires
further investigation - it is a new feature.

Link: https://lore.kernel.org/lkml/a44a3f5c801dcc697bacf7325b65d4a5b0460537.1691162043.git.bristot@kernel.org

Fixes: 27e348b221f6 ("rtla/timerlat: Add auto-analysis core")
Signed-off-by: Daniel Bristot de Oliveira <bristot@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/tracing/rtla/src/timerlat_aa.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/tools/tracing/rtla/src/timerlat_aa.c b/tools/tracing/rtla/src/timerlat_aa.c
index baf1efda0581d..7093fd5333beb 100644
--- a/tools/tracing/rtla/src/timerlat_aa.c
+++ b/tools/tracing/rtla/src/timerlat_aa.c
@@ -545,7 +545,7 @@ static int timerlat_aa_kworker_start_handler(struct trace_seq *s, struct tep_rec
 static void timerlat_thread_analysis(struct timerlat_aa_data *taa_data, int cpu,
 				     int irq_thresh, int thread_thresh)
 {
-	unsigned long long exp_irq_ts;
+	long long exp_irq_ts;
 	int total;
 	int irq;
 
@@ -562,12 +562,15 @@ static void timerlat_thread_analysis(struct timerlat_aa_data *taa_data, int cpu,
 
 	/*
 	 * Expected IRQ arrival time using the trace clock as the base.
+	 *
+	 * TODO: Add a list of previous IRQ, and then run the list backwards.
 	 */
 	exp_irq_ts = taa_data->timer_irq_start_time - taa_data->timer_irq_start_delay;
-
-	if (exp_irq_ts < taa_data->prev_irq_timstamp + taa_data->prev_irq_duration)
-		printf("  Previous IRQ interference:	\t\t up to  %9.2f us\n",
-			ns_to_usf(taa_data->prev_irq_duration));
+	if (exp_irq_ts < taa_data->prev_irq_timstamp + taa_data->prev_irq_duration) {
+		if (taa_data->prev_irq_timstamp < taa_data->timer_irq_start_time)
+			printf("  Previous IRQ interference:	\t\t up to  %9.2f us\n",
+				ns_to_usf(taa_data->prev_irq_duration));
+	}
 
 	/*
 	 * The delay that the IRQ suffered before starting.
-- 
2.40.1



