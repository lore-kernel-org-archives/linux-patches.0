Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6362F32C8B;
	Fri,  6 Dec 2024 14:51:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733496689; cv=none; b=BUvUyfEV9SWjMQ+nRwnLp2yXt0HlK7Tfuoa4Gzz8I+2nXrokuOa6DUFxqEzPaMNNIiqpbTXkq80kX3WwzY33iZW7sL1RfWwX6JqAptllX21rjfPWT3dczVwu8bcWMAE2g+iIyweNSP3FUwC3HDJNooJf3zXQEoV7zeeINR1Kpbg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733496689; c=relaxed/simple;
	bh=Uy/v0kYPuQblYC+clOr7uYU18/mKr+/3O4ptba99Sj4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UKV1HGTwLqLimeMdWabhFP15HMKAq600OJ4tJbWprux4XdwXI6tZL5UcteWIbXOQCwj6/fXUqcGGRHp/8O3LNjrTqjo/0fYG0AArB8gDSDCc/XR406D+QBHHG3CgNEEjYjeYpTxqk8zOXCChmpurp1exxhVYS+befntYp00bgN4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vaUXL3rk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vaUXL3rk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF255C4CED1;
	Fri,  6 Dec 2024 14:51:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733496689;
	bh=Uy/v0kYPuQblYC+clOr7uYU18/mKr+/3O4ptba99Sj4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vaUXL3rkw8ZhL/hfDoKTAKquqfa0dSS82S26KCe+W9VJJ+LCKPxamt8oFlwKzhY42
	 st+wnIjeL2gmfimwhZ5H4yzofa3tDc+HQ4M/vUd+H+G6l6+0Ss5NvgCbi96B3h1skK
	 r0h9y8kCEz1Et2bHvPG+xbgGcx1HDUbFquQ80npA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Keith Busch <kbusch@kernel.org>,
	Bin Lan <bin.lan.cn@windriver.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 044/676] nvme: apple: fix device reference counting
Date: Fri,  6 Dec 2024 15:27:43 +0100
Message-ID: <20241206143655.073842457@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Keith Busch <kbusch@kernel.org>

[ Upstream commit b9ecbfa45516182cd062fecd286db7907ba84210 ]

Drivers must call nvme_uninit_ctrl after a successful nvme_init_ctrl.
Split the allocation side out to make the error handling boundary easier
to navigate. The apple driver had been doing this wrong, leaking the
controller device memory on a tagset failure.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
[ Resolve minor conflicts ]
Signed-off-by: Bin Lan <bin.lan.cn@windriver.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/apple.c | 27 ++++++++++++++++++++++-----
 1 file changed, 22 insertions(+), 5 deletions(-)

diff --git a/drivers/nvme/host/apple.c b/drivers/nvme/host/apple.c
index 596bb11eeba5a..396eb94376597 100644
--- a/drivers/nvme/host/apple.c
+++ b/drivers/nvme/host/apple.c
@@ -1387,7 +1387,7 @@ static void devm_apple_nvme_mempool_destroy(void *data)
 	mempool_destroy(data);
 }
 
-static int apple_nvme_probe(struct platform_device *pdev)
+static struct apple_nvme *apple_nvme_alloc(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
 	struct apple_nvme *anv;
@@ -1395,7 +1395,7 @@ static int apple_nvme_probe(struct platform_device *pdev)
 
 	anv = devm_kzalloc(dev, sizeof(*anv), GFP_KERNEL);
 	if (!anv)
-		return -ENOMEM;
+		return ERR_PTR(-ENOMEM);
 
 	anv->dev = get_device(dev);
 	anv->adminq.is_adminq = true;
@@ -1515,10 +1515,26 @@ static int apple_nvme_probe(struct platform_device *pdev)
 		goto put_dev;
 	}
 
+	return anv;
+put_dev:
+	put_device(anv->dev);
+	return ERR_PTR(ret);
+}
+
+static int apple_nvme_probe(struct platform_device *pdev)
+{
+	struct apple_nvme *anv;
+	int ret;
+
+	anv = apple_nvme_alloc(pdev);
+	if (IS_ERR(anv))
+		return PTR_ERR(anv);
+
 	anv->ctrl.admin_q = blk_mq_init_queue(&anv->admin_tagset);
 	if (IS_ERR(anv->ctrl.admin_q)) {
 		ret = -ENOMEM;
-		goto put_dev;
+		anv->ctrl.admin_q = NULL;
+		goto out_uninit_ctrl;
 	}
 
 	nvme_reset_ctrl(&anv->ctrl);
@@ -1526,8 +1542,9 @@ static int apple_nvme_probe(struct platform_device *pdev)
 
 	return 0;
 
-put_dev:
-	put_device(anv->dev);
+out_uninit_ctrl:
+	nvme_uninit_ctrl(&anv->ctrl);
+	nvme_put_ctrl(&anv->ctrl);
 	return ret;
 }
 
-- 
2.43.0



