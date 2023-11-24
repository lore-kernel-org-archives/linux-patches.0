Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79CAE39FF7;
	Fri, 24 Nov 2023 18:21:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i2pN8NrB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 071E0C433C8;
	Fri, 24 Nov 2023 18:21:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700850063;
	bh=IKe/G64n//hUczacjlBuOYU6biHHV2mU6+dXu4AufOs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i2pN8NrBZsPJlvwrNJBglC/p+kGI7ZSMPalhXu3Flb3ACR1tRPjLGQxL+Vqyf1ETo
	 vM0cOFHjJc0QasTUibogoHGqPCrDaVx2UJIT9gQxHsgjsaGAT0SZq8+l5mrlM6QXIy
	 sowXeHyfQ2m/xVjyAAOg6UUBoTd9Px2owHaLvyiY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Frederic Weisbecker <frederic@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 406/530] torture: Make torture_hrtimeout_ns() take an hrtimer mode parameter
Date: Fri, 24 Nov 2023 17:49:32 +0000
Message-ID: <20231124172040.417688694@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172028.107505484@linuxfoundation.org>
References: <20231124172028.107505484@linuxfoundation.org>
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

From: Paul E. McKenney <paulmck@kernel.org>

[ Upstream commit a741deac787f0d2d7068638c067db20af9e63752 ]

The current torture-test sleeps are waiting for a duration, but there
are situations where it is better to wait for an absolute time, for
example, when ending a stutter interval.  This commit therefore adds
an hrtimer mode parameter to torture_hrtimeout_ns().  Why not also the
other torture_hrtimeout_*() functions?  The theory is that most absolute
times will be in nanoseconds, especially not (say) jiffies.

Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
Stable-dep-of: cca42bd8eb1b ("rcutorture: Fix stuttering races and other issues")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/torture.h |  3 ++-
 kernel/torture.c        | 13 +++++++------
 2 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/include/linux/torture.h b/include/linux/torture.h
index bb466eec01e42..017f0f710815a 100644
--- a/include/linux/torture.h
+++ b/include/linux/torture.h
@@ -81,7 +81,8 @@ static inline void torture_random_init(struct torture_random_state *trsp)
 }
 
 /* Definitions for high-resolution-timer sleeps. */
-int torture_hrtimeout_ns(ktime_t baset_ns, u32 fuzzt_ns, struct torture_random_state *trsp);
+int torture_hrtimeout_ns(ktime_t baset_ns, u32 fuzzt_ns, const enum hrtimer_mode mode,
+			 struct torture_random_state *trsp);
 int torture_hrtimeout_us(u32 baset_us, u32 fuzzt_ns, struct torture_random_state *trsp);
 int torture_hrtimeout_ms(u32 baset_ms, u32 fuzzt_us, struct torture_random_state *trsp);
 int torture_hrtimeout_jiffies(u32 baset_j, struct torture_random_state *trsp);
diff --git a/kernel/torture.c b/kernel/torture.c
index b28b05bbef027..e851b8e9390b3 100644
--- a/kernel/torture.c
+++ b/kernel/torture.c
@@ -87,14 +87,15 @@ EXPORT_SYMBOL_GPL(verbose_torout_sleep);
  * nanosecond random fuzz.  This function and its friends desynchronize
  * testing from the timer wheel.
  */
-int torture_hrtimeout_ns(ktime_t baset_ns, u32 fuzzt_ns, struct torture_random_state *trsp)
+int torture_hrtimeout_ns(ktime_t baset_ns, u32 fuzzt_ns, const enum hrtimer_mode mode,
+			 struct torture_random_state *trsp)
 {
 	ktime_t hto = baset_ns;
 
 	if (trsp)
 		hto += torture_random(trsp) % fuzzt_ns;
 	set_current_state(TASK_IDLE);
-	return schedule_hrtimeout(&hto, HRTIMER_MODE_REL);
+	return schedule_hrtimeout(&hto, mode);
 }
 EXPORT_SYMBOL_GPL(torture_hrtimeout_ns);
 
@@ -106,7 +107,7 @@ int torture_hrtimeout_us(u32 baset_us, u32 fuzzt_ns, struct torture_random_state
 {
 	ktime_t baset_ns = baset_us * NSEC_PER_USEC;
 
-	return torture_hrtimeout_ns(baset_ns, fuzzt_ns, trsp);
+	return torture_hrtimeout_ns(baset_ns, fuzzt_ns, HRTIMER_MODE_REL, trsp);
 }
 EXPORT_SYMBOL_GPL(torture_hrtimeout_us);
 
@@ -123,7 +124,7 @@ int torture_hrtimeout_ms(u32 baset_ms, u32 fuzzt_us, struct torture_random_state
 		fuzzt_ns = (u32)~0U;
 	else
 		fuzzt_ns = fuzzt_us * NSEC_PER_USEC;
-	return torture_hrtimeout_ns(baset_ns, fuzzt_ns, trsp);
+	return torture_hrtimeout_ns(baset_ns, fuzzt_ns, HRTIMER_MODE_REL, trsp);
 }
 EXPORT_SYMBOL_GPL(torture_hrtimeout_ms);
 
@@ -136,7 +137,7 @@ int torture_hrtimeout_jiffies(u32 baset_j, struct torture_random_state *trsp)
 {
 	ktime_t baset_ns = jiffies_to_nsecs(baset_j);
 
-	return torture_hrtimeout_ns(baset_ns, jiffies_to_nsecs(1), trsp);
+	return torture_hrtimeout_ns(baset_ns, jiffies_to_nsecs(1), HRTIMER_MODE_REL, trsp);
 }
 EXPORT_SYMBOL_GPL(torture_hrtimeout_jiffies);
 
@@ -153,7 +154,7 @@ int torture_hrtimeout_s(u32 baset_s, u32 fuzzt_ms, struct torture_random_state *
 		fuzzt_ns = (u32)~0U;
 	else
 		fuzzt_ns = fuzzt_ms * NSEC_PER_MSEC;
-	return torture_hrtimeout_ns(baset_ns, fuzzt_ns, trsp);
+	return torture_hrtimeout_ns(baset_ns, fuzzt_ns, HRTIMER_MODE_REL, trsp);
 }
 EXPORT_SYMBOL_GPL(torture_hrtimeout_s);
 
-- 
2.42.0



