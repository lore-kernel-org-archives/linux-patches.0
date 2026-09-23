Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CB4B53A8A3;
	Wed, 23 Sep 2026 14:51:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790175063; cv=none; b=ArHPWt8pTLcb8dd+z1vIGcr/1CoYrmtyyup27Li9bVq1LYEu7mc3V2rvsl+SudftkH33wjfdprVwA10bVU3zXVTK8xzaEYW0EswSY29iqgy2nyOhlcMQeCTBxQ/Tzg73boUpUIcENq0KvVm++FoysbHz02Yf/kyeTEycl++mWHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790175063; c=relaxed/simple;
	bh=RpTzOU76XniJHn/xnTJbTai0ohzm7CrkrStv6ZgwB0g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ppS1q2m4VOGHhAxzEP6BFLEIIO5rsm7MDMqG7FCSi7y4yfRy0QQn3r6AV8n06c62htK11+0M1mGMkWHpX7waHFO7ps5tFB+OD9TKBfz0Je7XPQWjOhX0Gv2LHdasNxE+Eg6uOJUqlO+VbxnB5/pUTOaeQPZNGIjj35PsF3JiRpA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qPTEw4MV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qPTEw4MV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76B571F000FF;
	Wed, 23 Sep 2026 14:51:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790175062;
	bh=eVR0SBj0+0VFmz0p6/vSynbTLKfITs375PDioH55QIo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qPTEw4MVBOY/28bW8fpJmRM3WwO7Cm2K36URZw0TQ7kUqy14JEClyYtJlxyydJOpm
	 lN+OH9bhKvxkwklNfy3cewF8h1+MJIgBLk5ZGtJfMy2cO7DFv9f/sVt9TcRW5k8W4v
	 eRmu/+K3hYvJArmhy/KrWHMOigxhAIGedLk1AHEw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sanman Pradhan <psanman@juniper.net>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 6.18 309/398] hwmon: (pmbus/tps53679) Select page 0 for single-page TPS53676
Date: Wed, 23 Sep 2026 16:06:23 +0200
Message-ID: <20260923140651.430940947@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140643.441954610@linuxfoundation.org>
References: <20260923140643.441954610@linuxfoundation.org>
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

From: Sanman Pradhan <psanman@juniper.net>

commit 089070b51ccbac411462a30a454690274c6e4270 upstream.

tps53676_identify() derives the number of PMBus pages but does not
ensure that page 0 is selected for single-page configurations.
pmbus_set_page() does not update the PAGE register when info->pages is
1, so if boot firmware leaves PAGE set to another value subsequent
register accesses may target the wrong page.

For single-page devices, select page 0 explicitly.

Fixes: cb3d37b59012 ("hwmon: (pmbus/tps53679) Add support for TI TPS53676")
Cc: stable@vger.kernel.org
Signed-off-by: Sanman Pradhan <psanman@juniper.net>
Link: https://patch.msgid.link/20260916235406.681131-2-sanman.pradhan@hpe.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hwmon/pmbus/tps53679.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/drivers/hwmon/pmbus/tps53679.c
+++ b/drivers/hwmon/pmbus/tps53679.c
@@ -200,6 +200,15 @@ static int tps53676_identify(struct i2c_
 	if (phases_b > 0) {
 		info->pages = 2;
 		info->phases[1] = phases_b;
+	} else {
+		/*
+		 * pmbus_set_page() does not update the PAGE register on
+		 * single-page devices, so select page 0 explicitly in case
+		 * the boot firmware left the device on another page.
+		 */
+		ret = i2c_smbus_write_byte_data(client, PMBUS_PAGE, 0);
+		if (ret < 0)
+			return ret;
 	}
 	return 0;
 }


