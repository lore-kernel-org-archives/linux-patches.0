Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 150A22165F0;
	Thu, 12 Dec 2024 16:13:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734020017; cv=none; b=UT4ziIUHeD0jlKZF/jDMecrNFigFQzlW/P2hiKKC4ItHql6qpolXUhwIFgv0e+UJnLo4weArQGHHaRAS405HlO/cGbnL3YwZrkSShllNpUpXVl5cgeHlTAEfJ9C0ES4HzsQToV9gjB5VnjKsEU+M3l1ItlgcE1/NO0lGp/5dWoc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734020017; c=relaxed/simple;
	bh=zVdwcT40xrU78LTv5HeR87LQwmHOaTEGHn2X9TcAg8g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FpMDfuKkkwCkr5Xw+vxSSkj/VGNEYfsaptHXtBKg7OnAmhDx7A27hZ3lYtLVXrYmUbNA2koI1oKgsrBSVaVwJCGP1eNJLUZbYexrbgjjvv/14LJynMQAxa1zrsV8cH3h/iXCvmjGe0u0ZD+5Qcy/onotwGwM3fZGZvk3nzoA0Oo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BY5m3HZg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BY5m3HZg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09774C4CECE;
	Thu, 12 Dec 2024 16:13:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734020016;
	bh=zVdwcT40xrU78LTv5HeR87LQwmHOaTEGHn2X9TcAg8g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BY5m3HZgmgw4TNYIt1dKR33vlpX+298D5imy4G8NIcHIWuHHDNk1wTepjRsSQJoUi
	 GuAn73ekof7qEgH6Ty7nhY2XBP2pITVKtGxe2aqzQ17hLkHssblzU5AKdSuEk80AiQ
	 +vhfSbuq0l/34ewmf8YHmj8dUi5MDyyI5DBYqHH0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 326/772] iio: light: al3010: Fix an error handling path in al3010_probe()
Date: Thu, 12 Dec 2024 15:54:31 +0100
Message-ID: <20241212144403.373633839@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit a4b7064d34186cf4970fe0333c3b27346cf8f819 ]

If i2c_smbus_write_byte_data() fails in al3010_init(),
al3010_set_pwr(false) is not called.

In order to avoid such a situation, move the devm_add_action_or_reset()
witch calls al3010_set_pwr(false) right after a successful
al3010_set_pwr(true).

Fixes: c36b5195ab70 ("iio: light: add Dyna-Image AL3010 driver")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Link: https://patch.msgid.link/ee5d10a2dd2b70f29772d5df33774d3974a80f30.1725993353.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/light/al3010.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/iio/light/al3010.c b/drivers/iio/light/al3010.c
index ce5363845b225..c1c37e5a85159 100644
--- a/drivers/iio/light/al3010.c
+++ b/drivers/iio/light/al3010.c
@@ -87,7 +87,12 @@ static int al3010_init(struct al3010_data *data)
 	int ret;
 
 	ret = al3010_set_pwr(data->client, true);
+	if (ret < 0)
+		return ret;
 
+	ret = devm_add_action_or_reset(&data->client->dev,
+				       al3010_set_pwr_off,
+				       data);
 	if (ret < 0)
 		return ret;
 
@@ -191,12 +196,6 @@ static int al3010_probe(struct i2c_client *client,
 		return ret;
 	}
 
-	ret = devm_add_action_or_reset(&client->dev,
-					al3010_set_pwr_off,
-					data);
-	if (ret < 0)
-		return ret;
-
 	return devm_iio_device_register(&client->dev, indio_dev);
 }
 
-- 
2.43.0



