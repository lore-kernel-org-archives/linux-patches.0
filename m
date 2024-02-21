Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 082B67EEE6;
	Wed, 21 Feb 2024 14:07:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708524450; cv=none; b=hi8tkhc3afrCfZFuqTZfS8AknL3s6o0PbUn0VC1acVLDlDLmVYcnCYmCZiZEKz0qwS026+2VizGorarG2wXSfU55Seg6cZ2luyU0fSmytOsJyTdsCnaSSV1WhdDeuOT+lxfTzrxlgTXG1yfvLUOz5CiqCWJSQscKhrbzUpW3B6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708524450; c=relaxed/simple;
	bh=IzgK1TKpoi8/UYjEu39AFgXeT9/f3x/gro6rDWyd5Tg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LART7Sg1SGyNU23wcPRd04cbuHboTrpk/h28yF/0Yy0VDAR9SySQX6w6qWvdWyWKh3xoLpLaEK+HZ/OATcO8VVHT2VW/1D96SdGJSCO6J8d6wYY+yZW9aUweyemzRqQPZ/5F6RYxiYLJgUCETOHSQtX/H+r1q+603E2/b1R4Ixg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x6VA30BZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x6VA30BZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 826E4C433C7;
	Wed, 21 Feb 2024 14:07:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708524449;
	bh=IzgK1TKpoi8/UYjEu39AFgXeT9/f3x/gro6rDWyd5Tg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x6VA30BZuAYwk6obVZoCf37Xv20U7KWNIunauYQbzzB8CRLXUYFHd4648u3Owvoky
	 PnZxAItCN0XiWrFMCE4jBnPe0cgRzk01cpC6E8Dvnrl9Rlc02mAeFeWRhr+Y3AfZkN
	 vqt/hJ9VvjqGxvc7f/QcL/ncJksRrvVMczfWFIk4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guanhua Gao <guanhua.gao@nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 246/379] dmaengine: fsl-dpaa2-qdma: Fix the size of dma pools
Date: Wed, 21 Feb 2024 14:07:05 +0100
Message-ID: <20240221130002.188050958@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125954.917878865@linuxfoundation.org>
References: <20240221125954.917878865@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guanhua Gao <guanhua.gao@nxp.com>

[ Upstream commit b73e43dcd7a8be26880ef8ff336053b29e79dbc5 ]

In case of long format of qDMA command descriptor, there are one frame
descriptor, three entries in the frame list and two data entries. So the
size of dma_pool_create for these three fields should be the same with
the total size of entries respectively, or the contents may be overwritten
by the next allocated descriptor.

Fixes: 7fdf9b05c73b ("dmaengine: fsl-dpaa2-qdma: Add NXP dpaa2 qDMA controller driver for Layerscape SoCs")
Signed-off-by: Guanhua Gao <guanhua.gao@nxp.com>
Signed-off-by: Frank Li <Frank.Li@nxp.com>
Link: https://lore.kernel.org/r/20240118162917.2951450-1-Frank.Li@nxp.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/fsl-dpaa2-qdma/dpaa2-qdma.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/dma/fsl-dpaa2-qdma/dpaa2-qdma.c b/drivers/dma/fsl-dpaa2-qdma/dpaa2-qdma.c
index 4ae057922ef1..2d905f0633d5 100644
--- a/drivers/dma/fsl-dpaa2-qdma/dpaa2-qdma.c
+++ b/drivers/dma/fsl-dpaa2-qdma/dpaa2-qdma.c
@@ -38,15 +38,17 @@ static int dpaa2_qdma_alloc_chan_resources(struct dma_chan *chan)
 	if (!dpaa2_chan->fd_pool)
 		goto err;
 
-	dpaa2_chan->fl_pool = dma_pool_create("fl_pool", dev,
-					      sizeof(struct dpaa2_fl_entry),
-					      sizeof(struct dpaa2_fl_entry), 0);
+	dpaa2_chan->fl_pool =
+		dma_pool_create("fl_pool", dev,
+				 sizeof(struct dpaa2_fl_entry) * 3,
+				 sizeof(struct dpaa2_fl_entry), 0);
+
 	if (!dpaa2_chan->fl_pool)
 		goto err_fd;
 
 	dpaa2_chan->sdd_pool =
 		dma_pool_create("sdd_pool", dev,
-				sizeof(struct dpaa2_qdma_sd_d),
+				sizeof(struct dpaa2_qdma_sd_d) * 2,
 				sizeof(struct dpaa2_qdma_sd_d), 0);
 	if (!dpaa2_chan->sdd_pool)
 		goto err_fl;
-- 
2.43.0



