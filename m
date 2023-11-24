Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 931B52C87B;
	Fri, 24 Nov 2023 18:57:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aRwl1Kzf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20D61C433C8;
	Fri, 24 Nov 2023 18:57:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700852261;
	bh=oVSenwr5DPQFSZmCu/ScwD1aL0YPtngCkNORLgmTCDs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aRwl1KzfWFN1UsAYmLiNz6zawjZ3c159qgrj4TigiItd9sbsANWFcqU2KJSn9IhDK
	 750+IBzcNSAi9XhYN0SszdtCYByBtId+8qcgMu7We2ek28AX3bzewL7yEgGp9NJLcD
	 vT9cbWHQvOpK+H5dYxZJew9F9xKEPjq5jTIWwP18=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengfei Li <pengfei.li_1@nxp.com>,
	Emil Kronborg <emil.kronborg@protonmail.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 285/372] pmdomain: imx: Make imx pgc power domain also set the fwnode
Date: Fri, 24 Nov 2023 17:51:12 +0000
Message-ID: <20231124172019.932503678@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172010.413667921@linuxfoundation.org>
References: <20231124172010.413667921@linuxfoundation.org>
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

From: Pengfei Li <pengfei.li_1@nxp.com>

[ Upstream commit 374de39d38f97b0e58cfee88da590b2d056ccf7f ]

Currently, The imx pgc power domain doesn't set the fwnode
pointer, which results in supply regulator device can't get
consumer imx pgc power domain device from fwnode when creating
a link.

This causes the driver core to instead try to create a link
between the parent gpc device of imx pgc power domain device and
supply regulator device. However, at this point, the gpc device
has already been bound, and the link creation will fail. So adding
the fwnode pointer to the imx pgc power domain device will fix
this issue.

Signed-off-by: Pengfei Li <pengfei.li_1@nxp.com>
Tested-by: Emil Kronborg <emil.kronborg@protonmail.com>
Fixes: 3fb16866b51d ("driver core: fw_devlink: Make cycle detection more robust")
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20231020185949.537083-1-pengfei.li_1@nxp.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/imx/gpc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/soc/imx/gpc.c b/drivers/soc/imx/gpc.c
index 90a8b2c0676ff..419ed15cc10c4 100644
--- a/drivers/soc/imx/gpc.c
+++ b/drivers/soc/imx/gpc.c
@@ -498,6 +498,7 @@ static int imx_gpc_probe(struct platform_device *pdev)
 
 			pd_pdev->dev.parent = &pdev->dev;
 			pd_pdev->dev.of_node = np;
+			pd_pdev->dev.fwnode = of_fwnode_handle(np);
 
 			ret = platform_device_add(pd_pdev);
 			if (ret) {
-- 
2.42.0



