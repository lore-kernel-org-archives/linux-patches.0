Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB5694582F8;
	Tue, 21 Jul 2026 22:31:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784673086; cv=none; b=V09CLhST+hdGhvENqIbOU8aC0xh6Etf5tzwa5AZSFkZ6AVnAimTElGb1sa31fDWB3GjMT3BMPgZeEmg7Cm74bt0tMZTvuhMrWMILyradtYEdcGyVwgIyXyxrqiJeBCsXAvOynHdDqJcsMeNfuiD2vkJozn5F8ma1gLU1KrX+jxQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784673086; c=relaxed/simple;
	bh=yjiBVs3pFFdf9Io/1zpwBig1MBe0GPBENWatsJ3P26g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iBZJYN1+2TDEpqAxuj68wtEt+0ETNxe6D5QSY+h5UeARO+rNYDCULUuDavmTXp8fvUM5kN+mj1FnpiJYrsJKbrVawlk9CJ1kqNaBTlc1Mm5W3VgbaH07u2jc8FY4qPlP3Tpjdx7zH6MbhthqEgxMBGBTqt8H9aeQM2MW0PiNTTs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HNeUTtw+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HNeUTtw+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EFF41F00A3A;
	Tue, 21 Jul 2026 22:31:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784673084;
	bh=nJ0Njmx5bJIVvr1JRoeplk5uI9OlDOjpA54xK16aqs0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HNeUTtw+FHgV7lk2X/+qwh5KCp2hnd7BPy+oSreCPlIaNhXOmfy9kbZPHXLPzahCs
	 Y09lfViufnI/VXXhnV+DCzFWUfhl6EYAgdUfU4p1RBKoQCU+RJG/jo83prr5Ap9GVU
	 WvaDT8LfSn/I11wZJkkfc223LPQKT5SWlpAMyx3U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Johan Hovold <johan@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 029/699] i2c: core: fix adapter debugfs creation
Date: Tue, 21 Jul 2026 17:16:28 +0200
Message-ID: <20260721152356.361313604@linuxfoundation.org>
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

[ Upstream commit 07d5fb537928aad4369aaff0cbae73ba38a719af ]

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
Stable-dep-of: ba14d7cf2fe7 ("i2c: core: fix adapter registration race")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i2c/i2c-core-base.c |   19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

--- a/drivers/i2c/i2c-core-base.c
+++ b/drivers/i2c/i2c-core-base.c
@@ -1456,10 +1456,19 @@ static int i2c_register_adapter(struct i
 		goto out_list;
 	}
 
-	dev_set_name(&adap->dev, "i2c-%d", adap->nr);
+	res = dev_set_name(&adap->dev, "i2c-%d", adap->nr);
+	if (res)
+		goto err_remove_irq_domain;
+
 	adap->dev.bus = &i2c_bus_type;
 	adap->dev.type = &i2c_adapter_type;
-	res = device_register(&adap->dev);
+	device_initialize(&adap->dev);
+
+	pm_runtime_no_callbacks(&adap->dev);
+	pm_suspend_ignore_children(&adap->dev, true);
+	pm_runtime_enable(&adap->dev);
+
+	res = device_add(&adap->dev);
 	if (res) {
 		pr_err("adapter '%s': can't register device (%d)\n", adap->name, res);
 		goto err_put_adap;
@@ -1469,10 +1478,6 @@ static int i2c_register_adapter(struct i
 	if (res)
 		goto out_reg;
 
-	pm_runtime_no_callbacks(&adap->dev);
-	pm_suspend_ignore_children(&adap->dev, true);
-	pm_runtime_enable(&adap->dev);
-
 	res = i2c_init_recovery(adap);
 	if (res == -EPROBE_DEFER)
 		goto out_reg;
@@ -1509,7 +1514,7 @@ err_put_adap:
 	init_completion(&adap->dev_released);
 	put_device(&adap->dev);
 	wait_for_completion(&adap->dev_released);
-
+err_remove_irq_domain:
 	i2c_host_notify_irq_teardown(adap);
 out_list:
 	mutex_lock(&core_lock);


