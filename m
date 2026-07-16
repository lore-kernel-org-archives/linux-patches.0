Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88E723D522F;
	Thu, 16 Jul 2026 13:56:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784210191; cv=none; b=eIa+1TtpaQJ8NRY1EiWjeCjMNHogvRGYz6jF5GQHAlVfB03ewO8fOvbH+wAVX6STlKn0R18KKQ+t7aYFETXXx4VoYnVuFs1hzL7dFeucNukxXr4cMeT8v7ynAkeyVDT8yoaErAcGilvhpkPVtRl4dJHVeidPuDbCuKRSz9OisJ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784210191; c=relaxed/simple;
	bh=HQ6woQ7nqqr8nFrMQFBjf/yhG1tBFHSNR6stVb1GE7U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XaHHYS7rNuppnAUKSCuV8nSc8r5j9Jcs1b7Ni75KylisSourGlqPxoJNtwy6plldkgaBMPd+aJcuhOL1clyrwVoMVFdX+1rQKui2hihL+bRuKgl8v+rD9kQWpHgsDSJXGURTLQZpDIxUBxd+RF0e/+tJ3nLhUUROIcF8+75GzL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Jz5PUebA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Jz5PUebA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE8FA1F000E9;
	Thu, 16 Jul 2026 13:56:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784210190;
	bh=hOAbI6H66VhyiHx8i7MHTGssJ78mB7Sno10HjoKTEqs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Jz5PUebAkeincq6t59E75ORDqz68E+eXvDKFvhZaPe6IRU54RJx0QDlp5mBbD8bC+
	 K2dy16Iql6zaQ3H2Z1LoE44NKn8YQ6jxSdZWXpl1lJ9+2eXf0xpzghqHQQrH+QAT2o
	 w5TJaHAW1ubaI1JRcB20lC//UC6RwQ4LHsHViUTI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>,
	Johan Hovold <johan@kernel.org>,
	Wolfram Sang <wsa+renesas@sang-engineering.com>
Subject: [PATCH 7.1 472/518] i2c: core: fix NULL-deref on adapter registration failure
Date: Thu, 16 Jul 2026 15:32:20 +0200
Message-ID: <20260716133058.172702576@linuxfoundation.org>
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
@@ -1581,8 +1581,7 @@ static int i2c_register_adapter(struct i
 	res = device_add(&adap->dev);
 	if (res) {
 		pr_err("adapter '%s': can't register device (%d)\n", adap->name, res);
-		put_device(&adap->dev);
-		goto err_remove_irq_domain;
+		goto err_put_adap;
 	}
 
 	adap->debugfs = debugfs_create_dir(dev_name(&adap->dev), i2c_debugfs_root);
@@ -1611,10 +1610,12 @@ static int i2c_register_adapter(struct i
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


