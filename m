Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8001359FB0;
	Fri,  9 Jan 2026 12:06:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767960411; cv=none; b=RHRHBHcmuUZ57R7KL+tWe1YiIHcqaYUWPJfcaTW84rnpZUb1HfjKpgMZ9GlHhsyDfHm8JpLyc3qs55OPUp5iyuUygmx8rpcO22VHAZj2peG5lGTYxnZeBhL3uL+wmb3zwYIAS/msN6hsA4gPjNtRFuq6z+GPSJvjlDVrzvmveeM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767960411; c=relaxed/simple;
	bh=ZnfdM2ZNn5OawAqJ5hnTrHDYEkv7uf3lIFGglFSmG9U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YZqiBfNQirEfrIUJfrxZiJA2EawSEvGNGn2YtRh5bxdaHYVIrAZQe+4OXWmmAspsbZbSt4D8ET03e4GEs8IuLR9wsshY52Li3sxthamCEjWqO/8N0fdFmvwdXFl8xNyfiZnqB/Ml4C4GjWwURmWIpYADRHg2zTJ1ALQdcTP15Hw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ql17fNG7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ql17fNG7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5201EC4CEF1;
	Fri,  9 Jan 2026 12:06:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767960411;
	bh=ZnfdM2ZNn5OawAqJ5hnTrHDYEkv7uf3lIFGglFSmG9U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ql17fNG7T1vbjh6fvTpqAsrnQTeRBEE0DKmbDovJcPKicoj0mOT/fiDs/wKoTb6KP
	 DlGyRMZMFigHZftFB7KModHua6lEml76KA4syL2qxi8Ur3VpDHNVoDxPRg6EJTownJ
	 A1hzn0SCZFkrzI1LKlVAbP+VbzeW2IvTCrBMnjlg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuhao Jiang <danisjiang@gmail.com>,
	Junrui Luo <moonafterrain@outlook.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 361/737] hwmon: (ibmpex) fix use-after-free in high/low store
Date: Fri,  9 Jan 2026 12:38:20 +0100
Message-ID: <20260109112147.575881385@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Junrui Luo <moonafterrain@outlook.com>

[ Upstream commit 6946c726c3f4c36f0f049e6f97e88c510b15f65d ]

The ibmpex_high_low_store() function retrieves driver data using
dev_get_drvdata() and uses it without validation. This creates a race
condition where the sysfs callback can be invoked after the data
structure is freed, leading to use-after-free.

Fix by adding a NULL check after dev_get_drvdata(), and reordering
operations in the deletion path to prevent TOCTOU.

Reported-by: Yuhao Jiang <danisjiang@gmail.com>
Reported-by: Junrui Luo <moonafterrain@outlook.com>
Fixes: 57c7c3a0fdea ("hwmon: IBM power meter driver")
Signed-off-by: Junrui Luo <moonafterrain@outlook.com>
Link: https://lore.kernel.org/r/MEYPR01MB7886BE2F51BFE41875B74B60AFA0A@MEYPR01MB7886.ausprd01.prod.outlook.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/ibmpex.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/hwmon/ibmpex.c b/drivers/hwmon/ibmpex.c
index db066b368918..40fff7e95ea1 100644
--- a/drivers/hwmon/ibmpex.c
+++ b/drivers/hwmon/ibmpex.c
@@ -282,6 +282,9 @@ static ssize_t ibmpex_high_low_store(struct device *dev,
 {
 	struct ibmpex_bmc_data *data = dev_get_drvdata(dev);
 
+	if (!data)
+		return -ENODEV;
+
 	ibmpex_reset_high_low_data(data);
 
 	return count;
@@ -514,6 +517,9 @@ static void ibmpex_bmc_delete(struct ibmpex_bmc_data *data)
 {
 	int i, j;
 
+	hwmon_device_unregister(data->hwmon_dev);
+	dev_set_drvdata(data->bmc_device, NULL);
+
 	device_remove_file(data->bmc_device,
 			   &sensor_dev_attr_reset_high_low.dev_attr);
 	device_remove_file(data->bmc_device, &sensor_dev_attr_name.dev_attr);
@@ -527,8 +533,7 @@ static void ibmpex_bmc_delete(struct ibmpex_bmc_data *data)
 		}
 
 	list_del(&data->list);
-	dev_set_drvdata(data->bmc_device, NULL);
-	hwmon_device_unregister(data->hwmon_dev);
+
 	ipmi_destroy_user(data->user);
 	kfree(data->sensors);
 	kfree(data);
-- 
2.51.0



