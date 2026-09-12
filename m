Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C9EA47ACF6;
	Sat, 12 Sep 2026 16:07:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789229257; cv=none; b=E1Th4SnlTEtTfZPX/HXpxNxHhDtMRseCfGpxmZYaEK02YmEZMEwRAgPOyGfgBAJO3aknt5alitwqPHxJSNm0TxQaE8liMUyxucnFR/7/rC7uL3+fkjOE+3Gx9Hc2OWUit87ru9r38iEJyA2q/bej7tmtfsCaBKvHfgEqTBiXmIg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789229257; c=relaxed/simple;
	bh=RcN/Z9ui+srkJVMWPTjnUv0HKjq53lmRMHWamRrdJ9Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CuixKvuKnKhTLrlQwoyV1g7NrKVsqIXuYM0VIPpMqCZcUHq1m1CFQh3TTvU6z6K7OiQeCX5ibqn9a0yM+qOn2BVDo3pK5UZE50E/rmTwKF2D1u2krr3rJJuSAYpT9XKaZO5UyRZASWKew8HUu9E0mjlhTVN8McZV5uMp8aMxGHA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kY/QhsR9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kY/QhsR9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 161461F000FF;
	Sat, 12 Sep 2026 16:07:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789229255;
	bh=sRv5mY982h+WlinN4A1RJU1YB8+qxv2qMAWMRqKPA7Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kY/QhsR951BRqkxo04sp/nAqGyRySMpaQM9+9Qs3bDT0EZfJ++4kIQL6Xzn1hkVgi
	 ygMFdX9fqm583dUeYTB1auJdJGy3DVp2oWrpSQC8At8jjyGz8OX9bcxF3A5MpDR9OI
	 rDP6oA2eFcohyzr5YROF3IiOq/RiCM1j+EqT0ot8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Woodhouse <dwmw@amazon.co.uk>,
	Thomas Gleixner <tglx@kernel.org>,
	John Stultz <jstultz@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0551/1191] timekeeping: Account for monotonicity adjustment in ntp_error
Date: Sat, 12 Sep 2026 08:54:39 +0200
Message-ID: <20260912065600.620780126@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Woodhouse <dwmw@amazon.co.uk>

[ Upstream commit b7befd6d91207cf3f4cecd68fea0c212093906cf ]

timekeeping_apply_adjustment() modifies xtime_nsec to ensure monotonicity
when mult changes:

    xtime_nsec -= offset

This ensures that the time reported to userspace does not jump when the
multiplier is adjusted from one tick to the next. However, the ntp_error
accumulator which tracks the difference between intended and actual
clock position was not being updated to reflect this additional
discrepancy.

An earlier attempt at this compensation existed as:

    ntp_error -= (interval - offset) << ntp_error_shift

but was removed in commit c2cda2a5bda9 ("timekeeping/ntp: Don't align
NTP frequency adjustments to ticks") because it was a major source of
NTP error. That's because (interval - offset) was wrong: the subtraction
of "interval" prematurely accounted for the changed xtime_interval of
the next tick, which would be correctly accounted in the next
accumulation anyway — a double subtraction.

What is actually needed is just the "offset" part: ntp_error must be
told that xtime_nsec moved by "offset" without a corresponding change
in the intended position. For the normal ±1 mult dithering this is
negligible (the adjustments cancel over time), but for larger mult
changes — such as when an external reference clock sets a new
frequency — the one-time uncompensated offset is significant.

Fix by adjusting ntp_error by the correct amount:

    ntp_error += offset << ntp_error_shift

This keeps ntp_error consistent with the actual xtime_nsec position
after the adjustment, and ensures the discrepancy is correctly smoothed
away over time and the clock returns to where it should have been.

Fixes: c2cda2a5bda9 ("timekeeping/ntp: Don't align NTP frequency adjustments to ticks")
Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Assisted-by: Kiro:claude-opus-4.6-1m
Acked-by: John Stultz <jstultz@google.com>
Link: https://patch.msgid.link/20260621220051.1030462-3-dwmw2@infradead.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/time/timekeeping.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index dd294e96193be..135c8727bb851 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -1983,6 +1983,11 @@ static __always_inline void timekeeping_apply_adjustment(struct timekeeper *tk,
 	 *	xtime_nsec_2 = xtime_nsec_1 - offset
 	 * Which simplifies to:
 	 *	xtime_nsec -= offset
+	 *
+	 * When subtracting offset from xtime_nsec, the same amount
+	 * (in appropriate units) has to be added to ntp_error, in
+	 * order to correctly track the delta between the time
+	 * reported in xtime_nsec, and the intended time.
 	 */
 	if ((mult_adj > 0) && (tk->tkr_mono.mult + mult_adj < mult_adj)) {
 		/* NTP adjustment caused clocksource mult overflow */
@@ -1993,6 +1998,7 @@ static __always_inline void timekeeping_apply_adjustment(struct timekeeper *tk,
 	tk->tkr_mono.mult += mult_adj;
 	tk->xtime_interval += interval;
 	tk->tkr_mono.xtime_nsec -= offset;
+	tk->ntp_error += offset << tk->ntp_error_shift;
 }
 
 /*
-- 
2.53.0



