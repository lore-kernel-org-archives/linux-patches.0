Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063657;
	b=bhn5dJmxNBUgSfmhFigmTxXdYzKKw5hl+aUQV1nxjSM+osOLEip10227QfSOmMBvn4tL
	 H35orsJEU2Ado2aqOsOdYv1loV3zlWxNY+iFp90x0EIbtH6fVlu1TvwdN5NdChrVxATaZ
	 CyiajG5b05v/J2pyA+c13YQyxvYtMdzu0UR0os18Wq1KWje1vfZZkqFbZmWzZQyJ/k1PE
	 XGtJbxundQ5OqIf6VPg+QFq3mUQrHDU036OELFE5AGlMPfmlrZI41VjuPQq7WbI7tZQeI
	 bVr86rDwqcH2booh9DB2tN/GloUO0BAsgcNTmPY5TjZUbfzeI6xRSgBOyfmPBafGuaA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063657;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=W2V82DM4BfhUwf5tQh37lDc90wO+9txmO0GEN4PD82Q=;
	b=dfW2RJZsOe490t2eJFFOHwSP3I9stvrXow/Kpfegh0sC3oCz/dJv8gXvrcvXh2Py7xSO
	 otAw4wCVZRC2w3r4K6rl4O3f3l0nFiM7sT0zRbDnqccuQklwCO5TMt8NdpylEQv8s9Mbz
	 sjGMVV/V7J+1RgaXXDmFZ9nKQkbEAvq5crG23gzLgsL3wKycQ12tTgyUPrTjSw5fe14Dp
	 iosLw/kX9FA1wSBFH8FsUFHAqVE3HwCF43nQsM0tOE9xaxL6MP3x9LFJGuN1olGbha2u9
	 vvxUCqnZkmxxLHTVJZDMxB1KAcMYCPjDhxpcEagHR9ELWJh6Tr/EX3pBd+4SJ92CA7A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=m0c+ScWg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3EB5606A9DA;
	Sat,  7 Nov 2026 15:00:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=m0c+ScWg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 903B11F0089F;
	Sat,  7 Nov 2026 15:00:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063656;
	bh=W2V82DM4BfhUwf5tQh37lDc90wO+9txmO0GEN4PD82Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=m0c+ScWgfcDnFmqBI8peXOnJPnvMZeLIdsbBmNg8uHC/CDYQ68o9PkYL8aFzOIbEv
	 8OVeVCbOaDmgAza6gp7Ao/dOdRoagvHGGKRFhsGF9eY42WcP5lIBoUucmWsj0xrzsE
	 TykiKxNgjqVFECnRx7SCgpJN977tkEtHT/u2TG5w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hungyu Lin <dennylin0707@gmail.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 763/869] timers/itimer: Keep a nonzero value at CPU timer expiry
Date: Sat,  7 Nov 2026 08:57:25 -0500
Message-ID: <20261107134918.584913995@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 03a32dffc56cc..f7de39769095f 100644
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



