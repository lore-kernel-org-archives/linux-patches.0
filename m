Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7263642FCC0;
	Thu, 16 Jul 2026 14:33:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784212440; cv=none; b=hUdTcEq+L0KA/P73epL4T0vFkbGmQLNlXzGWwjSAuSKvRCi8vLlFvzaerN8uXhIsIHBdmyhjp0IjTpqnbXwTzlHRIELWu9mI8BLCYOww/aTmOpZqyu5Pi85G2Ot5aQSIV9ayvDWt0dNa5ELNaBsTV5RXJParQvCy1sMc7941RWI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784212440; c=relaxed/simple;
	bh=0YhVz4apxXtmn7ULUNydyQKTNA8nbjzRR3LTKn0FTLc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rtAdoxotNp/2FpSYhJZlHwrycnT62NvAl91vDs/GFrJsycEg74SJzeOJKoMmpbUkPDSpfVT1i6/qZKVChBWTUwb4eBz6dIHZQIUk6+gLqeNh0rYfHaehoiRdv5eqAtR+s8E3MuTMGN1/fiVyz/xwW6S7o/yG26auxeEqGQGJGT4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KFm2f084; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KFm2f084"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8B0E1F000E9;
	Thu, 16 Jul 2026 14:33:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784212439;
	bh=pth5+tnM3yRBoT0/vqbZepdPPp+seBEnG+MImeO7U2s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KFm2f084iAI5mXyLl8XASPYeMCEa4LQHECSzFNjZcmkespYuiADayyqFA4iv+sIIZ
	 pzn1eISSqxtbwwjGP806k7wt0JKgTJ/1SSjvprQ3L/Dn0ODZcWddUrfd66IzjJxrn4
	 AJD7FQNFWTxm+GV2XuCUyQkeFRzRHOWRnPlTU5w0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 6.12 326/349] i2c: core: fix adapter debugfs creation
Date: Thu, 16 Jul 2026 15:34:20 +0200
Message-ID: <20260716133040.608699550@linuxfoundation.org>
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

commit 07d5fb537928aad4369aaff0cbae73ba38a719af upstream.

Clients can be registered from bus notifier callbacks so the debugfs
directory needs to be created before registering the adapter as clients
use that directory as their debugfs parent.

Move debugfs creation before adapter registration to avoid having
clients create their debugfs directories in the debugfs root (which is
also more likely to fail due to name collisions).

Note that failure to allocate the adapter name must now be handled
explicitly as debugfs_create_dir() cannot handle a NULL name (unlike
device_add() which returns an error).

Fixes: 73febd775bdb ("i2c: create debugfs entry per adapter")
Cc: stable@vger.kernel.org	# 6.8
Cc: Wolfram Sang <wsa+renesas@sang-engineering.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i2c/i2c-core-base.c |   16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

--- a/drivers/i2c/i2c-core-base.c
+++ b/drivers/i2c/i2c-core-base.c
@@ -1546,7 +1546,10 @@ static int i2c_register_adapter(struct i
 		goto out_list;
 	}
 
-	dev_set_name(&adap->dev, "i2c-%d", adap->nr);
+	res = dev_set_name(&adap->dev, "i2c-%d", adap->nr);
+	if (res)
+		goto err_remove_irq_domain;
+
 	adap->dev.bus = &i2c_bus_type;
 	adap->dev.type = &i2c_adapter_type;
 	device_initialize(&adap->dev);
@@ -1568,14 +1571,14 @@ static int i2c_register_adapter(struct i
 	idr_replace(&i2c_adapter_idr, adap, adap->nr);
 	mutex_unlock(&core_lock);
 
+	adap->debugfs = debugfs_create_dir(dev_name(&adap->dev), i2c_debugfs_root);
+
 	res = device_add(&adap->dev);
 	if (res) {
 		pr_err("adapter '%s': can't register device (%d)\n", adap->name, res);
-		goto err_put_adap;
+		goto err_remove_debugfs;
 	}
 
-	adap->debugfs = debugfs_create_dir(dev_name(&adap->dev), i2c_debugfs_root);
-
 	res = i2c_setup_smbus_alert(adap);
 	if (res)
 		goto out_reg;
@@ -1599,13 +1602,14 @@ static int i2c_register_adapter(struct i
 
 out_reg:
 	i2c_deregister_clients(adap);
-	debugfs_remove_recursive(adap->debugfs);
 	device_del(&adap->dev);
+err_remove_debugfs:
+	debugfs_remove_recursive(adap->debugfs);
 err_put_adap:
 	init_completion(&adap->dev_released);
 	put_device(&adap->dev);
 	wait_for_completion(&adap->dev_released);
-
+err_remove_irq_domain:
 	i2c_host_notify_irq_teardown(adap);
 out_list:
 	mutex_lock(&core_lock);


