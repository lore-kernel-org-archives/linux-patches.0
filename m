Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CB0F15CAE
	for <patches@lists.linux.dev>; Tue,  8 Nov 2022 14:00:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74645C433D6;
	Tue,  8 Nov 2022 14:00:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667916055;
	bh=eY1qeHXjjqGgAk9WBBtxoyan8XZigRsHeeGRd4tIcRI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fYBm07ws2esvm+HTerGbfJH7+xv10UtTFyxh3dQEhPDCOc8L82xzAiiZl9c9pARTn
	 nwEDXUTcygvVjx2EArSrPgaaquQ8mDQR1cPP8VfPg2l1iebvhT9NAWiXzuj1e6Bmnn
	 nEVFmFPRrxpGAruD4IuVj38am+vVM+mnjSX9CazU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Yingliang <yangyingliang@huawei.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 042/144] mISDN: fix possible memory leak in mISDN_register_device()
Date: Tue,  8 Nov 2022 14:38:39 +0100
Message-Id: <20221108133347.061436907@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133345.346704162@linuxfoundation.org>
References: <20221108133345.346704162@linuxfoundation.org>
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

[ Upstream commit e7d1d4d9ac0dfa40be4c2c8abd0731659869b297 ]

Afer commit 1fa5ae857bb1 ("driver core: get rid of struct device's
bus_id string array"), the name of device is allocated dynamically,
add put_device() to give up the reference, so that the name can be
freed in kobject_cleanup() when the refcount is 0.

Set device class before put_device() to avoid null release() function
WARN message in device_release().

Fixes: 1fa5ae857bb1 ("driver core: get rid of struct device's bus_id string array")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/isdn/mISDN/core.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/isdn/mISDN/core.c b/drivers/isdn/mISDN/core.c
index a41b4b264594..7ea0100f218a 100644
--- a/drivers/isdn/mISDN/core.c
+++ b/drivers/isdn/mISDN/core.c
@@ -233,11 +233,12 @@ mISDN_register_device(struct mISDNdevice *dev,
 	if (debug & DEBUG_CORE)
 		printk(KERN_DEBUG "mISDN_register %s %d\n",
 		       dev_name(&dev->dev), dev->id);
+	dev->dev.class = &mISDN_class;
+
 	err = create_stack(dev);
 	if (err)
 		goto error1;
 
-	dev->dev.class = &mISDN_class;
 	dev->dev.platform_data = dev;
 	dev->dev.parent = parent;
 	dev_set_drvdata(&dev->dev, dev);
@@ -249,8 +250,8 @@ mISDN_register_device(struct mISDNdevice *dev,
 
 error3:
 	delete_stack(dev);
-	return err;
 error1:
+	put_device(&dev->dev);
 	return err;
 
 }
-- 
2.35.1



