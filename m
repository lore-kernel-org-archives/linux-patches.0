Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E856A31E85C;
	Thu, 16 Jul 2026 13:56:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784210189; cv=none; b=eIeYCnbGi1rajAY8XC1C9rlSuCsVXQuzsK/ljBCb8wrXvCSLaDpGvtYH8bMGKydlqFKBgvWN/67E7c/VxX3zwiUJko4++lY6rz8w1ZCLoLetE/CBgId1VdzBS+hhZCSsOL4frhlFBe3nYUf1m0Pkwo8HicO2v8FILi8ZbhEzG0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784210189; c=relaxed/simple;
	bh=wCyTCraa9R+ISFxyCxBL+sRNEb4dqgN8bqHVxOEXS9A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rAJiC8DqkWd2UWfENARsVyEOWZKcdJRY1wh4/vnb+c3J4lBZPIe/Ur7mqmnIEpT72Dxid1rUvVUF5MZzJycBPk/kBe9YqLGLOvbJ5dVopTfX5Her2jhA1stOrUGzzukvQQt50us4iemFn/ueYjeZpoWMGUCSts32cBWDMlIheJk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ImLkqtpa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ImLkqtpa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A21C1F000E9;
	Thu, 16 Jul 2026 13:56:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784210187;
	bh=U+WRPnr8+9k02twMfhI3NGzPP0PnKwoS3xRfYD/8dpM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ImLkqtpar/ndmkY1ZfEvx0VwX/janL8S/Wwo/enlJ1QEnSAke1q59kKL0h69YsT6x
	 OcZq4PlrNAM1O4+RFqzIBFbChBDlUuPcmEL993B8guYg6g2e8CmyHOZPpEtc0Nkg+s
	 bj8NOXMMU51P0bA9H9p3DG0mOwFyu//x4eEZxG6c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Tissoires <bentiss@kernel.org>,
	Johan Hovold <johan@kernel.org>,
	Wolfram Sang <wsa+renesas@sang-engineering.com>
Subject: [PATCH 7.1 471/518] i2c: core: fix irq domain leak on adapter registration failure
Date: Thu, 16 Jul 2026 15:32:19 +0200
Message-ID: <20260716133058.151251650@linuxfoundation.org>
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
@@ -1582,7 +1582,7 @@ static int i2c_register_adapter(struct i
 	if (res) {
 		pr_err("adapter '%s': can't register device (%d)\n", adap->name, res);
 		put_device(&adap->dev);
-		goto out_list;
+		goto err_remove_irq_domain;
 	}
 
 	adap->debugfs = debugfs_create_dir(dev_name(&adap->dev), i2c_debugfs_root);
@@ -1614,6 +1614,8 @@ out_reg:
 	init_completion(&adap->dev_released);
 	device_unregister(&adap->dev);
 	wait_for_completion(&adap->dev_released);
+err_remove_irq_domain:
+	i2c_host_notify_irq_teardown(adap);
 out_list:
 	mutex_lock(&core_lock);
 	idr_remove(&i2c_adapter_idr, adap->nr);


