Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73460352FC7;
	Tue, 26 Aug 2025 14:01:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756216862; cv=none; b=ji5NEr1B5e1RELaa4DvU7sHh1GXQEf1PddDYE/KfMI0BwG+6AI1xIx0xV6XPt5p8LZ7B1It1JDTyhFyFLOmB/iis9mr46rMQp8A5YITxUB4MCdN75H/GJJ+AE/xBFjikZ6OJxDibYocSIbx2iRHW/Jkw0BNcyjfVN05FPaXBlEA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756216862; c=relaxed/simple;
	bh=43EenZSNUfhy2tr9uV0tZE6f6G6PqVDgMJtK97tYw80=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q/cMaLX1DRMGcvIQ/h4fEf9dhVDFjmqtXMo7/Vy7buI2rp1fEkGdYQSjyig5gCy0R18mVOG5a2E1NIlr+yKt6cd/89KOG+2n7gpcQxkXxGpnwetb3Pazl90vfLpzGpHUDn1xRFHPIzbXLsDeyeOLO9q4AyfJT2kW0Z0zSuoNP08=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NG2vi7dE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NG2vi7dE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AC03C4CEF1;
	Tue, 26 Aug 2025 14:01:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756216862;
	bh=43EenZSNUfhy2tr9uV0tZE6f6G6PqVDgMJtK97tYw80=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NG2vi7dETwem5KazDEFOjramvKrccuKb53bK+Fg5Ru9fgx7y/iW6uKoNVDqaIuo4j
	 XNS3uERHnXW4I2ntK5G/AKMBLY3k358U9Yyv/CBCjWy5EU15hvxGNay6akv53SVV79
	 4mYk75cerbtmA6GuTUqLbbhdnMr6N3fBrgit2/2o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tzung-Bi Shih <tzungbi@kernel.org>,
	Guenter Roeck <groeck@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 539/644] platform/chrome: cros_ec: remove unneeded label and if-condition
Date: Tue, 26 Aug 2025 13:10:30 +0200
Message-ID: <20250826110959.872438094@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tzung-Bi Shih <tzungbi@kernel.org>

[ Upstream commit 554ec02c97254962bbb0a8776c3160d294fc7e51 ]

Both `ec_dev->ec` and `ec_dev->pd` are initialized to NULL at the
beginning of cros_ec_register().  Also, platform_device_unregister()
takes care if the given platform_device is NULL.

Remove the unneeded goto-label and if-condition.

Signed-off-by: Tzung-Bi Shih <tzungbi@kernel.org>
Reviewed-by: Guenter Roeck <groeck@chromium.org>
Link: https://lore.kernel.org/r/20230308031247.2866401-1-tzungbi@kernel.org
Stable-dep-of: e23749534619 ("platform/chrome: cros_ec: Unregister notifier in cros_ec_unregister()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/chrome/cros_ec.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

--- a/drivers/platform/chrome/cros_ec.c
+++ b/drivers/platform/chrome/cros_ec.c
@@ -207,7 +207,7 @@ int cros_ec_register(struct cros_ec_devi
 	err = cros_ec_query_all(ec_dev);
 	if (err) {
 		dev_err(dev, "Cannot identify the EC: error %d\n", err);
-		goto destroy_mutex;
+		goto exit;
 	}
 
 	if (ec_dev->irq > 0) {
@@ -219,7 +219,7 @@ int cros_ec_register(struct cros_ec_devi
 		if (err) {
 			dev_err(dev, "Failed to request IRQ %d: %d",
 				ec_dev->irq, err);
-			goto destroy_mutex;
+			goto exit;
 		}
 	}
 
@@ -231,7 +231,7 @@ int cros_ec_register(struct cros_ec_devi
 		dev_err(ec_dev->dev,
 			"Failed to create CrOS EC platform device\n");
 		err = PTR_ERR(ec_dev->ec);
-		goto destroy_mutex;
+		goto exit;
 	}
 
 	if (ec_dev->max_passthru) {
@@ -297,7 +297,6 @@ int cros_ec_register(struct cros_ec_devi
 exit:
 	platform_device_unregister(ec_dev->ec);
 	platform_device_unregister(ec_dev->pd);
-destroy_mutex:
 	mutex_destroy(&ec_dev->lock);
 	lockdep_unregister_key(&ec_dev->lockdep_key);
 	return err;
@@ -314,8 +313,7 @@ EXPORT_SYMBOL(cros_ec_register);
  */
 void cros_ec_unregister(struct cros_ec_device *ec_dev)
 {
-	if (ec_dev->pd)
-		platform_device_unregister(ec_dev->pd);
+	platform_device_unregister(ec_dev->pd);
 	platform_device_unregister(ec_dev->ec);
 	mutex_destroy(&ec_dev->lock);
 	lockdep_unregister_key(&ec_dev->lockdep_key);


