Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036903;
	b=S2rSyyXsarSSUdaoJxHKzQM6u4YGcEp2CB8r92+rJPG4OpKTFlEKt0qhYuGyMopa/NNK
	 J9UOjGyDEe5ilJdEfBpXJ24nee+UBtINmnWhQw6Coc0jLd0NzzO0ySZsKALvaXj7/d/DE
	 Hx5kx4SwvLylPcaXzZ6klO1gneEIiSpHh5NyvY3J76u/9zK8CnuzE9izDRgUfA/7rSg+E
	 ahrEE4BlE0wZJ+8la79fXZ/HuasaK9DQ9QLnM3nf051doKkO6M4eA4B1w8dmEfcvSi7+1
	 LxULtwENCctzotjb+U677GTxhw3lWJa9JiQvJhbFyxkGDOfIjduWCoKLxjNNrDMOodA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036903;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mkc9Noihr/SBvEa1fUaxivcVoEDnFyTuAL+1vn2LiGA=;
	b=xhlbSpLeIwzopah0RbLTUbwNnaOZOJajHOGvdWGsWQjANVV319uLvVQFrPNducB9RU35
	 h7MgLy1ZbnUrO2/yuhSzHoMSnrXRjOZ/zyegdijNSJgycGsJ3gHfQqhGux8kvrn47ZMo5
	 LCIzYgiy+YczgtMDHprmQl++GpEC+UAeqwCAVKAny7Q7daHyjgWXrGfqzdQQ0W/W9T2Az
	 2se9Fv/Zo74pNwgIIzsPAEnBWsM5gli1fCRVqMAjnA+jdDe9aIysggNrKzmUkt/C7t0aL
	 V1jjV3M8vLeSHBS4HL4OhFh2UenMk0q/L07Pdg23lsOdZKF7p3adnbuf+0MCH0wUlSg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sRKcmdQC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6030C606A31C;
	Wed, 18 Nov 2026 21:21:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sRKcmdQC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3BEF1F000C4;
	Wed, 18 Nov 2026 21:21:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036903;
	bh=mkc9Noihr/SBvEa1fUaxivcVoEDnFyTuAL+1vn2LiGA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sRKcmdQCdMZllaMUUnQvCPsx3fQEF3CNxD+sezuPC5R9HL/Co6IDDIpXExW1kGimz
	 L2KiAf3xXVL7tARedYcLb9p7DmYqiJDJrXsk+NJwKr5THalXcqi69aFjRY1MnvvWP9
	 bWGnQAvujUjdzPrZ0akwkE+XFPYEyQX7BoeK4+NM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hungyu Lin <dennylin0707@gmail.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1224/3318] timers/itimer: Keep a nonzero value at CPU timer expiry
Date: Wed, 18 Nov 2026 15:30:46 +0100
Message-ID: <20261118150356.904793504@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hungyu Lin <dennylin0707@gmail.com>

[ Upstream commit ef60f61208a30eb5b941b707debdf04517271b4f ]

get_cpu_itimer() returns a zero remaining time when the sampled CPU time
is exactly equal to the nonzero expiry. This makes an armed ITIMER_VIRTUAL
or ITIMER_PROF timer appear disarmed.

The cputime cleanup replaced cputime_le(), which implements <=, with <.
Restore the inclusive comparison so the equality case returns TICK_NSEC,
like the overdue case and set_process_cpu_timer().

Fixes: 648616343cdb ("[S390] cputime: add sparse checking and cleanup")
Signed-off-by: Hungyu Lin <dennylin0707@gmail.com>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20261020223957.87842-1-dennylin0707@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/time/itimer.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/time/itimer.c b/kernel/time/itimer.c
index dc5b1d92e2466..677b67812fee3 100644
--- a/kernel/time/itimer.c
+++ b/kernel/time/itimer.c
@@ -60,7 +60,7 @@ static void get_cpu_itimer(struct task_struct *tsk, unsigned int clock_id,
 		thread_group_sample_cputime(tsk, samples);
 		t = samples[clock_id];
 
-		if (val < t)
+		if (val <= t)
 			/* about to fire */
 			val = TICK_NSEC;
 		else
-- 
2.53.0



