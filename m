Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2896C19E48
	for <patches@lists.linux.dev>; Wed,  7 Jun 2023 20:38:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E399C433EF;
	Wed,  7 Jun 2023 20:38:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686170283;
	bh=BiGCMNhMw41EXWmKbjiVcXk2i27aCFe7JMZIed8+vQ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DU8skG+CRs6os2/0fuAcYNgD0zQJA2FZRusM79FWzEJckSU1b+8zX35vl2jJhtud6
	 vEqClxx6DI3HX4+gZ4K9aqW8HvQl/k/oCcQUaKtg3LhkhQ/lUtabEx+XV/gnC4Vlm8
	 rAgzuWteAF9dswUeV6W0bXAhuFBSU7Bg2gIlBco0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Tudor Ambarus <tudor.ambarus@linaro.org>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 007/225] dmaengine: at_xdmac: fix potential Oops in at_xdmac_prep_interleaved()
Date: Wed,  7 Jun 2023 22:13:20 +0200
Message-ID: <20230607200913.578993091@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230607200913.334991024@linuxfoundation.org>
References: <20230607200913.334991024@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit 4d43acb145c363626d76f49febb4240c488cd1cf ]

There are two place if the at_xdmac_interleaved_queue_desc() fails which
could lead to a NULL dereference where "first" is NULL and we call
list_add_tail(&first->desc_node, ...).  In the first caller, the return
is not checked so add a check for that.  In the next caller, the return
is checked but if it fails on the first iteration through the loop then
it will lead to a NULL pointer dereference.

Fixes: 4e5385784e69 ("dmaengine: at_xdmac: handle numf > 1")
Fixes: 62b5cb757f1d ("dmaengine: at_xdmac: fix memory leak in interleaved mode")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Reviewed-by: Tudor Ambarus <tudor.ambarus@linaro.org>
Link: https://lore.kernel.org/r/21282b66-9860-410a-83df-39c17fcf2f1b@kili.mountain
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/at_xdmac.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/dma/at_xdmac.c b/drivers/dma/at_xdmac.c
index bfc8ae2143957..7919906b02e74 100644
--- a/drivers/dma/at_xdmac.c
+++ b/drivers/dma/at_xdmac.c
@@ -1026,6 +1026,8 @@ at_xdmac_prep_interleaved(struct dma_chan *chan,
 							NULL,
 							src_addr, dst_addr,
 							xt, xt->sgl);
+		if (!first)
+			return NULL;
 
 		/* Length of the block is (BLEN+1) microblocks. */
 		for (i = 0; i < xt->numf - 1; i++)
@@ -1056,8 +1058,9 @@ at_xdmac_prep_interleaved(struct dma_chan *chan,
 							       src_addr, dst_addr,
 							       xt, chunk);
 			if (!desc) {
-				list_splice_tail_init(&first->descs_list,
-						      &atchan->free_descs_list);
+				if (first)
+					list_splice_tail_init(&first->descs_list,
+							      &atchan->free_descs_list);
 				return NULL;
 			}
 
-- 
2.39.2



