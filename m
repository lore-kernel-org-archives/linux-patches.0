Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD7DD37DE97;
	Tue, 21 Jul 2026 18:25:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784658360; cv=none; b=p+ZJTjyZVMDGYdoeGC/DQ4JVSDLoX6ADdVTSjkCrmhXJWMYgP35zmjzI+Lc/Z1jWQ0ntg/srETUlqzB0R9E+MGYY4sSbx3w9a5FgKelkh01UIb99NKl/3YKLjRnBNThwI4DI/1QDhuy+gNQjzQwFiQEDj6PNLYQl5ve+qNJkNu0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784658360; c=relaxed/simple;
	bh=sM7p4172/dMjFwn75JiL3XFrKWKUBuV0vzclAP+wC3U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dMJWGD1Fm/6RPnbtayDuogkmMbCN/oEkYp1fRr+8ou/0HzXLfQ+vBurFeC7SMKVUYMuycCH43pFenO4TMBlBgLomPDprLVPir1y2E3/+z5f+mDnn3eEJD/hn34/s8lHah5jozHH3OrZ8S/SsxoQ8dzoF9BOI3WcGDuLno+M0cYw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YnmuO8ba; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YnmuO8ba"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D56D1F000E9;
	Tue, 21 Jul 2026 18:25:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784658359;
	bh=nyvNqQ4tdoQ88aJtPSqwr1ebX43GnwkC4PdENqPw3ZA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YnmuO8baCkHRqyMJW22wKEY8ZYnpF2xcE2nevvLBTMucbLzJyTCbE2rIyzlxvzapg
	 EWC/ng5+X16+yPXy93bDEplgrV0HtcGWrJ9azrLxCoZKmhGbDqH3favLNyK+OdZNYB
	 Driu2n81xtHE32d947vRbpeIamPkeXtoWjydZEGw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Samuel Moelius <sam.moelius@trailofbits.com>,
	=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1070/1611] net/sched: cake: reject overhead values that underflow length
Date: Tue, 21 Jul 2026 17:19:46 +0200
Message-ID: <20260721152539.474362716@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index f2ad946a519c2f..c19eeed7e7cfb7 100644
--- a/net/sched/sch_cake.c
+++ b/net/sched/sch_cake.c
@@ -1368,10 +1368,7 @@ static u32 cake_calc_overhead(struct cake_sched_data *q, u32 len, u32 off)
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



