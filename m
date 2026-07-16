Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7407942F708;
	Thu, 16 Jul 2026 14:33:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784212435; cv=none; b=HYh/F+FpolOiIdtx4nFLFVWyhRMxrjTRT3WfZ6yIK/ktAXdftYZ31cBOTJlux3D3Z9p/jQ3JuVLMO5/vTO1QAuauD0zu3eKNhkYed75WqzL+lX2XiALQcgrWjE/Xwe+pdmaAbVeXmgrjnog5e4gIUvQo3Xv01bSXWG/7QimpjY4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784212435; c=relaxed/simple;
	bh=OR5TMT9+p6MDQ/FX4yHdo2+STo1TH33fXb9PJruIlmk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EmMMU25y1Pq5+TULpoI19+XPkecjyMCDUBR4yv99cH3dXGafhqT0mBNvGRfiJCSa82JFzpcrcKLYL4ZE43DWcHuX32vYLMQ7CqW2FUR9glJKyOVG4zCugG8gVuCUt9HSxZiQxXqPjMKTZD9oTv0kfSSMoQEDMPFAbaAzxoTbTos=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CF2BmhDc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CF2BmhDc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9982D1F000E9;
	Thu, 16 Jul 2026 14:33:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784212434;
	bh=0jH+7U3kH9sfnJXGh2ZUzhnU9Ht9BxFuT+iWoCTFMcI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CF2BmhDchygu5hN5dB9rhPSNCV+8M8wwpvrpGuMvA6JeAiiA8yZQv5Ar0jMWDqizE
	 jYS7Qtp51EhBIkA8JZ/KacoCIAEqHJd7+QOYM277mdGuVSYsTj5Tc7jRVtXT5jVeT7
	 ptvixN1nmfKdRaMyKR15c+dw0j1PqArPLuQ1zGpQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Tissoires <bentiss@kernel.org>,
	Johan Hovold <johan@kernel.org>,
	Wolfram Sang <wsa+renesas@sang-engineering.com>
Subject: [PATCH 6.12 324/349] i2c: core: fix irq domain leak on adapter registration failure
Date: Thu, 16 Jul 2026 15:34:18 +0200
Message-ID: <20260716133040.563998299@linuxfoundation.org>
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

commit 8ce19524e4cc2462685f596a6402fbd8fb984ab2 upstream.

Make sure to tear down the host notify irq domain on adapter
registration failure to avoid leaking it.

This issue was flagged by Sashiko when reviewing another adapter
registration fix.

Fixes: 4d5538f5882a ("i2c: use an IRQ to report Host Notify events, not alert")
Cc: stable@vger.kernel.org	# 4.10
Cc: Benjamin Tissoires <bentiss@kernel.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i2c/i2c-core-base.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/i2c/i2c-core-base.c
+++ b/drivers/i2c/i2c-core-base.c
@@ -1572,7 +1572,7 @@ static int i2c_register_adapter(struct i
 	if (res) {
 		pr_err("adapter '%s': can't register device (%d)\n", adap->name, res);
 		put_device(&adap->dev);
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


