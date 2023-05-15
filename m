Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3857FBF6
	for <patches@lists.linux.dev>; Mon, 15 May 2023 17:56:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06606C433D2;
	Mon, 15 May 2023 17:56:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684173388;
	bh=mfpvP2kMpjsqrnywGnQtk/T1Asy2JIxAwVXTDRWh6LI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sXyWmAaicoxKG1qNeEyVZYzMlRXXeYRl49JYGbicQpILEQFxRAAVesgWH3dXIPEGA
	 /r/AF0zob5Q/DA3nqndQ6857mIjQc8ZVa74N2twXuL69ZzUdhMsEDMVOnRPce8Alza
	 PlvH7+WJEZZ1EKRg/Y99Ifgus+6ZL1dGduanhBVA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Gleixner <tglx@linutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 071/282] tick/sched: Optimize tick_do_update_jiffies64() further
Date: Mon, 15 May 2023 18:27:29 +0200
Message-Id: <20230515161724.361704409@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161722.146344674@linuxfoundation.org>
References: <20230515161722.146344674@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Thomas Gleixner <tglx@linutronix.de>

[ Upstream commit 7a35bf2a6a871cd0252cd371d741e7d070b53af9 ]

Now that it's clear that there is always one tick to account, simplify the
calculations some more.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Link: https://lore.kernel.org/r/20201117132006.565663056@linutronix.de
Stable-dep-of: e9523a0d8189 ("tick/common: Align tick period with the HZ tick.")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/time/tick-sched.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index eaeeb4bb1f8ab..3b00167656d78 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -53,7 +53,7 @@ static ktime_t last_jiffies_update;
  */
 static void tick_do_update_jiffies64(ktime_t now)
 {
-	unsigned long ticks = 0;
+	unsigned long ticks = 1;
 	ktime_t delta;
 
 	/*
@@ -91,20 +91,21 @@ static void tick_do_update_jiffies64(ktime_t now)
 
 	write_seqcount_begin(&jiffies_seq);
 
-	last_jiffies_update = ktime_add(last_jiffies_update, tick_period);
-
 	delta = ktime_sub(now, tick_next_period);
 	if (unlikely(delta >= tick_period)) {
 		/* Slow path for long idle sleep times */
 		s64 incr = ktime_to_ns(tick_period);
 
-		ticks = ktime_divns(delta, incr);
+		ticks += ktime_divns(delta, incr);
 
 		last_jiffies_update = ktime_add_ns(last_jiffies_update,
 						   incr * ticks);
+	} else {
+		last_jiffies_update = ktime_add(last_jiffies_update,
+						tick_period);
 	}
 
-	do_timer(++ticks);
+	do_timer(ticks);
 
 	/*
 	 * Keep the tick_next_period variable up to date.  WRITE_ONCE()
-- 
2.39.2



