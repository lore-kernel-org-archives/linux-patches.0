Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35A883BED61;
	Tue, 21 Jul 2026 21:07:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784668035; cv=none; b=R7SG5cA0JCXKxv/Ng1l/lgpu0RFdmyvxvPKgFNCwdmKz/t+atUsXtGrlLReonmje0U2e89v5XSESlkrMrLheAG1tC9hUvPBwHqSpAIXNMDwYHr0QsreXsWDoI+vlBmcNSxE2uHxbHbZg75VOqO6Oe/KfTZRuy+ovFtYu6zeG9s4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784668035; c=relaxed/simple;
	bh=l8N/iDgthd+OqVWqFBxbiAxf60oda7Obqz/8lPG0iio=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AGtrHuRbg/U9+JZu5bqbLnyQLg5S2Dpx9litan9EfOrLXXbHXm2paiR7KUpnUuXOPmYD2klSR5ZNxoFHbW95SfvfIWP2H3+y/Tjp72A9hzPpdmolhv6Xa7jjVRsWSDCzfLwd8pD9jtKospRMnk7vwwaFCaxZxJcFziL69Mzbxl4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BVyFt9NB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BVyFt9NB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BA591F000E9;
	Tue, 21 Jul 2026 21:07:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784668034;
	bh=X9pa8a/7gKSYiPfMOrhHXKcF0tiM6bsoUcNOV7DWYJg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BVyFt9NB95YlC4geV2tbeUTUmG3Z+HSIlmR8lW6EpdNljMrHQkGTi/PNmnwDbwBU4
	 LN7hYhkKc8zStH2CIxhdX15qDEMSNE0hpwvISg61gxpYbs/C2rDFzmvALKQ96MhUA9
	 8bmzIXtusd3wQysfo05xEERc7+fJZVGfYK4GgD5k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Tissoires <bentiss@kernel.org>,
	Johan Hovold <johan@kernel.org>,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0024/1067] i2c: core: fix irq domain leak on adapter registration failure
Date: Tue, 21 Jul 2026 17:10:25 +0200
Message-ID: <20260721152425.077798168@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

[ Upstream commit 8ce19524e4cc2462685f596a6402fbd8fb984ab2 ]

Make sure to tear down the host notify irq domain on adapter
registration failure to avoid leaking it.

This issue was flagged by Sashiko when reviewing another adapter
registration fix.

Fixes: 4d5538f5882a ("i2c: use an IRQ to report Host Notify events, not alert")
Cc: stable@vger.kernel.org	# 4.10
Cc: Benjamin Tissoires <bentiss@kernel.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Stable-dep-of: ba14d7cf2fe7 ("i2c: core: fix adapter registration race")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i2c/i2c-core-base.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/i2c/i2c-core-base.c
+++ b/drivers/i2c/i2c-core-base.c
@@ -1556,7 +1556,7 @@ static int i2c_register_adapter(struct i
 	res = device_register(&adap->dev);
 	if (res) {
 		pr_err("adapter '%s': can't register device (%d)\n", adap->name, res);
-		goto out_list;
+		goto err_remove_irq_domain;
 	}
 
 	adap->debugfs = debugfs_create_dir(dev_name(&adap->dev), i2c_debugfs_root);
@@ -1604,6 +1604,8 @@ out_reg:
 	init_completion(&adap->dev_released);
 	device_unregister(&adap->dev);
 	wait_for_completion(&adap->dev_released);
+err_remove_irq_domain:
+	i2c_host_notify_irq_teardown(adap);
 out_list:
 	mutex_lock(&core_lock);
 	idr_remove(&i2c_adapter_idr, adap->nr);


