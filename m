Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2780E17C7CA;
	Wed,  5 Feb 2025 15:10:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738768260; cv=none; b=FX/JUFE1eDHPxArAypcODqpV87p+HlFsysHt3asxMmgbAz7lR1jiZaT4+o52jq1Te5kQnbyXDy6r7MY0X46RDMOzNvTEW8bNPruHepIY/VUYU/izpcCdGU4lp9qGfVUFwBQtPtQawEF8Gyny1GYRRvUVgbDO97cF+/I28pxpJ2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738768260; c=relaxed/simple;
	bh=KRS1W24znUGQyAVfAheqUKkK3vVElW2BoKMHWrFu88o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tH0bHr+IFjIvyYThKpmRg8rIwRtn0D24Ly9G7E13xf+iS2110Ew+w/QHW53bc4uqxVQvV0GCGzxEK1T7F/YAHyO7rBYB6GFRotZWI28E+EPN8vNe83ttS3YZtwVy85wum9uThxegSJHkV0x8D4eTIsmbB2/AN6TB+olYHXZTNVI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L2G3BGdy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L2G3BGdy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18F76C4CEDD;
	Wed,  5 Feb 2025 15:10:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738768259;
	bh=KRS1W24znUGQyAVfAheqUKkK3vVElW2BoKMHWrFu88o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L2G3BGdygqmd1t32GMBLvlTb5ZjBd6lIT6ZbwpaxTLePs+sDr29+hczhzI2WFBKKe
	 zHtmfM2pfXZ+B61wBtB69tyP+/BUIr2cCxDV2/bZIXTdVep/qCgi6V0OgYntzaFIF4
	 J4xcyIsFmX6qfTWPAPa5GzPreqxmGK7zglRoX1cA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 496/623] dmaengine: ti: edma: fix OF node reference leaks in edma_driver
Date: Wed,  5 Feb 2025 14:43:58 +0100
Message-ID: <20250205134515.191751823@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>

[ Upstream commit e883c64778e5a9905fce955681f8ee38c7197e0f ]

The .probe() of edma_driver calls of_parse_phandle_with_fixed_args() but
does not release the obtained OF nodes. Thus add a of_node_put() call.

This bug was found by an experimental verification tool that I am
developing.

Fixes: 1be5336bc7ba ("dmaengine: edma: New device tree binding")
Signed-off-by: Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>
Reviewed-by: Dan Carpenter <dan.carpenter@linaro.org>
Link: https://lore.kernel.org/r/20241219020507.1983124-3-joe@pf.is.s.u-tokyo.ac.jp
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/ti/edma.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/dma/ti/edma.c b/drivers/dma/ti/edma.c
index 343e986e66e7c..171ab16840267 100644
--- a/drivers/dma/ti/edma.c
+++ b/drivers/dma/ti/edma.c
@@ -208,7 +208,6 @@ struct edma_desc {
 struct edma_cc;
 
 struct edma_tc {
-	struct device_node		*node;
 	u16				id;
 };
 
@@ -2466,13 +2465,13 @@ static int edma_probe(struct platform_device *pdev)
 			if (ret || i == ecc->num_tc)
 				break;
 
-			ecc->tc_list[i].node = tc_args.np;
 			ecc->tc_list[i].id = i;
 			queue_priority_mapping[i][1] = tc_args.args[0];
 			if (queue_priority_mapping[i][1] > lowest_priority) {
 				lowest_priority = queue_priority_mapping[i][1];
 				info->default_queue = i;
 			}
+			of_node_put(tc_args.np);
 		}
 
 		/* See if we have optional dma-channel-mask array */
-- 
2.39.5



