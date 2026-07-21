Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89DDD3E49F5;
	Tue, 21 Jul 2026 22:50:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784674203; cv=none; b=hFY30nyeU9C5AUrAtJWqIHf75KEJaxJUeaJc1lUye3i0kcS+/D++6W1dl12jKX0ye3Gl4f3vXkxPMxpDc7u22H1601qaVUcPmF5Akqk9QiFl21WPgK0JOGFAGKFPKgFGlVx3yFRiRLTPnkXXZfdZgHjFK9KaeFWs9TmCZ0rIsTQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784674203; c=relaxed/simple;
	bh=TFj41qaA3Usmd+CyCZVmsO6wCgg0OS6sVGrMno1SpFc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=o+54SuZ5c+kQkBJ0ZCN/5LcLqwitRttPxQkv5Jl/fBtUS0pKL36rCnc1GB/ww3u/19bWIcxbv2QqYY2UsrVojrC+09MNsG3/a7jX9ByKWp1CrkjIWHka/ZQyHruAw15N3S4lEIzzoVlhzCap6rgh2W9TdKC9BwgvybMmH7q3GpQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=irT1nGxD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="irT1nGxD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F01D11F000E9;
	Tue, 21 Jul 2026 22:50:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784674202;
	bh=aiudIqJocu7CkB27BnRLTXG3iB6FMP36z8SpCMJfgiA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=irT1nGxDjl/7D9PYbZhZAqZ2KtIseXDJx6QvM9hIwMtcuumfAv8Q4xtyTisONc6PK
	 S0Nsae5FdfUA5L7sBDMEgEo5fcm/yHXjyu3Go42sCncqhHvmGueRYAvJrxFVRqKwFX
	 yYRRpqCKrNvgEJ2d5L359z7ps6W2cA0jDtMK3h7Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Samuel Moelius <sam.moelius@trailofbits.com>,
	=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 409/699] net/sched: cake: reject overhead values that underflow length
Date: Tue, 21 Jul 2026 17:22:48 +0200
Message-ID: <20260721152404.921519174@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Samuel Moelius <sam.moelius@trailofbits.com>

[ Upstream commit b7f97cae7ec1b6c3c32843c42be218690d310467 ]

CAKE accepts signed overhead values and stores them in an s16, but the
adjusted packet length calculation uses unsigned arithmetic.  A negative
effective length can therefore wrap to a large value.

Such configurations make rate accounting depend on integer wraparound
rather than on the packet size userspace intended to model.  A static
netlink lower bound is not enough because packets reaching CAKE can be
smaller than any reasonable manual-overhead allowance.

Fold the signed overhead adjustment into the existing datapath MPU clamp
so negative adjusted lengths are clamped before link-layer framing
adjustments.

Fixes: a729b7f0bd5b ("sch_cake: Add overhead compensation support to the rate shaper")
Assisted-by: Codex:gpt-5.5-cyber-preview
Signed-off-by: Samuel Moelius <sam.moelius@trailofbits.com>
Acked-by: Toke Høiland-Jørgensen <toke@toke.dk>
Link: https://patch.msgid.link/20260702000758.297407.e5c888d9d99d.cake-overhead-underflow@trailofbits.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/sch_cake.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/net/sched/sch_cake.c b/net/sched/sch_cake.c
index 2be03c8d13cb01..45b175e53aac03 100644
--- a/net/sched/sch_cake.c
+++ b/net/sched/sch_cake.c
@@ -1381,10 +1381,7 @@ static u32 cake_calc_overhead(struct cake_sched_data *q, u32 len, u32 off)
 	if (q->min_netlen > len)
 		q->min_netlen = len;
 
-	len += q->rate_overhead;
-
-	if (len < q->rate_mpu)
-		len = q->rate_mpu;
+	len = max((s32)len + q->rate_overhead, (s32)q->rate_mpu);
 
 	if (q->atm_mode == CAKE_ATM_ATM) {
 		len += 47;
-- 
2.53.0



