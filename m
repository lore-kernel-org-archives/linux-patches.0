Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4D4F28ED
	for <patches@lists.linux.dev>; Mon, 12 Dec 2022 13:31:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECD56C433EF;
	Mon, 12 Dec 2022 13:31:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1670851902;
	bh=bXhs/QhFvTKfcQWAO4+SVEV/Y18+U60jNnpFr6U46Bw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WLlhIQOqocEynKBXnSLNCyBtieeuFFiBovko0Jx16m0boJWlZ5c4GpTgejHrDh5UO
	 DD/48M1X0eOUCcRQs2XnnIgBYK+sThXnt4ZKQodoO2HOPCVQyAcx+4qQxbn7B0Lbd8
	 qw96j51GhOV6u3xwCT0ka2jRgpe3OLAdaR9M6ODc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hauke Mehrtens <hauke@hauke-m.de>,
	Stefan Schmidt <stefan@datenfreihafen.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 066/123] ca8210: Fix crash by zero initializing data
Date: Mon, 12 Dec 2022 14:17:12 +0100
Message-Id: <20221212130929.721844425@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221212130926.811961601@linuxfoundation.org>
References: <20221212130926.811961601@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Hauke Mehrtens <hauke@hauke-m.de>

[ Upstream commit 1e24c54da257ab93cff5826be8a793b014a5dc9c ]

The struct cas_control embeds multiple generic SPI structures and we
have to make sure these structures are initialized to default values.
This driver does not set all attributes. When using kmalloc before some
attributes were not initialized and contained random data which caused
random crashes at bootup.

Fixes: ded845a781a5 ("ieee802154: Add CA8210 IEEE 802.15.4 device driver")
Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
Link: https://lore.kernel.org/r/20221121002201.1339636-1-hauke@hauke-m.de
Signed-off-by: Stefan Schmidt <stefan@datenfreihafen.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ieee802154/ca8210.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ieee802154/ca8210.c b/drivers/net/ieee802154/ca8210.c
index 96592a20c61f..0362917fce7a 100644
--- a/drivers/net/ieee802154/ca8210.c
+++ b/drivers/net/ieee802154/ca8210.c
@@ -927,7 +927,7 @@ static int ca8210_spi_transfer(
 
 	dev_dbg(&spi->dev, "%s called\n", __func__);
 
-	cas_ctl = kmalloc(sizeof(*cas_ctl), GFP_ATOMIC);
+	cas_ctl = kzalloc(sizeof(*cas_ctl), GFP_ATOMIC);
 	if (!cas_ctl)
 		return -ENOMEM;
 
-- 
2.35.1



