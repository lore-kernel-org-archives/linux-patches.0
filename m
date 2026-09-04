Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E133F401A25;
	Fri,  4 Sep 2026 05:55:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788501321; cv=none; b=tl8AfRtYq7ljPanSKyvyoU8bfLy+vek47K7GKIBn+ZpE5cqikEVnnM4cuWz+PFQoCc4JaIEuv6PNh8nuBQSaReIMBjlXAqqGaskdvL05B938QORZlwDCSTHwZfVvJbo0mEenFNov2gE5exVboBMUwr3tnRYLX3us4hETAIxNfok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788501321; c=relaxed/simple;
	bh=z5k0l9CQYuPrQOTxlx6cLVtFNKRH8MP+hQ3zNo8tEyM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G+T8xcuzcthzkIfd7cImow/800cIMSqTqlx5EyOvzXfBb2foumcbQzDcW4ja9d/8zIGAzXGwLxm4rUGs5a6WAAekQ/GeXSsGswfOwj5zXcciXbPDyMU4kAaXm3DcDXCn5d5UM6MP9haU0Ez6LgcB04wKzVDzf9b5omH/5KZF3lk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nj/+CLn+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nj/+CLn+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 127511F00A3D;
	Fri,  4 Sep 2026 05:55:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788501319;
	bh=6nuC9E7lP5j/b+wJ7e7h+kyGK1aQRQXY1nium+LHcYo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nj/+CLn+mmxX4tgH0s55ER5bf758LplxMoK0++EtIFVU3jS7Pvb94RJvwXIPaUrxf
	 tZdz4Cm81lz4ygtag788OFzHrgJ+3V1T0htxq/cJ/5eYoym6ISo+FOG80+t+2Qr2ou
	 dFNmBknTzU2qpKB9Ttufw+SXJQfe9KoF6Rxc1lK8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Ke <make_ruc2021@163.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>
Subject: [PATCH 6.18 368/552] power: supply: bq25890: Fix power_supply reference leak
Date: Fri,  4 Sep 2026 06:58:45 +0200
Message-ID: <20260904045758.571520013@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
References: <20260904045747.813364717@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ma Ke <make_ruc2021@163.com>

commit 863c32a83e4235eb0cbf6106f2b124e645302156 upstream.

bq25890_fw_probe() acquires a reference to a secondary charger using
power_supply_get_by_name(), but the reference is not released on later
probe failures or on driver detach.

In particular, failures after bq25890_fw_probe() returns successfully,
such as a failure in bq25890_hw_init(), also leak the reference.

Register a device-managed cleanup action immediately after acquiring
the secondary charger. This releases the reference on all subsequent
probe failures and on driver detach.

Found by code review.

Signed-off-by: Ma Ke <make_ruc2021@163.com>
Cc: stable@vger.kernel.org
Fixes: d54bf877fd87 ("power: supply: bq25890: Add support for having a secondary charger IC")
Link: https://patch.msgid.link/20260722044416.1623621-1-make_ruc2021@163.com
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/power/supply/bq25890_charger.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/drivers/power/supply/bq25890_charger.c
+++ b/drivers/power/supply/bq25890_charger.c
@@ -1389,6 +1389,14 @@ static int bq25890_fw_read_u32_props(str
 	return 0;
 }
 
+static void bq25890_release_secondary_chrg(void *data)
+{
+	struct bq25890_device *bq = data;
+
+	power_supply_put(bq->secondary_chrg);
+	bq->secondary_chrg = NULL;
+}
+
 static int bq25890_fw_probe(struct bq25890_device *bq)
 {
 	int ret;
@@ -1401,6 +1409,10 @@ static int bq25890_fw_probe(struct bq258
 		bq->secondary_chrg = power_supply_get_by_name(str);
 		if (!bq->secondary_chrg)
 			return -EPROBE_DEFER;
+
+		ret = devm_add_action_or_reset(bq->dev, bq25890_release_secondary_chrg, bq);
+		if (ret)
+			return ret;
 	}
 
 	/* Optional, left at 0 if property is not present */


