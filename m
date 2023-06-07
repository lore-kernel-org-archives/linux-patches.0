Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B7D83AE6D
	for <patches@lists.linux.dev>; Wed,  7 Jun 2023 20:30:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0816C433D2;
	Wed,  7 Jun 2023 20:30:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686169826;
	bh=FYJR6qWSJWlnYbwYLYW3Kfbp2BqXiYtyYtr+SGGnWy4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2BWUBTgkdZMqi1zqZgCCGT/GAO4uUsyiFJlAHawH3SbXBf2Ya0jHZaR5DrUhQIJ6M
	 0iGE1/yI8eg8vT8xr5XYYt8Va9/zG7MdOWJFaEMzCpAedSRq0FZ5OyeZwzVFfwTcYK
	 f/YsPcTGq5DfZJyljKwpEaxNhFGxcWbhBpJVrCCA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Li <Frank.Li@nxp.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.3 199/286] iio: light: vcnl4035: fixed chip ID check
Date: Wed,  7 Jun 2023 22:14:58 +0200
Message-ID: <20230607200929.757649660@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230607200922.978677727@linuxfoundation.org>
References: <20230607200922.978677727@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Frank Li <Frank.Li@nxp.com>

commit a551c26e8e568fad42120843521529241b9bceec upstream.

VCNL4035 register(0xE) ID_L and ID_M define as:

 ID_L: 0x80
 ID_H: 7:6 (0:0)
       5:4 (0:0) slave address = 0x60 (7-bit)
           (0:1) slave address = 0x51 (7-bit)
           (1:0) slave address = 0x40 (7-bit)
           (1:0) slave address = 0x41 (7-bit)
       3:0 Version code default	(0:0:0:0)

So just check ID_L.

Fixes: 55707294c4eb ("iio: light: Add support for vishay vcnl4035")
Signed-off-by: Frank Li <Frank.Li@nxp.com>
Link: https://lore.kernel.org/r/20230501143605.1615549-1-Frank.Li@nxp.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/light/vcnl4035.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/iio/light/vcnl4035.c
+++ b/drivers/iio/light/vcnl4035.c
@@ -8,6 +8,7 @@
  * TODO: Proximity
  */
 #include <linux/bitops.h>
+#include <linux/bitfield.h>
 #include <linux/i2c.h>
 #include <linux/module.h>
 #include <linux/pm_runtime.h>
@@ -42,6 +43,7 @@
 #define VCNL4035_ALS_PERS_MASK		GENMASK(3, 2)
 #define VCNL4035_INT_ALS_IF_H_MASK	BIT(12)
 #define VCNL4035_INT_ALS_IF_L_MASK	BIT(13)
+#define VCNL4035_DEV_ID_MASK		GENMASK(7, 0)
 
 /* Default values */
 #define VCNL4035_MODE_ALS_ENABLE	BIT(0)
@@ -413,6 +415,7 @@ static int vcnl4035_init(struct vcnl4035
 		return ret;
 	}
 
+	id = FIELD_GET(VCNL4035_DEV_ID_MASK, id);
 	if (id != VCNL4035_DEV_ID_VAL) {
 		dev_err(&data->client->dev, "Wrong id, got %x, expected %x\n",
 			id, VCNL4035_DEV_ID_VAL);


