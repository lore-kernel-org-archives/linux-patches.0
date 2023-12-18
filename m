Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2A91129EC8;
	Mon, 18 Dec 2023 13:55:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bDCpLx1X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75B07C433C8;
	Mon, 18 Dec 2023 13:55:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702907708;
	bh=WjsRL8yYNhNGAFYO/wqYpQimWH2H9olGjYnMi/y43H8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bDCpLx1XO4DLxxcKRgVO6H4o38HjiHEf1016BggbPdKCYBM3dVOoEhvR76ySItkGs
	 Xfrlk57Anf8S5IDTNKviqGWkrvD6u9U1gsFv/EDvfFf8EE5/Z/GznpIU8E7KsWtgw3
	 EFeUI57vevQGrAvyqP2MYKQC2bExdVm/VClYJxtg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Gospodarek <andrew.gospodarek@broadcom.com>,
	Pavan Chebbi <pavan.chebbi@broadcom.com>,
	Michael Chan <michael.chan@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 018/106] bnxt_en: Fix HWTSTAMP_FILTER_ALL packet timestamp logic
Date: Mon, 18 Dec 2023 14:50:32 +0100
Message-ID: <20231218135055.738057415@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231218135055.005497074@linuxfoundation.org>
References: <20231218135055.005497074@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Chan <michael.chan@broadcom.com>

[ Upstream commit c13e268c0768659cdaae4bfe2fb24860bcc8ddb4 ]

When the chip is configured to timestamp all receive packets, the
timestamp in the RX completion is only valid if the metadata
present flag is not set for packets received on the wire.  In
addition, internal loopback packets will never have a valid timestamp
and the timestamp field will always be zero.  We must exclude
any 0 value in the timestamp field because there is no way to
determine if it is a loopback packet or not.

Add a new function bnxt_rx_ts_valid() to check for all timestamp
valid conditions.

Fixes: 66ed81dcedc6 ("bnxt_en: Enable packet timestamping for all RX packets")
Reviewed-by: Andy Gospodarek <andrew.gospodarek@broadcom.com>
Reviewed-by: Pavan Chebbi <pavan.chebbi@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Link: https://lore.kernel.org/r/20231208001658.14230-5-michael.chan@broadcom.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 20 +++++++++++++++++---
 drivers/net/ethernet/broadcom/bnxt/bnxt.h |  8 +++++++-
 2 files changed, 24 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 29cdc305af130..623cdeb29ed90 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -1796,6 +1796,21 @@ static void bnxt_deliver_skb(struct bnxt *bp, struct bnxt_napi *bnapi,
 	napi_gro_receive(&bnapi->napi, skb);
 }
 
+static bool bnxt_rx_ts_valid(struct bnxt *bp, u32 flags,
+			     struct rx_cmp_ext *rxcmp1, u32 *cmpl_ts)
+{
+	u32 ts = le32_to_cpu(rxcmp1->rx_cmp_timestamp);
+
+	if (BNXT_PTP_RX_TS_VALID(flags))
+		goto ts_valid;
+	if (!bp->ptp_all_rx_tstamp || !ts || !BNXT_ALL_RX_TS_VALID(flags))
+		return false;
+
+ts_valid:
+	*cmpl_ts = ts;
+	return true;
+}
+
 /* returns the following:
  * 1       - 1 packet successfully received
  * 0       - successful TPA_START, packet not completed yet
@@ -1821,6 +1836,7 @@ static int bnxt_rx_pkt(struct bnxt *bp, struct bnxt_cp_ring_info *cpr,
 	struct sk_buff *skb;
 	struct xdp_buff xdp;
 	u32 flags, misc;
+	u32 cmpl_ts;
 	void *data;
 	int rc = 0;
 
@@ -2043,10 +2059,8 @@ static int bnxt_rx_pkt(struct bnxt *bp, struct bnxt_cp_ring_info *cpr,
 		}
 	}
 
-	if (unlikely((flags & RX_CMP_FLAGS_ITYPES_MASK) ==
-		     RX_CMP_FLAGS_ITYPE_PTP_W_TS) || bp->ptp_all_rx_tstamp) {
+	if (bnxt_rx_ts_valid(bp, flags, rxcmp1, &cmpl_ts)) {
 		if (bp->flags & BNXT_FLAG_CHIP_P5) {
-			u32 cmpl_ts = le32_to_cpu(rxcmp1->rx_cmp_timestamp);
 			u64 ns, ts;
 
 			if (!bnxt_get_rx_ts_p5(bp, &ts, cmpl_ts)) {
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
index 4f80ae084eb1c..111098b4b6062 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -160,7 +160,7 @@ struct rx_cmp {
 	#define RX_CMP_FLAGS_ERROR				(1 << 6)
 	#define RX_CMP_FLAGS_PLACEMENT				(7 << 7)
 	#define RX_CMP_FLAGS_RSS_VALID				(1 << 10)
-	#define RX_CMP_FLAGS_UNUSED				(1 << 11)
+	#define RX_CMP_FLAGS_PKT_METADATA_PRESENT		(1 << 11)
 	 #define RX_CMP_FLAGS_ITYPES_SHIFT			 12
 	 #define RX_CMP_FLAGS_ITYPES_MASK			 0xf000
 	 #define RX_CMP_FLAGS_ITYPE_UNKNOWN			 (0 << 12)
@@ -187,6 +187,12 @@ struct rx_cmp {
 	__le32 rx_cmp_rss_hash;
 };
 
+#define BNXT_PTP_RX_TS_VALID(flags)				\
+	(((flags) & RX_CMP_FLAGS_ITYPES_MASK) == RX_CMP_FLAGS_ITYPE_PTP_W_TS)
+
+#define BNXT_ALL_RX_TS_VALID(flags)				\
+	!((flags) & RX_CMP_FLAGS_PKT_METADATA_PRESENT)
+
 #define RX_CMP_HASH_VALID(rxcmp)				\
 	((rxcmp)->rx_cmp_len_flags_type & cpu_to_le32(RX_CMP_FLAGS_RSS_VALID))
 
-- 
2.43.0



