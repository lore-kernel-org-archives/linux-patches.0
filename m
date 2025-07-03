Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2C182EA49E;
	Thu,  3 Jul 2025 14:58:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751554708; cv=none; b=kvPezvDWHEO3jYE3uEx5Vql0aUxcbawNOzI/rxN4waZm4rssYT7ab+vRsmRPFJTA0O4XPq6+/SkxqroNs/6SOovvJjeP65K2QILOW+8HR2MuZlwvsIUqS21YRrVkwNW5JaFCcKCC95zWHevd3yAlc6/Z66jJzOW7t6Lws1lmd8g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751554708; c=relaxed/simple;
	bh=203bzRHtAdotDUrRZx8I0y/ZfObkMA5Ggnf9iaLC8Vg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vn4F4QWLf660vDEWihsTeHoIRapWl3EdeVOMU3DJ21rh49r0KpMwF2Ezhr8DnVIcU0iM/L1v5uZ+rHzclQU1ei2ZIlEG/WBnKG6x2uZUNtXp5Uj23JUBDUcDIaB1Z7p1OhPMMqNM4ifRroiHzOA1b5L+qXswRCA/xn8srne9eeI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JfdVjnNb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JfdVjnNb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 541B4C4CEE3;
	Thu,  3 Jul 2025 14:58:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751554707;
	bh=203bzRHtAdotDUrRZx8I0y/ZfObkMA5Ggnf9iaLC8Vg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JfdVjnNbUCIQTyLlleWO3uCvXHcFSkVKjBZIbhLhydgE2rq4xhrR9CXlFc0SCnG4G
	 Zcb4UjQZ27mysNZsU4drnwf1aZOALfBQn/1P4RGEy3pZTWwpipdBIkYExgKNyqN1MM
	 LlLhGJRRqsqAYTHjf0+EUVRMfVeQ5JICLRm4r6NQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Heidelberg <david@ixit.cz>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 053/263] iio: light: al3000a: Fix an error handling path in al3000a_probe()
Date: Thu,  3 Jul 2025 16:39:33 +0200
Message-ID: <20250703144006.434391656@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703144004.276210867@linuxfoundation.org>
References: <20250703144004.276210867@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Heidelberg <david@ixit.cz>

[ Upstream commit c0461f8e842495041c18b2c67647501d55c17441 ]

If regmap_write() fails in al3000a_init(), al3000a_set_pwr_off is
not called.

In order to avoid such a situation, move the devm_add_action_or_reset()
which calls al3000a_set_pwr_off right after a successful
al3000a_set_pwr_on.

Signed-off-by: David Heidelberg <david@ixit.cz>
Link: https://patch.msgid.link/20250402-al3010-iio-regmap-v4-2-d189bea87261@ixit.cz
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/light/al3000a.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/iio/light/al3000a.c b/drivers/iio/light/al3000a.c
index e2fbb1270040f..6d5115b2a06c5 100644
--- a/drivers/iio/light/al3000a.c
+++ b/drivers/iio/light/al3000a.c
@@ -85,12 +85,17 @@ static void al3000a_set_pwr_off(void *_data)
 
 static int al3000a_init(struct al3000a_data *data)
 {
+	struct device *dev = regmap_get_device(data->regmap);
 	int ret;
 
 	ret = al3000a_set_pwr_on(data);
 	if (ret)
 		return ret;
 
+	ret = devm_add_action_or_reset(dev, al3000a_set_pwr_off, data);
+	if (ret)
+		return dev_err_probe(dev, ret, "failed to add action\n");
+
 	ret = regmap_write(data->regmap, AL3000A_REG_SYSTEM, AL3000A_CONFIG_RESET);
 	if (ret)
 		return ret;
@@ -157,10 +162,6 @@ static int al3000a_probe(struct i2c_client *client)
 	if (ret)
 		return dev_err_probe(dev, ret, "failed to init ALS\n");
 
-	ret = devm_add_action_or_reset(dev, al3000a_set_pwr_off, data);
-	if (ret)
-		return dev_err_probe(dev, ret, "failed to add action\n");
-
 	return devm_iio_device_register(dev, indio_dev);
 }
 
-- 
2.39.5



