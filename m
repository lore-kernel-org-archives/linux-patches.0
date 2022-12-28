Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A66B1875
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 16:01:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0ED7AC433EF;
	Wed, 28 Dec 2022 16:01:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672243292;
	bh=Y8Nn3t9j8VvkQJGUSdsh2vwYE4YAD5KHUduEcJ0zQmE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TCF19971I33B7vFNaYSvnxq46GptPGEWXDkI6MDjOoCYfD0PRC53rXlmaUXnKfy0N
	 tdHdLOORB65RUUEnqO9gxt7oC0k70sHpy1RldUJTy6P6pVgxXsZQY0XwYlSRQF5Pzx
	 2hPNEmi+A9AkQGQrKGKHcd5FDXmy9cKItQyH0JsY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gaosheng Cui <cuigaosheng1@huawei.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0513/1073] net: stmmac: fix possible memory leak in stmmac_dvr_probe()
Date: Wed, 28 Dec 2022 15:35:01 +0100
Message-Id: <20221228144341.980631262@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Gaosheng Cui <cuigaosheng1@huawei.com>

[ Upstream commit a137f3f27f9290933fe7e40e6dc8a445781c31a2 ]

The bitmap_free() should be called to free priv->af_xdp_zc_qps
when create_singlethread_workqueue() fails, otherwise there will
be a memory leak, so we add the err path error_wq_init to fix it.

Fixes: bba2556efad6 ("net: stmmac: Enable RX via AF_XDP zero-copy")
Signed-off-by: Gaosheng Cui <cuigaosheng1@huawei.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 0f080bfe8b17..40bf30de8402 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -7115,7 +7115,7 @@ int stmmac_dvr_probe(struct device *device,
 	priv->wq = create_singlethread_workqueue("stmmac_wq");
 	if (!priv->wq) {
 		dev_err(priv->device, "failed to create workqueue\n");
-		return -ENOMEM;
+		goto error_wq_init;
 	}
 
 	INIT_WORK(&priv->service_task, stmmac_service_task);
@@ -7343,6 +7343,7 @@ int stmmac_dvr_probe(struct device *device,
 	stmmac_napi_del(ndev);
 error_hw_init:
 	destroy_workqueue(priv->wq);
+error_wq_init:
 	bitmap_free(priv->af_xdp_zc_qps);
 
 	return ret;
-- 
2.35.1



