Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C74853214;
	Thu, 15 Aug 2024 14:22:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723731734; cv=none; b=W0YLeucnKsTboelWdUGJzRZ5pQGVZYb2usHyfw34k/9Oy0eCcj6xhqiptqgkb0YxhGDkKRAVDk11V2FXefLvK7c/9dj8ywivYi5Ptz1z198HPOusuuPEtT9YkXSCbCEkRQZ/Y4WAlSRC+9C1cigIER772eg9QBkg2h6tGrPL5BQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723731734; c=relaxed/simple;
	bh=uTiU2GMgK7BItprZBZUQca7a7o1zlblwB0h2zNGyDgI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a6TsE1JYAFbJK0Gbq6g0T13sA5m13+DjhrsQqsqe/1aElNbemKumF6ifjRUxwVIpSQXO0971T1aSCvYrPEYuQXF3HnoeYOam3a3AFyFuXspa9Q127/VVWs8BtVc94t1P5t6QS03ES9D/fM5C8FInaOI0hG51lRngYNE6VXvszRo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pTNrvH9X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pTNrvH9X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 452F3C32786;
	Thu, 15 Aug 2024 14:22:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723731734;
	bh=uTiU2GMgK7BItprZBZUQca7a7o1zlblwB0h2zNGyDgI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pTNrvH9XcubGvNwd7j23ZB2uDB5UF3+hiDKO5YOP6hxXGCEsNiGm0ua2biFEbDtRE
	 vOBXV+Hu9bJzgWwyPWHON+oqLVo2FHkkDmFbPy8xJmCjBPB/yK62f/17Wc0mBv+Of0
	 RaSsam9J0WKg/QRaT4NZsSb4ZsBQmGwfZwH4fR0Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Corey Minyard <cminyard@mvista.com>,
	Jean Delvare <jdelvare@suse.de>,
	Benjamin Tissoires <benjamin.tissoires@redhat.com>,
	Wolfram Sang <wsa@the-dreams.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 221/259] i2c: smbus: Dont filter out duplicate alerts
Date: Thu, 15 Aug 2024 15:25:54 +0200
Message-ID: <20240815131911.306400187@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131902.779125794@linuxfoundation.org>
References: <20240815131902.779125794@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Corey Minyard <cminyard@mvista.com>

[ Upstream commit dca0dd28fa5e0a1ec41a623dbaf667601fc62331 ]

Getting the same alert twice in a row is legal and normal,
especially on a fast device (like running in qemu).  Kind of
like interrupts.  So don't report duplicate alerts, and deliver
them normally.

[JD: Fixed subject]

Signed-off-by: Corey Minyard <cminyard@mvista.com>
Signed-off-by: Jean Delvare <jdelvare@suse.de>
Reviewed-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
Stable-dep-of: 37c526f00bc1 ("i2c: smbus: Improve handling of stuck alerts")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/i2c-smbus.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/drivers/i2c/i2c-smbus.c b/drivers/i2c/i2c-smbus.c
index 03096f47e6abb..7e2f5d0eacdb0 100644
--- a/drivers/i2c/i2c-smbus.c
+++ b/drivers/i2c/i2c-smbus.c
@@ -66,7 +66,6 @@ static irqreturn_t smbus_alert(int irq, void *d)
 {
 	struct i2c_smbus_alert *alert = d;
 	struct i2c_client *ara;
-	unsigned short prev_addr = 0;	/* Not a valid address */
 
 	ara = alert->ara;
 
@@ -90,18 +89,12 @@ static irqreturn_t smbus_alert(int irq, void *d)
 		data.addr = status >> 1;
 		data.type = I2C_PROTOCOL_SMBUS_ALERT;
 
-		if (data.addr == prev_addr) {
-			dev_warn(&ara->dev, "Duplicate SMBALERT# from dev "
-				"0x%02x, skipping\n", data.addr);
-			break;
-		}
 		dev_dbg(&ara->dev, "SMBALERT# from dev 0x%02x, flag %d\n",
 			data.addr, data.data);
 
 		/* Notify driver for the device which issued the alert */
 		device_for_each_child(&ara->adapter->dev, &data,
 				      smbus_do_alert);
-		prev_addr = data.addr;
 	}
 
 	return IRQ_HANDLED;
-- 
2.43.0



