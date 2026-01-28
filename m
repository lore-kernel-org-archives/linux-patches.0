Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8C8636E47C;
	Wed, 28 Jan 2026 15:46:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769615167; cv=none; b=sQV1W4Qn056O3z7gAYIHZV5+kZj90exlxJlfaldW1SsqHmK6Ka8t1j60QeWu3p+5FHI0i3J3R3UzHVIXi/Gj9lVsYh5H2wNBLF3jueDNdF2bCDzaOaFOq5CoZ/0veChI+zxw6v0oJwVJw1L4DS0w9lf/jK+uF13mnRg1+Wjq0IU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769615167; c=relaxed/simple;
	bh=gh2YZswktUbR45h+IcFsren2jDznuo6P9flR7jEnW+I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zowd+neF3jii0dq8zAitlx3adlWECO+aYEJemUEXZpLvw83mpuHlzvJayVGc+N2h3tLmOLHcD+0/1NZ58DyPnXgkyYvdHWb3Yr97Qv1dl0kirIswbsIav+lCiu9KTfUnAS9SFFsCvLVwcXXaLFXq/ijboLlfB/8ay50aisZma9A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LUT/oCST; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LUT/oCST"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D0FEC4CEF1;
	Wed, 28 Jan 2026 15:46:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769615166;
	bh=gh2YZswktUbR45h+IcFsren2jDznuo6P9flR7jEnW+I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LUT/oCSTiGzKzUf6ubEccxwrg25BhUrsGOb8j3/VtctwhJWvMbREQnul4Is8z8t/i
	 rV74QiRAw1umlGYHFQQzHrr6yURG0lBC6QFsj0RynxSUhMljoaIEIvwAdHukslQH1B
	 PI1d6Hk528ytse246e7JvH7nqxjPdulPc3LI7tJg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel J Blueman <daniel@quora.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 081/169] clocksource: Reduce watchdog readout delay limit to prevent false positives
Date: Wed, 28 Jan 2026 16:22:44 +0100
Message-ID: <20260128145336.921068633@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145334.006287341@linuxfoundation.org>
References: <20260128145334.006287341@linuxfoundation.org>
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

From: Thomas Gleixner <tglx@linutronix.de>

[ Upstream commit c06343be0b4e03fe319910dd7a5d5b9929e1c0cb ]

The "valid" readout delay between the two reads of the watchdog is larger
than the valid delta between the resulting watchdog and clocksource
intervals, which results in false positive watchdog results.

Assume TSC is the clocksource and HPET is the watchdog and both have a
uncertainty margin of 250us (default). The watchdog readout does:

  1) wdnow = read(HPET);
  2) csnow = read(TSC);
  3) wdend = read(HPET);

The valid window for the delta between #1 and #3 is calculated by the
uncertainty margins of the watchdog and the clocksource:

   m = 2 * watchdog.uncertainty_margin + cs.uncertainty margin;

which results in 750us for the TSC/HPET case.

The actual interval comparison uses a smaller margin:

   m = watchdog.uncertainty_margin + cs.uncertainty margin;

which results in 500us for the TSC/HPET case.

That means the following scenario will trigger the watchdog:

 Watchdog cycle N:

 1)       wdnow[N] = read(HPET);
 2)       csnow[N] = read(TSC);
 3)       wdend[N] = read(HPET);

Assume the delay between #1 and #2 is 100us and the delay between #1 and

 Watchdog cycle N + 1:

 4)       wdnow[N + 1] = read(HPET);
 5)       csnow[N + 1] = read(TSC);
 6)       wdend[N + 1] = read(HPET);

If the delay between #4 and #6 is within the 750us margin then any delay
between #4 and #5 which is larger than 600us will fail the interval check
and mark the TSC unstable because the intervals are calculated against the
previous value:

    wd_int = wdnow[N + 1] - wdnow[N];
    cs_int = csnow[N + 1] - csnow[N];

Putting the above delays in place this results in:

    cs_int = (wdnow[N + 1] + 610us) - (wdnow[N] + 100us);
 -> cs_int = wd_int + 510us;

which is obviously larger than the allowed 500us margin and results in
marking TSC unstable.

Fix this by using the same margin as the interval comparison. If the delay
between two watchdog reads is larger than that, then the readout was either
disturbed by interconnect congestion, NMIs or SMIs.

Fixes: 4ac1dd3245b9 ("clocksource: Set cs_watchdog_read() checks based on .uncertainty_margin")
Reported-by: Daniel J Blueman <daniel@quora.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Paul E. McKenney <paulmck@kernel.org>
Tested-by: Paul E. McKenney <paulmck@kernel.org>
Link: https://lore.kernel.org/lkml/20250602223251.496591-1-daniel@quora.org/
Link: https://patch.msgid.link/87bjjxc9dq.ffs@tglx
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/time/clocksource.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/time/clocksource.c b/kernel/time/clocksource.c
index ae862ad9642cb..df386912f9613 100644
--- a/kernel/time/clocksource.c
+++ b/kernel/time/clocksource.c
@@ -244,7 +244,7 @@ enum wd_read_status {
 
 static enum wd_read_status cs_watchdog_read(struct clocksource *cs, u64 *csnow, u64 *wdnow)
 {
-	int64_t md = 2 * watchdog->uncertainty_margin;
+	int64_t md = watchdog->uncertainty_margin;
 	unsigned int nretries, max_retries;
 	int64_t wd_delay, wd_seq_delay;
 	u64 wd_end, wd_end2;
-- 
2.51.0



