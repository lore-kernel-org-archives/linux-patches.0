Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5FED79C0
	for <patches@lists.linux.dev>; Wed, 30 Nov 2022 18:50:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AFD4C433C1;
	Wed, 30 Nov 2022 18:50:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669834204;
	bh=LTNH4xGyhDC5BTTaJpPQA2KG8y89jEMMUmkKfeHhRdc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qVpwpoZt5bx6NgGzlj0CjgwgZbZ5G5JeIwjqbeQ53UY1FGMvlvOWwYcifJwQfYHt8
	 cD3ebPnE9h6NYZokUw2QTTSYyFQAPDKtXBJbLoZ6J2lyWxEtQu2aXWetuxkL4tFanj
	 v67H/HXnWA5x9U+OUP75sBiCP0qMR8QjMp+RN/qo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wang Hai <wanghai38@huawei.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 140/289] arcnet: fix potential memory leak in com20020_probe()
Date: Wed, 30 Nov 2022 19:22:05 +0100
Message-Id: <20221130180547.311479369@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180544.105550592@linuxfoundation.org>
References: <20221130180544.105550592@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Wang Hai <wanghai38@huawei.com>

[ Upstream commit 1c40cde6b5171d9c8dfc69be00464fd1c75e210b ]

In com20020_probe(), if com20020_config() fails, dev and info
will not be freed, which will lead to a memory leak.

This patch adds freeing dev and info after com20020_config()
fails to fix this bug.

Compile tested only.

Fixes: 15b99ac17295 ("[PATCH] pcmcia: add return value to _config() functions")
Signed-off-by: Wang Hai <wanghai38@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/arcnet/com20020_cs.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/net/arcnet/com20020_cs.c b/drivers/net/arcnet/com20020_cs.c
index 24150c933fcb..dc3253b318da 100644
--- a/drivers/net/arcnet/com20020_cs.c
+++ b/drivers/net/arcnet/com20020_cs.c
@@ -113,6 +113,7 @@ static int com20020_probe(struct pcmcia_device *p_dev)
 	struct com20020_dev *info;
 	struct net_device *dev;
 	struct arcnet_local *lp;
+	int ret = -ENOMEM;
 
 	dev_dbg(&p_dev->dev, "com20020_attach()\n");
 
@@ -142,12 +143,18 @@ static int com20020_probe(struct pcmcia_device *p_dev)
 	info->dev = dev;
 	p_dev->priv = info;
 
-	return com20020_config(p_dev);
+	ret = com20020_config(p_dev);
+	if (ret)
+		goto fail_config;
+
+	return 0;
 
+fail_config:
+	free_arcdev(dev);
 fail_alloc_dev:
 	kfree(info);
 fail_alloc_info:
-	return -ENOMEM;
+	return ret;
 } /* com20020_attach */
 
 static void com20020_detach(struct pcmcia_device *link)
-- 
2.35.1



