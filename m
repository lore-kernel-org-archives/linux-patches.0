Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B7A830C63E;
	Sat, 25 Oct 2025 16:29:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761409776; cv=none; b=EOigXHQP90fJdXZ9T8RN4Oya7N9bi+BP+6i8UkjZ7zbVCxUihVbQ87YuAt8oA9gUy5vGmV0DDI3hULJPO3JZ1w4zzWYHFBWRwnwg+ZZ7AUCUmUYt2dpKvvU+ZIwve9PXfQ/7UI8rA0lcf7bSvyd5e5mLG+esH2hLsYAiQiRcVzU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761409776; c=relaxed/simple;
	bh=9VEmU0KcJcDGOmMaXLKVl/CnUXnEcBiyGx39tor1Sog=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rd2a/wBqs8uWdeYhplXn7f9UVoVHlD5Y5nKs9nOx1kS0pJitlwSJ8WWKi/XAQlXorebZjOqj0cfdQ0D2feJ4bRy+1iv2lvZ+BW91Ia4dWTkibQMOAZEdF6qzxynAhI3qGqHdMa/n8ID3pcoLEZPTP16KgttZjzJeHiwAlzwtNIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mjupDYe0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mjupDYe0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 510D2C4CEF5;
	Sat, 25 Oct 2025 16:29:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761409775;
	bh=9VEmU0KcJcDGOmMaXLKVl/CnUXnEcBiyGx39tor1Sog=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mjupDYe0+bT0tKbooLpRtXfPCSQLZ6M5BvkD3CUlCivDVxP38mJ349z3x5Xn2sx5f
	 OT62ISK2c54h5tkq6/BleIBpFWrKJdwBb3IQgm6shAf4J5eeIq7YcZEEo4hbWKW4jk
	 klPgRLrYRWvU749h9tE3zcDhTj7RfV+2hDj6QLzYUoWCMAUCpDiQGd/vJz6D4l0tTw
	 zdRRBGfFR2LRVg9Q8P/sY6VbgKXM/Kz1GqsoAA2kDyF69dtfLH81UYI/j0W4IAG92O
	 E2C1lphBO2FttiJeogrzbn5e4jYNhpMFibrCprd3Epiidb8imj/kn8dVpkmjTyUdJx
	 N7PVzWc3SPNiQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Miroslav Lichvar <mlichvar@redhat.com>,
	Richard Cochran <richardcochran@gmail.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	John Stultz <jstultz@google.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Vadim Fedorenko <vadim.fedorenko@linux.dev>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	andrew+netdev@lunn.ch,
	davem@davemloft.net,
	edumazet@google.com,
	pabeni@redhat.com,
	netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 6.17-5.15] ptp: Limit time setting of PTP clocks
Date: Sat, 25 Oct 2025 12:01:32 -0400
Message-ID: <20251025160905.3857885-461-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251025160905.3857885-1-sashal@kernel.org>
References: <20251025160905.3857885-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Miroslav Lichvar <mlichvar@redhat.com>

[ Upstream commit 5a8c02a6bf52b1cf9cfb7868a8330f7c3c6aebe9 ]

Networking drivers implementing PTP clocks and kernel socket code
handling hardware timestamps use the 64-bit signed ktime_t type counting
nanoseconds. When a PTP clock reaches the maximum value in year 2262,
the timestamps returned to applications will overflow into year 1667.
The same thing happens when injecting a large offset with
clock_adjtime(ADJ_SETOFFSET).

The commit 7a8e61f84786 ("timekeeping: Force upper bound for setting
CLOCK_REALTIME") limited the maximum accepted value setting the system
clock to 30 years before the maximum representable value (i.e. year
2232) to avoid the overflow, assuming the system will not run for more
than 30 years.

Enforce the same limit for PTP clocks. Don't allow negative values and
values closer than 30 years to the maximum value. Drivers may implement
an even lower limit if the hardware registers cannot represent the whole
interval between years 1970 and 2262 in the required resolution.

Signed-off-by: Miroslav Lichvar <mlichvar@redhat.com>
Cc: Richard Cochran <richardcochran@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: John Stultz <jstultz@google.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Vadim Fedorenko <vadim.fedorenko@linux.dev>
Link: https://patch.msgid.link/20250828103300.1387025-1-mlichvar@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES

- Fixes a real bug: Prevents PTP clocks and timestamping from
  overflowing 64-bit signed ktime_t (wrap to year 1667) when a clock is
  set near the representable maximum or when a large offset is injected
  via ADJ_SETOFFSET. This is user-visible and can be triggered
  immediately by userspace with large offsets, not only in year 2262.
- Small, contained change in the PTP core:
  - Validates absolute settime requests using the established helper.
    Added check in `ptp_clock_settime()` to reject invalid targets:
    `drivers/ptp/ptp_clock.c:104`.
  - Validates relative ADJ_SETOFFSET by first reading current time,
    adding the offset, then rejecting if the resulting time would be
    invalid: `ptp_clock_gettime()` call `drivers/ptp/ptp_clock.c:151`,
    compute sum `drivers/ptp/ptp_clock.c:154`, and validate with
    `timespec64_valid_settod()` `drivers/ptp/ptp_clock.c:155`.
- Aligns PTP behavior with system clock rules: Uses the same upper-bound
  policy as CLOCK_REALTIME by calling `timespec64_valid_settod()`, which
  rejects negative times and values within 30 years of ktime’s max
  (`include/linux/time64.h:118`). This matches the prior “timekeeping:
  Force upper bound for setting CLOCK_REALTIME” change and ensures
  consistent semantics across clocks.
- Minimal regression risk:
  - Only rejects out-of-range inputs that previously produced overflowed
    timestamps; returns `-EINVAL` instead of silently wrapping.
  - No architectural changes; no driver APIs change; ADJ_OFFSET and
    ADJ_FREQUENCY paths are untouched (besides existing range checks).
  - Matches existing kernel timekeeping validation patterns (system
    clock already enforces the same limits).
- Touches a non-core subsystem (PTP POSIX clock ops) and is
  straightforward to review and backport.
- Backport note: The change depends on `timespec64_valid_settod()` and
  related defines in `include/linux/time64.h`. If a target stable branch
  predates this helper, a trivial adaptation (or backport of the helper)
  is needed.

Given the clear correctness benefit, minimal scope, and alignment with
existing timekeeping policy, this is a good candidate for stable
backport.

 drivers/ptp/ptp_clock.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/ptp/ptp_clock.c b/drivers/ptp/ptp_clock.c
index 1cc06b7cb17ef..3e0726c6f55b3 100644
--- a/drivers/ptp/ptp_clock.c
+++ b/drivers/ptp/ptp_clock.c
@@ -100,6 +100,9 @@ static int ptp_clock_settime(struct posix_clock *pc, const struct timespec64 *tp
 		return -EBUSY;
 	}
 
+	if (!timespec64_valid_settod(tp))
+		return -EINVAL;
+
 	return  ptp->info->settime64(ptp->info, tp);
 }
 
@@ -130,7 +133,7 @@ static int ptp_clock_adjtime(struct posix_clock *pc, struct __kernel_timex *tx)
 	ops = ptp->info;
 
 	if (tx->modes & ADJ_SETOFFSET) {
-		struct timespec64 ts;
+		struct timespec64 ts, ts2;
 		ktime_t kt;
 		s64 delta;
 
@@ -143,6 +146,14 @@ static int ptp_clock_adjtime(struct posix_clock *pc, struct __kernel_timex *tx)
 		if ((unsigned long) ts.tv_nsec >= NSEC_PER_SEC)
 			return -EINVAL;
 
+		/* Make sure the offset is valid */
+		err = ptp_clock_gettime(pc, &ts2);
+		if (err)
+			return err;
+		ts2 = timespec64_add(ts2, ts);
+		if (!timespec64_valid_settod(&ts2))
+			return -EINVAL;
+
 		kt = timespec64_to_ktime(ts);
 		delta = ktime_to_ns(kt);
 		err = ops->adjtime(ops, delta);
-- 
2.51.0

