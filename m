Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CABB62572
	for <patches@lists.linux.dev>; Tue, 18 Apr 2023 12:48:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3878FC4339C;
	Tue, 18 Apr 2023 12:48:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1681822124;
	bh=xtGEDVJm4OrHZzuvlFRTJ3y2iBEqnWKHjzoKnOyk48o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WrJTFeA3Va2u2aY86cjqElRdfvdvtSbwIDRZrVs5lYUpoGlVLkqbHVydlGnyloAfv
	 n1xIzO97CQqRo4zHqKgCLBJkN8WyNWm9xqoNJ4SwUu0NBp/IoLskAjvUhRFdxGD6uT
	 iZLUhdmP6dOkkcA9wpCufbRlWMdDjfgJWYY00bEM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mustafa Ismail <mustafa.ismail@intel.com>,
	Shiraz Saleem <shiraz.saleem@intel.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 031/139] RDMA/irdma: Do not generate SW completions for NOPs
Date: Tue, 18 Apr 2023 14:21:36 +0200
Message-Id: <20230418120314.809541111@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120313.725598495@linuxfoundation.org>
References: <20230418120313.725598495@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Mustafa Ismail <mustafa.ismail@intel.com>

[ Upstream commit 30ed9ee9a10a90ae719dcfcacead1d0506fa45ed ]

Currently, artificial SW completions are generated for NOP wqes which can
generate unexpected completions with wr_id = 0. Skip the generation of
artificial completions for NOPs.

Fixes: 81091d7696ae ("RDMA/irdma: Add SW mechanism to generate completions on error")
Signed-off-by: Mustafa Ismail <mustafa.ismail@intel.com>
Signed-off-by: Shiraz Saleem <shiraz.saleem@intel.com>
Link: https://lore.kernel.org/r/20230315145231.931-2-shiraz.saleem@intel.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/irdma/utils.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/irdma/utils.c b/drivers/infiniband/hw/irdma/utils.c
index 445e69e864097..7887230c867b1 100644
--- a/drivers/infiniband/hw/irdma/utils.c
+++ b/drivers/infiniband/hw/irdma/utils.c
@@ -2595,7 +2595,10 @@ void irdma_generate_flush_completions(struct irdma_qp *iwqp)
 			/* remove the SQ WR by moving SQ tail*/
 			IRDMA_RING_SET_TAIL(*sq_ring,
 				sq_ring->tail + qp->sq_wrtrk_array[sq_ring->tail].quanta);
-
+			if (cmpl->cpi.op_type == IRDMAQP_OP_NOP) {
+				kfree(cmpl);
+				continue;
+			}
 			ibdev_dbg(iwqp->iwscq->ibcq.device,
 				  "DEV: %s: adding wr_id = 0x%llx SQ Completion to list qp_id=%d\n",
 				  __func__, cmpl->cpi.wr_id, qp->qp_id);
-- 
2.39.2



