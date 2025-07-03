Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AD0DEEBA;
	Thu,  3 Jul 2025 15:24:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751556257; cv=none; b=j61PEaonMECrLP0zF2Xu3cvYyhm36When6zSNcta/E3TTSdh93Sn2UAC2r4tBPrsYv2qwo6e6a8fzaYk/Gsgp2Yax08XiVpg07gdVVcdebrCt7n0dJc9icZCdF0uhEJB9obmUL8+MfHDmCg0UpOwTvX8ZL3W8aToFo4UVSZEZrw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751556257; c=relaxed/simple;
	bh=KcE3YL3W+y1BwQu3EiQgXi6iTIzgGA72ktF+7QFSzWk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JSSUCgFAs8OJZhI+j5ZE1ZmOmblQNwf9Fyta78zNX7hOlVF8FauBNSjawsLSIqFC4JBY1wo+4smCt8g8hTQCdg7XBz41f8I8nfQ8w1eVH1Ak4cV9PrTuMDRKY547OwSjznrUYpzn6rzWgWf/9Uzp+eshT6h25y5n5G9sMbkafp0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vbp05169; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vbp05169"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74711C4CEE3;
	Thu,  3 Jul 2025 15:24:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751556257;
	bh=KcE3YL3W+y1BwQu3EiQgXi6iTIzgGA72ktF+7QFSzWk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vbp05169DhuRuXjULBqlbZX/OvlhnGgmKzeT9r5xZeHmQwiUH54/eUykbyD3w6jt3
	 3gv6hnACWdGC5nwcrev1E96bI6iqUTUbVODYvVE2u/UykYpRd1Q0AW50eHBA46Sxij
	 ZxXzh3u/vf6lgC8MTiwfwyd7nkW50RXziSKMWew0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Chan <michael.chan@broadcom.com>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 122/132] bnxt_en: Fix W=stringop-overflow warning in bnxt_dcb.c
Date: Thu,  3 Jul 2025 16:43:31 +0200
Message-ID: <20250703143944.187948869@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703143939.370927276@linuxfoundation.org>
References: <20250703143939.370927276@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Michael Chan <michael.chan@broadcom.com>

commit 3d5ecada049f4afdad71be09295c4cd0bbf105c3 upstream.

Fix the following warning:

drivers/net/ethernet/broadcom/bnxt/bnxt_dcb.c: In function ‘bnxt_hwrm_queue_cos2bw_cfg’:
cc1: error: writing 12 bytes into a region of size 1 [-Werror=stringop-overflow ]
In file included from drivers/net/ethernet/broadcom/bnxt/bnxt_dcb.c:19:
drivers/net/ethernet/broadcom/bnxt/bnxt_hsi.h:6045:17: note: destination object ‘unused_0’ of size 1
 6045 |         u8      unused_0;

Fix it by modifying struct hwrm_queue_cos2bw_cfg_input to use an array
of sub struct similar to the previous patch.  This will eliminate the
pointer arithmetc to calculate the destination pointer passed to
memcpy().

Link: https://lore.kernel.org/netdev/CACKFLinikvXmKcxr4kjWO9TPYxTd2cb5agT1j=w9Qyj5-24s5A@mail.gmail.com/
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Reviewed-by: Gustavo A. R. Silva <gustavoars@kernel.org>
Link: https://lore.kernel.org/r/20230807145720.159645-3-michael.chan@broadcom.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt_dcb.c |   11 
 drivers/net/ethernet/broadcom/bnxt/bnxt_hsi.h |  322 +++-----------------------
 2 files changed, 49 insertions(+), 284 deletions(-)

--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_dcb.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_dcb.c
@@ -98,7 +98,6 @@ static int bnxt_hwrm_queue_cos2bw_cfg(st
 {
 	struct hwrm_queue_cos2bw_cfg_input *req;
 	struct bnxt_cos2bw_cfg cos2bw;
-	void *data;
 	int rc, i;
 
 	rc = hwrm_req_init(bp, req, HWRM_QUEUE_COS2BW_CFG);
@@ -129,11 +128,15 @@ static int bnxt_hwrm_queue_cos2bw_cfg(st
 				cpu_to_le32((ets->tc_tx_bw[i] * 100) |
 					    BW_VALUE_UNIT_PERCENT1_100);
 		}
-		data = &req->unused_0 + qidx * (sizeof(cos2bw) - 4);
-		memcpy(data, &cos2bw.cfg, sizeof(cos2bw) - 4);
 		if (qidx == 0) {
 			req->queue_id0 = cos2bw.queue_id;
-			req->unused_0 = 0;
+			req->queue_id0_min_bw = cos2bw.min_bw;
+			req->queue_id0_max_bw = cos2bw.max_bw;
+			req->queue_id0_tsa_assign = cos2bw.tsa;
+			req->queue_id0_pri_lvl = cos2bw.pri_lvl;
+			req->queue_id0_bw_weight = cos2bw.bw_weight;
+		} else {
+			memcpy(&req->cfg[i - 1], &cos2bw.cfg, sizeof(cos2bw.cfg));
 		}
 	}
 	return hwrm_req_send(bp, req);
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_hsi.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_hsi.h
@@ -5779,286 +5779,48 @@ struct hwrm_queue_cos2bw_cfg_input {
 	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID0_TSA_ASSIGN_RESERVED_LAST  0xffUL
 	u8	queue_id0_pri_lvl;
 	u8	queue_id0_bw_weight;
-	u8	queue_id1;
-	__le32	queue_id1_min_bw;
-	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID1_MIN_BW_BW_VALUE_MASK             0xfffffffUL
-	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID1_MIN_BW_BW_VALUE_SFT              0
-	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID1_MIN_BW_SCALE                     0x10000000UL
-	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID1_MIN_BW_SCALE_BITS                  (0x0UL << 28)
-	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID1_MIN_BW_SCALE_BYTES                 (0x1UL << 28)
-	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID1_MIN_BW_SCALE_LAST                 QUEUE_COS2BW_CFG_REQ_QUEUE_ID1_MIN_BW_SCALE_BYTES
-	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID1_MIN_BW_BW_VALUE_UNIT_MASK        0xe0000000UL
-	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID1_MIN_BW_BW_VALUE_UNIT_SFT         29
-	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID1_MIN_BW_BW_VALUE_UNIT_MEGA          (0x0UL << 29)
-	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID1_MIN_BW_BW_VALUE_UNIT_KILO          (0x2UL << 29)
-	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID1_MIN_BW_BW_VALUE_UNIT_BASE          (0x4UL << 29)
-	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID1_MIN_BW_BW_VALUE_UNIT_GIGA          (0x6UL << 29)
-	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID1_MIN_BW_BW_VALUE_UNIT_PERCENT1_100  (0x1UL << 29)
-	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID1_MIN_BW_BW_VALUE_UNIT_INVALID       (0x7UL << 29)
-	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID1_MIN_BW_BW_VALUE_UNIT_LAST         QUEUE_COS2BW_CFG_REQ_QUEUE_ID1_MIN_BW_BW_VALUE_UNIT_INVALID
-	__le32	queue_id1_max_bw;
-	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID1_MAX_BW_BW_VALUE_MASK             0xfffffffUL
-	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID1_MAX_BW_BW_VALUE_SFT              0
-	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID1_MAX_BW_SCALE                     0x10000000UL
-	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID1_MAX_BW_SCALE_BITS                  (0x0UL << 28)
-	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID1_MAX_BW_SCALE_BYTES                 (0x1UL << 28)
-	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID1_MAX_BW_SCALE_LAST                 QUEUE_COS2BW_CFG_REQ_QUEUE_ID1_MAX_BW_SCALE_BYTES
-	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID1_MAX_BW_BW_VALUE_UNIT_MASK        0xe0000000UL
-	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID1_MAX_BW_BW_VALUE_UNIT_SFT         29
-	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID1_MAX_BW_BW_VALUE_UNIT_MEGA          (0x0UL << 29)
-	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID1_MAX_BW_BW_VALUE_UNIT_KILO          (0x2UL << 29)
-	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID1_MAX_BW_BW_VALUE_UNIT_BASE          (0x4UL << 29)
-	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID1_MAX_BW_BW_VALUE_UNIT_GIGA          (0x6UL << 29)
-	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID1_MAX_BW_BW_VALUE_UNIT_PERCENT1_100  (0x1UL << 29)
-	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID1_MAX_BW_BW_VALUE_UNIT_INVALID       (0x7UL << 29)
-	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID1_MAX_BW_BW_VALUE_UNIT_LAST         QUEUE_COS2BW_CFG_REQ_QUEUE_ID1_MAX_BW_BW_VALUE_UNIT_INVALID
-	u8	queue_id1_tsa_assign;
-	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID1_TSA_ASSIGN_SP             0x0UL
-	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID1_TSA_ASSIGN_ETS            0x1UL
-	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID1_TSA_ASSIGN_RESERVED_FIRST 0x2UL
-	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID1_TSA_ASSIGN_RESERVED_LAST  0xffUL
-	u8	queue_id1_pri_lvl;
-	u8	queue_id1_bw_weight;
-	u8	queue_id2;
-	__le32	queue_id2_min_bw;
-	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID2_MIN_BW_BW_VALUE_MASK             0xfffffffUL
-	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID2_MIN_BW_BW_VALUE_SFT              0
-	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID2_MIN_BW_SCALE                     0x10000000UL
-	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID2_MIN_BW_SCALE_BITS                  (0x0UL << 28)
-	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID2_MIN_BW_SCALE_BYTES                 (0x1UL << 28)
-	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID2_MIN_BW_SCALE_LAST                 QUEUE_COS2BW_CFG_REQ_QUEUE_ID2_MIN_BW_SCALE_BYTES
-	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID2_MIN_BW_BW_VALUE_UNIT_MASK        0xe0000000UL
-	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID2_MIN_BW_BW_VALUE_UNIT_SFT         29
-	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID2_MIN_BW_BW_VALUE_UNIT_MEGA          (0x0UL << 29)
-	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID2_MIN_BW_BW_VALUE_UNIT_KILO          (0x2UL << 29)
-	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID2_MIN_BW_BW_VALUE_UNIT_BASE          (0x4UL << 29)
-	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID2_MIN_BW_BW_VALUE_UNIT_GIGA          (0x6UL << 29)
-	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID2_MIN_BW_BW_VALUE_UNIT_PERCENT1_100  (0x1UL << 29)
-	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID2_MIN_BW_BW_VALUE_UNIT_INVALID       (0x7UL << 29)
-	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID2_MIN_BW_BW_VALUE_UNIT_LAST         QUEUE_COS2BW_CFG_REQ_QUEUE_ID2_MIN_BW_BW_VALUE_UNIT_INVALID
-	__le32	queue_id2_max_bw;
-	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID2_MAX_BW_BW_VALUE_MASK             0xfffffffUL
-	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID2_MAX_BW_BW_VALUE_SFT              0
-	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID2_MAX_BW_SCALE                     0x10000000UL
-	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID2_MAX_BW_SCALE_BITS                  (0x0UL << 28)
-	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID2_MAX_BW_SCALE_BYTES                 (0x1UL << 28)
-	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID2_MAX_BW_SCALE_LAST                 QUEUE_COS2BW_CFG_REQ_QUEUE_ID2_MAX_BW_SCALE_BYTES
-	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID2_MAX_BW_BW_VALUE_UNIT_MASK        0xe0000000UL
-	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID2_MAX_BW_BW_VALUE_UNIT_SFT         29
-	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID2_MAX_BW_BW_VALUE_UNIT_MEGA          (0x0UL << 29)
-	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID2_MAX_BW_BW_VALUE_UNIT_KILO          (0x2UL << 29)
-	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID2_MAX_BW_BW_VALUE_UNIT_BASE          (0x4UL << 29)
-	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID2_MAX_BW_BW_VALUE_UNIT_GIGA          (0x6UL << 29)
-	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID2_MAX_BW_BW_VALUE_UNIT_PERCENT1_100  (0x1UL << 29)
-	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID2_MAX_BW_BW_VALUE_UNIT_INVALID       (0x7UL << 29)
-	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID2_MAX_BW_BW_VALUE_UNIT_LAST         QUEUE_COS2BW_CFG_REQ_QUEUE_ID2_MAX_BW_BW_VALUE_UNIT_INVALID
-	u8	queue_id2_tsa_assign;
-	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID2_TSA_ASSIGN_SP             0x0UL
-	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID2_TSA_ASSIGN_ETS            0x1UL
-	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID2_TSA_ASSIGN_RESERVED_FIRST 0x2UL
-	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID2_TSA_ASSIGN_RESERVED_LAST  0xffUL
-	u8	queue_id2_pri_lvl;
-	u8	queue_id2_bw_weight;
-	u8	queue_id3;
-	__le32	queue_id3_min_bw;
-	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID3_MIN_BW_BW_VALUE_MASK             0xfffffffUL
-	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID3_MIN_BW_BW_VALUE_SFT              0
-	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID3_MIN_BW_SCALE                     0x10000000UL
-	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID3_MIN_BW_SCALE_BITS                  (0x0UL << 28)
-	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID3_MIN_BW_SCALE_BYTES                 (0x1UL << 28)
-	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID3_MIN_BW_SCALE_LAST                 QUEUE_COS2BW_CFG_REQ_QUEUE_ID3_MIN_BW_SCALE_BYTES
-	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID3_MIN_BW_BW_VALUE_UNIT_MASK        0xe0000000UL
-	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID3_MIN_BW_BW_VALUE_UNIT_SFT         29
-	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID3_MIN_BW_BW_VALUE_UNIT_MEGA          (0x0UL << 29)
-	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID3_MIN_BW_BW_VALUE_UNIT_KILO          (0x2UL << 29)
-	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID3_MIN_BW_BW_VALUE_UNIT_BASE          (0x4UL << 29)
-	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID3_MIN_BW_BW_VALUE_UNIT_GIGA          (0x6UL << 29)
-	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID3_MIN_BW_BW_VALUE_UNIT_PERCENT1_100  (0x1UL << 29)
-	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID3_MIN_BW_BW_VALUE_UNIT_INVALID       (0x7UL << 29)
-	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID3_MIN_BW_BW_VALUE_UNIT_LAST         QUEUE_COS2BW_CFG_REQ_QUEUE_ID3_MIN_BW_BW_VALUE_UNIT_INVALID
-	__le32	queue_id3_max_bw;
-	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID3_MAX_BW_BW_VALUE_MASK             0xfffffffUL
-	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID3_MAX_BW_BW_VALUE_SFT              0
-	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID3_MAX_BW_SCALE                     0x10000000UL
-	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID3_MAX_BW_SCALE_BITS                  (0x0UL << 28)
-	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID3_MAX_BW_SCALE_BYTES                 (0x1UL << 28)
-	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID3_MAX_BW_SCALE_LAST                 QUEUE_COS2BW_CFG_REQ_QUEUE_ID3_MAX_BW_SCALE_BYTES
-	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID3_MAX_BW_BW_VALUE_UNIT_MASK        0xe0000000UL
-	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID3_MAX_BW_BW_VALUE_UNIT_SFT         29
-	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID3_MAX_BW_BW_VALUE_UNIT_MEGA          (0x0UL << 29)
-	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID3_MAX_BW_BW_VALUE_UNIT_KILO          (0x2UL << 29)
-	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID3_MAX_BW_BW_VALUE_UNIT_BASE          (0x4UL << 29)
-	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID3_MAX_BW_BW_VALUE_UNIT_GIGA          (0x6UL << 29)
-	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID3_MAX_BW_BW_VALUE_UNIT_PERCENT1_100  (0x1UL << 29)
-	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID3_MAX_BW_BW_VALUE_UNIT_INVALID       (0x7UL << 29)
-	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID3_MAX_BW_BW_VALUE_UNIT_LAST         QUEUE_COS2BW_CFG_REQ_QUEUE_ID3_MAX_BW_BW_VALUE_UNIT_INVALID
-	u8	queue_id3_tsa_assign;
-	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID3_TSA_ASSIGN_SP             0x0UL
-	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID3_TSA_ASSIGN_ETS            0x1UL
-	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID3_TSA_ASSIGN_RESERVED_FIRST 0x2UL
-	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID3_TSA_ASSIGN_RESERVED_LAST  0xffUL
-	u8	queue_id3_pri_lvl;
-	u8	queue_id3_bw_weight;
-	u8	queue_id4;
-	__le32	queue_id4_min_bw;
-	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID4_MIN_BW_BW_VALUE_MASK             0xfffffffUL
-	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID4_MIN_BW_BW_VALUE_SFT              0
-	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID4_MIN_BW_SCALE                     0x10000000UL
-	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID4_MIN_BW_SCALE_BITS                  (0x0UL << 28)
-	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID4_MIN_BW_SCALE_BYTES                 (0x1UL << 28)
-	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID4_MIN_BW_SCALE_LAST                 QUEUE_COS2BW_CFG_REQ_QUEUE_ID4_MIN_BW_SCALE_BYTES
-	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID4_MIN_BW_BW_VALUE_UNIT_MASK        0xe0000000UL
-	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID4_MIN_BW_BW_VALUE_UNIT_SFT         29
-	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID4_MIN_BW_BW_VALUE_UNIT_MEGA          (0x0UL << 29)
-	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID4_MIN_BW_BW_VALUE_UNIT_KILO          (0x2UL << 29)
-	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID4_MIN_BW_BW_VALUE_UNIT_BASE          (0x4UL << 29)
-	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID4_MIN_BW_BW_VALUE_UNIT_GIGA          (0x6UL << 29)
-	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID4_MIN_BW_BW_VALUE_UNIT_PERCENT1_100  (0x1UL << 29)
-	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID4_MIN_BW_BW_VALUE_UNIT_INVALID       (0x7UL << 29)
-	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID4_MIN_BW_BW_VALUE_UNIT_LAST         QUEUE_COS2BW_CFG_REQ_QUEUE_ID4_MIN_BW_BW_VALUE_UNIT_INVALID
-	__le32	queue_id4_max_bw;
-	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID4_MAX_BW_BW_VALUE_MASK             0xfffffffUL
-	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID4_MAX_BW_BW_VALUE_SFT              0
-	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID4_MAX_BW_SCALE                     0x10000000UL
-	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID4_MAX_BW_SCALE_BITS                  (0x0UL << 28)
-	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID4_MAX_BW_SCALE_BYTES                 (0x1UL << 28)
-	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID4_MAX_BW_SCALE_LAST                 QUEUE_COS2BW_CFG_REQ_QUEUE_ID4_MAX_BW_SCALE_BYTES
-	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID4_MAX_BW_BW_VALUE_UNIT_MASK        0xe0000000UL
-	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID4_MAX_BW_BW_VALUE_UNIT_SFT         29
-	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID4_MAX_BW_BW_VALUE_UNIT_MEGA          (0x0UL << 29)
-	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID4_MAX_BW_BW_VALUE_UNIT_KILO          (0x2UL << 29)
-	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID4_MAX_BW_BW_VALUE_UNIT_BASE          (0x4UL << 29)
-	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID4_MAX_BW_BW_VALUE_UNIT_GIGA          (0x6UL << 29)
-	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID4_MAX_BW_BW_VALUE_UNIT_PERCENT1_100  (0x1UL << 29)
-	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID4_MAX_BW_BW_VALUE_UNIT_INVALID       (0x7UL << 29)
-	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID4_MAX_BW_BW_VALUE_UNIT_LAST         QUEUE_COS2BW_CFG_REQ_QUEUE_ID4_MAX_BW_BW_VALUE_UNIT_INVALID
-	u8	queue_id4_tsa_assign;
-	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID4_TSA_ASSIGN_SP             0x0UL
-	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID4_TSA_ASSIGN_ETS            0x1UL
-	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID4_TSA_ASSIGN_RESERVED_FIRST 0x2UL
-	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID4_TSA_ASSIGN_RESERVED_LAST  0xffUL
-	u8	queue_id4_pri_lvl;
-	u8	queue_id4_bw_weight;
-	u8	queue_id5;
-	__le32	queue_id5_min_bw;
-	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID5_MIN_BW_BW_VALUE_MASK             0xfffffffUL
-	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID5_MIN_BW_BW_VALUE_SFT              0
-	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID5_MIN_BW_SCALE                     0x10000000UL
-	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID5_MIN_BW_SCALE_BITS                  (0x0UL << 28)
-	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID5_MIN_BW_SCALE_BYTES                 (0x1UL << 28)
-	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID5_MIN_BW_SCALE_LAST                 QUEUE_COS2BW_CFG_REQ_QUEUE_ID5_MIN_BW_SCALE_BYTES
-	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID5_MIN_BW_BW_VALUE_UNIT_MASK        0xe0000000UL
-	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID5_MIN_BW_BW_VALUE_UNIT_SFT         29
-	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID5_MIN_BW_BW_VALUE_UNIT_MEGA          (0x0UL << 29)
-	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID5_MIN_BW_BW_VALUE_UNIT_KILO          (0x2UL << 29)
-	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID5_MIN_BW_BW_VALUE_UNIT_BASE          (0x4UL << 29)
-	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID5_MIN_BW_BW_VALUE_UNIT_GIGA          (0x6UL << 29)
-	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID5_MIN_BW_BW_VALUE_UNIT_PERCENT1_100  (0x1UL << 29)
-	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID5_MIN_BW_BW_VALUE_UNIT_INVALID       (0x7UL << 29)
-	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID5_MIN_BW_BW_VALUE_UNIT_LAST         QUEUE_COS2BW_CFG_REQ_QUEUE_ID5_MIN_BW_BW_VALUE_UNIT_INVALID
-	__le32	queue_id5_max_bw;
-	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID5_MAX_BW_BW_VALUE_MASK             0xfffffffUL
-	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID5_MAX_BW_BW_VALUE_SFT              0
-	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID5_MAX_BW_SCALE                     0x10000000UL
-	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID5_MAX_BW_SCALE_BITS                  (0x0UL << 28)
-	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID5_MAX_BW_SCALE_BYTES                 (0x1UL << 28)
-	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID5_MAX_BW_SCALE_LAST                 QUEUE_COS2BW_CFG_REQ_QUEUE_ID5_MAX_BW_SCALE_BYTES
-	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID5_MAX_BW_BW_VALUE_UNIT_MASK        0xe0000000UL
-	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID5_MAX_BW_BW_VALUE_UNIT_SFT         29
-	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID5_MAX_BW_BW_VALUE_UNIT_MEGA          (0x0UL << 29)
-	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID5_MAX_BW_BW_VALUE_UNIT_KILO          (0x2UL << 29)
-	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID5_MAX_BW_BW_VALUE_UNIT_BASE          (0x4UL << 29)
-	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID5_MAX_BW_BW_VALUE_UNIT_GIGA          (0x6UL << 29)
-	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID5_MAX_BW_BW_VALUE_UNIT_PERCENT1_100  (0x1UL << 29)
-	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID5_MAX_BW_BW_VALUE_UNIT_INVALID       (0x7UL << 29)
-	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID5_MAX_BW_BW_VALUE_UNIT_LAST         QUEUE_COS2BW_CFG_REQ_QUEUE_ID5_MAX_BW_BW_VALUE_UNIT_INVALID
-	u8	queue_id5_tsa_assign;
-	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID5_TSA_ASSIGN_SP             0x0UL
-	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID5_TSA_ASSIGN_ETS            0x1UL
-	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID5_TSA_ASSIGN_RESERVED_FIRST 0x2UL
-	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID5_TSA_ASSIGN_RESERVED_LAST  0xffUL
-	u8	queue_id5_pri_lvl;
-	u8	queue_id5_bw_weight;
-	u8	queue_id6;
-	__le32	queue_id6_min_bw;
-	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID6_MIN_BW_BW_VALUE_MASK             0xfffffffUL
-	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID6_MIN_BW_BW_VALUE_SFT              0
-	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID6_MIN_BW_SCALE                     0x10000000UL
-	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID6_MIN_BW_SCALE_BITS                  (0x0UL << 28)
-	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID6_MIN_BW_SCALE_BYTES                 (0x1UL << 28)
-	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID6_MIN_BW_SCALE_LAST                 QUEUE_COS2BW_CFG_REQ_QUEUE_ID6_MIN_BW_SCALE_BYTES
-	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID6_MIN_BW_BW_VALUE_UNIT_MASK        0xe0000000UL
-	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID6_MIN_BW_BW_VALUE_UNIT_SFT         29
-	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID6_MIN_BW_BW_VALUE_UNIT_MEGA          (0x0UL << 29)
-	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID6_MIN_BW_BW_VALUE_UNIT_KILO          (0x2UL << 29)
-	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID6_MIN_BW_BW_VALUE_UNIT_BASE          (0x4UL << 29)
-	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID6_MIN_BW_BW_VALUE_UNIT_GIGA          (0x6UL << 29)
-	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID6_MIN_BW_BW_VALUE_UNIT_PERCENT1_100  (0x1UL << 29)
-	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID6_MIN_BW_BW_VALUE_UNIT_INVALID       (0x7UL << 29)
-	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID6_MIN_BW_BW_VALUE_UNIT_LAST         QUEUE_COS2BW_CFG_REQ_QUEUE_ID6_MIN_BW_BW_VALUE_UNIT_INVALID
-	__le32	queue_id6_max_bw;
-	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID6_MAX_BW_BW_VALUE_MASK             0xfffffffUL
-	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID6_MAX_BW_BW_VALUE_SFT              0
-	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID6_MAX_BW_SCALE                     0x10000000UL
-	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID6_MAX_BW_SCALE_BITS                  (0x0UL << 28)
-	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID6_MAX_BW_SCALE_BYTES                 (0x1UL << 28)
-	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID6_MAX_BW_SCALE_LAST                 QUEUE_COS2BW_CFG_REQ_QUEUE_ID6_MAX_BW_SCALE_BYTES
-	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID6_MAX_BW_BW_VALUE_UNIT_MASK        0xe0000000UL
-	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID6_MAX_BW_BW_VALUE_UNIT_SFT         29
-	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID6_MAX_BW_BW_VALUE_UNIT_MEGA          (0x0UL << 29)
-	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID6_MAX_BW_BW_VALUE_UNIT_KILO          (0x2UL << 29)
-	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID6_MAX_BW_BW_VALUE_UNIT_BASE          (0x4UL << 29)
-	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID6_MAX_BW_BW_VALUE_UNIT_GIGA          (0x6UL << 29)
-	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID6_MAX_BW_BW_VALUE_UNIT_PERCENT1_100  (0x1UL << 29)
-	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID6_MAX_BW_BW_VALUE_UNIT_INVALID       (0x7UL << 29)
-	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID6_MAX_BW_BW_VALUE_UNIT_LAST         QUEUE_COS2BW_CFG_REQ_QUEUE_ID6_MAX_BW_BW_VALUE_UNIT_INVALID
-	u8	queue_id6_tsa_assign;
-	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID6_TSA_ASSIGN_SP             0x0UL
-	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID6_TSA_ASSIGN_ETS            0x1UL
-	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID6_TSA_ASSIGN_RESERVED_FIRST 0x2UL
-	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID6_TSA_ASSIGN_RESERVED_LAST  0xffUL
-	u8	queue_id6_pri_lvl;
-	u8	queue_id6_bw_weight;
-	u8	queue_id7;
-	__le32	queue_id7_min_bw;
-	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID7_MIN_BW_BW_VALUE_MASK             0xfffffffUL
-	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID7_MIN_BW_BW_VALUE_SFT              0
-	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID7_MIN_BW_SCALE                     0x10000000UL
-	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID7_MIN_BW_SCALE_BITS                  (0x0UL << 28)
-	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID7_MIN_BW_SCALE_BYTES                 (0x1UL << 28)
-	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID7_MIN_BW_SCALE_LAST                 QUEUE_COS2BW_CFG_REQ_QUEUE_ID7_MIN_BW_SCALE_BYTES
-	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID7_MIN_BW_BW_VALUE_UNIT_MASK        0xe0000000UL
-	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID7_MIN_BW_BW_VALUE_UNIT_SFT         29
-	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID7_MIN_BW_BW_VALUE_UNIT_MEGA          (0x0UL << 29)
-	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID7_MIN_BW_BW_VALUE_UNIT_KILO          (0x2UL << 29)
-	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID7_MIN_BW_BW_VALUE_UNIT_BASE          (0x4UL << 29)
-	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID7_MIN_BW_BW_VALUE_UNIT_GIGA          (0x6UL << 29)
-	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID7_MIN_BW_BW_VALUE_UNIT_PERCENT1_100  (0x1UL << 29)
-	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID7_MIN_BW_BW_VALUE_UNIT_INVALID       (0x7UL << 29)
-	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID7_MIN_BW_BW_VALUE_UNIT_LAST         QUEUE_COS2BW_CFG_REQ_QUEUE_ID7_MIN_BW_BW_VALUE_UNIT_INVALID
-	__le32	queue_id7_max_bw;
-	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID7_MAX_BW_BW_VALUE_MASK             0xfffffffUL
-	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID7_MAX_BW_BW_VALUE_SFT              0
-	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID7_MAX_BW_SCALE                     0x10000000UL
-	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID7_MAX_BW_SCALE_BITS                  (0x0UL << 28)
-	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID7_MAX_BW_SCALE_BYTES                 (0x1UL << 28)
-	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID7_MAX_BW_SCALE_LAST                 QUEUE_COS2BW_CFG_REQ_QUEUE_ID7_MAX_BW_SCALE_BYTES
-	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID7_MAX_BW_BW_VALUE_UNIT_MASK        0xe0000000UL
-	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID7_MAX_BW_BW_VALUE_UNIT_SFT         29
-	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID7_MAX_BW_BW_VALUE_UNIT_MEGA          (0x0UL << 29)
-	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID7_MAX_BW_BW_VALUE_UNIT_KILO          (0x2UL << 29)
-	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID7_MAX_BW_BW_VALUE_UNIT_BASE          (0x4UL << 29)
-	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID7_MAX_BW_BW_VALUE_UNIT_GIGA          (0x6UL << 29)
-	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID7_MAX_BW_BW_VALUE_UNIT_PERCENT1_100  (0x1UL << 29)
-	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID7_MAX_BW_BW_VALUE_UNIT_INVALID       (0x7UL << 29)
-	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID7_MAX_BW_BW_VALUE_UNIT_LAST         QUEUE_COS2BW_CFG_REQ_QUEUE_ID7_MAX_BW_BW_VALUE_UNIT_INVALID
-	u8	queue_id7_tsa_assign;
-	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID7_TSA_ASSIGN_SP             0x0UL
-	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID7_TSA_ASSIGN_ETS            0x1UL
-	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID7_TSA_ASSIGN_RESERVED_FIRST 0x2UL
-	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID7_TSA_ASSIGN_RESERVED_LAST  0xffUL
-	u8	queue_id7_pri_lvl;
-	u8	queue_id7_bw_weight;
+	struct {
+		u8	queue_id;
+		__le32	queue_id_min_bw;
+	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID_MIN_BW_BW_VALUE_MASK             0xfffffffUL
+	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID_MIN_BW_BW_VALUE_SFT              0
+	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID_MIN_BW_SCALE                     0x10000000UL
+	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID_MIN_BW_SCALE_BITS                  (0x0UL << 28)
+	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID_MIN_BW_SCALE_BYTES                 (0x1UL << 28)
+	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID_MIN_BW_SCALE_LAST                 QUEUE_COS2BW_CFG_REQ_QUEUE_ID_MIN_BW_SCALE_BYTES
+	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID_MIN_BW_BW_VALUE_UNIT_MASK        0xe0000000UL
+	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID_MIN_BW_BW_VALUE_UNIT_SFT         29
+	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID_MIN_BW_BW_VALUE_UNIT_MEGA          (0x0UL << 29)
+	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID_MIN_BW_BW_VALUE_UNIT_KILO          (0x2UL << 29)
+	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID_MIN_BW_BW_VALUE_UNIT_BASE          (0x4UL << 29)
+	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID_MIN_BW_BW_VALUE_UNIT_GIGA          (0x6UL << 29)
+	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID_MIN_BW_BW_VALUE_UNIT_PERCENT1_100  (0x1UL << 29)
+	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID_MIN_BW_BW_VALUE_UNIT_INVALID       (0x7UL << 29)
+	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID_MIN_BW_BW_VALUE_UNIT_LAST         QUEUE_COS2BW_CFG_REQ_QUEUE_ID_MIN_BW_BW_VALUE_UNIT_INVALID
+		__le32	queue_id_max_bw;
+	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID_MAX_BW_BW_VALUE_MASK             0xfffffffUL
+	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID_MAX_BW_BW_VALUE_SFT              0
+	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID_MAX_BW_SCALE                     0x10000000UL
+	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID_MAX_BW_SCALE_BITS                  (0x0UL << 28)
+	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID_MAX_BW_SCALE_BYTES                 (0x1UL << 28)
+	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID_MAX_BW_SCALE_LAST                 QUEUE_COS2BW_CFG_REQ_QUEUE_ID_MAX_BW_SCALE_BYTES
+	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID_MAX_BW_BW_VALUE_UNIT_MASK        0xe0000000UL
+	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID_MAX_BW_BW_VALUE_UNIT_SFT         29
+	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID_MAX_BW_BW_VALUE_UNIT_MEGA          (0x0UL << 29)
+	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID_MAX_BW_BW_VALUE_UNIT_KILO          (0x2UL << 29)
+	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID_MAX_BW_BW_VALUE_UNIT_BASE          (0x4UL << 29)
+	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID_MAX_BW_BW_VALUE_UNIT_GIGA          (0x6UL << 29)
+	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID_MAX_BW_BW_VALUE_UNIT_PERCENT1_100  (0x1UL << 29)
+	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID_MAX_BW_BW_VALUE_UNIT_INVALID       (0x7UL << 29)
+	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID_MAX_BW_BW_VALUE_UNIT_LAST         QUEUE_COS2BW_CFG_REQ_QUEUE_ID_MAX_BW_BW_VALUE_UNIT_INVALID
+		u8	queue_id_tsa_assign;
+	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID_TSA_ASSIGN_SP             0x0UL
+	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID_TSA_ASSIGN_ETS            0x1UL
+	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID_TSA_ASSIGN_RESERVED_FIRST 0x2UL
+	#define QUEUE_COS2BW_CFG_REQ_QUEUE_ID_TSA_ASSIGN_RESERVED_LAST  0xffUL
+		u8	queue_id_pri_lvl;
+		u8	queue_id_bw_weight;
+	} __packed cfg[7];
 	u8	unused_1[5];
 };
 


