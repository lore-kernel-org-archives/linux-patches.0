Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAE9D1AC8BB;
	Thu, 15 Aug 2024 14:01:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723730506; cv=none; b=NlvJT5sPvpTXfgYIwVmqHYcSb+r1HnlknKft8Yokgg5QU6EGt9UyAMuOlHy3cC9uRY/Q7O08DzA/lQjq4mYJMkZGavJ61hdRyhKYODrCY0XDrJZa4PCn/7ouM5dHpSVLLjry9sy+ACI/v5kbrVDCaTMweoTrazVjgwy5ufqMP7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723730506; c=relaxed/simple;
	bh=U3A31N3zw1rwXplX3SaNgepd68aQFcdtcaonebNIYKA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VYIg9EsCmBTdAfpXJgUu79Frx3Lmh4GTKCJHde2yGFnX6eKEaD2wo8tIPVpPgSHV+Q8ZShNa7oKHgzydHVhgKrEUBRm9PB0iHueZf4c03TnG9RzCP+kbioQBtGS+8xwojq4DDrOJapUs/dYjaEiWPtyzDhMW7bxqOsmXmZ0sz5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qP7ft859; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qP7ft859"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62580C4AF0A;
	Thu, 15 Aug 2024 14:01:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723730505;
	bh=U3A31N3zw1rwXplX3SaNgepd68aQFcdtcaonebNIYKA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qP7ft859KzS5R0iiKLCIR3RTykrj306xdnp8uVG9kQj4MwSpWyhGX1JuMnn+rGKc0
	 e6j6sQOyvvlI+0oo3RZN0wTfRrS1Ak0wYlEVY3vS6C3xlf/qTjdCYBBFzAZH8nAORz
	 LtTIwI4lvxB0jf5Y/fMhYrHa3AwSo5ZMG+Kd4OiY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Justin Stitt <justinstitt@google.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Miroslav Lichvar <mlichvar@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 428/484] ntp: Clamp maxerror and esterror to operating range
Date: Thu, 15 Aug 2024 15:24:46 +0200
Message-ID: <20240815131957.990157358@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131941.255804951@linuxfoundation.org>
References: <20240815131941.255804951@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Justin Stitt <justinstitt@google.com>

[ Upstream commit 87d571d6fb77ec342a985afa8744bb9bb75b3622 ]

Using syzkaller alongside the newly reintroduced signed integer overflow
sanitizer spits out this report:

UBSAN: signed-integer-overflow in ../kernel/time/ntp.c:461:16
9223372036854775807 + 500 cannot be represented in type 'long'
Call Trace:
 handle_overflow+0x171/0x1b0
 second_overflow+0x2d6/0x500
 accumulate_nsecs_to_secs+0x60/0x160
 timekeeping_advance+0x1fe/0x890
 update_wall_time+0x10/0x30

time_maxerror is unconditionally incremented and the result is checked
against NTP_PHASE_LIMIT, but the increment itself can overflow, resulting
in wrap-around to negative space.

Before commit eea83d896e31 ("ntp: NTP4 user space bits update") the user
supplied value was sanity checked to be in the operating range. That change
removed the sanity check and relied on clamping in handle_overflow() which
does not work correctly when the user supplied value is in the overflow
zone of the '+ 500' operation.

The operation requires CAP_SYS_TIME and the side effect of the overflow is
NTP getting out of sync.

Miroslav confirmed that the input value should be clamped to the operating
range and the same applies to time_esterror. The latter is not used by the
kernel, but the value still should be in the operating range as it was
before the sanity check got removed.

Clamp them to the operating range.

[ tglx: Changed it to clamping and included time_esterror ]

Fixes: eea83d896e31 ("ntp: NTP4 user space bits update")
Signed-off-by: Justin Stitt <justinstitt@google.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Miroslav Lichvar <mlichvar@redhat.com>
Link: https://lore.kernel.org/all/20240517-b4-sio-ntp-usec-v2-1-d539180f2b79@google.com
Closes: https://github.com/KSPP/linux/issues/354
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/time/ntp.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/time/ntp.c b/kernel/time/ntp.c
index 406dccb79c2b6..502e1e5b7f7f6 100644
--- a/kernel/time/ntp.c
+++ b/kernel/time/ntp.c
@@ -727,10 +727,10 @@ static inline void process_adjtimex_modes(const struct __kernel_timex *txc,
 	}
 
 	if (txc->modes & ADJ_MAXERROR)
-		time_maxerror = txc->maxerror;
+		time_maxerror = clamp(txc->maxerror, 0, NTP_PHASE_LIMIT);
 
 	if (txc->modes & ADJ_ESTERROR)
-		time_esterror = txc->esterror;
+		time_esterror = clamp(txc->esterror, 0, NTP_PHASE_LIMIT);
 
 	if (txc->modes & ADJ_TIMECONST) {
 		time_constant = txc->constant;
-- 
2.43.0



