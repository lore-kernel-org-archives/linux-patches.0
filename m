Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9594F46D2A4;
	Tue, 21 Jul 2026 17:12:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784653963; cv=none; b=ea0N3KDIV5z7DLipPdTlE4eKtgwQMhu+sqBveK5OUq4/0Ih2gwckzlfMpbIUtNaeBCT/yKTJ44chvHJr1uM5buLCgN5ORVSCrMJGf7+7p7OFCr2zmTXdPLBOnXJS4DWRdR+xsv+DrLtOZS2511DXj3HpTR2vSmGaFS7EGVl6F6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784653963; c=relaxed/simple;
	bh=TJu00TTVewAwIU4IoC9B+JkKWssDGkKWUBulviRV7Ro=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=p8UIcqZCnpVx1kUsWeHHrkWV4NDIYOzzcw7eOAbpEHIB3+cYhmogClSINkuAqnmnJt1NkXdiZ9hHZNftRTB8XEmDmyYq5fRWlt2lCjBVoVyJ8BlMBQm9NP/QHITB1OJtDGsyCgtvxaKZgd08xE6TSqXoPWDWLndJlHiFTF4prEM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dsZf+7vF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dsZf+7vF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 037531F000E9;
	Tue, 21 Jul 2026 17:12:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784653962;
	bh=lsFmhR/KQEjMjxboeGWy8VBg78QjvI4LeLEjpA7l80k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dsZf+7vFbW78MrVy6L5zkJ0L7j4F6dE4Gm3V6EQi7gWLafkLGGnm3NkwEpHvBmYAF
	 2WTkrYEVgq7H3L//HZ8ARCjZS9k7w+vHA1PzmsNVHPpT+W1Xd//xQDd9zi5lE3TM7c
	 egwQsTJ70KSkJ8GjUTveWyl014vvvLg30su3bQi8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Samuel Moelius <sam.moelius@trailofbits.com>,
	=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1482/2077] net/sched: cake: reject overhead values that underflow length
Date: Tue, 21 Jul 2026 17:19:15 +0200
Message-ID: <20260721152627.756296565@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index c4915073d9d1a4..07ea175657bb8e 100644
--- a/net/sched/sch_cake.c
+++ b/net/sched/sch_cake.c
@@ -1389,10 +1389,7 @@ static u32 cake_calc_overhead(struct cake_sched_data *qd, u32 len, u32 off)
 	if (qd->min_netlen > len)
 		WRITE_ONCE(qd->min_netlen, len);
 
-	len += q->rate_overhead;
-
-	if (len < q->rate_mpu)
-		len = q->rate_mpu;
+	len = max((s32)len + q->rate_overhead, (s32)q->rate_mpu);
 
 	if (q->atm_mode == CAKE_ATM_ATM) {
 		len += 47;
-- 
2.53.0



