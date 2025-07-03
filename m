Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEC242DE6F8;
	Thu,  3 Jul 2025 15:24:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751556254; cv=none; b=OZTizm53Uj9zTFJhlegoqgiWS/a6qBDZEo+hAhzcSofI/sdsOsAjlbc6OPH39gyekcJYc/n1dcwSNG6t+bqOKSW4B9vRkkS0PGmgrhDz9Kmyp63jkZXs6NiKnLdBH4l4J0YKLiu1NoCAwXE8/n51HcHUsKO/tqgLpjIytZhQqgE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751556254; c=relaxed/simple;
	bh=6CeyfUcS6tRvRKdOXHuH2D/tbu9mg6D5TBqzCXeNY90=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qsgL9p4P+l+qg/VbXo4fgSTF6HsmYPJ0a8nyiXkS1CzkCfAZcJhIY205tS3zm1zLs4nkS8S3XJdqW/ll6NTkaHfpwRuJhJr9WGX1NWTDXxNGrSmxY7ZKOrsWkblnsFoGxFC+vUkxSh4fjH7RgPPZDHCE4wuGNemy/aXh+OwN2Zk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zgIbJpo6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zgIbJpo6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A095C4CEE3;
	Thu,  3 Jul 2025 15:24:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751556253;
	bh=6CeyfUcS6tRvRKdOXHuH2D/tbu9mg6D5TBqzCXeNY90=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zgIbJpo6vDU/nFcLNlwLpN51lUva7Ir+h+b+5mPeA9/GlpxmLP5MicWrWKzJ9sc20
	 20AhZmRKF2y3mrg38krL5PbT997dcNGWqwG9naWzoMocRMt2H6Mc2GVxzK5RGi9Id2
	 2ppCRxYJ7SNGmazAa3SLzHYXiFMgY9TDK4CB3ic8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Gospodarek <andrew.gospodarek@broadcom.com>,
	Michael Chan <michael.chan@broadcom.com>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 121/132] bnxt_en: Fix W=1 warning in bnxt_dcb.c from fortify memcpy()
Date: Thu,  3 Jul 2025 16:43:30 +0200
Message-ID: <20250703143944.147108489@linuxfoundation.org>
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

commit ac1b8c978a7acce25a530b02e7b3f0e74ac931c8 upstream.

Fix the following warning:

inlined from ‘bnxt_hwrm_queue_cos2bw_qcfg’ at drivers/net/ethernet/broadcom/bnxt/bnxt_dcb.c:165:3,
./include/linux/fortify-string.h:592:4: error: call to ‘__read_overflow2_field’ declared with attribute warning: detected read beyond size of field (2nd parameter); maybe use struct_group()? [-Werror]
    __read_overflow2_field(q_size_field, size);
    ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Modify the FW interface defintion of struct hwrm_queue_cos2bw_qcfg_output
to use an array of sub struct for the queue1 to queue7 fields.  Note that
the layout of the queue0 fields are different and these are not part of
the array.  This makes the code much cleaner by removing the pointer
arithmetic for memcpy().

Link: https://lore.kernel.org/netdev/20230727190726.1859515-2-kuba@kernel.org/
Reviewed-by: Andy Gospodarek <andrew.gospodarek@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Reviewed-by: Gustavo A. R. Silva <gustavoars@kernel.org>
Link: https://lore.kernel.org/r/20230807145720.159645-2-michael.chan@broadcom.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt_dcb.c |   15 -
 drivers/net/ethernet/broadcom/bnxt/bnxt_hsi.h |  322 +++-----------------------
 2 files changed, 52 insertions(+), 285 deletions(-)

--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_dcb.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_dcb.c
@@ -144,7 +144,6 @@ static int bnxt_hwrm_queue_cos2bw_qcfg(s
 	struct hwrm_queue_cos2bw_qcfg_output *resp;
 	struct hwrm_queue_cos2bw_qcfg_input *req;
 	struct bnxt_cos2bw_cfg cos2bw;
-	void *data;
 	int rc, i;
 
 	rc = hwrm_req_init(bp, req, HWRM_QUEUE_COS2BW_QCFG);
@@ -158,13 +157,19 @@ static int bnxt_hwrm_queue_cos2bw_qcfg(s
 		return rc;
 	}
 
-	data = &resp->queue_id0 + offsetof(struct bnxt_cos2bw_cfg, queue_id);
-	for (i = 0; i < bp->max_tc; i++, data += sizeof(cos2bw.cfg)) {
+	for (i = 0; i < bp->max_tc; i++) {
 		int tc;
 
-		memcpy(&cos2bw.cfg, data, sizeof(cos2bw.cfg));
-		if (i == 0)
+		if (i == 0) {
 			cos2bw.queue_id = resp->queue_id0;
+			cos2bw.min_bw = resp->queue_id0_min_bw;
+			cos2bw.max_bw = resp->queue_id0_max_bw;
+			cos2bw.tsa = resp->queue_id0_tsa_assign;
+			cos2bw.pri_lvl = resp->queue_id0_pri_lvl;
+			cos2bw.bw_weight = resp->queue_id0_bw_weight;
+		} else {
+			memcpy(&cos2bw.cfg, &resp->cfg[i - 1], sizeof(cos2bw.cfg));
+		}
 
 		tc = bnxt_queue_to_tc(bp, cos2bw.queue_id);
 		if (tc < 0)
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_hsi.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_hsi.h
@@ -5674,286 +5674,48 @@ struct hwrm_queue_cos2bw_qcfg_output {
 	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID0_TSA_ASSIGN_RESERVED_LAST  0xffUL
 	u8	queue_id0_pri_lvl;
 	u8	queue_id0_bw_weight;
-	u8	queue_id1;
-	__le32	queue_id1_min_bw;
-	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID1_MIN_BW_BW_VALUE_MASK             0xfffffffUL
-	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID1_MIN_BW_BW_VALUE_SFT              0
-	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID1_MIN_BW_SCALE                     0x10000000UL
-	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID1_MIN_BW_SCALE_BITS                  (0x0UL << 28)
-	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID1_MIN_BW_SCALE_BYTES                 (0x1UL << 28)
-	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID1_MIN_BW_SCALE_LAST                 QUEUE_COS2BW_QCFG_RESP_QUEUE_ID1_MIN_BW_SCALE_BYTES
-	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID1_MIN_BW_BW_VALUE_UNIT_MASK        0xe0000000UL
-	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID1_MIN_BW_BW_VALUE_UNIT_SFT         29
-	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID1_MIN_BW_BW_VALUE_UNIT_MEGA          (0x0UL << 29)
-	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID1_MIN_BW_BW_VALUE_UNIT_KILO          (0x2UL << 29)
-	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID1_MIN_BW_BW_VALUE_UNIT_BASE          (0x4UL << 29)
-	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID1_MIN_BW_BW_VALUE_UNIT_GIGA          (0x6UL << 29)
-	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID1_MIN_BW_BW_VALUE_UNIT_PERCENT1_100  (0x1UL << 29)
-	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID1_MIN_BW_BW_VALUE_UNIT_INVALID       (0x7UL << 29)
-	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID1_MIN_BW_BW_VALUE_UNIT_LAST         QUEUE_COS2BW_QCFG_RESP_QUEUE_ID1_MIN_BW_BW_VALUE_UNIT_INVALID
-	__le32	queue_id1_max_bw;
-	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID1_MAX_BW_BW_VALUE_MASK             0xfffffffUL
-	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID1_MAX_BW_BW_VALUE_SFT              0
-	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID1_MAX_BW_SCALE                     0x10000000UL
-	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID1_MAX_BW_SCALE_BITS                  (0x0UL << 28)
-	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID1_MAX_BW_SCALE_BYTES                 (0x1UL << 28)
-	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID1_MAX_BW_SCALE_LAST                 QUEUE_COS2BW_QCFG_RESP_QUEUE_ID1_MAX_BW_SCALE_BYTES
-	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID1_MAX_BW_BW_VALUE_UNIT_MASK        0xe0000000UL
-	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID1_MAX_BW_BW_VALUE_UNIT_SFT         29
-	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID1_MAX_BW_BW_VALUE_UNIT_MEGA          (0x0UL << 29)
-	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID1_MAX_BW_BW_VALUE_UNIT_KILO          (0x2UL << 29)
-	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID1_MAX_BW_BW_VALUE_UNIT_BASE          (0x4UL << 29)
-	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID1_MAX_BW_BW_VALUE_UNIT_GIGA          (0x6UL << 29)
-	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID1_MAX_BW_BW_VALUE_UNIT_PERCENT1_100  (0x1UL << 29)
-	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID1_MAX_BW_BW_VALUE_UNIT_INVALID       (0x7UL << 29)
-	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID1_MAX_BW_BW_VALUE_UNIT_LAST         QUEUE_COS2BW_QCFG_RESP_QUEUE_ID1_MAX_BW_BW_VALUE_UNIT_INVALID
-	u8	queue_id1_tsa_assign;
-	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID1_TSA_ASSIGN_SP             0x0UL
-	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID1_TSA_ASSIGN_ETS            0x1UL
-	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID1_TSA_ASSIGN_RESERVED_FIRST 0x2UL
-	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID1_TSA_ASSIGN_RESERVED_LAST  0xffUL
-	u8	queue_id1_pri_lvl;
-	u8	queue_id1_bw_weight;
-	u8	queue_id2;
-	__le32	queue_id2_min_bw;
-	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID2_MIN_BW_BW_VALUE_MASK             0xfffffffUL
-	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID2_MIN_BW_BW_VALUE_SFT              0
-	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID2_MIN_BW_SCALE                     0x10000000UL
-	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID2_MIN_BW_SCALE_BITS                  (0x0UL << 28)
-	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID2_MIN_BW_SCALE_BYTES                 (0x1UL << 28)
-	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID2_MIN_BW_SCALE_LAST                 QUEUE_COS2BW_QCFG_RESP_QUEUE_ID2_MIN_BW_SCALE_BYTES
-	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID2_MIN_BW_BW_VALUE_UNIT_MASK        0xe0000000UL
-	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID2_MIN_BW_BW_VALUE_UNIT_SFT         29
-	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID2_MIN_BW_BW_VALUE_UNIT_MEGA          (0x0UL << 29)
-	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID2_MIN_BW_BW_VALUE_UNIT_KILO          (0x2UL << 29)
-	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID2_MIN_BW_BW_VALUE_UNIT_BASE          (0x4UL << 29)
-	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID2_MIN_BW_BW_VALUE_UNIT_GIGA          (0x6UL << 29)
-	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID2_MIN_BW_BW_VALUE_UNIT_PERCENT1_100  (0x1UL << 29)
-	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID2_MIN_BW_BW_VALUE_UNIT_INVALID       (0x7UL << 29)
-	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID2_MIN_BW_BW_VALUE_UNIT_LAST         QUEUE_COS2BW_QCFG_RESP_QUEUE_ID2_MIN_BW_BW_VALUE_UNIT_INVALID
-	__le32	queue_id2_max_bw;
-	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID2_MAX_BW_BW_VALUE_MASK             0xfffffffUL
-	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID2_MAX_BW_BW_VALUE_SFT              0
-	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID2_MAX_BW_SCALE                     0x10000000UL
-	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID2_MAX_BW_SCALE_BITS                  (0x0UL << 28)
-	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID2_MAX_BW_SCALE_BYTES                 (0x1UL << 28)
-	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID2_MAX_BW_SCALE_LAST                 QUEUE_COS2BW_QCFG_RESP_QUEUE_ID2_MAX_BW_SCALE_BYTES
-	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID2_MAX_BW_BW_VALUE_UNIT_MASK        0xe0000000UL
-	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID2_MAX_BW_BW_VALUE_UNIT_SFT         29
-	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID2_MAX_BW_BW_VALUE_UNIT_MEGA          (0x0UL << 29)
-	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID2_MAX_BW_BW_VALUE_UNIT_KILO          (0x2UL << 29)
-	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID2_MAX_BW_BW_VALUE_UNIT_BASE          (0x4UL << 29)
-	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID2_MAX_BW_BW_VALUE_UNIT_GIGA          (0x6UL << 29)
-	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID2_MAX_BW_BW_VALUE_UNIT_PERCENT1_100  (0x1UL << 29)
-	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID2_MAX_BW_BW_VALUE_UNIT_INVALID       (0x7UL << 29)
-	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID2_MAX_BW_BW_VALUE_UNIT_LAST         QUEUE_COS2BW_QCFG_RESP_QUEUE_ID2_MAX_BW_BW_VALUE_UNIT_INVALID
-	u8	queue_id2_tsa_assign;
-	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID2_TSA_ASSIGN_SP             0x0UL
-	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID2_TSA_ASSIGN_ETS            0x1UL
-	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID2_TSA_ASSIGN_RESERVED_FIRST 0x2UL
-	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID2_TSA_ASSIGN_RESERVED_LAST  0xffUL
-	u8	queue_id2_pri_lvl;
-	u8	queue_id2_bw_weight;
-	u8	queue_id3;
-	__le32	queue_id3_min_bw;
-	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID3_MIN_BW_BW_VALUE_MASK             0xfffffffUL
-	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID3_MIN_BW_BW_VALUE_SFT              0
-	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID3_MIN_BW_SCALE                     0x10000000UL
-	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID3_MIN_BW_SCALE_BITS                  (0x0UL << 28)
-	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID3_MIN_BW_SCALE_BYTES                 (0x1UL << 28)
-	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID3_MIN_BW_SCALE_LAST                 QUEUE_COS2BW_QCFG_RESP_QUEUE_ID3_MIN_BW_SCALE_BYTES
-	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID3_MIN_BW_BW_VALUE_UNIT_MASK        0xe0000000UL
-	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID3_MIN_BW_BW_VALUE_UNIT_SFT         29
-	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID3_MIN_BW_BW_VALUE_UNIT_MEGA          (0x0UL << 29)
-	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID3_MIN_BW_BW_VALUE_UNIT_KILO          (0x2UL << 29)
-	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID3_MIN_BW_BW_VALUE_UNIT_BASE          (0x4UL << 29)
-	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID3_MIN_BW_BW_VALUE_UNIT_GIGA          (0x6UL << 29)
-	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID3_MIN_BW_BW_VALUE_UNIT_PERCENT1_100  (0x1UL << 29)
-	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID3_MIN_BW_BW_VALUE_UNIT_INVALID       (0x7UL << 29)
-	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID3_MIN_BW_BW_VALUE_UNIT_LAST         QUEUE_COS2BW_QCFG_RESP_QUEUE_ID3_MIN_BW_BW_VALUE_UNIT_INVALID
-	__le32	queue_id3_max_bw;
-	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID3_MAX_BW_BW_VALUE_MASK             0xfffffffUL
-	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID3_MAX_BW_BW_VALUE_SFT              0
-	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID3_MAX_BW_SCALE                     0x10000000UL
-	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID3_MAX_BW_SCALE_BITS                  (0x0UL << 28)
-	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID3_MAX_BW_SCALE_BYTES                 (0x1UL << 28)
-	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID3_MAX_BW_SCALE_LAST                 QUEUE_COS2BW_QCFG_RESP_QUEUE_ID3_MAX_BW_SCALE_BYTES
-	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID3_MAX_BW_BW_VALUE_UNIT_MASK        0xe0000000UL
-	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID3_MAX_BW_BW_VALUE_UNIT_SFT         29
-	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID3_MAX_BW_BW_VALUE_UNIT_MEGA          (0x0UL << 29)
-	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID3_MAX_BW_BW_VALUE_UNIT_KILO          (0x2UL << 29)
-	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID3_MAX_BW_BW_VALUE_UNIT_BASE          (0x4UL << 29)
-	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID3_MAX_BW_BW_VALUE_UNIT_GIGA          (0x6UL << 29)
-	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID3_MAX_BW_BW_VALUE_UNIT_PERCENT1_100  (0x1UL << 29)
-	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID3_MAX_BW_BW_VALUE_UNIT_INVALID       (0x7UL << 29)
-	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID3_MAX_BW_BW_VALUE_UNIT_LAST         QUEUE_COS2BW_QCFG_RESP_QUEUE_ID3_MAX_BW_BW_VALUE_UNIT_INVALID
-	u8	queue_id3_tsa_assign;
-	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID3_TSA_ASSIGN_SP             0x0UL
-	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID3_TSA_ASSIGN_ETS            0x1UL
-	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID3_TSA_ASSIGN_RESERVED_FIRST 0x2UL
-	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID3_TSA_ASSIGN_RESERVED_LAST  0xffUL
-	u8	queue_id3_pri_lvl;
-	u8	queue_id3_bw_weight;
-	u8	queue_id4;
-	__le32	queue_id4_min_bw;
-	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID4_MIN_BW_BW_VALUE_MASK             0xfffffffUL
-	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID4_MIN_BW_BW_VALUE_SFT              0
-	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID4_MIN_BW_SCALE                     0x10000000UL
-	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID4_MIN_BW_SCALE_BITS                  (0x0UL << 28)
-	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID4_MIN_BW_SCALE_BYTES                 (0x1UL << 28)
-	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID4_MIN_BW_SCALE_LAST                 QUEUE_COS2BW_QCFG_RESP_QUEUE_ID4_MIN_BW_SCALE_BYTES
-	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID4_MIN_BW_BW_VALUE_UNIT_MASK        0xe0000000UL
-	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID4_MIN_BW_BW_VALUE_UNIT_SFT         29
-	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID4_MIN_BW_BW_VALUE_UNIT_MEGA          (0x0UL << 29)
-	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID4_MIN_BW_BW_VALUE_UNIT_KILO          (0x2UL << 29)
-	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID4_MIN_BW_BW_VALUE_UNIT_BASE          (0x4UL << 29)
-	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID4_MIN_BW_BW_VALUE_UNIT_GIGA          (0x6UL << 29)
-	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID4_MIN_BW_BW_VALUE_UNIT_PERCENT1_100  (0x1UL << 29)
-	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID4_MIN_BW_BW_VALUE_UNIT_INVALID       (0x7UL << 29)
-	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID4_MIN_BW_BW_VALUE_UNIT_LAST         QUEUE_COS2BW_QCFG_RESP_QUEUE_ID4_MIN_BW_BW_VALUE_UNIT_INVALID
-	__le32	queue_id4_max_bw;
-	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID4_MAX_BW_BW_VALUE_MASK             0xfffffffUL
-	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID4_MAX_BW_BW_VALUE_SFT              0
-	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID4_MAX_BW_SCALE                     0x10000000UL
-	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID4_MAX_BW_SCALE_BITS                  (0x0UL << 28)
-	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID4_MAX_BW_SCALE_BYTES                 (0x1UL << 28)
-	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID4_MAX_BW_SCALE_LAST                 QUEUE_COS2BW_QCFG_RESP_QUEUE_ID4_MAX_BW_SCALE_BYTES
-	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID4_MAX_BW_BW_VALUE_UNIT_MASK        0xe0000000UL
-	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID4_MAX_BW_BW_VALUE_UNIT_SFT         29
-	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID4_MAX_BW_BW_VALUE_UNIT_MEGA          (0x0UL << 29)
-	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID4_MAX_BW_BW_VALUE_UNIT_KILO          (0x2UL << 29)
-	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID4_MAX_BW_BW_VALUE_UNIT_BASE          (0x4UL << 29)
-	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID4_MAX_BW_BW_VALUE_UNIT_GIGA          (0x6UL << 29)
-	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID4_MAX_BW_BW_VALUE_UNIT_PERCENT1_100  (0x1UL << 29)
-	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID4_MAX_BW_BW_VALUE_UNIT_INVALID       (0x7UL << 29)
-	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID4_MAX_BW_BW_VALUE_UNIT_LAST         QUEUE_COS2BW_QCFG_RESP_QUEUE_ID4_MAX_BW_BW_VALUE_UNIT_INVALID
-	u8	queue_id4_tsa_assign;
-	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID4_TSA_ASSIGN_SP             0x0UL
-	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID4_TSA_ASSIGN_ETS            0x1UL
-	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID4_TSA_ASSIGN_RESERVED_FIRST 0x2UL
-	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID4_TSA_ASSIGN_RESERVED_LAST  0xffUL
-	u8	queue_id4_pri_lvl;
-	u8	queue_id4_bw_weight;
-	u8	queue_id5;
-	__le32	queue_id5_min_bw;
-	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID5_MIN_BW_BW_VALUE_MASK             0xfffffffUL
-	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID5_MIN_BW_BW_VALUE_SFT              0
-	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID5_MIN_BW_SCALE                     0x10000000UL
-	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID5_MIN_BW_SCALE_BITS                  (0x0UL << 28)
-	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID5_MIN_BW_SCALE_BYTES                 (0x1UL << 28)
-	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID5_MIN_BW_SCALE_LAST                 QUEUE_COS2BW_QCFG_RESP_QUEUE_ID5_MIN_BW_SCALE_BYTES
-	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID5_MIN_BW_BW_VALUE_UNIT_MASK        0xe0000000UL
-	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID5_MIN_BW_BW_VALUE_UNIT_SFT         29
-	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID5_MIN_BW_BW_VALUE_UNIT_MEGA          (0x0UL << 29)
-	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID5_MIN_BW_BW_VALUE_UNIT_KILO          (0x2UL << 29)
-	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID5_MIN_BW_BW_VALUE_UNIT_BASE          (0x4UL << 29)
-	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID5_MIN_BW_BW_VALUE_UNIT_GIGA          (0x6UL << 29)
-	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID5_MIN_BW_BW_VALUE_UNIT_PERCENT1_100  (0x1UL << 29)
-	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID5_MIN_BW_BW_VALUE_UNIT_INVALID       (0x7UL << 29)
-	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID5_MIN_BW_BW_VALUE_UNIT_LAST         QUEUE_COS2BW_QCFG_RESP_QUEUE_ID5_MIN_BW_BW_VALUE_UNIT_INVALID
-	__le32	queue_id5_max_bw;
-	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID5_MAX_BW_BW_VALUE_MASK             0xfffffffUL
-	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID5_MAX_BW_BW_VALUE_SFT              0
-	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID5_MAX_BW_SCALE                     0x10000000UL
-	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID5_MAX_BW_SCALE_BITS                  (0x0UL << 28)
-	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID5_MAX_BW_SCALE_BYTES                 (0x1UL << 28)
-	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID5_MAX_BW_SCALE_LAST                 QUEUE_COS2BW_QCFG_RESP_QUEUE_ID5_MAX_BW_SCALE_BYTES
-	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID5_MAX_BW_BW_VALUE_UNIT_MASK        0xe0000000UL
-	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID5_MAX_BW_BW_VALUE_UNIT_SFT         29
-	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID5_MAX_BW_BW_VALUE_UNIT_MEGA          (0x0UL << 29)
-	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID5_MAX_BW_BW_VALUE_UNIT_KILO          (0x2UL << 29)
-	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID5_MAX_BW_BW_VALUE_UNIT_BASE          (0x4UL << 29)
-	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID5_MAX_BW_BW_VALUE_UNIT_GIGA          (0x6UL << 29)
-	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID5_MAX_BW_BW_VALUE_UNIT_PERCENT1_100  (0x1UL << 29)
-	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID5_MAX_BW_BW_VALUE_UNIT_INVALID       (0x7UL << 29)
-	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID5_MAX_BW_BW_VALUE_UNIT_LAST         QUEUE_COS2BW_QCFG_RESP_QUEUE_ID5_MAX_BW_BW_VALUE_UNIT_INVALID
-	u8	queue_id5_tsa_assign;
-	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID5_TSA_ASSIGN_SP             0x0UL
-	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID5_TSA_ASSIGN_ETS            0x1UL
-	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID5_TSA_ASSIGN_RESERVED_FIRST 0x2UL
-	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID5_TSA_ASSIGN_RESERVED_LAST  0xffUL
-	u8	queue_id5_pri_lvl;
-	u8	queue_id5_bw_weight;
-	u8	queue_id6;
-	__le32	queue_id6_min_bw;
-	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID6_MIN_BW_BW_VALUE_MASK             0xfffffffUL
-	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID6_MIN_BW_BW_VALUE_SFT              0
-	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID6_MIN_BW_SCALE                     0x10000000UL
-	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID6_MIN_BW_SCALE_BITS                  (0x0UL << 28)
-	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID6_MIN_BW_SCALE_BYTES                 (0x1UL << 28)
-	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID6_MIN_BW_SCALE_LAST                 QUEUE_COS2BW_QCFG_RESP_QUEUE_ID6_MIN_BW_SCALE_BYTES
-	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID6_MIN_BW_BW_VALUE_UNIT_MASK        0xe0000000UL
-	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID6_MIN_BW_BW_VALUE_UNIT_SFT         29
-	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID6_MIN_BW_BW_VALUE_UNIT_MEGA          (0x0UL << 29)
-	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID6_MIN_BW_BW_VALUE_UNIT_KILO          (0x2UL << 29)
-	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID6_MIN_BW_BW_VALUE_UNIT_BASE          (0x4UL << 29)
-	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID6_MIN_BW_BW_VALUE_UNIT_GIGA          (0x6UL << 29)
-	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID6_MIN_BW_BW_VALUE_UNIT_PERCENT1_100  (0x1UL << 29)
-	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID6_MIN_BW_BW_VALUE_UNIT_INVALID       (0x7UL << 29)
-	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID6_MIN_BW_BW_VALUE_UNIT_LAST         QUEUE_COS2BW_QCFG_RESP_QUEUE_ID6_MIN_BW_BW_VALUE_UNIT_INVALID
-	__le32	queue_id6_max_bw;
-	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID6_MAX_BW_BW_VALUE_MASK             0xfffffffUL
-	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID6_MAX_BW_BW_VALUE_SFT              0
-	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID6_MAX_BW_SCALE                     0x10000000UL
-	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID6_MAX_BW_SCALE_BITS                  (0x0UL << 28)
-	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID6_MAX_BW_SCALE_BYTES                 (0x1UL << 28)
-	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID6_MAX_BW_SCALE_LAST                 QUEUE_COS2BW_QCFG_RESP_QUEUE_ID6_MAX_BW_SCALE_BYTES
-	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID6_MAX_BW_BW_VALUE_UNIT_MASK        0xe0000000UL
-	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID6_MAX_BW_BW_VALUE_UNIT_SFT         29
-	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID6_MAX_BW_BW_VALUE_UNIT_MEGA          (0x0UL << 29)
-	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID6_MAX_BW_BW_VALUE_UNIT_KILO          (0x2UL << 29)
-	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID6_MAX_BW_BW_VALUE_UNIT_BASE          (0x4UL << 29)
-	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID6_MAX_BW_BW_VALUE_UNIT_GIGA          (0x6UL << 29)
-	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID6_MAX_BW_BW_VALUE_UNIT_PERCENT1_100  (0x1UL << 29)
-	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID6_MAX_BW_BW_VALUE_UNIT_INVALID       (0x7UL << 29)
-	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID6_MAX_BW_BW_VALUE_UNIT_LAST         QUEUE_COS2BW_QCFG_RESP_QUEUE_ID6_MAX_BW_BW_VALUE_UNIT_INVALID
-	u8	queue_id6_tsa_assign;
-	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID6_TSA_ASSIGN_SP             0x0UL
-	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID6_TSA_ASSIGN_ETS            0x1UL
-	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID6_TSA_ASSIGN_RESERVED_FIRST 0x2UL
-	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID6_TSA_ASSIGN_RESERVED_LAST  0xffUL
-	u8	queue_id6_pri_lvl;
-	u8	queue_id6_bw_weight;
-	u8	queue_id7;
-	__le32	queue_id7_min_bw;
-	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID7_MIN_BW_BW_VALUE_MASK             0xfffffffUL
-	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID7_MIN_BW_BW_VALUE_SFT              0
-	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID7_MIN_BW_SCALE                     0x10000000UL
-	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID7_MIN_BW_SCALE_BITS                  (0x0UL << 28)
-	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID7_MIN_BW_SCALE_BYTES                 (0x1UL << 28)
-	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID7_MIN_BW_SCALE_LAST                 QUEUE_COS2BW_QCFG_RESP_QUEUE_ID7_MIN_BW_SCALE_BYTES
-	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID7_MIN_BW_BW_VALUE_UNIT_MASK        0xe0000000UL
-	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID7_MIN_BW_BW_VALUE_UNIT_SFT         29
-	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID7_MIN_BW_BW_VALUE_UNIT_MEGA          (0x0UL << 29)
-	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID7_MIN_BW_BW_VALUE_UNIT_KILO          (0x2UL << 29)
-	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID7_MIN_BW_BW_VALUE_UNIT_BASE          (0x4UL << 29)
-	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID7_MIN_BW_BW_VALUE_UNIT_GIGA          (0x6UL << 29)
-	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID7_MIN_BW_BW_VALUE_UNIT_PERCENT1_100  (0x1UL << 29)
-	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID7_MIN_BW_BW_VALUE_UNIT_INVALID       (0x7UL << 29)
-	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID7_MIN_BW_BW_VALUE_UNIT_LAST         QUEUE_COS2BW_QCFG_RESP_QUEUE_ID7_MIN_BW_BW_VALUE_UNIT_INVALID
-	__le32	queue_id7_max_bw;
-	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID7_MAX_BW_BW_VALUE_MASK             0xfffffffUL
-	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID7_MAX_BW_BW_VALUE_SFT              0
-	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID7_MAX_BW_SCALE                     0x10000000UL
-	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID7_MAX_BW_SCALE_BITS                  (0x0UL << 28)
-	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID7_MAX_BW_SCALE_BYTES                 (0x1UL << 28)
-	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID7_MAX_BW_SCALE_LAST                 QUEUE_COS2BW_QCFG_RESP_QUEUE_ID7_MAX_BW_SCALE_BYTES
-	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID7_MAX_BW_BW_VALUE_UNIT_MASK        0xe0000000UL
-	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID7_MAX_BW_BW_VALUE_UNIT_SFT         29
-	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID7_MAX_BW_BW_VALUE_UNIT_MEGA          (0x0UL << 29)
-	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID7_MAX_BW_BW_VALUE_UNIT_KILO          (0x2UL << 29)
-	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID7_MAX_BW_BW_VALUE_UNIT_BASE          (0x4UL << 29)
-	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID7_MAX_BW_BW_VALUE_UNIT_GIGA          (0x6UL << 29)
-	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID7_MAX_BW_BW_VALUE_UNIT_PERCENT1_100  (0x1UL << 29)
-	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID7_MAX_BW_BW_VALUE_UNIT_INVALID       (0x7UL << 29)
-	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID7_MAX_BW_BW_VALUE_UNIT_LAST         QUEUE_COS2BW_QCFG_RESP_QUEUE_ID7_MAX_BW_BW_VALUE_UNIT_INVALID
-	u8	queue_id7_tsa_assign;
-	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID7_TSA_ASSIGN_SP             0x0UL
-	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID7_TSA_ASSIGN_ETS            0x1UL
-	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID7_TSA_ASSIGN_RESERVED_FIRST 0x2UL
-	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID7_TSA_ASSIGN_RESERVED_LAST  0xffUL
-	u8	queue_id7_pri_lvl;
-	u8	queue_id7_bw_weight;
+	struct {
+		u8	queue_id;
+		__le32	queue_id_min_bw;
+	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID_MIN_BW_BW_VALUE_MASK             0xfffffffUL
+	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID_MIN_BW_BW_VALUE_SFT              0
+	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID_MIN_BW_SCALE                     0x10000000UL
+	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID_MIN_BW_SCALE_BITS                  (0x0UL << 28)
+	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID_MIN_BW_SCALE_BYTES                 (0x1UL << 28)
+	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID_MIN_BW_SCALE_LAST                 QUEUE_COS2BW_QCFG_RESP_QUEUE_ID_MIN_BW_SCALE_BYTES
+	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID_MIN_BW_BW_VALUE_UNIT_MASK        0xe0000000UL
+	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID_MIN_BW_BW_VALUE_UNIT_SFT         29
+	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID_MIN_BW_BW_VALUE_UNIT_MEGA          (0x0UL << 29)
+	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID_MIN_BW_BW_VALUE_UNIT_KILO          (0x2UL << 29)
+	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID_MIN_BW_BW_VALUE_UNIT_BASE          (0x4UL << 29)
+	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID_MIN_BW_BW_VALUE_UNIT_GIGA          (0x6UL << 29)
+	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID_MIN_BW_BW_VALUE_UNIT_PERCENT1_100  (0x1UL << 29)
+	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID_MIN_BW_BW_VALUE_UNIT_INVALID       (0x7UL << 29)
+	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID_MIN_BW_BW_VALUE_UNIT_LAST         QUEUE_COS2BW_QCFG_RESP_QUEUE_ID_MIN_BW_BW_VALUE_UNIT_INVALID
+		__le32	queue_id_max_bw;
+	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID_MAX_BW_BW_VALUE_MASK             0xfffffffUL
+	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID_MAX_BW_BW_VALUE_SFT              0
+	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID_MAX_BW_SCALE                     0x10000000UL
+	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID_MAX_BW_SCALE_BITS                  (0x0UL << 28)
+	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID_MAX_BW_SCALE_BYTES                 (0x1UL << 28)
+	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID_MAX_BW_SCALE_LAST                 QUEUE_COS2BW_QCFG_RESP_QUEUE_ID_MAX_BW_SCALE_BYTES
+	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID_MAX_BW_BW_VALUE_UNIT_MASK        0xe0000000UL
+	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID_MAX_BW_BW_VALUE_UNIT_SFT         29
+	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID_MAX_BW_BW_VALUE_UNIT_MEGA          (0x0UL << 29)
+	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID_MAX_BW_BW_VALUE_UNIT_KILO          (0x2UL << 29)
+	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID_MAX_BW_BW_VALUE_UNIT_BASE          (0x4UL << 29)
+	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID_MAX_BW_BW_VALUE_UNIT_GIGA          (0x6UL << 29)
+	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID_MAX_BW_BW_VALUE_UNIT_PERCENT1_100  (0x1UL << 29)
+	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID_MAX_BW_BW_VALUE_UNIT_INVALID       (0x7UL << 29)
+	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID_MAX_BW_BW_VALUE_UNIT_LAST         QUEUE_COS2BW_QCFG_RESP_QUEUE_ID_MAX_BW_BW_VALUE_UNIT_INVALID
+		u8	queue_id_tsa_assign;
+	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID_TSA_ASSIGN_SP             0x0UL
+	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID_TSA_ASSIGN_ETS            0x1UL
+	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID_TSA_ASSIGN_RESERVED_FIRST 0x2UL
+	#define QUEUE_COS2BW_QCFG_RESP_QUEUE_ID_TSA_ASSIGN_RESERVED_LAST  0xffUL
+		u8	queue_id_pri_lvl;
+		u8	queue_id_bw_weight;
+	} __packed cfg[7];
 	u8	unused_2[4];
 	u8	valid;
 };


