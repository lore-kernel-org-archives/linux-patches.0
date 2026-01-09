Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA91233032C;
	Fri,  9 Jan 2026 12:39:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767962364; cv=none; b=RE4mXt5FH0I3ukcC1yKiIokmxq2Tm8Fzl7AXEltbiwe4hifqs2Tl9r8eIZjorqVtrp1M2PcvmOQ3b2ZEjn+vKaqVLHzGEWQQWnbBvIElcniVhukbE36K9AHvwE3FQQ3XCE8NV70Dorq5VyBFeoS26V3V0AUynWDh9LB3vDmBq8Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767962364; c=relaxed/simple;
	bh=/SQn9W/ouKWPuJijNX2empe6cQRmClTW6AdXTixAyXI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lvqLLjRs+dBSOo6fLwvK22tPpgfUoteiguNbLErR73gYT9MZ8BJ6Wy3Wefi8Mf+kCoNr6xB3FNq12h8hNPk+PhUQcsB2XoKU6Qnocs8z2sIAawFU7EE+FJYTf5szzQGIsbTbGxhyPAFdzZhUEGUtsEDzsjBayrPKzlL3MiexsIk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fnvOirLv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fnvOirLv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 173BBC4CEF1;
	Fri,  9 Jan 2026 12:39:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767962364;
	bh=/SQn9W/ouKWPuJijNX2empe6cQRmClTW6AdXTixAyXI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fnvOirLvlAv/Lqk6T+m2MzOstEzH3J76moIpk4PqDIDqeb8ovHaGMSDJFZGUQYH4T
	 +2AT0l+ELGMEOzYL990JdWjPfcuCLoysM6ogutTlkZjPq1mU6KxQTBesl2acRMNyny
	 IAvmWIJpsMdSKphKv+CHelMSyqtqAQRjkufNs7lc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Ke <make24@iscas.ac.cn>,
	Johan Hovold <johan@kernel.org>,
	Vladimir Zapolskiy <vz@mleia.com>
Subject: [PATCH 6.1 339/634] usb: phy: isp1301: fix non-OF device reference imbalance
Date: Fri,  9 Jan 2026 12:40:17 +0100
Message-ID: <20260109112130.282121267@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

commit b4b64fda4d30a83a7f00e92a0c8a1d47699609f3 upstream.

A recent change fixing a device reference leak in a UDC driver
introduced a potential use-after-free in the non-OF case as the
isp1301_get_client() helper only increases the reference count for the
returned I2C device in the OF case.

Increment the reference count also for non-OF so that the caller can
decrement it unconditionally.

Note that this is inherently racy just as using the returned I2C device
is since nothing is preventing the PHY driver from being unbound while
in use.

Fixes: c84117912bdd ("USB: lpc32xx_udc: Fix error handling in probe")
Cc: stable@vger.kernel.org
Cc: Ma Ke <make24@iscas.ac.cn>
Signed-off-by: Johan Hovold <johan@kernel.org>
Reviewed-by: Vladimir Zapolskiy <vz@mleia.com>
Link: https://patch.msgid.link/20251218153519.19453-3-johan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/phy/phy-isp1301.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/usb/phy/phy-isp1301.c
+++ b/drivers/usb/phy/phy-isp1301.c
@@ -150,7 +150,12 @@ struct i2c_client *isp1301_get_client(st
 		return client;
 
 	/* non-DT: only one ISP1301 chip supported */
-	return isp1301_i2c_client;
+	if (isp1301_i2c_client) {
+		get_device(&isp1301_i2c_client->dev);
+		return isp1301_i2c_client;
+	}
+
+	return NULL;
 }
 EXPORT_SYMBOL_GPL(isp1301_get_client);
 


