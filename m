Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E67E309F08;
	Sat, 12 Sep 2026 15:23:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789226610; cv=none; b=NUOO5VO6d3TLAN1s9bL6TFUMCvPG2lH8Tetpg9tO23EzjKyyruzvxx0LPAd//HWQdGO+dHRpQp1ndUo8OAXEiEP5mhuDka9DaBgOuw2xlMMEcQ4201oc5nMQEWowStNZqVRlaVdYo6GfZ4USg5l8A7DPVOzc56h8oYQch2h/GtA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789226610; c=relaxed/simple;
	bh=o7/oFCdRJrZyri1E8nTLeIpLrA39Nbf/ec/+kzq2DMU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EfS/ZZDRb7Tx2T6XJqBBlvPgkxlQfoEsntjEn6Gq9JZGm45hNnRlE53dJkkvqy6UIykBeKzyarjPSRNjzWwrsd0ZCXSrF50hctVhQjSGGa7r8+60w+HyXt/9tMGAxcQL2A349SIoSUN/kXEzutqAQspIZsjWDtaRn4qG9bKcCIo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dNqBHf9I; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dNqBHf9I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 743621F00899;
	Sat, 12 Sep 2026 15:23:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789226609;
	bh=l6v17L6Pv7mnJldgHsI8TpblHCdKKEK9nscbGl1AKAw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dNqBHf9IT2c9H2u7txgIeqPL5C+MbNs4w6xuh2eZJJE9w31iMKg7iCDVklGwyCE1+
	 k0Tta4+kidI2Nf1LKu8wkwFavV66MOTnIlV0q7aDgfCKCmGZc43jsJpDjqGlAncfFb
	 nTbgWNzVHkU09jG9ZmgS3pC7jF0z0EoHMXVRXhmI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Indrek Kruusa <indrek.kruusa@gmail.com>,
	Felix Yan <felixonmars@archlinux.org>,
	Daniel Lezcano <daniel.lezcano@kernel.org>,
	Jernej Skrabec <jernej.skrabec@gmail.com>
Subject: [PATCH 6.1 0005/1191] clocksource/drivers/timer-sun4i: Advertise a real minimum delta
Date: Sat, 12 Sep 2026 08:45:33 +0200
Message-ID: <20260912065548.222177916@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Yan <felixonmars@archlinux.org>

commit d21808328225ab8cee46885bf9a0dffcefbe630e upstream.

sun4i_clkevt_next_event() compensates for the timer stop/start
synchronization delay by programming evt - TIMER_SYNC_TICKS into the
hardware interval register. The clockevent device currently advertises
TIMER_SYNC_TICKS as min_delta_ticks, so the clockevents core is allowed
to call set_next_event() with evt == TIMER_SYNC_TICKS.

That programs a zero-tick interval. With oneshot/highres/nohz timer
operation this can leave the next event stuck, which was observed as a
boot hang on Allwinner D1 after the clockevents core started reusing
forced minimum-delta events.

Advertise one extra tick instead, so the smallest event accepted by the
core still programs at least one hardware tick after the synchronization
compensation.

Fixes: 12e1480bcb49 ("clocksource: sun4i: Report the minimum tick that we can program")
Reported-by: Indrek Kruusa <indrek.kruusa@gmail.com>
Closes: https://lore.kernel.org/linux-riscv/CA+fTLhgLmTY+exGujKf8OYYQvcEW5X5NJ_5sLq2AYL6zER2c0A@mail.gmail.com/
Assisted-by: Codex:gpt-5.5
Signed-off-by: Felix Yan <felixonmars@archlinux.org>
Signed-off-by: Daniel Lezcano <daniel.lezcano@kernel.org>
Tested-by: Indrek Kruusa <indrek.kruusa@gmail.com>
Acked-by: Jernej Skrabec <jernej.skrabec@gmail.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/linux-riscv/CA+fTLhgLmTY+exGujKf8OYYQvcEW5X5NJ_5sLq2AYL6zER2c0A@mail.gmail.com/
Link: https://patch.msgid.link/20260624220434.4183732-1-felixonmars@archlinux.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/clocksource/timer-sun4i.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/clocksource/timer-sun4i.c
+++ b/drivers/clocksource/timer-sun4i.c
@@ -207,7 +207,7 @@ static int __init sun4i_timer_init(struc
 	sun4i_timer_clear_interrupt(timer_of_base(&to));
 
 	clockevents_config_and_register(&to.clkevt, timer_of_rate(&to),
-					TIMER_SYNC_TICKS, 0xffffffff);
+					TIMER_SYNC_TICKS + 1, 0xffffffff);
 
 	/* Enable timer0 interrupt */
 	val = readl(timer_of_base(&to) + TIMER_IRQ_EN_REG);


