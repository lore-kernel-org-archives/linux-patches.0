Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E28853F54B6;
	Thu, 16 Jul 2026 14:19:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784211568; cv=none; b=PV+zienDbBt29Qt8LDkRlfltW8nCY3hMGrpPMpQs9QeemFDDnnSETbhKpee1x+DGrJbE+8Dtx+K7O54WdBjptqM7KpR44Ev5XovzBww/AiNt9xQJamR5/jZ6kc/PCFdWV6tGWiDmO3aUtQWHro4+dgJucE+WGhIFkAdGqZWCpn8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784211568; c=relaxed/simple;
	bh=gOC9SK9MQE+77yrRN9O5MCHtp0YkcsEUL/KnQXoKEqY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QkckjynuSihT+lVp7MOnCTQ+0llUr6DliB2KOFmNkiuz5/gwpW9FtLgt722jDI2qyhP6rr4aLfyOvJm5MrjlkPxQACiCzi7pqZA4q0jNWRo4nDAcgNdM+9JSr0hvprRESRHOgO3Tv6cCtg4xIKbP2m6yrOXqrIak2RlkEmeYk4c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KWK7Xooo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KWK7Xooo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 548151F000E9;
	Thu, 16 Jul 2026 14:19:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784211566;
	bh=LymJ1bWyJOPGcYcIIvju35ILeSjBVi/6Yb41mQqNYvw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KWK7Xoook4rxbuU8z0N1YuxTnbQ81wQNUlvSMVh0dAgULky8f6AXklUKgtlD7tXad
	 y+nQ60M6ch/5m0e6lFOrtjH5sd7QCtyCMT1vX8ychz3PBm2dhDLf5fX/WZj2d6yZrv
	 W/ioQgz3D7nUdHRsO1pneSTRWCIb/VQnsoHeRZ0A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Breno Leitao <leitao@debian.org>,
	Oleg Nesterov <oleg@redhat.com>
Subject: [PATCH 6.18 478/480] timekeeping: Register default clocksource before taking tk_core.lock
Date: Thu, 16 Jul 2026 15:33:45 +0200
Message-ID: <20260716133055.165089944@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133044.672218725@linuxfoundation.org>
References: <20260716133044.672218725@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>

commit 8fa30821180a9a19e78e9f4df1c0ba710252801e upstream.

Commit f24df84cbe05 ("time/jiffies: Register jiffies clocksource before
usage") moved the jiffies clocksource registration into
clocksource_default_clock(), so that it is registered lazily on the first
call. __clocksource_register() acquires clocksource_mutex, but the first
caller is timekeeping_init(), which invokes clocksource_default_clock()
while holding tk_core.lock, a raw spinlock.

Acquiring a sleeping mutex while holding a raw spinlock is invalid.

The default clocksource only has to be registered before
tk_setup_internals() consumes its mult/shift/maxadj. Neither
clocksource_default_clock(), the ->enable() callback, nor the registration
itself need tk_core.lock, so fetch and enable the clock before acquiring
the lock. This preserves the "register before usage" ordering while
keeping clocksource_mutex out of the raw spinlock section.

clocksource_default_clock() has a second caller,
clocksource_done_booting(), which invokes it with clocksource_mutex already
held. That path avoids a recursive lock because timekeeping_init() has
already run and set cs_jiffies_registered, so the registration is skipped
there. This change does not alter that; it only fixes the invalid wait
context in timekeeping_init().

Fixes: f24df84cbe05 ("time/jiffies: Register jiffies clocksource before usage")
Signed-off-by: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Reported-by: Breno Leitao <leitao@debian.org>
Reported-by: Oleg Nesterov <oleg@redhat.com>
Reviewed-by: Breno Leitao <leitao@debian.org>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260616070914.65818-1-mikhail.v.gavrilov@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/time/timekeeping.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -1825,13 +1825,14 @@ void __init timekeeping_init(void)
 	 */
 	wall_to_mono = timespec64_sub(boot_offset, wall_time);
 
+	clock = clocksource_default_clock();
+	if (clock->enable)
+		clock->enable(clock);
+
 	guard(raw_spinlock_irqsave)(&tk_core.lock);
 
 	ntp_init();
 
-	clock = clocksource_default_clock();
-	if (clock->enable)
-		clock->enable(clock);
 	tk_setup_internals(tks, clock);
 
 	tk_set_xtime(tks, &wall_time);


