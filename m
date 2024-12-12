Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07876223E65;
	Thu, 12 Dec 2024 16:57:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734022669; cv=none; b=YgmKcimPviH4fDHHAG6cue53ST3I6dVrQIlxpUnIXTZgaXu4xdkCTrR6ai6JC05gaJ4p+yThbElfZdnFCyjmICzuynosV22xDnk1DJrPUiqpT8hMajfxU0/GO+OVoUMCEBgN1cZHvgms0FiyyJiZ6IxyOcBGvNQblHcmjF6QxrE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734022669; c=relaxed/simple;
	bh=MsbS9M1KTdtj91g7Ie7oOZM1yn5m0/LMXe0RzKy6kM8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=chIxl3RNKaaTYMgKSVbNKczY45AkaKpdiwKl/CTf5lK5nO/mRx8cEn0FpVg3vQ8UsDiXiAXXP0EOK3TVnff56kjOgByfkP8ZeCM3f9mpYqPSkgqKtAYvzoNuWxq7SHJNkokiG07xw53LUQmyc4ykxBbHzvjcA2UHTgbc1rMTFfE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UQ5rBnKH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UQ5rBnKH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53B2CC4CECE;
	Thu, 12 Dec 2024 16:57:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734022668;
	bh=MsbS9M1KTdtj91g7Ie7oOZM1yn5m0/LMXe0RzKy6kM8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UQ5rBnKHMgFvwNIFpNnDWEO5erz0DXe42TdLCGP9sMMxhPtkIvcnTrbxZT9PU32xb
	 Cs2iUDa0pqLocmP6tRlgYqpNQWUCZyH3FsKY3o+aCAu+woS60HFsMbl38tQmQY+2ke
	 +c1E9Tir3of4h8N7+vZwJtm2e1KA/WCWTghBtmeo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 286/565] iio: light: al3010: Fix an error handling path in al3010_probe()
Date: Thu, 12 Dec 2024 15:58:01 +0100
Message-ID: <20241212144322.766638626@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index b4e9924094cd1..bd83e73e68026 100644
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



