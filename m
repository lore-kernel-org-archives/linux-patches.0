Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2787D3BFE43;
	Thu, 15 Jan 2026 17:30:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768498244; cv=none; b=tsMcy8KQSYmwM0peehMKeH/lxtn/nzweqRo/skRp7BPTrODlj3pJhgiB/U/j3nhHdvYSz88toRkFoqVbS40NRV/LCJyr90weV95p9tZ8K6hGx4uF8XKI+LFQtpaDs3SLGjcMKwP6FI7FS7dOlSqMvzcxRcB/02adMwxlOy5Ul4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768498244; c=relaxed/simple;
	bh=ZDVP3Sp3LVi5oBtCP9ItiaHneJVqGghyeECTbqRKSb4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IW3JBCLEc6jwOY9jnQV3t9eg2p9FF9FnS1WM71Q72FYpkiRg7yK99UgqUi5U52Vrs9yFCITqf8vwZGmjYnMpmmAI9ygwE63DmgdAmAU9abn/e4WhibXbY1GqO8M9YQk9I28DqhaPQgzfbmRbQKps+7oNim027/vMi4/NppLNqFQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hKe/3LzE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hKe/3LzE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80569C116D0;
	Thu, 15 Jan 2026 17:30:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768498243;
	bh=ZDVP3Sp3LVi5oBtCP9ItiaHneJVqGghyeECTbqRKSb4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hKe/3LzEgp4kuqVYYvqpmliGlNhTVbFzyzv4F2ytVUktM/XfYZqbsxbmhKSPnHio1
	 g2SIm/7WfORSLzitNtiQZdBRqm4xet+5FhfS+EvAh1s5Q0lFm14NSh86VwsidIQwHI
	 GqEHoC3htYadWkBYVqeQG/J9HueCjZME/QOALV+8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alok Tiwari <alok.a.tiwari@oracle.com>,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 364/554] RDMA/bnxt_re: Fix IB_SEND_IP_CSUM handling in post_send
Date: Thu, 15 Jan 2026 17:47:10 +0100
Message-ID: <20260115164259.403107984@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alok Tiwari <alok.a.tiwari@oracle.com>

[ Upstream commit f01765a2361323e78e3d91b1cb1d5527a83c5cf7 ]

The bnxt_re SEND path checks wr->send_flags to enable features such as
IP checksum offload. However, send_flags is a bitmask and may contain
multiple flags (e.g. IB_SEND_SIGNALED | IB_SEND_IP_CSUM), while the
existing code uses a switch() statement that only matches when
send_flags is exactly IB_SEND_IP_CSUM.

As a result, checksum offload is not enabled when additional SEND
flags are present.

Replace the switch() with a bitmask test:

    if (wr->send_flags & IB_SEND_IP_CSUM)

This ensures IP checksum offload is enabled correctly when multiple
SEND flags are used.

Fixes: 1ac5a4047975 ("RDMA/bnxt_re: Add bnxt_re RoCE driver")
Signed-off-by: Alok Tiwari <alok.a.tiwari@oracle.com>
Link: https://patch.msgid.link/20251219093308.2415620-1-alok.a.tiwari@oracle.com
Reviewed-by: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/bnxt_re/ib_verbs.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/infiniband/hw/bnxt_re/ib_verbs.c b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
index cb733fc497c8..83bc013c8f79 100644
--- a/drivers/infiniband/hw/bnxt_re/ib_verbs.c
+++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
@@ -2644,14 +2644,9 @@ int bnxt_re_post_send(struct ib_qp *ib_qp, const struct ib_send_wr *wr,
 				wqe.rawqp1.lflags |=
 					SQ_SEND_RAWETH_QP1_LFLAGS_ROCE_CRC;
 			}
-			switch (wr->send_flags) {
-			case IB_SEND_IP_CSUM:
+			if (wr->send_flags & IB_SEND_IP_CSUM)
 				wqe.rawqp1.lflags |=
 					SQ_SEND_RAWETH_QP1_LFLAGS_IP_CHKSUM;
-				break;
-			default:
-				break;
-			}
 			fallthrough;
 		case IB_WR_SEND_WITH_INV:
 			rc = bnxt_re_build_send_wqe(qp, wr, &wqe);
-- 
2.51.0



