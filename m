Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFCB442376D;
	Thu, 16 Jul 2026 14:17:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784211462; cv=none; b=dp6dsse5acvWfMaQwClbKn9Wwg/tRcjRyET4h11Ai2MvBvorWXz/GnET07UP9hC3MQiv57EU6AZ7WD23H/IXE0UYBQHbNfsKbIwkSbmrq/Z02HtX9CNpeO9Ro1j13I672kkddrZAJcTqw4LgKm5QGt+EVkN3K7eCSh1XngCptwY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784211462; c=relaxed/simple;
	bh=Z395vW6vhAMkWhofAe3FzUlNnvTQmldfwlmlqGdpgMM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OAaWWbORGxnQP3F8IWHwMhowl68GKdo7XGbU97l21eSEPNEWZjjl29ne6gPoRiGRwN3lLtK3r3BqimyWVOEkAB7eALZ7hluh7751LPf0SBaYUuzuQdRVOnGLrMzXOb8NRqdER48KM9r9/yhuBt3+w/TWhrz5kcMuuqDrmN7l6P4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V+aHyign; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V+aHyign"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2026B1F000E9;
	Thu, 16 Jul 2026 14:17:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784211461;
	bh=mqAb5lAXUm7v4E9Y/gw9iFes66AE2QI5MXe9jHQEjPs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=V+aHyignW2PCXQgeS30FBWfVc1To2es1B6JZxvSOcs7t0z1uD9wCiEA15dfuG6I40
	 p2AwUzdWeblOzdrG23Cl/stsm6C2qNmDvXtuETbrwBRootMC5MNIh+2Y6w61TbeQB6
	 6mWxioKw96FR5UrTrjoYw0zhtcK/IAE3V2mRDgac=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jean Delvare <khali@linux-fr.org>,
	Johan Hovold <johan@kernel.org>,
	Wolfram Sang <wsa+renesas@sang-engineering.com>
Subject: [PATCH 6.18 437/480] i2c: core: fix adapter deregistration race
Date: Thu, 16 Jul 2026 15:33:04 +0200
Message-ID: <20260716133054.271614784@linuxfoundation.org>
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

commit b1a58ed9eab146b36f41a55db8f5d7ce9fdedf3f upstream.

Adapters can be looked up by their id using i2c_get_adapter() which
takes a reference to the embedded struct device.

Remove the adapter from the IDR before tearing it down during
deregistration (and on registration failure) to make sure its resources
are not accessed after having been freed (e.g. the device name).

Fixes: 35fc37f81881 ("i2c: Limit core locking to the necessary sections")
Cc: stable@vger.kernel.org	# 2.6.31
Cc: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i2c/i2c-core-base.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/drivers/i2c/i2c-core-base.c
+++ b/drivers/i2c/i2c-core-base.c
@@ -1587,7 +1587,7 @@ static int i2c_register_adapter(struct i
 	res = device_add(&adap->dev);
 	if (res) {
 		pr_err("adapter '%s': can't register device (%d)\n", adap->name, res);
-		goto err_remove_debugfs;
+		goto err_replace_id;
 	}
 
 	res = i2c_setup_smbus_alert(adap);
@@ -1614,7 +1614,10 @@ static int i2c_register_adapter(struct i
 out_reg:
 	i2c_deregister_clients(adap);
 	device_del(&adap->dev);
-err_remove_debugfs:
+err_replace_id:
+	mutex_lock(&core_lock);
+	idr_replace(&i2c_adapter_idr, NULL, adap->nr);
+	mutex_unlock(&core_lock);
 	debugfs_remove_recursive(adap->debugfs);
 err_put_adap:
 	init_completion(&adap->dev_released);
@@ -1803,6 +1806,8 @@ void i2c_del_adapter(struct i2c_adapter
 	/* First make sure that this adapter was ever added */
 	mutex_lock(&core_lock);
 	found = idr_find(&i2c_adapter_idr, adap->nr);
+	if (found == adap)
+		idr_replace(&i2c_adapter_idr, NULL, adap->nr);
 	mutex_unlock(&core_lock);
 	if (found != adap) {
 		pr_debug("attempting to delete unregistered adapter [%s]\n", adap->name);


