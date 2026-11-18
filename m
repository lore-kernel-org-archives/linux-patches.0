Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045769;
	b=OAZ544iE4aJEh8eZ9aAgOHixxBRd990o0in1hPwcJ95YW/Pr3Q/AhdG2P5MpyuVB1NyW
	 dPHehuQ+XjbTzCtBQQLirTQkaJR3wMjTnCZrKtG4fHzuwsGQGdjltXcf2Kzk+herI1BD9
	 vLV9BXv9wY+tRx1LKQgFUgHbfLqvWa7FL8c/+VgsUyJsKzwlE4+1vlsgufVzAecWlZMi9
	 8BPmUZu13vATL2WdwtX6E1m5FQ9+5eDwStE1Qy1SQZ7n5MRGkdACDaegPwz1hph8hDPoS
	 U3s3C/bFadnB3N8CE0vR7F+sEnoI2Xq6X8wopP0l5NMzaxWnHT6BpKNoJNOn15rxTAQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045769;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8yACSL8FbHJqjpnCz6C/HqmKYIq6WFtRpo9lY1L4uf0=;
	b=g2++tqvelOkJa8x8w37YsV29e033gAin251Bi3pbrIuaTj00I2purhN7HKLqUwXEsXGe
	 5nvtLTBkLOmlhAd5eeC2xx29FWoeSDtfepI+BLsKQYYww77luUTiVa9qG52/9O0K5JNg+
	 EkZAkXr2WynG0IstWZpr7Fot5l4Lzm1xiVTbj8cXYvsQGyTS07vNbh2lW5iI5NeoBLr5s
	 i2JsC4HYuRgkL1O16lnZd+Qftq0eKXfG2qZkhoBaHauHISR1z11kdGOR1xBPQ5qxa/9DL
	 //V+JGPLRU09ADpO7EXBoAcj1OvIBvfVlkEA4Zs/2axMMzfhsuzVMZ7Yfh0171NzPOg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=D7uwtBpV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C627C606A325;
	Wed, 18 Nov 2026 23:49:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=D7uwtBpV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D584D1F000C4;
	Wed, 18 Nov 2026 23:49:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045769;
	bh=8yACSL8FbHJqjpnCz6C/HqmKYIq6WFtRpo9lY1L4uf0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=D7uwtBpV9ZUP1vQkLL2k5mfqoVoASqTrhJx2h2928cHnxZlyCLVp48iaucJyJyLZR
	 5JEH5ySThhCOftZtMT4F7GaSY5Sl79pTAarA+oBMBoh78PvjQ1wlvawESUDmrDILiJ
	 65HF3uAUNLWhrg+uwqfgpMDZf6uwCY7l/k/kFYIE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hungyu Lin <dennylin0707@gmail.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1043/2857] timers/itimer: Keep a nonzero value at CPU timer expiry
Date: Wed, 18 Nov 2026 15:34:37 +0100
Message-ID: <20261118150239.149406132@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



