Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5820022ACDC;
	Mon, 10 Mar 2025 17:35:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741628141; cv=none; b=qKSEKqlxasAvmCAv1kKnFBLD+AsNf+uiEP5hfOd+B8JgZK4wn3qEH+ikxLsRzQBEN7v108KzIumTvS1Yu2QrzARHGYt4rw/zCHy8afkL84eyuFYh8cvjB8RpqZ83T40Sw6RUpyouHwXb1iZkw5fN50b/wGXW+/vyTRftDEOWJf0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741628141; c=relaxed/simple;
	bh=aF7YcOOFxbBql5p8WpnwA+5xzqscJH4E+H2LGCMu67U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HU5DKt9HW2vQrlaaCkw71nWJsXeM1frh41OeQnnsTiaj+WaT4vM5l02tmvUpdokmz1/l4ppEL1X9T5v67oYOqpHPmz7L88Rteg7vhupJpeyI5oKNMO047sh4E+ZFYQRV2hfIOmXu6QgN14ZDiJeDgJR9AQFtrgJEGZN/0XXxHHI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ojuCD/le; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ojuCD/le"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D697EC4CEE5;
	Mon, 10 Mar 2025 17:35:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741628141;
	bh=aF7YcOOFxbBql5p8WpnwA+5xzqscJH4E+H2LGCMu67U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ojuCD/leZyvNjBICPgT9pR/B5HfIM3UZljNED/0/LwJ2xnvkNCpCgume2oPil8TpC
	 lYyc9O4tPZ7O1MdThBDU3jcNPUmjibAm+rViAH99YUHyAKfeOkHRFEvQVPHKmQh0wk
	 mKQD4OJmlj1QpxeVZ/2mEKVtRjBkxMKMuAqp5EfE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Erik Schumacher <erik.schumacher@iris-sensing.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 069/145] hwmon: (ad7314) Validate leading zero bits and return error
Date: Mon, 10 Mar 2025 18:06:03 +0100
Message-ID: <20250310170437.534885552@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170434.733307314@linuxfoundation.org>
References: <20250310170434.733307314@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Erik Schumacher <erik.schumacher@iris-sensing.com>

[ Upstream commit e278d5e8aef4c0a1d9a9fa8b8910d713a89aa800 ]

Leading zero bits are sent on the bus before the temperature value is
transmitted. If any of these bits are high, the connection might be
unstable or there could be no AD7314 / ADT730x (or compatible) at all.
Return -EIO in that case.

Signed-off-by: Erik Schumacher <erik.schumacher@iris-sensing.com>
Fixes: 4f3a659581cab ("hwmon: AD7314 driver (ported from IIO)")
Link: https://lore.kernel.org/r/24a50c2981a318580aca8f50d23be7987b69ea00.camel@iris-sensing.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/ad7314.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/hwmon/ad7314.c b/drivers/hwmon/ad7314.c
index 7802bbf5f9587..59424103f6348 100644
--- a/drivers/hwmon/ad7314.c
+++ b/drivers/hwmon/ad7314.c
@@ -22,11 +22,13 @@
  */
 #define AD7314_TEMP_MASK		0x7FE0
 #define AD7314_TEMP_SHIFT		5
+#define AD7314_LEADING_ZEROS_MASK	BIT(15)
 
 /*
  * ADT7301 and ADT7302 temperature masks
  */
 #define ADT7301_TEMP_MASK		0x3FFF
+#define ADT7301_LEADING_ZEROS_MASK	(BIT(15) | BIT(14))
 
 enum ad7314_variant {
 	adt7301,
@@ -65,12 +67,20 @@ static ssize_t ad7314_temperature_show(struct device *dev,
 		return ret;
 	switch (spi_get_device_id(chip->spi_dev)->driver_data) {
 	case ad7314:
+		if (ret & AD7314_LEADING_ZEROS_MASK) {
+			/* Invalid read-out, leading zero part is missing */
+			return -EIO;
+		}
 		data = (ret & AD7314_TEMP_MASK) >> AD7314_TEMP_SHIFT;
 		data = sign_extend32(data, 9);
 
 		return sprintf(buf, "%d\n", 250 * data);
 	case adt7301:
 	case adt7302:
+		if (ret & ADT7301_LEADING_ZEROS_MASK) {
+			/* Invalid read-out, leading zero part is missing */
+			return -EIO;
+		}
 		/*
 		 * Documented as a 13 bit twos complement register
 		 * with a sign bit - which is a 14 bit 2's complement
-- 
2.39.5



