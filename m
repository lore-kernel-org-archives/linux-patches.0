Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F352210FF
	for <patches@lists.linux.dev>; Mon,  6 Nov 2023 13:23:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SXE17PUp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BD4CC433C8;
	Mon,  6 Nov 2023 13:23:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1699276993;
	bh=5vspVQh9289/zAt2JcwdRduHtWRltcEMeWbIUw8pDDM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SXE17PUp/JNybxfiJ4ZGf932zaRooe5M/YT5W0xhDUFIsCmQVSScz1UuJA/hM7v/J
	 1HG2xeYdGjl3JDIOwphBe/nXExxUOf/+1oBXfyAAt02XuJEb9/PC5H/WFgVvZoQuOS
	 qtDFe0H6qcOfEgpq8ZX/F4tVcAXuD2PyXQE/HUgs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Shurong <zhang_shurong@foxmail.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 53/74] dmaengine: ste_dma40: Fix PM disable depth imbalance in d40_probe
Date: Mon,  6 Nov 2023 14:04:13 +0100
Message-ID: <20231106130303.556021099@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231106130301.687882731@linuxfoundation.org>
References: <20231106130301.687882731@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhang Shurong <zhang_shurong@foxmail.com>

[ Upstream commit 0618c077a8c20e8c81e367988f70f7e32bb5a717 ]

The pm_runtime_enable will increase power disable depth. Thus
a pairing decrement is needed on the error handling path to
keep it balanced according to context.
We fix it by calling pm_runtime_disable when error returns.

Signed-off-by: Zhang Shurong <zhang_shurong@foxmail.com>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Link: https://lore.kernel.org/r/tencent_DD2D371DB5925B4B602B1E1D0A5FA88F1208@qq.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/ste_dma40.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
index 96a808b487cbe..fa0ad8581edcc 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -3700,6 +3700,7 @@ static int __init d40_probe(struct platform_device *pdev)
 		regulator_disable(base->lcpa_regulator);
 		regulator_put(base->lcpa_regulator);
 	}
+	pm_runtime_disable(base->dev);
 
 	kfree(base->lcla_pool.alloc_map);
 	kfree(base->lookup_log_chans);
-- 
2.42.0



