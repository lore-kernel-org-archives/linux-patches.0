Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16E0742F708;
	Thu, 16 Jul 2026 14:33:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784212438; cv=none; b=a58Tt/JKS9vhEigijTR0eiwQpK7RK4ZNEtNL9jGxBkXDyPlyqexYoSc6PZGm7uOgKvehuIDQ9T/I37VjDfRzKeW6l/+cXpSfS2dh6SoL13CZ5qwRRb61YF+77G3PXjUjwscswVZRM3WOYWb5Sc2LCY4lkyBInHxlM5P8rW5ndN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784212438; c=relaxed/simple;
	bh=iMDKtBjCNPsuz0oU3RlX0XzRgMwBD9S5iOhPELmYD3M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pLOs6wuzZd358QsTaGBIf7y/9jf41HK4/72U/gxsy0m1RLOcB/1XsKQjNZ+3b9EKkQKOSHvJmjgYt0inGKXcMiXFuzL4d5XiSCx1Vd1RirNELbTD3RHD4lhkhjKtQoT5YkZIquXGj2S4o6p31vuC8nZ1IrkJ0wLsajzhGmwm0O0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VQ5+n1Ci; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VQ5+n1Ci"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41AC21F000E9;
	Thu, 16 Jul 2026 14:33:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784212436;
	bh=xX5qHyDiTxubPd2pxYfmCN4Ym9/gR3fIL42RhYctxg4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VQ5+n1CiOWn2HhGIqbs4MqkIzAj5wdFml4hM9YKg0vKr9s90CQRp7rES7QbCxyyZM
	 ILt6P9F9LHuTtd+pLcWod7yo1Q2dpoLdedGc+6iW+RzkKcQY7Np65kdToswTiRLW1i
	 fPqasVEevChzN14F66Rpzw8o/XBTxQeqYtN41deY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>,
	Johan Hovold <johan@kernel.org>,
	Wolfram Sang <wsa+renesas@sang-engineering.com>
Subject: [PATCH 6.12 325/349] i2c: core: fix NULL-deref on adapter registration failure
Date: Thu, 16 Jul 2026 15:34:19 +0200
Message-ID: <20260716133040.586304007@linuxfoundation.org>
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

commit 2295d2bb101faa663fbc45fadbb3fec45f107441 upstream.

If adapter registration ever fails the release callback would trigger a
NULL-pointer dereference as the completion struct has not been
initialised.

Note that before the offending commit this would instead have resulted
in a minor memory leak of the adapter name.

Fixes: 3f8c4f5e9a57 ("i2c: core: fix reference leak in i2c_register_adapter()")
Cc: stable@vger.kernel.org
Cc: Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i2c/i2c-core-base.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/drivers/i2c/i2c-core-base.c
+++ b/drivers/i2c/i2c-core-base.c
@@ -1571,8 +1571,7 @@ static int i2c_register_adapter(struct i
 	res = device_add(&adap->dev);
 	if (res) {
 		pr_err("adapter '%s': can't register device (%d)\n", adap->name, res);
-		put_device(&adap->dev);
-		goto err_remove_irq_domain;
+		goto err_put_adap;
 	}
 
 	adap->debugfs = debugfs_create_dir(dev_name(&adap->dev), i2c_debugfs_root);
@@ -1601,10 +1600,12 @@ static int i2c_register_adapter(struct i
 out_reg:
 	i2c_deregister_clients(adap);
 	debugfs_remove_recursive(adap->debugfs);
+	device_del(&adap->dev);
+err_put_adap:
 	init_completion(&adap->dev_released);
-	device_unregister(&adap->dev);
+	put_device(&adap->dev);
 	wait_for_completion(&adap->dev_released);
-err_remove_irq_domain:
+
 	i2c_host_notify_irq_teardown(adap);
 out_list:
 	mutex_lock(&core_lock);


