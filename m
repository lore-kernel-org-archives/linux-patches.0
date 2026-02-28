Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B13E936C9E5
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:12:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302321; cv=none; b=NG2zHno+qLFLuUmAZ7K1mx9U2zrcgLNiMOefb9ept4mKrWdy0mIsfM3MbfHQRKTMVniZe/DBzXg4fDi8zM5kc6MzApcbflGPv5ZAxu8GvLqSkKfcK833iZiZ8JE2iNm3O77HSpBtn4ZIw/SFcx7YsYPhusqYheRaopYqBoYMcno=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302321; c=relaxed/simple;
	bh=j+dfmpyXr3PflnG+fxb2wrNo8Fgmxwro1qvPHdL4Gv8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GV+/vNB7XS8ge7A2Kv1oYVT6vSfPJS5YFDdRoTtonMPkz1beiDVUnOVjnDmTDgwr3dulFzhRmJOW7zuZ2plZQmztKgm0ne4QtdhzI0OWCZGgp0d5xSe0VtXUUFVVE+raVaEc15MCVAS+Te8MNvwDAU6LQ75OOltj8AMZxCC1+Ic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=R3VfJcRY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="R3VfJcRY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14CFBC19423;
	Sat, 28 Feb 2026 18:12:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302321;
	bh=j+dfmpyXr3PflnG+fxb2wrNo8Fgmxwro1qvPHdL4Gv8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R3VfJcRYHbZ8mDTLjxDVlba/SG3yTxnBqfF1ckh0p17yB0IpiRoarqk8cAU0jx05G
	 969fQeOKeS/dcSwan+M05dNoNCNaditROvJjhiWCLWwAwdASzouLjol4V1tvXlLd4h
	 8Mr2ch9Xd2SfjFi1OqjpYYI06R506r7HyKaGM+D2M/e0bV46NmrVl2uB3kcKNTtfN4
	 5+2LoL3ti1XL2feqoatHA+DGqnt9QCt1H7j59yj7i3a6KKDeAhsA+84QrXNFfpmRpt
	 3VDgWJQskIFfeCdi/4nSnt0Iq1NMjI7775hx30+3LliGvHs3+6C202noda6azS8pV/
	 gfHQLTO7JirVw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Thomas Gleixner <tglx@linutronix.de>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 040/232] hrtimer: Fix trace oddity
Date: Sat, 28 Feb 2026 13:08:13 -0500
Message-ID: <20260228181127.1592657-40-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181127.1592657-1-sashal@kernel.org>
References: <20260228181127.1592657-1-sashal@kernel.org>
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
index 049dd5b37274b..002b29e566cb3 100644
--- a/kernel/time/hrtimer.c
+++ b/kernel/time/hrtimer.c
@@ -1712,7 +1712,7 @@ static void __run_hrtimer(struct hrtimer_cpu_base *cpu_base,
 
 	lockdep_assert_held(&cpu_base->lock);
 
-	debug_deactivate(timer);
+	debug_hrtimer_deactivate(timer);
 	base->running = timer;
 
 	/*
-- 
2.51.0

