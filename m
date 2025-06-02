Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0715B1EA65;
	Mon,  2 Jun 2025 14:54:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748876063; cv=none; b=aRR7jNUxHjhUsUEZjCsm9JbTltL3PjkUPQOd1sFu8+qpMAsi/JjeXbqiCSIk3lW6nSb+PuMpfHFupl7DtM2a9xZsJoav1esn7EQx1DMQxubqalhum/n8k+RlLUKhgqN8aqKv4x2u6LdSblX8komsCnZOalqULb3NL1YFNg856Tg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748876063; c=relaxed/simple;
	bh=pR9Ew6B/zz80Xd5obELpj15dTVvLZaWDfgYhr72ydmk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qiSvOygzVhF5r/T1iehiER9abiQK3h2NicLXpmDWXXZAYrIJDkVwYiaLvFwwzF4CbAr4s1WqPPfb3s7e9WEbf+HoN34ANKLHq/AHkbQ1W59VMLOJr9mcdE/1N40+ldSpAMMWotcrtOxDMXfq3hZHa3MOmvgeLrCtRn0JgKKE8To=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MajpBE3N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MajpBE3N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83CEBC4CEEB;
	Mon,  2 Jun 2025 14:54:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748876062;
	bh=pR9Ew6B/zz80Xd5obELpj15dTVvLZaWDfgYhr72ydmk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MajpBE3NJor3eu8gqcF9WglhCN3mEtzwBsF6U0DebppFRwX9kSKFrAxLXfaM6V727
	 TM+H8Wikd83fN0qm4EMulId2OCjE/6TzKJcFFL7GurIVyznNVJ1ZKh//QbfR3TINLz
	 wJK72obOrCgiekqXhoiTzLuxxKWf84UicrqAQTh0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	Thomas Gleixner <tglx@linutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 052/207] timer_list: Dont use %pK through printk()
Date: Mon,  2 Jun 2025 15:47:04 +0200
Message-ID: <20250602134300.790588139@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134258.769974467@linuxfoundation.org>
References: <20250602134258.769974467@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Weißschuh <thomas.weissschuh@linutronix.de>

[ Upstream commit a52067c24ccf6ee4c85acffa0f155e9714f9adce ]

This reverts commit f590308536db ("timer debug: Hide kernel addresses via
%pK in /proc/timer_list")

The timer list helper SEQ_printf() uses either the real seq_printf() for
procfs output or vprintk() to print to the kernel log, when invoked from
SysRq-q. It uses %pK for printing pointers.

In the past %pK was prefered over %p as it would not leak raw pointer
values into the kernel log. Since commit ad67b74d2469 ("printk: hash
addresses printed with %p") the regular %p has been improved to avoid this
issue.

Furthermore, restricted pointers ("%pK") were never meant to be used
through printk(). They can still unintentionally leak raw pointers or
acquire sleeping looks in atomic contexts.

Switch to the regular pointer formatting which is safer, easier to reason
about and sufficient here.

Signed-off-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Link: https://lore.kernel.org/lkml/20250113171731-dc10e3c1-da64-4af0-b767-7c7070468023@linutronix.de/
Link: https://lore.kernel.org/all/20250311-restricted-pointers-timer-v1-1-6626b91e54ab@linutronix.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/time/timer_list.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/time/timer_list.c b/kernel/time/timer_list.c
index ed7d6ad694fba..20a5e6962b696 100644
--- a/kernel/time/timer_list.c
+++ b/kernel/time/timer_list.c
@@ -46,7 +46,7 @@ static void
 print_timer(struct seq_file *m, struct hrtimer *taddr, struct hrtimer *timer,
 	    int idx, u64 now)
 {
-	SEQ_printf(m, " #%d: <%pK>, %ps", idx, taddr, timer->function);
+	SEQ_printf(m, " #%d: <%p>, %ps", idx, taddr, timer->function);
 	SEQ_printf(m, ", S:%02x", timer->state);
 	SEQ_printf(m, "\n");
 	SEQ_printf(m, " # expires at %Lu-%Lu nsecs [in %Ld to %Ld nsecs]\n",
@@ -98,7 +98,7 @@ print_active_timers(struct seq_file *m, struct hrtimer_clock_base *base,
 static void
 print_base(struct seq_file *m, struct hrtimer_clock_base *base, u64 now)
 {
-	SEQ_printf(m, "  .base:       %pK\n", base);
+	SEQ_printf(m, "  .base:       %p\n", base);
 	SEQ_printf(m, "  .index:      %d\n", base->index);
 
 	SEQ_printf(m, "  .resolution: %u nsecs\n", hrtimer_resolution);
-- 
2.39.5



