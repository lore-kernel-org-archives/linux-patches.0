Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 089744248DC;
	Tue, 21 Jul 2026 19:15:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784661305; cv=none; b=YDFW1nsPxSo5TfrigGzCkXKgrL1qTPh+0d+7siS8qTJkvKWFrE1UdXowyHLU1CWV8MZbw4IlkpwCHm+Fm3P35xxGYFOR7Sj7hkz2pNHSN6hX/TXFBTanbEmqaXOxNHUU/2vNaBKzkkZ1s4HC1DBv3vWp6inT/NyALs3QkAnoRBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784661305; c=relaxed/simple;
	bh=XDhxH9SxRrn4fy0k1izFSp83PQbKgSleg+finH14fMg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ulYRahqo+yh6damwXf+Yg2frxcSJsvWn66VQS8L2L5zDKfxKw3pU1JEowngeocQk6NABTc12oFrOPYuyBxhSCgiQfct1XcQd614aJpS2V8eA+zgc7ifXiSHil57fBDa9Sgl8c6fu53qrRzYjxW6MWOA6uN4LzQAythHwr+MiP58=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HrAYbjMt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HrAYbjMt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E4B81F000E9;
	Tue, 21 Jul 2026 19:15:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784661303;
	bh=ta8oNNMZzUuYZ2gietjuIkRnDWTFmALB9qz/k0xZUNQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HrAYbjMtzSVPQCD/+D7Lm7nEEhHE5rT1V49x9n1sdnu5zEzpSAoM+6D+Fa6YRmQ68
	 utZGpt9Ut2UrmOdIDgeRKSkyzlJCy2iJMvbNVytjdo5dpNIPFkIkA2vI1APsFRxklb
	 5pr2aCgRmyYMJpN0XWvguAYzVsLwN4skD2iP8WdQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Breno Leitao <leitao@debian.org>,
	Oleg Nesterov <oleg@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0017/1276] timekeeping: Register default clocksource before taking tk_core.lock
Date: Tue, 21 Jul 2026 17:07:40 +0200
Message-ID: <20260721152446.465331292@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

From: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>

[ Upstream commit 8fa30821180a9a19e78e9f4df1c0ba710252801e ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/time/timekeeping.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index e3896b2be45321..b99171e71e0ac5 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -1685,13 +1685,14 @@ void __init timekeeping_init(void)
 	 */
 	wall_to_mono = timespec64_sub(boot_offset, wall_time);
 
+	clock = clocksource_default_clock();
+	if (clock->enable)
+		clock->enable(clock);
+
 	raw_spin_lock_irqsave(&timekeeper_lock, flags);
 	write_seqcount_begin(&tk_core.seq);
 	ntp_init();
 
-	clock = clocksource_default_clock();
-	if (clock->enable)
-		clock->enable(clock);
 	tk_setup_internals(tk, clock);
 
 	tk_set_xtime(tk, &wall_time);
-- 
2.53.0



