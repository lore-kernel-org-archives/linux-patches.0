Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55CC779C9
	for <patches@lists.linux.dev>; Thu, 12 Jan 2023 14:18:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B792CC433D2;
	Thu, 12 Jan 2023 14:18:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673533096;
	bh=kcQgg9ehBOzyXNlFza6/yPpkNfY3mOMvIREc/aWgUCM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VFST435aZcPP8RpF08Q9nk00PG+aIU+nHLdTrnOMT+zz6Vu6NXMzv20Z+aJaUvTPg
	 Es4+RALxe6/Mx/2ckwGd+qI99EW4WqX+PuYbxr1Aua5JOaUZ1svLtfKWOkhA2cZ+2M
	 L87oYmiPPloe6Wsjss4wEF6/ZsegjLh91N5weNpY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cosmin Tanislav <cosmin.tanislav@analog.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 367/783] iio: temperature: ltc2983: make bulk write buffer DMA-safe
Date: Thu, 12 Jan 2023 14:51:23 +0100
Message-Id: <20230112135541.347139114@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Cosmin Tanislav <cosmin.tanislav@analog.com>

[ Upstream commit 5e0176213949724fbe9a8e4a39817edce337b8a0 ]

regmap_bulk_write() does not guarantee implicit DMA-safety,
even though the current implementation duplicates the given
buffer. Do not rely on it.

Fixes: f110f3188e56 ("iio: temperature: Add support for LTC2983")
Signed-off-by: Cosmin Tanislav <cosmin.tanislav@analog.com>
Link: https://lore.kernel.org/r/20221103130041.2153295-2-demonsingur@gmail.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/temperature/ltc2983.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/iio/temperature/ltc2983.c b/drivers/iio/temperature/ltc2983.c
index 8306daa77908..b2ae2d2c7eef 100644
--- a/drivers/iio/temperature/ltc2983.c
+++ b/drivers/iio/temperature/ltc2983.c
@@ -205,6 +205,7 @@ struct ltc2983_data {
 	 * Holds the converted temperature
 	 */
 	__be32 temp ____cacheline_aligned;
+	__be32 chan_val;
 };
 
 struct ltc2983_sensor {
@@ -309,19 +310,18 @@ static int __ltc2983_fault_handler(const struct ltc2983_data *st,
 	return 0;
 }
 
-static int __ltc2983_chan_assign_common(const struct ltc2983_data *st,
+static int __ltc2983_chan_assign_common(struct ltc2983_data *st,
 					const struct ltc2983_sensor *sensor,
 					u32 chan_val)
 {
 	u32 reg = LTC2983_CHAN_START_ADDR(sensor->chan);
-	__be32 __chan_val;
 
 	chan_val |= LTC2983_CHAN_TYPE(sensor->type);
 	dev_dbg(&st->spi->dev, "Assign reg:0x%04X, val:0x%08X\n", reg,
 		chan_val);
-	__chan_val = cpu_to_be32(chan_val);
-	return regmap_bulk_write(st->regmap, reg, &__chan_val,
-				 sizeof(__chan_val));
+	st->chan_val = cpu_to_be32(chan_val);
+	return regmap_bulk_write(st->regmap, reg, &st->chan_val,
+				 sizeof(st->chan_val));
 }
 
 static int __ltc2983_chan_custom_sensor_assign(struct ltc2983_data *st,
-- 
2.35.1



