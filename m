Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82AEF3DB8F
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 20:04:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TBiXgypj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08AD8C433C7;
	Wed, 15 Nov 2023 20:04:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700078695;
	bh=ZpFU/3ayOne/wULhsNVQJuf13IyIcd4viJoo07jJEzI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TBiXgypjqFsa9uwBQowExbLrsgJbzDM9ppkWIvSa1RYaQ9bw0uyiXX4GiH1tx+nFd
	 MMPKTEMMUuKZfS2bWF2uJpbAgShN9TEdVghIU9QwvcSOYREkTOlPctSVKTAJDVk6mj
	 npTGcwSmdMp8UlLEkBFTewYpuXzcqAq5Z9pUSjhM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Yingliang <yangyingliang@huawei.com>,
	Dominik Brodowski <linux@dominikbrodowski.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 33/45] pcmcia: ds: fix possible name leak in error path in pcmcia_device_add()
Date: Wed, 15 Nov 2023 14:33:10 -0500
Message-ID: <20231115191421.567532381@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191419.641552204@linuxfoundation.org>
References: <20231115191419.641552204@linuxfoundation.org>
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

4.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit 99e1241049a92dd3e9a90a0f91e32ce390133278 ]

Afer commit 1fa5ae857bb1 ("driver core: get rid of struct device's
bus_id string array"), the name of device is allocated dynamically.
Therefore, it needs to be freed, which is done by the driver core for
us once all references to the device are gone. Therefore, move the
dev_set_name() call immediately before the call device_register(), which
either succeeds (then the freeing will be done upon subsequent remvoal),
or puts the reference in the error call. Also, it is not unusual that the
return value of dev_set_name is not checked.

Fixes: 1fa5ae857bb1 ("driver core: get rid of struct device's bus_id string array")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
[linux@dominikbrodowski.net: simplification, commit message modified]
Signed-off-by: Dominik Brodowski <linux@dominikbrodowski.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pcmcia/ds.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/pcmcia/ds.c b/drivers/pcmcia/ds.c
index e07bd5249f271..3701887be32e8 100644
--- a/drivers/pcmcia/ds.c
+++ b/drivers/pcmcia/ds.c
@@ -521,9 +521,6 @@ static struct pcmcia_device *pcmcia_device_add(struct pcmcia_socket *s,
 	/* by default don't allow DMA */
 	p_dev->dma_mask = DMA_MASK_NONE;
 	p_dev->dev.dma_mask = &p_dev->dma_mask;
-	dev_set_name(&p_dev->dev, "%d.%d", p_dev->socket->sock, p_dev->device_no);
-	if (!dev_name(&p_dev->dev))
-		goto err_free;
 	p_dev->devname = kasprintf(GFP_KERNEL, "pcmcia%s", dev_name(&p_dev->dev));
 	if (!p_dev->devname)
 		goto err_free;
@@ -581,6 +578,7 @@ static struct pcmcia_device *pcmcia_device_add(struct pcmcia_socket *s,
 
 	pcmcia_device_query(p_dev);
 
+	dev_set_name(&p_dev->dev, "%d.%d", p_dev->socket->sock, p_dev->device_no);
 	if (device_register(&p_dev->dev)) {
 		mutex_lock(&s->ops_mutex);
 		list_del(&p_dev->socket_device_list);
-- 
2.42.0



