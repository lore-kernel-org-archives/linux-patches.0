Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADDED3ECBDA;
	Fri,  4 Sep 2026 06:04:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788501878; cv=none; b=BgnNm95ycK8T63NVLAQfgnDNGBqlKcCE5UkHvOqufiEz7euVPKdCGiUEmjbwfY9O21KZCEI0qt5krdtX7kcUIPxPzF82R0FmC9GDMhzJve7QHMUiZUkLl6WsKPYw1Vip3yDTnw32+ZZq75ZX3xlBW/Es4supHinVY5u8rSP1jio=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788501878; c=relaxed/simple;
	bh=G4VAdgTj+f+2apfGI2xjIX+w3GjqiC4FP3cOYvm6pl4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dzHP+9USqYiWqETDVPQ1MCeR9wtwLlsH2Al/fL6g663KOttlUrz6fw3MNEAzZxIGmGaoyttAwt8flZws/S3UpKbWrL6e+OXf3Snp84ZFP/Ez+vUE1PyGFbDAPK2eD1ctZIomeWNwm3DqcvP7/W5U3dz++EiC8vxPTlUGrCcsEfc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cGwq6D7q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cGwq6D7q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12EB21F00A3D;
	Fri,  4 Sep 2026 06:04:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788501877;
	bh=SL7sQw2XA1TQj34D8OdNEZqEOavaJEoUymsiW3/up4c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cGwq6D7qPMgb0BqRB5XrFBRgNBUTAkRWVBBXjMDLez6X2mBiQxL/TWvqoz1cVQkku
	 54VbFnudtMhruIQCMzwyTQ0SQ2kiwBT1L/Im8upFj03zXaj4XUmPU+3j+mlh1pU81+
	 3HWcMVKpRPNwa/1RGGYLxpemv3FV77iIuYAk2tLE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Indrek Kruusa <indrek.kruusa@gmail.com>,
	Felix Yan <felixonmars@archlinux.org>,
	Daniel Lezcano <daniel.lezcano@kernel.org>,
	Jernej Skrabec <jernej.skrabec@gmail.com>
Subject: [PATCH 6.12 012/403] clocksource/drivers/timer-sun4i: Advertise a real minimum delta
Date: Fri,  4 Sep 2026 06:56:55 +0200
Message-ID: <20260904045735.090870322@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045734.806166532@linuxfoundation.org>
References: <20260904045734.806166532@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -208,7 +208,7 @@ static int __init sun4i_timer_init(struc
 	sun4i_timer_clear_interrupt(timer_of_base(&to));
 
 	clockevents_config_and_register(&to.clkevt, timer_of_rate(&to),
-					TIMER_SYNC_TICKS, 0xffffffff);
+					TIMER_SYNC_TICKS + 1, 0xffffffff);
 
 	/* Enable timer0 interrupt */
 	val = readl(timer_of_base(&to) + TIMER_IRQ_EN_REG);


