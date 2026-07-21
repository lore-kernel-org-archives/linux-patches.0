Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F5A835C686;
	Tue, 21 Jul 2026 22:31:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784673078; cv=none; b=SgvCvyLhpA8mMCLu6yPUf7FOs0JFNQ5HPFwBIQCzabgL3SQz7cxfmDWcUERtXUpsz+kJ5J8ZKzhY8DE9p9YS1iUTq5Htks+BFydhan9KjDKr8oM0Or2KOLzYQYLDOE+/rct0PwNzbeVqc0pgP+287T6c5cthdogj4/9uwy+Tyh4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784673078; c=relaxed/simple;
	bh=p4T2BHT7P/+NHgwbx3jGuZLhG9D6iirqF2lbI5nRV7M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HwpyuXoaBy0Xr0OIytixhYkHfSHUJ8xeP3C79F6e3/nwyYUs6oGghIG+Xn85NVlVa9ndMRofEvabsdFfhNUnIIceC7LJvvma1DS4mAput6K6X2o1HXzcHwMnSIJFq9xE4PLmE0MXXS+k6QFaFCYqW40izpnB4hPu6Y2+uWeweJI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Onwg0G9/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Onwg0G9/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B4DA1F000E9;
	Tue, 21 Jul 2026 22:31:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784673076;
	bh=t8WwsbtRL+X0TMep1NzX2cDNIlsku9Of4WiSXV+rnGo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Onwg0G9/rVZNgf1/v2JiBxezNXUtz1rXfB5rYWzJFEEVntcE6NTRaI/UQvI8X6+mM
	 zVZpyPllZj1qCABbJZ1Meha6i3oGqpaVLX4xz297B6mnnzzzv++56TKM/QFgjiabZ4
	 DfKi1dch5/gt/AInNok+AOsDvyYMQy6Do666Y5Nc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Tissoires <bentiss@kernel.org>,
	Johan Hovold <johan@kernel.org>,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 026/699] i2c: core: fix irq domain leak on adapter registration failure
Date: Tue, 21 Jul 2026 17:16:25 +0200
Message-ID: <20260721152356.290577131@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1461,7 +1461,7 @@ static int i2c_register_adapter(struct i
 	res = device_register(&adap->dev);
 	if (res) {
 		pr_err("adapter '%s': can't register device (%d)\n", adap->name, res);
-		goto out_list;
+		goto err_remove_irq_domain;
 	}
 
 	res = of_i2c_setup_smbus_alert(adap);
@@ -1505,6 +1505,8 @@ out_reg:
 	init_completion(&adap->dev_released);
 	device_unregister(&adap->dev);
 	wait_for_completion(&adap->dev_released);
+err_remove_irq_domain:
+	i2c_host_notify_irq_teardown(adap);
 out_list:
 	mutex_lock(&core_lock);
 	idr_remove(&i2c_adapter_idr, adap->nr);


