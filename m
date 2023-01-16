Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B771A6FA0
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 16:39:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 410C1C43392;
	Mon, 16 Jan 2023 16:39:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673887185;
	bh=y0RYymWES8yUMcNcK7hAJ9L88eMOJbo1s8jKpVj8TTo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xQrsgEwaIrz7JefHhW98ph9aH2nNdz12Bv85MypAN1HlOckjjKEHqCEEWoyAxQ9uX
	 DBf500qHt6IRTHguS6/bgthbnhIS2eJB7n+HZM12MpPpFl71SQvzg23aueLmFse9o8
	 B6BFL6vPYPCim7S23AtjDyjBfoBJ4bi5SovMyJXE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Yingliang <yangyingliang@huawei.com>,
	Hanjun Guo <guohanjun@huawei.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 054/521] PNP: fix name memory leak in pnp_alloc_dev()
Date: Mon, 16 Jan 2023 16:45:16 +0100
Message-Id: <20230116154849.668412267@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154847.246743274@linuxfoundation.org>
References: <20230116154847.246743274@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit 110d7b0325c55ff3620073ba4201845f59e22ebf ]

After commit 1fa5ae857bb1 ("driver core: get rid of struct device's
bus_id string array"), the name of device is allocated dynamically,
move dev_set_name() after pnp_add_id() to avoid memory leak.

Fixes: 1fa5ae857bb1 ("driver core: get rid of struct device's bus_id string array")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Reviewed-by: Hanjun Guo <guohanjun@huawei.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pnp/core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/pnp/core.c b/drivers/pnp/core.c
index 3bf18d718975..131b925b820d 100644
--- a/drivers/pnp/core.c
+++ b/drivers/pnp/core.c
@@ -160,14 +160,14 @@ struct pnp_dev *pnp_alloc_dev(struct pnp_protocol *protocol, int id,
 	dev->dev.coherent_dma_mask = dev->dma_mask;
 	dev->dev.release = &pnp_release_device;
 
-	dev_set_name(&dev->dev, "%02x:%02x", dev->protocol->number, dev->number);
-
 	dev_id = pnp_add_id(dev, pnpid);
 	if (!dev_id) {
 		kfree(dev);
 		return NULL;
 	}
 
+	dev_set_name(&dev->dev, "%02x:%02x", dev->protocol->number, dev->number);
+
 	return dev;
 }
 
-- 
2.35.1



