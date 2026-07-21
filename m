Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60AE044AB9E;
	Tue, 21 Jul 2026 21:37:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784669843; cv=none; b=sNmRAQdBDpMhvSqoHT/L8mD24Xqhy6f/VpYuZt84dkLLP2Lgv/vV5B0HZf9qo8Y4ppqcMjXfISUzyvZArqPB03bjOnynmmQnXT9ABPrgFnlhJoZLkxVhC8BHptqc/vb7ahOU3fx7aWRRX5BM80WVrB6g2qD0ZOub18yO2JEfer8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784669843; c=relaxed/simple;
	bh=5LVAjcO6LyeO4l3YY7DEM8Wjk7+V2gk3Eynj4f913yQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kEj2HOjxNvJoYhqn53MS60ld2jWOTJRTwuNgz9i0oYn6Ch15Ghh3VD3t4wn2Twefe/BpTiH8YdiwNMh61tVRK2oUQSNOv5qo+Rpj+sgd/g/nCpksep05yZimhYsAkywQE/Vu6B9DbCnBYIkKfrChEpfNp6eDcLouwX8cLaiJ3zU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WnSpZJ7a; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WnSpZJ7a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C607D1F000E9;
	Tue, 21 Jul 2026 21:37:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784669841;
	bh=D4K/dEZDuc5VH3N0SARZrBXYLlo4246XdbfFiBTnaxc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WnSpZJ7aMUj67dKz9ePvr8qcyzSiIbedT3nXf6pPBy2FOtTj5wqQFxxE3yfCiUMAC
	 9zeJJDFhdpT/3bEriuoE+eF8jimd5eIMm7199DTS/604qfge3EauD1kcu53tk8TrnQ
	 BtJS2CGWk57z2ARy3An6GpP87rcfjwZNP6DgkgMo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Samuel Moelius <sam.moelius@trailofbits.com>,
	=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0700/1067] net/sched: cake: reject overhead values that underflow length
Date: Tue, 21 Jul 2026 17:21:41 +0200
Message-ID: <20260721152440.252221696@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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
index c6c03f758d0d7c..e210a676dc340b 100644
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



