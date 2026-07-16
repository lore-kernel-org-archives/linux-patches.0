Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5919423EBD;
	Thu, 16 Jul 2026 14:35:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784212517; cv=none; b=jOcMvrMX13caD35i24M+b3Mtv/61Jx7NRa2j04cQoGxAFEH2rnH1gPEtswfZ8BFW1C6P972+Rti+93x0RC0q5ue6e8MFy0Yjw0rO9LG4cKFFubowcjhADn1QkAU8fBWvdK+W1yXUJQwXqCAtQeCxQinoJPijF8aW2/DSkELDPAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784212517; c=relaxed/simple;
	bh=muPSIvWJZXQ0v6CKnethNqUdrjOfqdPCaUT5WHMjpZQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g+/em6AKw0a6kuF8m/nKg4Tsdx4kY1udQDARSjmwbAVqIj8eVH0Z7e3FCDSMKwg+ad7tWws/Apc0inPbqvWHfu2qj4IIK0OK7v7mvWZ6hluVx78ZpZaoKFk7CExqc0act9UoWDi5XqVZwks3sb/UA5a6yeZHBqySppDEBgxONW8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zfxG7wOd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zfxG7wOd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 162201F000E9;
	Thu, 16 Jul 2026 14:35:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784212515;
	bh=yA8j95aN2ogFpcJSoLf/cnbbnBMlCgV5F6D02KeGIKU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zfxG7wOdEb0pgW/6Q0iHmD8iZisEzQpKFoI7H21kHEmGRylIfiDY41Ros2QRvfveX
	 MHOQk3SHJ5Y99/kJC0iyj0/vv98cNnF3K2n87/A/Hg2BLjajK5JBfo/q4XHgDrdvFm
	 1gEZ/H+c29Myx5LQe7tcgzAJ+6FUo54VooUr/C30=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jean Delvare <khali@linux-fr.org>,
	Johan Hovold <johan@kernel.org>,
	Wolfram Sang <wsa+renesas@sang-engineering.com>
Subject: [PATCH 6.12 327/349] i2c: core: fix adapter deregistration race
Date: Thu, 16 Jul 2026 15:34:21 +0200
Message-ID: <20260716133040.631543014@linuxfoundation.org>
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
@@ -1576,7 +1576,7 @@ static int i2c_register_adapter(struct i
 	res = device_add(&adap->dev);
 	if (res) {
 		pr_err("adapter '%s': can't register device (%d)\n", adap->name, res);
-		goto err_remove_debugfs;
+		goto err_replace_id;
 	}
 
 	res = i2c_setup_smbus_alert(adap);
@@ -1603,7 +1603,10 @@ static int i2c_register_adapter(struct i
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
@@ -1794,6 +1797,8 @@ void i2c_del_adapter(struct i2c_adapter
 	/* First make sure that this adapter was ever added */
 	mutex_lock(&core_lock);
 	found = idr_find(&i2c_adapter_idr, adap->nr);
+	if (found == adap)
+		idr_replace(&i2c_adapter_idr, NULL, adap->nr);
 	mutex_unlock(&core_lock);
 	if (found != adap) {
 		pr_debug("attempting to delete unregistered adapter [%s]\n", adap->name);


