Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 836D237EFE2;
	Sat, 12 Sep 2026 19:20:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789240823; cv=none; b=WLTUs/pDGS/Euv4WVfRhq75fzHn70XQmdbNVNPRqjVSFBRuwnpXTTzqQysp/MkeEmhY9KVjqHgHfRA5upL6skY52RDUJ9NU3zzPifTfd8kVVe6pBy7gwq2DcqMlbI7/YTfl6VLz1aoor56wVYpWKqcWSoo7+430Wicq3NqQnDUA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789240823; c=relaxed/simple;
	bh=YXDuAKIPw39rxwnk+KLwyfwswt7zMPLUtQzCKV8EQ58=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bwlqz5T3K4eG+mAyVs3J2l0UcZ1ppsvjBuSZD8uMvpu7rDkxeCJfZi/n8Ly419Sd3CS0zI0cjfXR7PburinY7dk9hWeMRvSf4nCmheLeZUb1CrgohcYKDZl7P60BMEGH3d3SdN0vtYEnbm97zKJj4BBDIJNo8mBEbnGziDtimac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pZ1TlJlP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pZ1TlJlP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7ED4B1F000FF;
	Sat, 12 Sep 2026 19:20:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789240820;
	bh=Y+1n70C0KcXgcR7vekqR04hvYmn9HdGFJPMmY7Cco64=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pZ1TlJlP2pSSrDUa2S+V/VH+PpY89E9QtI8VoWK4FZg6M957CWDYzcZfcxtj0CYLL
	 +i4ZxxyhkeuoI45yKXmwnA6zGsuOKsM+CAcKAtUKbBXheEDqTvuOk7wxdJeSy1hHcx
	 rqs+f7412TRdOjaeYb86Cfw7COHZ0lkwurLECz9o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Indrek Kruusa <indrek.kruusa@gmail.com>,
	Felix Yan <felixonmars@archlinux.org>,
	Daniel Lezcano <daniel.lezcano@kernel.org>,
	Jernej Skrabec <jernej.skrabec@gmail.com>
Subject: [PATCH 5.10 003/798] clocksource/drivers/timer-sun4i: Advertise a real minimum delta
Date: Sat, 12 Sep 2026 08:53:51 +0200
Message-ID: <20260912065517.035792242@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -209,7 +209,7 @@ static int __init sun4i_timer_init(struc
 	sun4i_timer_clear_interrupt(timer_of_base(&to));
 
 	clockevents_config_and_register(&to.clkevt, timer_of_rate(&to),
-					TIMER_SYNC_TICKS, 0xffffffff);
+					TIMER_SYNC_TICKS + 1, 0xffffffff);
 
 	/* Enable timer0 interrupt */
 	val = readl(timer_of_base(&to) + TIMER_IRQ_EN_REG);


