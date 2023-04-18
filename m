Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 645292572
	for <patches@lists.linux.dev>; Tue, 18 Apr 2023 12:42:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC7DEC433EF;
	Tue, 18 Apr 2023 12:42:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1681821773;
	bh=UcBb1SWicVyObsSsbRP82R/JZQRp+GrhRSQRf86ymKE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nwxGs0w2JoQ/s0DV4bbI0jXb4O41s77dR3UjScpYIO0fDeDPVHNR+8TUoRNIqW7Qg
	 8pLNmWMK+LTD7znTbyQTmHpWXNko3GV56xg+DAEchrOvnyORSim/TPyFhEv8WO0Ofi
	 LoG3jrOxQCfo7kMEiCDXZ8c7iLsPK5ebZ69MUv3k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cheng Xu <chengyou@linux.alibaba.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 035/134] RDMA/erdma: Inline mtt entries into WQE if supported
Date: Tue, 18 Apr 2023 14:21:31 +0200
Message-Id: <20230418120314.184718272@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120313.001025904@linuxfoundation.org>
References: <20230418120313.001025904@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Cheng Xu <chengyou@linux.alibaba.com>

[ Upstream commit 0dd83a4d7756713f81990d6c5547500f212a1190 ]

The max inline mtt count supported is ERDMA_MAX_INLINE_MTT_ENTRIES.
When mr->mem.mtt_nents == ERDMA_MAX_INLINE_MTT_ENTRIES, inline mtt
is also supported, fix it.

Fixes: 155055771704 ("RDMA/erdma: Add verbs implementation")
Signed-off-by: Cheng Xu <chengyou@linux.alibaba.com>
Link: https://lore.kernel.org/r/20230320084652.16807-4-chengyou@linux.alibaba.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/erdma/erdma_qp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/erdma/erdma_qp.c b/drivers/infiniband/hw/erdma/erdma_qp.c
index 5fe1a339a4354..e3b0baa703e68 100644
--- a/drivers/infiniband/hw/erdma/erdma_qp.c
+++ b/drivers/infiniband/hw/erdma/erdma_qp.c
@@ -402,7 +402,7 @@ static int erdma_push_one_sqe(struct erdma_qp *qp, u16 *pi,
 			FIELD_PREP(ERDMA_SQE_MR_MTT_CNT_MASK,
 				   mr->mem.mtt_nents);
 
-		if (mr->mem.mtt_nents < ERDMA_MAX_INLINE_MTT_ENTRIES) {
+		if (mr->mem.mtt_nents <= ERDMA_MAX_INLINE_MTT_ENTRIES) {
 			attrs |= FIELD_PREP(ERDMA_SQE_MR_MTT_TYPE_MASK, 0);
 			/* Copy SGLs to SQE content to accelerate */
 			memcpy(get_queue_entry(qp->kern_qp.sq_buf, idx + 1,
-- 
2.39.2



