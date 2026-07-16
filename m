Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C89C2FFDE1;
	Thu, 16 Jul 2026 14:17:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784211452; cv=none; b=Zxh2En4y2JnJMDIV+QXUCNyF6SD47naJ4IyzgkGuGNlMC+wsBXQ1/e1CUFFl0Ib6naBrI2hUzqyCtV87aWuM0iSmmslolfYaVet1exNdscn5kTr3ZV6q2wULv1N8MjFq33OrWR6UlgthGr8ta5bNtkiv8TXilJGsxbI7Wp0jEjc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784211452; c=relaxed/simple;
	bh=Ly9QI5rCFWepvh7oFjaEOv7wVYLDr26d9/+zwNmrwB0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KCfNHHWZVkQnsI+RK8Z+6Bxftu068WWHZFk4bpq/S0/4Kvd74JEdCtuthAZD3kPdtVmzVeV7qZ70M05MqQDQ751diwHLkiMALCBVJEqLiWE8d5wr0mwLo0y1jpksshax7PDAyVpDTvSvSNPoVU4ac+amK9MdPEkm8SYaTf7lmsA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n7S8d0QY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n7S8d0QY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91FB91F000E9;
	Thu, 16 Jul 2026 14:17:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784211451;
	bh=xi6Q8G3MrUJLMFRZHkcFsM7Hu4MmQXilpKLqPU5xbfs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=n7S8d0QYpm2n5jCYHW+dBO++E97eN4YevO8QOiO+9Wz8+hq4C3aJ3u7Oesjc9qbjY
	 sZf/eS4Y7Snt32HinCYrcztNSem7MyjpMlaPfpTcRpZpDkavkYWrQO39n02LKAiC/P
	 dYIGplMBj0Cbft+imVY90ZLS8Ex6uYXjUSS07/zE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Tissoires <bentiss@kernel.org>,
	Johan Hovold <johan@kernel.org>,
	Wolfram Sang <wsa+renesas@sang-engineering.com>
Subject: [PATCH 6.18 434/480] i2c: core: fix irq domain leak on adapter registration failure
Date: Thu, 16 Jul 2026 15:33:01 +0200
Message-ID: <20260716133054.203393844@linuxfoundation.org>
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
@@ -1583,7 +1583,7 @@ static int i2c_register_adapter(struct i
 	if (res) {
 		pr_err("adapter '%s': can't register device (%d)\n", adap->name, res);
 		put_device(&adap->dev);
-		goto out_list;
+		goto err_remove_irq_domain;
 	}
 
 	adap->debugfs = debugfs_create_dir(dev_name(&adap->dev), i2c_debugfs_root);
@@ -1615,6 +1615,8 @@ out_reg:
 	init_completion(&adap->dev_released);
 	device_unregister(&adap->dev);
 	wait_for_completion(&adap->dev_released);
+err_remove_irq_domain:
+	i2c_host_notify_irq_teardown(adap);
 out_list:
 	mutex_lock(&core_lock);
 	idr_remove(&i2c_adapter_idr, adap->nr);


