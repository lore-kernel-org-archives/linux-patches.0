Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA851331234;
	Mon, 29 Dec 2025 16:19:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025166; cv=none; b=qfHjhj6eKcfxKsHo3mlodYeOUFWlqEiC0aDFyKsFEB8j97i0pbmWVvWl6pVOMokqnqyTOVtHJI1Yj7xz+brcaS5bRyo/ifxmkmMUCm346JhzhVJasxPDNhEXsdhZcQ9ziNb0ROzKxpXz3VBYqwWRQus+YYQCoOsuGWLww4XU5mQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025166; c=relaxed/simple;
	bh=Q+ILSGbJfr8aINzBFZI0bHY49sEIlsSEyfEGrUzd1qU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B6SMcttTkbzl58VdwKUPbLV0c5KFt+lHMU4jiwgt0fLMdQIcmHCxQPcgSa7+ll1GyZ1OPdvu4z/EZTPHBd8sNP+t17e/LPIWJ3x/J+ceM5WAcVKS6S1qDMyzsOM3QQbd0/QbPJ0uXKOdSVMargeZT5EAY/CHeGkQ8RbUWj3BRmk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QNBLxxL6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QNBLxxL6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44891C4CEF7;
	Mon, 29 Dec 2025 16:19:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025166;
	bh=Q+ILSGbJfr8aINzBFZI0bHY49sEIlsSEyfEGrUzd1qU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QNBLxxL6CBjA4J7M2zCyb9+z3HlLp5GbtGVPChw//ew3vmvp/F/bKqBUAbZvMvFbC
	 3HqK26OzmFUghn3OBPBlLeXE9LN6qD1+MTxzyPETFK8G7eRoYmG238vYZ0f5ojZT82
	 I2e9OsfastyUbDjh1oO0Z0BlPKdoMwxDr1I3MbgY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuhao Jiang <danisjiang@gmail.com>,
	Junrui Luo <moonafterrain@outlook.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 117/430] hwmon: (ibmpex) fix use-after-free in high/low store
Date: Mon, 29 Dec 2025 17:08:39 +0100
Message-ID: <20251229160728.672837996@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
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
index 228c5f6c6f38..129f3a9e8fe9 100644
--- a/drivers/hwmon/ibmpex.c
+++ b/drivers/hwmon/ibmpex.c
@@ -277,6 +277,9 @@ static ssize_t ibmpex_high_low_store(struct device *dev,
 {
 	struct ibmpex_bmc_data *data = dev_get_drvdata(dev);
 
+	if (!data)
+		return -ENODEV;
+
 	ibmpex_reset_high_low_data(data);
 
 	return count;
@@ -508,6 +511,9 @@ static void ibmpex_bmc_delete(struct ibmpex_bmc_data *data)
 {
 	int i, j;
 
+	hwmon_device_unregister(data->hwmon_dev);
+	dev_set_drvdata(data->bmc_device, NULL);
+
 	device_remove_file(data->bmc_device,
 			   &sensor_dev_attr_reset_high_low.dev_attr);
 	device_remove_file(data->bmc_device, &dev_attr_name.attr);
@@ -521,8 +527,7 @@ static void ibmpex_bmc_delete(struct ibmpex_bmc_data *data)
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



