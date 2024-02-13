Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 815935FDD7;
	Tue, 13 Feb 2024 17:23:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707845010; cv=none; b=kFxR3XZfKn/pleeyMIcfv/QNlggfORMwYqpyi2E22ue/CQDS1O5qEzWT7qL7zqgAAepdNPzMbsFawBPF27eM3The3+L0wazj2YKQUmOZzPFv+fP49rqenlJvVYnJfe2/5rbYbFf2MFju+SduKL7EyRgLmWNxVnzcxa6FL949d7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707845010; c=relaxed/simple;
	bh=QtLEdwc1BwNIApD42AkMlF1m2lxlLJRFBke0H0nY7jE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JdWf8Hz7bD+MHue7vVntxDJfoIrLyYOiG3jtAjFFnc6TPjLD46J1horGOZnj3glFLYMN+QjojFtgtwWjfx13p9KZNWTBcSB5ECRQQ0vKukbNZQCKotF85xZnuB2Si4u6+Z4S0dqMaLeEfQaIyJNj5AETsy+YXNnICmTbwWnhdA4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LzCPnBf1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LzCPnBf1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81C76C433C7;
	Tue, 13 Feb 2024 17:23:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1707845010;
	bh=QtLEdwc1BwNIApD42AkMlF1m2lxlLJRFBke0H0nY7jE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LzCPnBf1/0o+R8V1b0J/qlD9KmX29Z0e+9SUnVoZ3JpNG2vrgG7NflrQOI67wMWVN
	 5B+wbbteMogKsTRNj7hCqz/etINjotKcJYzqpfdxDa0A3aZGjAjZI2HQVQ0/dFh0YU
	 WMSCis/u93PUu9yC/pkK0XYhivP5lz7UIe5NTvHI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guanhua Gao <guanhua.gao@nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 02/64] dmaengine: fsl-dpaa2-qdma: Fix the size of dma pools
Date: Tue, 13 Feb 2024 18:20:48 +0100
Message-ID: <20240213171844.797348933@linuxfoundation.org>
X-Mailer: git-send-email 2.43.1
In-Reply-To: <20240213171844.702064831@linuxfoundation.org>
References: <20240213171844.702064831@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 8dd40d00a672..6b829d347417 100644
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



