Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED6FE28EB
	for <patches@lists.linux.dev>; Mon, 30 Jan 2023 13:54:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61786C433D2;
	Mon, 30 Jan 2023 13:54:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675086878;
	bh=VvIdiigehAz4PxJOaDkEDsq4A8cHs3gn6LdfPo6Cieg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l/NOPqDAHjQ7gpMW2YW6A9/YbM2O/b0eSVk/I8FXZur78wklFCvcBN0HyXNzwYlRw
	 24QoP20UZQB/W/3sUpMKHbM0wIkFP0dXLoOp2/kA+hi2ucEsGlP/CIozfKrzy/MyJ2
	 J/fOW4YUxvlCRL/6BErExsHp0Wpjl33F5codI4lo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miaoqian Lin <linmq006@gmail.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Andre Przywara <andre.przywara@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 026/313] EDAC/highbank: Fix memory leak in highbank_mc_probe()
Date: Mon, 30 Jan 2023 14:47:41 +0100
Message-Id: <20230130134337.876851199@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134336.532886729@linuxfoundation.org>
References: <20230130134336.532886729@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Miaoqian Lin <linmq006@gmail.com>

[ Upstream commit e7a293658c20a7945014570e1921bf7d25d68a36 ]

When devres_open_group() fails, it returns -ENOMEM without freeing memory
allocated by edac_mc_alloc().

Call edac_mc_free() on the error handling path to avoid a memory leak.

  [ bp: Massage commit message. ]

Fixes: a1b01edb2745 ("edac: add support for Calxeda highbank memory controller")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Reviewed-by: Andre Przywara <andre.przywara@arm.com>
Link: https://lore.kernel.org/r/20221229054825.1361993-1-linmq006@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/edac/highbank_mc_edac.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/edac/highbank_mc_edac.c b/drivers/edac/highbank_mc_edac.c
index 61b76ec226af..19fba258ae10 100644
--- a/drivers/edac/highbank_mc_edac.c
+++ b/drivers/edac/highbank_mc_edac.c
@@ -174,8 +174,10 @@ static int highbank_mc_probe(struct platform_device *pdev)
 	drvdata = mci->pvt_info;
 	platform_set_drvdata(pdev, mci);
 
-	if (!devres_open_group(&pdev->dev, NULL, GFP_KERNEL))
-		return -ENOMEM;
+	if (!devres_open_group(&pdev->dev, NULL, GFP_KERNEL)) {
+		res = -ENOMEM;
+		goto free;
+	}
 
 	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (!r) {
@@ -243,6 +245,7 @@ static int highbank_mc_probe(struct platform_device *pdev)
 	edac_mc_del_mc(&pdev->dev);
 err:
 	devres_release_group(&pdev->dev, NULL);
+free:
 	edac_mc_free(mci);
 	return res;
 }
-- 
2.39.0



