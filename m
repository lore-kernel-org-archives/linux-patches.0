Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 904FE2C0F69;
	Thu, 16 Jul 2026 14:17:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784211449; cv=none; b=IwzBrcKzvEdcFtvt9wax7n0tqthkn9qkDrK2adGhTvBp+MQhNyumguAF2h0oNbfQ/G3sKHfkDT0H10o+77szP5mkJi5ytsJBP/l2/LSKAdkXgp90zawpbrvh7gOXZwGBrPs+GSkyOYeraSEBfZ+rfvoOonhwvndXkUd8NiSaF3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784211449; c=relaxed/simple;
	bh=ScFP/9VMn7U4K/iOLATi5yeqlAeb4dNLnOv6H8thEuQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RqcPBolzuaIiGR1PmVV736bZvOEE9EomTW6RRYozqV1Zud/W6rCPgmVLKmZQ5aj+UcpQJfOo5hsvjBWXCF+Ptny1pkAb8I0wfJOKjmJglwn9OcwMl/DYAom+0xrOGmFJl++nar/oID3dmFT0Xcu7cSQiUB8TSU1JU3wigxnserM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SAYJdTNx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SAYJdTNx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE16C1F000E9;
	Thu, 16 Jul 2026 14:17:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784211448;
	bh=f9BSLnzdL8PR8z+DZF1WREr5ERMLVnMXQ9p84Y84eYo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SAYJdTNxOym/Kyv9+Ae7j8dtE3L3Efxy/3EOsPm7Sb0Zs7PJeNMvBZD7a6K5alilD
	 pJjcS9axmJ3cj7TlslZrLLtq1EB59DpesKq2Xayjznn+VZvKbHxZE0s1mE4sYEDueW
	 l7R973rcU04Lij+GcNeqNHpF9wxIomqRfnVL+DM8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Codrin Ciubotariu <codrin.ciubotariu@microchip.com>,
	Johan Hovold <johan@kernel.org>,
	Wolfram Sang <wsa+renesas@sang-engineering.com>
Subject: [PATCH 6.18 433/480] i2c: core: fix adapter probe deferral loop
Date: Thu, 16 Jul 2026 15:33:00 +0200
Message-ID: <20260716133054.180001056@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133044.672218725@linuxfoundation.org>
References: <20260716133044.672218725@linuxfoundation.org>
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

From: Johan Hovold <johan@kernel.org>

commit 158efa411c57111d87bf265a3776614f32d70007 upstream.

Drivers must not probe defer after having registered devices as that
will trigger a probe loop if the devices bind to a driver (cf. commit
fbc35b45f9f6 ("Add documentation on meaning of -EPROBE_DEFER")).

Move the recovery initialisation, where the GPIO lookup may fail, before
registering the adapter to prevent this.

Fixes: 75820314de26 ("i2c: core: add generic I2C GPIO recovery")
Cc: stable@vger.kernel.org	# 5.9
Cc: Codrin Ciubotariu <codrin.ciubotariu@microchip.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i2c/i2c-core-base.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/i2c/i2c-core-base.c
+++ b/drivers/i2c/i2c-core-base.c
@@ -1562,6 +1562,10 @@ static int i2c_register_adapter(struct i
 	adap->dev.type = &i2c_adapter_type;
 	device_initialize(&adap->dev);
 
+	res = i2c_init_recovery(adap);
+	if (res == -EPROBE_DEFER)
+		goto err_put_adap;
+
 	/*
 	 * This adapter can be used as a parent immediately after device_add(),
 	 * setup runtime-pm (especially ignore-children) before hand.
@@ -1588,10 +1592,6 @@ static int i2c_register_adapter(struct i
 	if (res)
 		goto out_reg;
 
-	res = i2c_init_recovery(adap);
-	if (res == -EPROBE_DEFER)
-		goto out_reg;
-
 	dev_dbg(&adap->dev, "adapter [%s] registered\n", adap->name);
 
 	/* create pre-declared device nodes */


