Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 846DF200A6
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 19:00:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07A66C433CA;
	Fri, 21 Jul 2023 19:00:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689966021;
	bh=Q4Sz475iDA4jrj2RyguwdxMDlpSpNrT+l6eb4nIrUGo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ak2627msGMFgAhBVGIKSvP5BSJevGW6yxHmQTkPxS3iY0PyDNtkVczZrHg9j4oU06
	 HB8HAez0TPNhFMCiBuMux0lMt4i5LXuE6UcK5FLBVswoe8Cjd6TLhrVFQZefzLcex3
	 pE9o2F9g8vRolJyaRBobgRYAsDk8kYQxnT9CH5Q4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kashyap Desai <kashyap.desai@broadcom.com>,
	Selvin Xavier <selvin.xavier@broadcom.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 169/532] RDMA/bnxt_re: wraparound mbox producer index
Date: Fri, 21 Jul 2023 18:01:13 +0200
Message-ID: <20230721160623.565291526@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160614.695323302@linuxfoundation.org>
References: <20230721160614.695323302@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Kashyap Desai <kashyap.desai@broadcom.com>

[ Upstream commit 0af91306e17ef3d18e5f100aa58aa787869118af ]

Driver is not handling the wraparound of the mbox producer index correctly.
Currently the wraparound happens once u32 max is reached.

Bit 31 of the producer index register is special and should be set
only once for the first command. Because the producer index overflow
setting bit31 after a long time, FW goes to initialization sequence
and this causes FW hang.

Fix is to wraparound the mbox producer index once it reaches u16 max.

Fixes: cee0c7bba486 ("RDMA/bnxt_re: Refactor command queue management code")
Fixes: 1ac5a4047975 ("RDMA/bnxt_re: Add bnxt_re RoCE driver")
Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
Signed-off-by: Selvin Xavier <selvin.xavier@broadcom.com>
Link: https://lore.kernel.org/r/1686308514-11996-2-git-send-email-selvin.xavier@broadcom.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/bnxt_re/qplib_rcfw.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/bnxt_re/qplib_rcfw.c b/drivers/infiniband/hw/bnxt_re/qplib_rcfw.c
index d72f36d2bd496..abeee7cc7dc6d 100644
--- a/drivers/infiniband/hw/bnxt_re/qplib_rcfw.c
+++ b/drivers/infiniband/hw/bnxt_re/qplib_rcfw.c
@@ -181,7 +181,7 @@ static int __send_message(struct bnxt_qplib_rcfw *rcfw, struct cmdq_base *req,
 	} while (size > 0);
 	cmdq->seq_num++;
 
-	cmdq_prod = hwq->prod;
+	cmdq_prod = hwq->prod & 0xFFFF;
 	if (test_bit(FIRMWARE_FIRST_FLAG, &cmdq->flags)) {
 		/* The very first doorbell write
 		 * is required to set this flag
@@ -599,7 +599,7 @@ int bnxt_qplib_alloc_rcfw_channel(struct bnxt_qplib_res *res,
 		rcfw->cmdq_depth = BNXT_QPLIB_CMDQE_MAX_CNT_8192;
 
 	sginfo.pgsize = bnxt_qplib_cmdqe_page_size(rcfw->cmdq_depth);
-	hwq_attr.depth = rcfw->cmdq_depth;
+	hwq_attr.depth = rcfw->cmdq_depth & 0x7FFFFFFF;
 	hwq_attr.stride = BNXT_QPLIB_CMDQE_UNITS;
 	hwq_attr.type = HWQ_TYPE_CTX;
 	if (bnxt_qplib_alloc_init_hwq(&cmdq->hwq, &hwq_attr)) {
-- 
2.39.2



