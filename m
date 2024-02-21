Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 301903FB21;
	Wed, 21 Feb 2024 13:44:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708523078; cv=none; b=SR1+NmhPbl9/zSGEZ6GeAjzCH264VaWtXF29N/oWKW6n9NxVF9fYKNufwkgmkykttrJdDSSHp9w+ZjEZ8xbUPeGRP2ZLUkbnwDX+R9IMQN0tqt3nKEYj1YoSAu/zTGqUkepYz2ry/KttsV6hwNOr0Ni3oZzM9n6YZQmCxlBTIMg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708523078; c=relaxed/simple;
	bh=kgLDBdi3bYt4GT8N9V4QxiBW+HO7WCcwUsM6B3eeeSU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hlqSKlM2Rm8l81XqTObDu7o/v8q/uJ1MaodcAhbzlRwj/mwOCBY5yAt4mLhFOhgiCcC0t6gHMhDTN0PZvP2iH5BNlt2C9sss544hdyQJQZYr95xRX+2aAtc9pHY8tVN9iQUpmzkYGgTT2qUz0AqPyYuVfML+nok0FcDg8/yVXsM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PHxT3RU9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PHxT3RU9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB919C433F1;
	Wed, 21 Feb 2024 13:44:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708523078;
	bh=kgLDBdi3bYt4GT8N9V4QxiBW+HO7WCcwUsM6B3eeeSU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PHxT3RU9ziy+vClU0hanGxjH5B5vcJDoj74x6MX8J2bW9xe660P0zNdCZK4/NwMnL
	 /A35dxbt1k24HXYamEKTDOg7Ia6NQw4dLCxWwUEawoIgImB3MrauneTMJmK6phe+J5
	 JtnGUXcgPD0ZkN3qNW21nYqKIZ18yUZHxNnvRZWc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guanhua Gao <guanhua.gao@nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 296/476] dmaengine: fsl-dpaa2-qdma: Fix the size of dma pools
Date: Wed, 21 Feb 2024 14:05:47 +0100
Message-ID: <20240221130018.946047015@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221130007.738356493@linuxfoundation.org>
References: <20240221130007.738356493@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



