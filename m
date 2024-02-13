Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D1EBAD55;
	Tue, 13 Feb 2024 17:34:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707845651; cv=none; b=nvpS8WwH4j7G/z+52SqEU0rbRn6+L4th0kngy+3SSACpEPTjpGp9990reRYJoUsvMCdI4ONjb7aF+jeQBvwd9tgcs9kOEWR5jwlorOEWnRguZqkbg1a7R/H7QJPmyS11lohULhm1cIieMFmpicNs4oEag+89Hi6kvSD5Hpy6lkk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707845651; c=relaxed/simple;
	bh=gYiuDvXz4ewyjP/Oelc9uaM00JX312MstimiLdUVj00=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KjKas58QJxzJBK+csy7BUZ67uvVSAWiLHijncZwmZF3/UTQbcNy1v/h+8PTXonu1VM6NC+pq4M79gVIfY2XeXIINbXNiZNrOr8qD0G0YmA6uSt0aJJG5qYdyNhI7/vQWB1cdN1EqkVjOGosOuTrcriDfl5LWTmr4dpfNtDjostQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nLLvEG76; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nLLvEG76"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B1E2C433C7;
	Tue, 13 Feb 2024 17:34:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1707845650;
	bh=gYiuDvXz4ewyjP/Oelc9uaM00JX312MstimiLdUVj00=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nLLvEG76B2yESgulhah3YaO43QbuMT0FsZtOcWgl2gSqJjhJkaGwYflmpW2/Dp41l
	 TRk6HVelxVI+s/TU96kOjAvGHKw5IyNn0ftmfAfYuPuHEpw+4VSt8XktI/pCHdERhy
	 RI2Ad/mwFt/cjQeNGGgyldxfxNTBM8AFa7fsnLF0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guanhua Gao <guanhua.gao@nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 002/124] dmaengine: fsl-dpaa2-qdma: Fix the size of dma pools
Date: Tue, 13 Feb 2024 18:20:24 +0100
Message-ID: <20240213171853.798487576@linuxfoundation.org>
X-Mailer: git-send-email 2.43.1
In-Reply-To: <20240213171853.722912593@linuxfoundation.org>
References: <20240213171853.722912593@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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
index 7958ac33e36c..5a8061a307cd 100644
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



