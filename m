Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F14E1863
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 15:25:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BBD3C433D2;
	Wed, 28 Dec 2022 15:25:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672241125;
	bh=2Idr6nOgbDBFRgTAnc1SG6537rByiLD6kpwX2ZCTtzE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LK1tWLBAi8JvJy9e9CygvAUim0CMUbqJECeOmUJISBGn9A6TmmBNzZq8uH+wpLXp0
	 hS6nXdQriSu6nfG5SPz0eXHqe1JjLDhKVoSrZXWABewIhiVlSJzSCRxireG6D3Usy1
	 0PTZm+VbU+xTogjRrAH9p0yVwbkmq5FVp+VGofKw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuan Can <yuancan@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 440/731] serial: 8250_bcm7271: Fix error handling in brcmuart_init()
Date: Wed, 28 Dec 2022 15:39:07 +0100
Message-Id: <20221228144309.313582495@linuxfoundation.org>
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

From: Yuan Can <yuancan@huawei.com>

[ Upstream commit 6a3ff858915fa8ca36c7eb02c87c9181ae2fc333 ]

A problem about 8250_bcm7271 create debugfs failed is triggered with the
following log given:

 [  324.516635] debugfs: Directory 'bcm7271-uart' with parent '/' already present!

The reason is that brcmuart_init() returns platform_driver_register()
directly without checking its return value, if platform_driver_register()
failed, it returns without destroy the newly created debugfs, resulting
the debugfs of 8250_bcm7271 can never be created later.

 brcmuart_init()
   debugfs_create_dir() # create debugfs directory
   platform_driver_register()
     driver_register()
       bus_add_driver()
         priv = kzalloc(...) # OOM happened
   # return without destroy debugfs directory

Fix by removing debugfs when platform_driver_register() returns error.

Fixes: 41a469482de2 ("serial: 8250: Add new 8250-core based Broadcom STB driver")
Signed-off-by: Yuan Can <yuancan@huawei.com>
Link: https://lore.kernel.org/r/20221109072110.117291-2-yuancan@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/8250/8250_bcm7271.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/tty/serial/8250/8250_bcm7271.c b/drivers/tty/serial/8250/8250_bcm7271.c
index 711cf30e835a..60b3ac1a0317 100644
--- a/drivers/tty/serial/8250/8250_bcm7271.c
+++ b/drivers/tty/serial/8250/8250_bcm7271.c
@@ -1214,9 +1214,17 @@ static struct platform_driver brcmuart_platform_driver = {
 
 static int __init brcmuart_init(void)
 {
+	int ret;
+
 	brcmuart_debugfs_root = debugfs_create_dir(
 		brcmuart_platform_driver.driver.name, NULL);
-	return platform_driver_register(&brcmuart_platform_driver);
+	ret = platform_driver_register(&brcmuart_platform_driver);
+	if (ret) {
+		debugfs_remove_recursive(brcmuart_debugfs_root);
+		return ret;
+	}
+
+	return 0;
 }
 module_init(brcmuart_init);
 
-- 
2.35.1



