Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA9AF431488;
	Thu, 30 Jul 2026 14:35:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785422143; cv=none; b=msRem1aN4SldtKNPFquVNCDxeVSp0HGSxIFnYPMi+pxvStHAGDXqSZn7vPKk1rwkSQB9W+xBxwxEBeYuKQ42xske6Evfc6f1sgyIjOFXPll/pQeWaERHPTaGixtAq+qqUjyC+PxXlCNlQ2SZafddSsdC4iIeFUAnvIPiNYkpJYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785422143; c=relaxed/simple;
	bh=x/9SbpoT2Sjb3L08QlAbE7BAiVK0RE0gRVEMSz4smVs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E0eMkBs9dftw1Fgp/ei849tgF6jyYTVx9mUZ/fNUUWUbiMt3+AT44kO5mF7AxoSdS4NOMuefHVSv50ZoSfqA6ig6pzif7wVgO6yRMrcSfqiHse2kTClDnNNdh9ZkEkKulLpxoDWlapyPhnBtnKNDQ4/KSUAo+Ff2a0bLOgcWLfE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VO6E3kB4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VO6E3kB4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A4FE1F000E9;
	Thu, 30 Jul 2026 14:35:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785422142;
	bh=+QqaXLIVL42cWXS/GUxLtXOrRrSm2HzeGV7xgN3xe8Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VO6E3kB4LIcx7DCZDcYTKLWK8zwJaFIOMblN10RCxzIldS/YLSAN7Y+VAwKZrE9gX
	 8pskP7dtkFmzLgFI3t2d315wtxNgrlOV24u7WraUbDDzaQ9iWsIn+I3QhWXQn+KNKD
	 TNcPVnMS0C8KVxfnomzLIISgKeIYzEoGi7WMT9jI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hariprasad Kelam <hkelam@marvell.com>,
	Nitin Shetty J <nshettyj@marvell.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 339/744] octeontx2-pf: tc: fix egress ratelimiting
Date: Thu, 30 Jul 2026 16:10:12 +0200
Message-ID: <20260730141451.487700415@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hariprasad Kelam <hkelam@marvell.com>

[ Upstream commit bb0d96ebe5f4d1acccf4dc36ca7f01f9a8fa1ba1 ]

The egress rate calculation computes an incorrect mantissa and exponent,
causing up to ~50% deviation from the configured rate at lower speeds.

Rework the computation to follow the hardware rate formula:

	rate = 2 * (1 + mantissa/256) * 2^exp / (1 << div_exp)

Keep div_exp = 0 and derive exp and mantissa from half of the requested
rate. Rates below 2 Mbps are floored to the smallest encodable step
(exp = 0, mantissa = 0).

Fixes: e638a83f167e ("octeontx2-pf: TC_MATCHALL egress ratelimiting offload")
Signed-off-by: Hariprasad Kelam <hkelam@marvell.com>
Signed-off-by: Nitin Shetty J <nshettyj@marvell.com>
Link: https://patch.msgid.link/20260717084349.2227796-1-nshettyj@marvell.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../ethernet/marvell/octeontx2/nic/otx2_tc.c  | 29 ++++++++++---------
 1 file changed, 16 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_tc.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_tc.c
index 40162b08014dd6..0b46ec29e64eaa 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_tc.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_tc.c
@@ -30,6 +30,7 @@
 #define OTX2_UNSUPP_LSE_DEPTH		GENMASK(6, 4)
 
 #define MCAST_INVALID_GRP		(-1U)
+#define RATE_MANTISSA_BITS		8
 
 static void otx2_get_egress_burst_cfg(struct otx2_nic *nic, u32 burst,
 				      u32 *burst_exp, u32 *burst_mantissa)
@@ -66,28 +67,30 @@ static void otx2_get_egress_burst_cfg(struct otx2_nic *nic, u32 burst,
 static void otx2_get_egress_rate_cfg(u64 maxrate, u32 *exp,
 				     u32 *mantissa, u32 *div_exp)
 {
-	u64 tmp;
-
 	/* Rate calculation by hardware
 	 *
 	 * PIR_ADD = ((256 + mantissa) << exp) / 256
 	 * rate = (2 * PIR_ADD) / ( 1 << div_exp)
 	 * The resultant rate is in Mbps.
+	 *
+	 * Use div_exp = 0 and compute exp/mantissa for maxrate / 2; the
+	 * leading factor of two yields the full rate. Rates below 2 Mbps
+	 * are floored to the smallest step (exp = 0, mantissa = 0).
 	 */
 
-	/* 2Mbps to 100Gbps can be expressed with div_exp = 0.
-	 * Setting this to '0' will ease the calculation of
-	 * exponent and mantissa.
-	 */
 	*div_exp = 0;
-
 	if (maxrate) {
-		*exp = ilog2(maxrate) ? ilog2(maxrate) - 1 : 0;
-		tmp = maxrate - rounddown_pow_of_two(maxrate);
-		if (maxrate < MAX_RATE_MANTISSA)
-			*mantissa = tmp * 2;
-		else
-			*mantissa = tmp / (1ULL << (*exp - 7));
+		maxrate = maxrate / 2;
+		if (!maxrate) {
+			/* Rates below 2 Mbps map to the smallest step */
+			*exp = 0;
+			*mantissa = 0;
+		} else {
+			*exp = ilog2(maxrate);
+			/* Clear MSB and derive fractional bits */
+			maxrate &= ~BIT(*exp);
+			*mantissa = (maxrate << RATE_MANTISSA_BITS) >> *exp;
+		}
 	} else {
 		/* Instead of disabling rate limiting, set all values to max */
 		*exp = MAX_RATE_EXPONENT;
-- 
2.53.0



