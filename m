Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F34325DAE8;
	Tue, 11 Mar 2025 15:06:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741705567; cv=none; b=u/mt/HodTLD7IwAueiS/r1KMrnG6mT+3eXBqOKozQwYyFGM3PyiCI3cEqzDyLxjNajvoOum2tiC0TOt6KuRDumAZimi2TdQCQRKS0kkK+79+vQQ3y7fyC9HFFZtxqfLTlLSjdF7+sxgG2HDWSfiL0psChdCfqWWNtnHvCvW373U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741705567; c=relaxed/simple;
	bh=vQzrv8nD1EUn8FS/g6xgfli8sroI01FCDsrJataKlMY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ik/6DaNGf4j9GxMuVW2drLoyoVs0FfgT0DQOOoDQ7wsB2snUG6KLos8LmkCay4M1ZGgXUB6STu8p8zuEXSdgrr3Tpc03LlMLIizzb2t5SxzaAjUtY7W9TNoaDBTkLBGzkCLDyN0a2/GT7tI5LOteJMAB22917msbGfWCzhdZV/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xEkqm6Wi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xEkqm6Wi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17D0FC4CEE9;
	Tue, 11 Mar 2025 15:06:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741705567;
	bh=vQzrv8nD1EUn8FS/g6xgfli8sroI01FCDsrJataKlMY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xEkqm6Wi7ftEc41nWFRKWseS8TdS0/5CKRKwk7BfF2+g0EWgyVKowk2WM6vch0jw1
	 yb/SGX+CU1+re9/XRGjwkJgSqejVxmJbkMo4b98FhZcLZnjiZ0TObsYN5xBHShhxef
	 IpPv9E0WXDNtlbqMauQjMk/5V6PPN/i9f8qLDiqY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 060/328] dmaengine: ti: edma: fix OF node reference leaks in edma_driver
Date: Tue, 11 Mar 2025 15:57:10 +0100
Message-ID: <20250311145717.282034579@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145714.865727435@linuxfoundation.org>
References: <20250311145714.865727435@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index b570f08888eeb..01089e5c565f3 100644
--- a/drivers/dma/ti/edma.c
+++ b/drivers/dma/ti/edma.c
@@ -217,7 +217,6 @@ struct edma_desc {
 struct edma_cc;
 
 struct edma_tc {
-	struct device_node		*node;
 	u16				id;
 };
 
@@ -2414,13 +2413,13 @@ static int edma_probe(struct platform_device *pdev)
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
 	}
 
-- 
2.39.5



