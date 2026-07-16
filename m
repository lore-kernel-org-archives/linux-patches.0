Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 929E242F705;
	Thu, 16 Jul 2026 14:33:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784212432; cv=none; b=qbTCarsMgn59kTAZ6Wvra5dZtoGIFqYf/0yfQB6JBePbdmcsZBN+6pWFDcSBT6Is7UWN9aI40R9iJKx0HfnR5uTcoppBxGEfN67kXbduDW26DDiiOAPlJ9hqhzyWoO0XiRTYksvOedzrVLDb2UiMGeoJiWYeYnmjKHOc645yMas=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784212432; c=relaxed/simple;
	bh=9/QfjCnjOUETVWD7+pxzkpeYtFCAbLXdpB4Qawzr1mw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=myf2+ypMdiU+6Fl78bZip1ekVDwVhkMXDy6R5sdXIEKt2DjGsnDJUUCXUtpnbnqPoF6EF+02fssyaB3WKMmfMdSnKOyiJu6eDtBnahMTVkWKT8NnO2ZrFCVQhFEyiyCy6URbVSzAmD4ce/oUrZsX6hVDVt3P50VyaF8w+Ptx+CA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Dd1JeLOH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Dd1JeLOH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 051A71F000E9;
	Thu, 16 Jul 2026 14:33:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784212431;
	bh=9E8M39DrMhFq3yHr0BYeV1pTdVlJg+9TG4ZIbJfiAoo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Dd1JeLOHobBnIxC455LkK6UjRDPhZ6moBcpNFzChNG/BpoiYremyUuPf4Ey03KMaR
	 Xp10gPL1sAl5rJDuNaw4Zt9ztuaSxHTKso0o7hXXzCB2oQn3ZOSxTDn/hfW0V2Gk5r
	 y37s4oLim5f+Y+HoYqnb6qk5dOHC0ec9X9eD4XdA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Codrin Ciubotariu <codrin.ciubotariu@microchip.com>,
	Johan Hovold <johan@kernel.org>,
	Wolfram Sang <wsa+renesas@sang-engineering.com>
Subject: [PATCH 6.12 323/349] i2c: core: fix adapter probe deferral loop
Date: Thu, 16 Jul 2026 15:34:17 +0200
Message-ID: <20260716133040.541640162@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133033.287196923@linuxfoundation.org>
References: <20260716133033.287196923@linuxfoundation.org>
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
@@ -1551,6 +1551,10 @@ static int i2c_register_adapter(struct i
 	adap->dev.type = &i2c_adapter_type;
 	device_initialize(&adap->dev);
 
+	res = i2c_init_recovery(adap);
+	if (res == -EPROBE_DEFER)
+		goto err_put_adap;
+
 	/*
 	 * This adapter can be used as a parent immediately after device_add(),
 	 * setup runtime-pm (especially ignore-children) before hand.
@@ -1577,10 +1581,6 @@ static int i2c_register_adapter(struct i
 	if (res)
 		goto out_reg;
 
-	res = i2c_init_recovery(adap);
-	if (res == -EPROBE_DEFER)
-		goto out_reg;
-
 	dev_dbg(&adap->dev, "adapter [%s] registered\n", adap->name);
 
 	/* create pre-declared device nodes */


