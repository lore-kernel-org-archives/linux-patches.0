Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DE5E1171A
	for <patches@lists.linux.dev>; Mon, 21 Aug 2023 20:07:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69F05C433C7;
	Mon, 21 Aug 2023 20:07:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1692648435;
	bh=uzlnNqGnx8FeAVZGbYGkTuzoNAkGYYuTZCLj/Dhrq3w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DaURMkk1NUI+vbtIYd6wkWOGbd0A9HFGbAzn6hxsILKUNy9VejLTKllzLWsERUOSl
	 ftQRFeZLiKFD/RZVv9EP7ipqtgP/MVopEV32mlKXApgun88XTDqnejILVTONjBvfRh
	 j/IZZLJjkoHdbSu51xJHlQkMyv7EftkOF7lFLNrA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pieter Jansen van Vuuren <pieter.jansen-van-vuuren@amd.com>,
	Martin Habets <habetsm.xilinx@gmail.com>,
	Edward Cree <ecree.xilinx@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 174/234] sfc: dont unregister flow_indr if it was never registered
Date: Mon, 21 Aug 2023 21:42:17 +0200
Message-ID: <20230821194136.527123594@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230821194128.754601642@linuxfoundation.org>
References: <20230821194128.754601642@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Edward Cree <ecree.xilinx@gmail.com>

[ Upstream commit fa165e1949976704500a442faeef8d9596faee76 ]

In efx_init_tc(), move the setting of efx->tc->up after the
 flow_indr_dev_register() call, so that if it fails, efx_fini_tc()
 won't call flow_indr_dev_unregister().

Fixes: 5b2e12d51bd8 ("sfc: bind indirect blocks for TC offload on EF100")
Suggested-by: Pieter Jansen van Vuuren <pieter.jansen-van-vuuren@amd.com>
Reviewed-by: Martin Habets <habetsm.xilinx@gmail.com>
Signed-off-by: Edward Cree <ecree.xilinx@gmail.com>
Link: https://lore.kernel.org/r/a81284d7013aba74005277bd81104e4cfbea3f6f.1692114888.git.ecree.xilinx@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/sfc/tc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/sfc/tc.c b/drivers/net/ethernet/sfc/tc.c
index 54c5719031f9e..6c8dfe0a64824 100644
--- a/drivers/net/ethernet/sfc/tc.c
+++ b/drivers/net/ethernet/sfc/tc.c
@@ -1460,10 +1460,10 @@ int efx_init_tc(struct efx_nic *efx)
 	rc = efx_tc_configure_fallback_acts_reps(efx);
 	if (rc)
 		return rc;
-	efx->tc->up = true;
 	rc = flow_indr_dev_register(efx_tc_indr_setup_cb, efx);
 	if (rc)
 		return rc;
+	efx->tc->up = true;
 	return 0;
 }
 
-- 
2.40.1



