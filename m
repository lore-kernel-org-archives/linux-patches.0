Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60503313E13;
	Tue, 16 Dec 2025 11:24:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765884255; cv=none; b=KGMGIaiVayMI4xTlzeKmxAuiGSpce4L6onotxkGYKvSXxglIN8SxFZoWQgfrUtVZnADs2tsZmL2KzH31N0qkSq9Fz5BvP8l7BPQC7t0gLd+YWg5BAz4dyEFOc4Yg1zG3Xc8EYtl7Pov/qcJaxoNhKYgmClt/XZKZEvm8Xhs98hY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765884255; c=relaxed/simple;
	bh=fAKLiq1lLRTnWuaZUL8c3/NA9PJC7PIYVGetCI3z0fo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NNiSekkxOCv3rPGl/Ohqj8Mj6CKobcdyJAsSiWpktrJfFnNyJPShq3SgtJakJ+Basf+RUrHMSDwguEJwZQIJayblQ0qo/yP3yfF/fR8N0Qt1yeGSvTEe36RxCIqLictzCUIW6mGIu4u7VO8qYld7ykuXwGoXxegGgY2hJC1d2O8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QbpzxPdN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QbpzxPdN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD531C4CEF1;
	Tue, 16 Dec 2025 11:24:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765884255;
	bh=fAKLiq1lLRTnWuaZUL8c3/NA9PJC7PIYVGetCI3z0fo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QbpzxPdNorT7iK91ARnkmzgz0RDCLw4ZC/js+tLuCJQR4xIwYPe8D+UO9cOgIUpLV
	 9s5EdcAvMPjrDNEN6ycgjIpLCKYEfsxh6nKH8CRbgWJytS5OE0uL12qwDHD+m3h+tH
	 0LsE7szEhoV0RQ3mbfS2EcWAFqcYMeYUTFWH1Hqc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ivan Abramov <i.abramov@mt-integration.ru>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 105/354] power: supply: max17040: Check iio_read_channel_processed() return code
Date: Tue, 16 Dec 2025 12:11:12 +0100
Message-ID: <20251216111324.723898740@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111320.896758933@linuxfoundation.org>
References: <20251216111320.896758933@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ivan Abramov <i.abramov@mt-integration.ru>

[ Upstream commit 2c68ac48c52ad146523f32b01d70009622bf81aa ]

Since iio_read_channel_processed() may fail, return its exit code on error.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: 814755c48f8b ("power: max17040: get thermal data from adc if available")
Signed-off-by: Ivan Abramov <i.abramov@mt-integration.ru>
Link: https://patch.msgid.link/20251008133648.559286-1-i.abramov@mt-integration.ru
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/max17040_battery.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/power/supply/max17040_battery.c b/drivers/power/supply/max17040_battery.c
index c1640bc6accd2..48453508688a4 100644
--- a/drivers/power/supply/max17040_battery.c
+++ b/drivers/power/supply/max17040_battery.c
@@ -388,6 +388,7 @@ static int max17040_get_property(struct power_supply *psy,
 			    union power_supply_propval *val)
 {
 	struct max17040_chip *chip = power_supply_get_drvdata(psy);
+	int ret;
 
 	switch (psp) {
 	case POWER_SUPPLY_PROP_ONLINE:
@@ -410,7 +411,10 @@ static int max17040_get_property(struct power_supply *psy,
 		if (!chip->channel_temp)
 			return -ENODATA;
 
-		iio_read_channel_processed(chip->channel_temp, &val->intval);
+		ret = iio_read_channel_processed(chip->channel_temp, &val->intval);
+		if (ret)
+			return ret;
+
 		val->intval /= 100; /* Convert from milli- to deci-degree */
 
 		break;
-- 
2.51.0



