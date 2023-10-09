Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2C44168D5
	for <patches@lists.linux.dev>; Mon,  9 Oct 2023 13:11:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F58JHSM5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D1D2C433CB;
	Mon,  9 Oct 2023 13:11:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696857089;
	bh=qqvxmQxI3Eb12Ank7Z/TtATJ3SgNQqZSzlmqccTLvIw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F58JHSM5dA9XBvta32OjmoBmbavQ39nCmh2IVH2NDrX83G5+oY23QSNPn+SxNWBD7
	 XUBufPlK1YWD+GQ0tjJhrUG27tM8CMdFtTRM2kv/dTaOG9l+qrsGhgS9dHOYyNIprb
	 lxdRCyfmyWVl5Hx+4dFIuCrqKShATK7ICeHDzydA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Bristot de Oliveira <bristot@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 066/163] rtla/timerlat_aa: Fix negative IRQ delay
Date: Mon,  9 Oct 2023 15:00:30 +0200
Message-ID: <20231009130125.872123498@linuxfoundation.org>
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

[ Upstream commit 6c73daf26420b97fb8b4a620e4ffee5c1f9d44d1 ]

When estimating the IRQ timer delay, we are dealing with two different
clock sources: the external clock source that timerlat uses as a reference
and the clock used by the tracer. There are also two moments: the time
reading the clock and the timer in which the event is placed in the
buffer (the trace event timestamp).

If the processor is slow or there is some hardware noise, the difference
between the timestamp and the external clock, read can be longer than the
IRQ handler delay, resulting in a negative time.

If so, set IRQ to start delay as 0. In the end, it is less near-zero and relevant
then the noise.

Link: https://lore.kernel.org/lkml/a066fb667c7136d86dcddb3c7ccd72587db3e7c7.1691162043.git.bristot@kernel.org

Fixes: 27e348b221f6 ("rtla/timerlat: Add auto-analysis core")
Signed-off-by: Daniel Bristot de Oliveira <bristot@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/tracing/rtla/src/timerlat_aa.c | 18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff --git a/tools/tracing/rtla/src/timerlat_aa.c b/tools/tracing/rtla/src/timerlat_aa.c
index dec5b4c4511e1..baf1efda0581d 100644
--- a/tools/tracing/rtla/src/timerlat_aa.c
+++ b/tools/tracing/rtla/src/timerlat_aa.c
@@ -338,7 +338,23 @@ static int timerlat_aa_irq_handler(struct trace_seq *s, struct tep_record *recor
 		taa_data->timer_irq_start_time = start;
 		taa_data->timer_irq_duration = duration;
 
-		taa_data->timer_irq_start_delay = taa_data->timer_irq_start_time - expected_start;
+		/*
+		 * We are dealing with two different clock sources: the
+		 * external clock source that timerlat uses as a reference
+		 * and the clock used by the tracer. There are also two
+		 * moments: the time reading the clock and the timer in
+		 * which the event is placed in the buffer (the trace
+		 * event timestamp). If the processor is slow or there
+		 * is some hardware noise, the difference between the
+		 * timestamp and the external clock read can be longer
+		 * than the IRQ handler delay, resulting in a negative
+		 * time. If so, set IRQ start delay as 0. In the end,
+		 * it is less relevant than the noise.
+		 */
+		if (expected_start < taa_data->timer_irq_start_time)
+			taa_data->timer_irq_start_delay = taa_data->timer_irq_start_time - expected_start;
+		else
+			taa_data->timer_irq_start_delay = 0;
 
 		/*
 		 * not exit from idle.
-- 
2.40.1



