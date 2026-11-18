Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021825;
	b=3eHp/kaFCG4EqEGZZZB724XWRu9KtaPtU1CeahvdwEArgcNus6t28dvCkqd4QOMI1Zhq
	 pRW6748hgfU79XvANREeGuJ8W7oH4r4gGVTFSh9+sBRmP4ra+NYOagmMiXXKHRlTKwtMA
	 kwsBBRPlGPj4RHT30Lv8vfRwqTtrxFUkdo2XJXJXBG0xiOoIkwMzs5FtdYsSeXLV4lRvp
	 /row6QY59FC4NtSrLiCcNXeA0Kd7xq3+v8hI5T1/2juyzaE0h5+eDCsxc6jUS5nMMpOs/
	 WW22hOi8VyhAoWqvUeXrlOxlu6lGaAHB4qgJwnul3MtzJOWXc3Ny+STaGa9wGEjetpg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021825;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=yc06lunNgQzcckWgIXBKZ6/eTuwDt7gs0gOvWXrfl3c=;
	b=Q3s2wvi5EuQ5A1rr0BGxOCHBx3MQHyYSdhX/kJ7dObmOetcZ5hr78ZCv3fBDyLPiO1OO
	 E7rBY0kRbQXuxeIZjf2oVGlKA0Ymm6YFxK2Au3jizht2YxFWzFVy9hhyYf82C4U0gouRw
	 vvsX3mJoRltUqloTsD/Tti705xelg9EN7KcCzt0xX9KDwoAqIWsXUsGI2u0AAYR0rA6+E
	 aB1f14WlhTGTv4TFoYV7+QVap/mY7C6eSxj2+jRr3PQUqLsRnnoK4WK2lJAXdH51E0ePE
	 Fit9Wom5Jt8JRnZITIbOwaeDnCjJd7wU4M7ap0wsfTQUw5JTEE7ZxSdErO29CatDgLg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ds9W13Es;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 350C8606A332;
	Wed, 18 Nov 2026 17:10:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ds9W13Es
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3990B1F000C4;
	Wed, 18 Nov 2026 17:10:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021824;
	bh=yc06lunNgQzcckWgIXBKZ6/eTuwDt7gs0gOvWXrfl3c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ds9W13EsWC04TQkkBcssAP4lIOlPRhIkHIyUj5/f2hetIWNAtkuZk6vNoaiQnhQQq
	 oGI8xEGUuSQkfi1THp6Lnk2oH0AKvDPIoFRUVoEMWJDfVfsx6OYn8XIU9PlKUAOv0i
	 fHkItEK/JEM3qvqyywydNCtDhLnDv8iY++u8+x4Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hui Su <sh_def@163.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2407/2651] sched/idle: Use hrtimer cleanup class in play_idle_precise()
Date: Wed, 18 Nov 2026 16:00:47 +0100
Message-ID: <20261118150411.976360470@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

From: Hui Su <sh_def@163.com>

[ Upstream commit bd091346971c88fccd44afd2547d28366f824572 ]

Pair on-stack setup with destruction using the hrtimer_on_stack cleanup
class in play_idle_precise().

Keep the cleanup object's scope around timer start and the idle wait. Start
the timer in pinned hard mode, so its callback runs as a hardirq on the
current CPU. The interrupted task observes it.done only after the callback
returns. Since the callback returns HRTIMER_NORESTART, the timer is not
requeued before the cleanup object tears down its on-stack debug object.

Fixes: c1de45ca831a ("sched/idle: Add support for tasks that inject idle")
Signed-off-by: Hui Su <sh_def@163.com>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Link: https://patch.msgid.link/eccd97b2003a16291817974798cbe98b25b582a0.1792083743.git.sh_def@163.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/idle.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/kernel/sched/idle.c b/kernel/sched/idle.c
index eb73b65ce6c47..2880e01368b8e 100644
--- a/kernel/sched/idle.c
+++ b/kernel/sched/idle.c
@@ -429,13 +429,17 @@ void play_idle_precise(u64 duration_ns, u64 latency_ns)
 	cpuidle_use_deepest_state(latency_ns);
 
 	it.done = 0;
-	hrtimer_setup_on_stack(&it.timer, idle_inject_timer_fn, CLOCK_MONOTONIC,
-			       HRTIMER_MODE_REL_HARD);
-	hrtimer_start(&it.timer, ns_to_ktime(duration_ns),
-		      HRTIMER_MODE_REL_PINNED_HARD);
+	{
+		CLASS(hrtimer_on_stack, timer)(&it.timer, idle_inject_timer_fn,
+					       CLOCK_MONOTONIC,
+					       HRTIMER_MODE_REL_HARD);
 
-	while (!READ_ONCE(it.done))
-		do_idle();
+		hrtimer_start(timer, ns_to_ktime(duration_ns),
+			      HRTIMER_MODE_REL_PINNED_HARD);
+
+		while (!READ_ONCE(it.done))
+			do_idle();
+	}
 
 	cpuidle_use_deepest_state(0);
 	current->flags &= ~PF_IDLE;
-- 
2.53.0



