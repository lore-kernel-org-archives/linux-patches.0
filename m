Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9377D1863
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 14:50:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 174D0C433EF;
	Wed, 28 Dec 2022 14:50:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672239003;
	bh=AXPXLxh17Tug/qn92KC4ufziprryzeaMVNCXJJh7qCA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=y5yxRLJ9CubfWHOJ+3PY2VVgkEHUIFeBtZEcjN2XuV+z1ypLPWbqTpz/zG45ytotx
	 di7abOAbiUCQs8XbvY8DTlFv62JxQT19qSXpK6OkBzmCIbbI7b5MActJHxfC7tQvbm
	 XE8bi01G969JHGG9cL+G34ifGyqpdiDduclLEahw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Yingliang <yangyingliang@huawei.com>,
	Hanjun Guo <guohanjun@huawei.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 092/731] PNP: fix name memory leak in pnp_alloc_dev()
Date: Wed, 28 Dec 2022 15:33:19 +0100
Message-Id: <20221228144259.215707960@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
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
index 4df5aa6a309c..6a60c5d83383 100644
--- a/drivers/pnp/core.c
+++ b/drivers/pnp/core.c
@@ -148,14 +148,14 @@ struct pnp_dev *pnp_alloc_dev(struct pnp_protocol *protocol, int id,
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



