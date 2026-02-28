Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12923375AC8
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:01:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301661; cv=none; b=LOSPNyn7yN/n9hSbdKvaKvtib0Wv+xT1H/m3oddg+mm4vOJsAG0H1KH7tlnqRaOoqjXMKrMLv9pZa8d0em8fl1S0JFp0dYLKCcwDuLGVpKq4eduRInkUsVciP27uUK56uVndvM1WplrlDyNgA9safiybf4FfE0nPm3Te8nt7Cy8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301661; c=relaxed/simple;
	bh=dBVI438N2MfctTF8hJulZxtSXRYiqYpzX1jLlInQzKQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eoaLE1JKxHOkZsg1YofPk9MLhnF81++LhhmGhbJJ77Lxjp4fNRpOeij6xFFDlU6quGljZ1L9HFnwdkw+jMVkWwphCZiyXAym2ANQID+uJWpu9VwNinWLXIPe6fJC6oLbPTQf4F0lHmD7bSIH+LVZzQouGwf5SNLBRfjDxDO8Sy4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=p54mMjfc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="p54mMjfc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73D87C19423;
	Sat, 28 Feb 2026 18:01:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301661;
	bh=dBVI438N2MfctTF8hJulZxtSXRYiqYpzX1jLlInQzKQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p54mMjfcnPQ49eN5zavPW3+OuVTKvy78mzsUrlSpcZhQnNgrI60AMfFqLz+uf7jSc
	 Af8vFMwIR7IhAjwaeYouLSCNv8jwd2/J4hjRzGYFo7Z32nQn8ezaV971k+z7LOqD2O
	 vXR6SyiiMljL0WImKZR7XnjkYy3Aso/xWbHfcnW0UhOJXkb1nNvnwdLHRXsPW8Qm0h
	 rz6XUFwAuTRkeISSYcsMNArl225CCVp3Ef/JNnnCwtUvYtPdGwZR5oLuPwVssXG8Yw
	 c4EBUKtuki7itJWZlIwoUP6eFPKo7ZXmX2nNrxKJYJM/Io5PxDiLy7Hk8Q1nbjEgLy
	 7yUCE03zw82uQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Thomas Gleixner <tglx@linutronix.de>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 059/385] hrtimer: Fix trace oddity
Date: Sat, 28 Feb 2026 12:54:41 -0500
Message-ID: <20260228180011.1568201-59-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Thomas Gleixner <tglx@linutronix.de>

[ Upstream commit 5d6446f409da00e5a389125ddb5ce09f5bc404c9 ]

It turns out that __run_hrtimer() will trace like:

          <idle>-0     [032] d.h2. 20705.474563: hrtimer_cancel:       hrtimer=0xff2db8f77f8226e8
          <idle>-0     [032] d.h1. 20705.474563: hrtimer_expire_entry: hrtimer=0xff2db8f77f8226e8 now=20699452001850 function=tick_nohz_handler/0x0

Which is a bit nonsensical, the timer doesn't get canceled on
expiration. The cause is the use of the incorrect debug helper.

Fixes: c6a2a1770245 ("hrtimer: Add tracepoint for hrtimers")
Reported-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://patch.msgid.link/20260121143208.219595606@infradead.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/time/hrtimer.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/time/hrtimer.c b/kernel/time/hrtimer.c
index 184d5c3d89bac..640d2ea4bd1fa 100644
--- a/kernel/time/hrtimer.c
+++ b/kernel/time/hrtimer.c
@@ -1714,7 +1714,7 @@ static void __run_hrtimer(struct hrtimer_cpu_base *cpu_base,
 
 	lockdep_assert_held(&cpu_base->lock);
 
-	debug_deactivate(timer);
+	debug_hrtimer_deactivate(timer);
 	base->running = timer;
 
 	/*
-- 
2.51.0

