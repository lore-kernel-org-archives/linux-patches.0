Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D363770825;
	Wed,  5 Feb 2025 14:32:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738765976; cv=none; b=TafV6tODDvFEFaFnnp1nIT1dvfM4sXnpJpVLcqh3+TG0K80e7J97Dqczp+44JZp8a6VG8nmisFPlnuFqAy8ACOBr66u73MT2i7qHieMnPZR4gSz6L2P1AK+sy89yqtmOwDgLdfbFCnxtSVaY1cmd2WZeWQyPKeE6JXTusyDBkI4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738765976; c=relaxed/simple;
	bh=uqfDunJxGxYzxh0fKejcCg4IFFEnKUm8CxMZQ63JFwM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FUpkA90+uqYQCFTmUplAeyL8TDDY90kzRstp/xAU5eAy25tfR/2Ipvj3pXgHAZ3628AJWXDgJ0ZQ2YucADZwtnON22U48DpJOS/i3Hu+z++trsVKv39oQdrOad45SrX5xe9ski3VLLTjfpOGCJNuW2eaXk1eqxq305qBp9+3aw0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Wfyk58Tf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Wfyk58Tf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 475D0C4CED1;
	Wed,  5 Feb 2025 14:32:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738765976;
	bh=uqfDunJxGxYzxh0fKejcCg4IFFEnKUm8CxMZQ63JFwM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Wfyk58TfcT+YwElKxB4RFV1Ja07oFa5/MwfJQ6geZDI0oFn9HUIX51v3bYEkGcFwg
	 bXiDds+48wAV0HFMbk75970CVqeycLY9BGAD2EDOASyODxkNckk4sDQmqdiv4InNJg
	 j2i5aCswGvHrBU2TnKaNSj9oEgdJZ3zFMNUH3vF8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 317/393] dmaengine: ti: edma: fix OF node reference leaks in edma_driver
Date: Wed,  5 Feb 2025 14:43:56 +0100
Message-ID: <20250205134432.443937792@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134420.279368572@linuxfoundation.org>
References: <20250205134420.279368572@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 155c409d2b434..c0fa541324675 100644
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



