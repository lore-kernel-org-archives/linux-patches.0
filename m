Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D3FE42A9B;
	Tue, 27 May 2025 17:42:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748367735; cv=none; b=uQSAKis6t7FjCvDB9KeP9hBiOex77Q2kXzKOxj0HBz5YyPozgGveUcwDzeol5qNGCxV7357g4y6H8jvK2uG/x5rSoM0+/P/WStApMBTNxcVGOmLJWowz5/HOWCbdf68zbRR2KbOf8jUmB6TdhNAR67trDtWH3O1kanwXvDMN8F4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748367735; c=relaxed/simple;
	bh=MMawq7c+fsINb3YRTTGMqqQ4wRNqMvr6VMyJlSuGFv4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TPDT67OYnPYHGFp0Qi+lKHYVyeTOfYPIoak1WSVEmMkviI3Hsc8KsirQeVoObZ9pOcDTGoZeorkuXQ8u5h3pdDZjhGfD/Px8u1daTAp+Nxem0kW2tEIogYHRbJJJlicz8uG42gL15AS+AQlkZrqZFatWSucPhbKGbY8JvtgmfLE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oIXN4L+6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oIXN4L+6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D99A1C4CEE9;
	Tue, 27 May 2025 17:42:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748367735;
	bh=MMawq7c+fsINb3YRTTGMqqQ4wRNqMvr6VMyJlSuGFv4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oIXN4L+6cH0QfdHtlTLvP3LkM3EmtX0lBXBkXGsqe7GJxYKJTPZDlkfcNyzAloW2g
	 yJadXexFdzaJyB6aYveLowcE32pFyUbGqg78JlpAUMX27EJtBSv7n65S+nAINDwdWF
	 3PQF3sSNqhlkJjC2PwrNeBVJCzmE1ULuK3Vc8BVQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alain Volmat <alain.volmat@foss.st.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 452/783] media: stm32: csi: add missing pm_runtime_put on error
Date: Tue, 27 May 2025 18:24:09 +0200
Message-ID: <20250527162531.533775265@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alain Volmat <alain.volmat@foss.st.com>

[ Upstream commit f7cd9c94959e7a5b8c4eca33e20bd6ba1b048a64 ]

Within the stm32_csi_start function, pm_runtime_put should
be called upon error following pm_runtime_get_sync.
Rework the function error handling by putting a label in
order to have common error handling for all calls requiring
pm_runtime_put.

Signed-off-by: Alain Volmat <alain.volmat@foss.st.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/st/stm32/stm32-csi.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/media/platform/st/stm32/stm32-csi.c b/drivers/media/platform/st/stm32/stm32-csi.c
index a4f8db608cedd..0c776e4a7ce83 100644
--- a/drivers/media/platform/st/stm32/stm32-csi.c
+++ b/drivers/media/platform/st/stm32/stm32-csi.c
@@ -499,21 +499,19 @@ static int stm32_csi_start(struct stm32_csi_dev *csidev,
 
 	ret = pm_runtime_get_sync(csidev->dev);
 	if (ret < 0)
-		return ret;
+		goto error_put;
 
 	/* Retrieve CSI2PHY clock rate to compute CCFR value */
 	phy_clk_frate = clk_get_rate(csidev->clks[STM32_CSI_CLK_CSI2PHY].clk);
 	if (!phy_clk_frate) {
-		pm_runtime_put(csidev->dev);
 		dev_err(csidev->dev, "CSI2PHY clock rate invalid (0)\n");
-		return ret;
+		ret = -EINVAL;
+		goto error_put;
 	}
 
 	ret = stm32_csi_setup_lane_merger(csidev);
-	if (ret) {
-		pm_runtime_put(csidev->dev);
-		return ret;
-	}
+	if (ret)
+		goto error_put;
 
 	/* Enable the CSI */
 	writel_relaxed(STM32_CSI_CR_CSIEN, csidev->base + STM32_CSI_CR);
@@ -569,6 +567,10 @@ static int stm32_csi_start(struct stm32_csi_dev *csidev,
 	writel_relaxed(0, csidev->base + STM32_CSI_PMCR);
 
 	return ret;
+
+error_put:
+	pm_runtime_put(csidev->dev);
+	return ret;
 }
 
 static void stm32_csi_stop(struct stm32_csi_dev *csidev)
-- 
2.39.5



