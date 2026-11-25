Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795622617;
	b=Dwzqrvl5TNomwbv4BCp378PnAUGK9x0NRk5ZljARh2mwFB4aGp6zx9zymBAmIE5T+/GW
	 Ah2rinm6b7pZ8NGXgU6dC4rcYahZo1+mGNcnyMigQrYSegHiGWSkz2wPTd8lGxbcYFI0u
	 OTft7R96H4KfN7YSEue9usUYirZnPpgd7QWiNmO4BCA2b6WFGtt4/6E8rYKlmcFVTnX4a
	 20XHB8pGZfJR6Bh+l4sDMdUd3IDc1ktG6F9cGBmD6nm4QJe1tL4vNOd7bkOynMnX9h16n
	 bSNqSoQGNvbkNY8Nl0FX3GOYwYYC1m6HhFiW3+p5kySIKpckcXveB9dwGnGLcQ0jEJQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622617;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=sRpeaOJ4RRbywfh3USsDc5STCW0r2UrR6rNWGYeezX8=;
	b=h+stnMKRwUM2wlyOB27SS+se8Urf2LyJyQhaCDS45xcRUcjCQ7gUMX26KSOlyql7uvNe
	 9eOrWlViFuIwcGHVm3kbk4pDgiiWQVgsl8BvDnpBGB5R3xyX4ZwpdP61+XfSPw9XGCE7g
	 j5fmCuA1anhC0TNBy6edoQ1CbcCb33xbv28WUp1xpm6wcqkKNc0iL2F0sxzR0v/9B4Oac
	 gpeON9Gt2vv017uSyhg2lGqx/DllQ9z53WX/749DgkhfsSlvAeOBuWKJuhRibHdXaaXxl
	 Pdwgg1w5IBHrdB8ZhQXIkhxKfeRJw+EJb0r5DA5neFoFVIxja/d7rS+IY1lajMje4zw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=h0EEpfEU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42C80606A31E;
	Wed, 25 Nov 2026 16:03:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=h0EEpfEU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B48881F000D1;
	Wed, 25 Nov 2026 16:03:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795622616;
	bh=sRpeaOJ4RRbywfh3USsDc5STCW0r2UrR6rNWGYeezX8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h0EEpfEU23ZxmxFD/ZTLii5K0ny49Ahpv9QnGf5sTWrjDlwkWsRv1e3qnJKn78ibi
	 r1DFgvMrl7NJwjy5ypY0w2B5YFo1RP7I2NAhZI6hQEgvdxuUiLi/g1NJcUPAJkAxTQ
	 72rfdvffhinTOrA3joOJeCa+rQMLA47oXmTq8Mks=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kang Yang <kang.yang@oss.qualcomm.com>,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 549/990] wifi: ath12k: fix skb leak on monitor PPDU ID wraparound
Date: Wed, 25 Nov 2026 15:31:56 +0100
Message-ID: <20261125143834.958761732@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kang Yang <kang.yang@oss.qualcomm.com>

[ Upstream commit 97b144b82e2388efef1f78269626d61de0480feb ]

ath12k_dp_mon_comp_ppduid() updates *ppdu_id and returns
msdu_ppdu_id to indicate that a PPDU transition was detected.

When PPDU IDs wrap around, msdu_ppdu_id can be 0. In that case
the function updates *ppdu_id but returns 0, causing
ath12k_wifi7_dp_rx_mon_mpdu_pop() to interpret the result as
"no PPDU update" and continue processing the MPDU.

The MSDUs are then linked into head_msdu while their RX
descriptors have already been detached. Later,
ath12k_wifi7_dp_rx_mon_dest_process() detects the PPDU
mismatch and exits with the partially built MSDU chain,
leaking the SKBs.

kmemleak reports the leak through:
  kmemleak_alloc()
  __netdev_alloc_skb()
  ath12k_dp_rx_bufs_replenish()
  ath12k_wifi7_dp_rx_mon_dest_process()

Fix this by returning a boolean value from
ath12k_dp_mon_comp_ppduid() so the update notification is
independent of the actual PPDU ID value.

Tested-on: WCN7850 hw2.0 PCI WLAN.HMT.1.1.c7-00108-QCAHMTSWPL_V1.0_V2.0_SILICONZ_UPSTREAM-3

Fixes: 72bfbf19b7da ("wifi: ath12k: add support to reap and process mon dest ring")
Signed-off-by: Kang Yang <kang.yang@oss.qualcomm.com>
Reviewed-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Reviewed-by: Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>
Link: https://patch.msgid.link/20260916060325.854-6-kang.yang@oss.qualcomm.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
[ sashal: Kept the function static in dp_mon.c and dropped the header hunk, since this tree has no prototype; only the return type changed to bool. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath12k/dp_mon.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/dp_mon.c b/drivers/net/wireless/ath/ath12k/dp_mon.c
index cfd9ea83887aa..2cb4e0bb0221a 100644
--- a/drivers/net/wireless/ath/ath12k/dp_mon.c
+++ b/drivers/net/wireless/ath/ath12k/dp_mon.c
@@ -1860,24 +1860,23 @@ ath12k_dp_rx_mon_buf_done(struct ath12k_base *ab, struct hal_srng *srng,
 	return DP_MON_STATUS_REPLINISH;
 }
 
-static u32 ath12k_dp_mon_comp_ppduid(u32 msdu_ppdu_id, u32 *ppdu_id)
+static bool ath12k_dp_mon_comp_ppduid(u32 msdu_ppdu_id, u32 *ppdu_id)
 {
-	u32 ret = 0;
-
 	if ((*ppdu_id < msdu_ppdu_id) &&
 	    ((msdu_ppdu_id - *ppdu_id) < DP_NOT_PPDU_ID_WRAP_AROUND)) {
 		/* Hold on mon dest ring, and reap mon status ring. */
 		*ppdu_id = msdu_ppdu_id;
-		ret = msdu_ppdu_id;
-	} else if ((*ppdu_id > msdu_ppdu_id) &&
-		((*ppdu_id - msdu_ppdu_id) > DP_NOT_PPDU_ID_WRAP_AROUND)) {
+		return true;
+	}
+	if ((*ppdu_id > msdu_ppdu_id) &&
+	    ((*ppdu_id - msdu_ppdu_id) > DP_NOT_PPDU_ID_WRAP_AROUND)) {
 		/* PPDU ID has exceeded the maximum value and will
 		 * restart from 0.
 		 */
 		*ppdu_id = msdu_ppdu_id;
-		ret = msdu_ppdu_id;
+		return true;
 	}
-	return ret;
+	return false;
 }
 
 static
-- 
2.53.0



