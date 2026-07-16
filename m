Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5083C22301;
	Thu, 16 Jul 2026 13:56:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784210186; cv=none; b=XYfE317vF0BNJrbtBDe4zFNsBJxEGGyk57j+ToWDCMKbQHsEOjm+cVdC9uqnzGNCSU2cvsvGAI9YVIz//krdQoQ3e6EGi+rLFnwyWVc/t+ii5gY2O4eM2iUNSkn+1l1hWf4A1DtvmorBrYJheLCePub24t0f2SAPF4L0A7SZDxk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784210186; c=relaxed/simple;
	bh=C6lnhXQPxJSXVe34LWWw7pUqSJyY1MCpzkNXLqtlhuo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nmBNbEPYuc+jRQ1tWtvbnx1yvtg7iPa3+3VDoI4oK98GUm0zDk+T9tMjFljBA2pDS8/1Gd6s3YY+pIsN+kLX5eefXBrTWFk5txXgV+2K8NwgaHs09m8PU/+EImNuEaJuKiRWnyeDkOlAzqzJtZ4QCd/87mu5k+39oCL8i8ToN6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fQA7dbB6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fQA7dbB6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5F621F000E9;
	Thu, 16 Jul 2026 13:56:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784210185;
	bh=J/O3R1M04vBLdSYqx5/9iY3BY0//N6vG5VxImifUZ9o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fQA7dbB68sycZDKRrNWXFkGpfYqmXFCFzvojpKPuoiMDoNCOB95y3tZw84UB2y9Ap
	 Pwq8eVhv5FWdQXGOC3p4Sj/IYtxYw6m/WQeTafg3d9gMyZOX9ZeNc7DIzURVcDTZBZ
	 WpwfJGDt2tt4zvjAky8YhN0XZX7Iwl4kCcfG9sFo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Codrin Ciubotariu <codrin.ciubotariu@microchip.com>,
	Johan Hovold <johan@kernel.org>,
	Wolfram Sang <wsa+renesas@sang-engineering.com>
Subject: [PATCH 7.1 470/518] i2c: core: fix adapter probe deferral loop
Date: Thu, 16 Jul 2026 15:32:18 +0200
Message-ID: <20260716133058.128714956@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
References: <20260716133047.772246337@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1561,6 +1561,10 @@ static int i2c_register_adapter(struct i
 	adap->dev.type = &i2c_adapter_type;
 	device_initialize(&adap->dev);
 
+	res = i2c_init_recovery(adap);
+	if (res == -EPROBE_DEFER)
+		goto err_put_adap;
+
 	/*
 	 * This adapter can be used as a parent immediately after device_add(),
 	 * setup runtime-pm (especially ignore-children) before hand.
@@ -1587,10 +1591,6 @@ static int i2c_register_adapter(struct i
 	if (res)
 		goto out_reg;
 
-	res = i2c_init_recovery(adap);
-	if (res == -EPROBE_DEFER)
-		goto out_reg;
-
 	dev_dbg(&adap->dev, "adapter [%s] registered\n", adap->name);
 
 	/* create pre-declared device nodes */


