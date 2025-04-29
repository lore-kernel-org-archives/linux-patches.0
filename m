Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62E7240C03;
	Tue, 29 Apr 2025 18:07:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745950059; cv=none; b=XXD12HwzU4aXxN7k9kEW8Y5sRrb1eO1M5ESDsQD1zEjknp8lMUnn0LyxxXtfin/owqdvzJ6NimU0h2juNshCUIotYBDRYOQxMpXDg3q+3QJtXQ7xdCFEGplQQcuXQM2YzmsDMUiPzIUoqKQ170jw0OcClhmU3iVEcUASGYW7fVw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745950059; c=relaxed/simple;
	bh=uqL/IiH/DkNsc6K9l+FrTCHpjtvKO28Znwv54PdSKGc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TvYSvZaeIajPiGOasslWvuCRQeMTnU/mKNVjgDKZLEQQDvIIWEPkWbCB90fIKUNlYlbT6jH1o8qez2SRoJCFr7nuAp+Zu8W8bnckjwvGcFJLaLrIGlVbXPl8M97okRXYSmWM1WvxXbEU7xn7mpqxGVV1savbsaoy0Xp6LfGvrZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BDLhrIs4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BDLhrIs4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6EC5C4CEE3;
	Tue, 29 Apr 2025 18:07:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745950059;
	bh=uqL/IiH/DkNsc6K9l+FrTCHpjtvKO28Znwv54PdSKGc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BDLhrIs4lMy0fKW2mFjvJSlHnmSARYiLwV5DaMwv/XrokJcr2nWygsp7epiEVek24
	 QXio/qHFrsneHKI+DiRm2WaoO0Xfm8HVPgkV2BPUtkDCkf69DUOMgwpfbFB3+C3z9p
	 6scFljIGKI32T4c5aw0QCczY9FFbVVgAzQPWysc8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Gleixner <tglx@linutronix.de>,
	Fernando Fernandez Mancera <ffmancera@riseup.net>,
	Ingo Molnar <mingo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 143/167] x86/i8253: Call clockevent_i8253_disable() with interrupts disabled
Date: Tue, 29 Apr 2025 18:44:11 +0200
Message-ID: <20250429161057.514338370@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161051.743239894@linuxfoundation.org>
References: <20250429161051.743239894@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Fernando Fernandez Mancera <ffmancera@riseup.net>

[ Upstream commit 3940f5349b476197fb079c5aa19c9a988de64efb ]

There's a lockdep false positive warning related to i8253_lock:

  WARNING: HARDIRQ-safe -> HARDIRQ-unsafe lock order detected
  ...
  systemd-sleep/3324 [HC0[0]:SC0[0]:HE0:SE1] is trying to acquire:
  ffffffffb2c23398 (i8253_lock){+.+.}-{2:2}, at: pcspkr_event+0x3f/0xe0 [pcspkr]

  ...
  ... which became HARDIRQ-irq-unsafe at:
  ...
    lock_acquire+0xd0/0x2f0
    _raw_spin_lock+0x30/0x40
    clockevent_i8253_disable+0x1c/0x60
    pit_timer_init+0x25/0x50
    hpet_time_init+0x46/0x50
    x86_late_time_init+0x1b/0x40
    start_kernel+0x962/0xa00
    x86_64_start_reservations+0x24/0x30
    x86_64_start_kernel+0xed/0xf0
    common_startup_64+0x13e/0x141
  ...

Lockdep complains due pit_timer_init() using the lock in an IRQ-unsafe
fashion, but it's a false positive, because there is no deadlock
possible at that point due to init ordering: at the point where
pit_timer_init() is called there is no other possible usage of
i8253_lock because the system is still in the very early boot stage
with no interrupts.

But in any case, pit_timer_init() should disable interrupts before
calling clockevent_i8253_disable() out of general principle, and to
keep lockdep working even in this scenario.

Use scoped_guard() for that, as suggested by Thomas Gleixner.

[ mingo: Cleaned up the changelog. ]

Suggested-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Fernando Fernandez Mancera <ffmancera@riseup.net>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
Link: https://lore.kernel.org/r/Z-uwd4Bnn7FcCShX@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/i8253.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/i8253.c b/arch/x86/kernel/i8253.c
index 80e262bb627fe..cb9852ad60989 100644
--- a/arch/x86/kernel/i8253.c
+++ b/arch/x86/kernel/i8253.c
@@ -46,7 +46,8 @@ bool __init pit_timer_init(void)
 		 * VMMs otherwise steal CPU time just to pointlessly waggle
 		 * the (masked) IRQ.
 		 */
-		clockevent_i8253_disable();
+		scoped_guard(irq)
+			clockevent_i8253_disable();
 		return false;
 	}
 	clockevent_i8253_init(true);
-- 
2.39.5



