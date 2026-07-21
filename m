Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB171471402;
	Tue, 21 Jul 2026 19:49:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784663352; cv=none; b=XiGf8SPo1y/H7VRmZVMiO72hhVJKXI/WbpKxD1kk0iXIbDzBHjH3zoh3/GbFIenXTwysPmZOCGwMFybguzorlKI2jiEhEsJrYCxvGbGP6j4tHf0XIEj/jD+FGKLJlY6qM5FfTKz+2SAT9T3fhGYScoY0g95IfQLT99GZztKXqnU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784663352; c=relaxed/simple;
	bh=Pmzeni4ax/PycPifGjWgWBFDTVSfd+Ot/cFDvuIPqrQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ak9PEfliD1r9XXEE95D9GxXmHPXRLkPx1//U7Yll1fq5Y16RDWlnJY+uaRmo9Yum1r/vZN5XslhQe8xZrhViXZAEyGqEL//1aobhcm54R105K2XM/6lGIGnhnEHTJ7p3CgdbP1Pjpb4EWMl68F2NZyU2kyIq7cjoexYobVFunpc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lxUjyYpz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lxUjyYpz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 216BE1F00A3A;
	Tue, 21 Jul 2026 19:49:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784663350;
	bh=FRPfu6Txvrn0ON21oGkUo4kmdcdxAZ0ovNiHBNlmy0Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lxUjyYpz3DmP/9MBkXL2DNtx1gq+1LU+xHkWpcknsLi3PEbJU+Z3BSU9xiNfh4zn4
	 SEfk3qlDKNfmW5Z4r9QZ/f+oOQqh9i/cT/r26MqvEu2TRbYJM4spoV1IDQ2hKRlvbk
	 YeM0qOr0w9T7wqvkoXFoSZoEWuFLUFWlVxSF3Oi0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Samuel Moelius <sam.moelius@trailofbits.com>,
	=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0783/1276] net/sched: cake: reject overhead values that underflow length
Date: Tue, 21 Jul 2026 17:20:26 +0200
Message-ID: <20260721152503.600911635@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index ba1a5c15e6cabb..2f33739036bb1b 100644
--- a/net/sched/sch_cake.c
+++ b/net/sched/sch_cake.c
@@ -1365,10 +1365,7 @@ static u32 cake_calc_overhead(struct cake_sched_data *q, u32 len, u32 off)
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



