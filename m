Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87CB111703
	for <patches@lists.linux.dev>; Mon, 21 Aug 2023 19:57:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC65FC433C7;
	Mon, 21 Aug 2023 19:57:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1692647850;
	bh=63DoUM+Q+NylRYkPzqYnb/TaawSHcakRxY876FWY4AI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uxv6oB00QRxs7xVPfGT3yz6Exa/fGYr6zPnLyGIpZOY+WXd2mWzQgO+cXKLg30xMi
	 qWZS3NUKL9Mfeq81iUoF7AqO5WmfeN0+4SRs8aBna0M7/OZf9ffM3c+kEHvPNdyJQB
	 B7TziKvwvpUOHb9LqQvOa87/ZIjtJEdyCpnIlvoY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pieter Jansen van Vuuren <pieter.jansen-van-vuuren@amd.com>,
	Martin Habets <habetsm.xilinx@gmail.com>,
	Edward Cree <ecree.xilinx@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 130/194] sfc: dont unregister flow_indr if it was never registered
Date: Mon, 21 Aug 2023 21:41:49 +0200
Message-ID: <20230821194128.411508114@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230821194122.695845670@linuxfoundation.org>
References: <20230821194122.695845670@linuxfoundation.org>
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
index 3478860d40232..d312147cd2dd7 100644
--- a/drivers/net/ethernet/sfc/tc.c
+++ b/drivers/net/ethernet/sfc/tc.c
@@ -603,10 +603,10 @@ int efx_init_tc(struct efx_nic *efx)
 	rc = efx_tc_configure_rep_mport(efx);
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



