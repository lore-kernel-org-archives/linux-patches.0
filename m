Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 549C31F7569;
	Tue,  3 Dec 2024 15:23:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733239390; cv=none; b=u25yaBhPh3jqHvTXlEfQ1y12gPVBEQWCV2E56vBBqCQV/L/7L+BJeXDen16GtONPUk8eMNKurRSQtddJSdDQNNvZZGjfGMHSyxugo2qsrlMNtbaSzw4LUyJiglEQk1FGJTYqfyqe4Vqk1g32SWA6t3zFXPvdIceaMlkub/ICxew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733239390; c=relaxed/simple;
	bh=RbGC9zLHgLLIo7LNRVkk8UdTFv4iCtmUzE4lA1iZnQM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OZFUGSdg23JA9tpa0LKPjrEnem6pYSVVreT9yI84FuriqjRxkRSOaW0/hYur3AKZAKGsgAO27QNJBmAOeG2nd6SXyEzs9CmVdXosQlknmiQL2PajiYyP/F8NeYOyOGOz9Dg0UmGlnc7WT5w09vgI3+EEoy0TMrdoHID4OTdVM28=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vGTgmRrU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vGTgmRrU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4D68C4CECF;
	Tue,  3 Dec 2024 15:23:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733239390;
	bh=RbGC9zLHgLLIo7LNRVkk8UdTFv4iCtmUzE4lA1iZnQM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vGTgmRrUU08f+ndGFyuoDkQd38NpkNf2FVsGN5YzvTKDZHuEXmSwQKEL7Xsue56Uu
	 SVu3ZvMlh5kzPWyghniQSKtC7G+ZfxjIYC0XwpcN1DozRUBjc+DVM261SUpt7eaP+V
	 sjPyPSc/ZDt6oZLr+XSWdlY388LkK7dk71Xd00dk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 597/817] iio: light: al3010: Fix an error handling path in al3010_probe()
Date: Tue,  3 Dec 2024 15:42:49 +0100
Message-ID: <20241203144019.228407305@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
index 53569587ccb7b..7cbb8b2033009 100644
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
 
@@ -190,12 +195,6 @@ static int al3010_probe(struct i2c_client *client)
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



