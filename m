Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A02C01F95A
	for <patches@lists.linux.dev>; Tue,  1 Aug 2023 09:42:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21C88C433C8;
	Tue,  1 Aug 2023 09:42:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690882941;
	bh=P/civ6XNJrhtPRBxZ6s0TL04LScZyh6k5LLPhp3P6h4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CuugHrgE/LKZnm18vmc3Jr7COpcvTx0MnCUAEBSjF3XGu79eKmaLDV+XALXBSbTyD
	 eJvcjS9dVbDNFBTehAMQEEg8c2jRKU1Zb/nfBNaL10MIE7D1wBVQIGevYRiTcPHazt
	 /rvu3cp1G0N4soIETvMFG81oYO9VsB/CuF8SkVZE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Mukunda,Vijendar" <vijendar.mukunda@amd.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 057/239] soundwire: amd: Fix a check for errors in probe()
Date: Tue,  1 Aug 2023 11:18:41 +0200
Message-ID: <20230801091927.587431667@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230801091925.659598007@linuxfoundation.org>
References: <20230801091925.659598007@linuxfoundation.org>
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

[ Upstream commit 7891d0a5ce6f627132d3068ba925cf86f29008b1 ]

This code has two problems:
1) The devm_ioremap() function returns NULL, not error pointers.
2) It's checking the wrong variable.  ->mmio instead of ->acp_mmio.

Fixes: d8f48fbdfd9a ("soundwire: amd: Add support for AMD Manager driver")
Suggested-by: "Mukunda,Vijendar" <vijendar.mukunda@amd.com>
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Link: https://lore.kernel.org/r/9863b2bf-0de2-4bf8-8f09-fe24dc5c63ff@moroto.mountain
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soundwire/amd_manager.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/soundwire/amd_manager.c b/drivers/soundwire/amd_manager.c
index 9fb7f91ca1827..21c638e38c51f 100644
--- a/drivers/soundwire/amd_manager.c
+++ b/drivers/soundwire/amd_manager.c
@@ -910,9 +910,9 @@ static int amd_sdw_manager_probe(struct platform_device *pdev)
 		return -ENOMEM;
 
 	amd_manager->acp_mmio = devm_ioremap(dev, res->start, resource_size(res));
-	if (IS_ERR(amd_manager->mmio)) {
+	if (!amd_manager->acp_mmio) {
 		dev_err(dev, "mmio not found\n");
-		return PTR_ERR(amd_manager->mmio);
+		return -ENOMEM;
 	}
 	amd_manager->instance = pdata->instance;
 	amd_manager->mmio = amd_manager->acp_mmio +
-- 
2.39.2



