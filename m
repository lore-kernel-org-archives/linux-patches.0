Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D063727E1CA;
	Tue, 27 May 2025 16:53:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748364801; cv=none; b=PwmQ1KoJ14chpUNsVNeXUrcvxnjPpAdRJytFLfyFhAIk/1k4vw+/UA2cbXAcqf9N4mhSsxXkryTIVokKW2hs2n96EIh3c/6PYn53xniAV2w0DpEV8QhmhDg8gimcWF4BGAZAaB3lEjmH6zvsQLE5miXaKM8Uv6bO9x+bZGiqkko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748364801; c=relaxed/simple;
	bh=SG3GK2A+Ufej3W5jB9Xs7hfpg7K8UIVT0ccwBfBFIzk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KQr/TfvcR577BF4QHzanU8+QkbpTBzKEA+JgyUtFJOqdItF05VeGDvwDCM5o3Jqi5ygERL52ZAmRngIAd41OKYrpliz8Ohphg9xZ0LuDlfv4NGupcyWiNIDy2dqekusmNWccg5BAnEotw6gLrL9nhRer8uBWHy9qlwAIumSrrG0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KkkW/2CV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KkkW/2CV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA780C4CEEB;
	Tue, 27 May 2025 16:53:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748364801;
	bh=SG3GK2A+Ufej3W5jB9Xs7hfpg7K8UIVT0ccwBfBFIzk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KkkW/2CV0+GnDYN+X8r1JNEY1As6pr2EKguxZBIV8nTev11txEkp6BYaUtpL7r2Hg
	 2ZLjobeZaZIZpRtQMPNlR6iklzIGp2I1MnjkcGcpqoBQVli+MSMhlggRMPlSj4WdMc
	 mCmwJB7punYB64WPUHlXii7/KRgaHsv6b3SvXoBw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	Thomas Gleixner <tglx@linutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 170/626] timer_list: Dont use %pK through printk()
Date: Tue, 27 May 2025 18:21:03 +0200
Message-ID: <20250527162451.928591177@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 1c311c46da507..cfbb46cc4e761 100644
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



