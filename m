Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 166823AE43
	for <patches@lists.linux.dev>; Wed,  7 Jun 2023 20:21:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C4D8C4339B;
	Wed,  7 Jun 2023 20:21:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686169318;
	bh=Jrf+GEyQ1Tyv50RydLT48oUtDbtGSFN8KoFbbN8d1uw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SBvYDJ1/BU6S8URe0+hJzl3qkas+JlaeteCiZFdMr1Cw/9F5saI4JjS8XbYAamuX8
	 6IGNi1gyn22gVhf+OlSAoPVlL32Jn+5rQqs+Jx+6Hxbilzqf8V8fmunIM8bOHSLTeq
	 A1BAHaXzAw1WyN2HPbdpIILwM9wcIs3JdS5s6T1c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Tudor Ambarus <tudor.ambarus@linaro.org>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 007/286] dmaengine: at_xdmac: fix potential Oops in at_xdmac_prep_interleaved()
Date: Wed,  7 Jun 2023 22:11:46 +0200
Message-ID: <20230607200923.237432720@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230607200922.978677727@linuxfoundation.org>
References: <20230607200922.978677727@linuxfoundation.org>
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
index 96f1b69f8a75e..ab13704f27f11 100644
--- a/drivers/dma/at_xdmac.c
+++ b/drivers/dma/at_xdmac.c
@@ -1102,6 +1102,8 @@ at_xdmac_prep_interleaved(struct dma_chan *chan,
 							NULL,
 							src_addr, dst_addr,
 							xt, xt->sgl);
+		if (!first)
+			return NULL;
 
 		/* Length of the block is (BLEN+1) microblocks. */
 		for (i = 0; i < xt->numf - 1; i++)
@@ -1132,8 +1134,9 @@ at_xdmac_prep_interleaved(struct dma_chan *chan,
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



