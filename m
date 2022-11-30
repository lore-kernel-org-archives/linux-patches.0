Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDE206FA1
	for <patches@lists.linux.dev>; Wed, 30 Nov 2022 18:38:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C32EC433D6;
	Wed, 30 Nov 2022 18:38:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669833483;
	bh=lZYlX9R6NTrGrPiEc9g8ilQ9Jaf88CamsoT5XaqCdGg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yQ0nDHNhs6KppMzdIdik+RejiMaQ0/B8bmDJu3ch6mGPgqSNNHPg5cAC9Vn6lwGTf
	 4a0XSHJQk0mR1n+6ul4dZL8By9EQk45GLg8EGobaehYoLzwXigx7Xpp2lULqkvbFV1
	 E8E7sFrxRNzWCB4XlSwZyJK9IT4NEdn6l1Y1bByM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wang Hai <wanghai38@huawei.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 122/206] arcnet: fix potential memory leak in com20020_probe()
Date: Wed, 30 Nov 2022 19:22:54 +0100
Message-Id: <20221130180536.152285242@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180532.974348590@linuxfoundation.org>
References: <20221130180532.974348590@linuxfoundation.org>
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
index b88a109b3b15..26ee263d8f3a 100644
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



