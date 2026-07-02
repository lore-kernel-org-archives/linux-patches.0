Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF4573955FE;
	Thu,  2 Jul 2026 16:23:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783009409; cv=none; b=U9/lpC9xuwQOytNSm0jZxd0ocUXJ+kipAI2LcIC/HuQYRoHvFnE1eXZZqxu6jU5u2hkvtj6By4CU8Kiw7bLStS0QyDmoUbeoceX3D9jvep+okuwQoa50+fVZgCSX/mXMxgt3eFt+1Pcy5NbUHhfLnXSqh3pSfgJ6ewf6vcdfYkI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783009409; c=relaxed/simple;
	bh=c53BTLDEiUFg4akAfYBpyKgcQJoQv1jzWgCLduyFpi8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fme10NniRxQz9GP4BC/P22rKkVIJSGgJqTbegdUrbHZVjPModTzcHZPwr+XGYhUSYXQ0CplLw0oUZuXZjlxmylBnyHQhLgf7Qsfv11SCeYtpAuUxHpvf9wO+fXg65sHYtlCSCk1MssRxNZA34zkJ/lNNw0nopDd2o7u/+qwY8Tc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cNrHp//I; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cNrHp//I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 331811F000E9;
	Thu,  2 Jul 2026 16:23:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783009405;
	bh=kva9/LH8taVrg0R/RyXKPDfigfEOsfE5QApAgufBcBo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cNrHp//ItPyrfhwuxdC7740PviE1CqisjY3HxtFt6bRkg/vR9/qzHwTeCRGIWWskO
	 7fFp2TEKR2m4YCb/Zu7rvIMfFI/klJFhTPrMpLOZV10dd153rWAwoFA//9xFmCyhF+
	 MI0bXzlvkvgBOYc1YQ60obylndAYfQfN1P8NwY8Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Sven Eckelmann <sven@narfation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 38/96] batman-adv: tp_meter: avoid divide-by-zero for dec_cwnd
Date: Thu,  2 Jul 2026 18:19:30 +0200
Message-ID: <20260702155109.786856403@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155108.949633242@linuxfoundation.org>
References: <20260702155108.949633242@linuxfoundation.org>
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

From: Sven Eckelmann <sven@narfation.org>

commit 33ccd52f3cc9ed46ce395199f89aa3234dc83314 upstream.

The cwnd is always MSS <= cwnd <= 0x20000000. But the calculation in
batadv_tp_update_cwnd() assumes unsigned 32 bit arithmetics.

    ((mss * 8) ** 2) / (cwnd * 8)

In case cwnd is actually 0x20000000, it will be shifted by 3 bit to the
left end up at 0x100000000 or U32_MAX + 1. It will therefore wrap around
and be 0 - resulting in:

    ((mss * 8) ** 2) / 0

This is of course invalid and cannot be calculated. The calculation should
must be simplified to avoid this overflow:

   (mss ** 2) * 8 / cwnd

It will keep the precision enhancement from the scaling (by 8) but avoid
the overflow in the divisor.

In theory, there could still be an overflow in the dividend. It is at the
moment fixed to BATADV_TP_PLEN in batadv_tp_recv_ack() - so it is not an
imminent problem. But allowing it to use the whole u32 bit range, would
mean that it can still use up to 67 bits. To keep this calculation safe for
32 bit arithmetic, mss must never use more than floor((32 - 3) / 2) bits -
or in other words: must never be larger than 16383.

Cc: stable@kernel.org
Fixes: 33a3bb4a3345 ("batman-adv: throughput meter implementation")
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/batman-adv/tp_meter.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/batman-adv/tp_meter.c b/net/batman-adv/tp_meter.c
index 10953096996ab1..118cb5dd285c2d 100644
--- a/net/batman-adv/tp_meter.c
+++ b/net/batman-adv/tp_meter.c
@@ -153,9 +153,12 @@ static void batadv_tp_update_cwnd(struct batadv_tp_vars *tp_vars, u32 mss)
 		return;
 	}
 
+	/* prevent overflow in (mss * mss) << 3 */
+	mss = min_t(u32, mss, (1U << 14) - 1);
+
 	/* increment CWND at least of 1 (section 3.1 of RFC5681) */
 	tp_vars->dec_cwnd += max_t(u32, 1U << 3,
-				   ((mss * mss) << 6) / (tp_vars->cwnd << 3));
+				   ((mss * mss) << 3) / tp_vars->cwnd);
 	if (tp_vars->dec_cwnd < (mss << 3)) {
 		spin_unlock_bh(&tp_vars->cwnd_lock);
 		return;
-- 
2.53.0



