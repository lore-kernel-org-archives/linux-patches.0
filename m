Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6906E30F95C;
	Mon, 13 Oct 2025 15:23:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369021; cv=none; b=jKxN6OpKuJifpGpaFK7QTKfJk66d/OiAkI9Aa03dADzdptsE9kZBNnZsLfQBN9Jp3rcvExlckA4cL62bwU/YfLmXOsXABMG3qd6SDIDiAUCA20nEdptycCq+TdtufVTtoW1+2aRefilB/ZlbIo2bx8H3gZS/xZP4rRjw/M8bm/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369021; c=relaxed/simple;
	bh=mKzWcum/Xhls3J3kszV2//wlW9ZuTlkDZbHO3a4MeTg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X1f6uAEJhvLUMFRSgqR2d14GzwaysbP8VjQ6OU6OUmGpPkGTLCD8Qz+THoef+zQITbVBNI+ZDhVKL8Kq9IkYbyK5xL94slgypyUEh4xDDtGLrvQTZCP0bWb5YWrYi2SSfahRmqIqERD30tMMhanqZwgWQCvOCN0yvbt8sVCLtPM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aSvtIsSb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aSvtIsSb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E543CC4CEFE;
	Mon, 13 Oct 2025 15:23:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369021;
	bh=mKzWcum/Xhls3J3kszV2//wlW9ZuTlkDZbHO3a4MeTg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aSvtIsSb/N4S2qxh9W2NiHJM9B4LpseH0nJznB+iuafK/Kr+iZ4hhT2wnElKwc1F7
	 r6fW9wfX9CZOGVaQoA5mY7ItSBmaFash07STg2GWePlHBwGHrYA9y6f6AbIXjy7UPf
	 67iOjVtL0uLQbtQJfRNrHFnVwTb8rjEJBU5xB8J8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eugene Shalygin <eugene.shalygin@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 101/563] hwmon: (asus-ec-sensors) Narrow lock for X870E-CREATOR WIFI
Date: Mon, 13 Oct 2025 16:39:22 +0200
Message-ID: <20251013144414.953273494@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eugene Shalygin <eugene.shalygin@gmail.com>

[ Upstream commit 3aa72cf03924d04c8d20f8b319df8f73550dd26c ]

Use mutex from the SIO device rather than the global lock.

Signed-off-by: Eugene Shalygin <eugene.shalygin@gmail.com>

Fixes: 3e538b52157b ("hwmon: (asus-ec-sensors) add ProArt X870E-CREATOR WIFI")
Link: https://lore.kernel.org/r/20250805203157.18446-1-eugene.shalygin@gmail.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/asus-ec-sensors.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hwmon/asus-ec-sensors.c b/drivers/hwmon/asus-ec-sensors.c
index 4ac554731e98a..f43efb80aabf3 100644
--- a/drivers/hwmon/asus-ec-sensors.c
+++ b/drivers/hwmon/asus-ec-sensors.c
@@ -396,7 +396,7 @@ static const struct ec_board_info board_info_pro_art_x870E_creator_wifi = {
 	.sensors = SENSOR_TEMP_CPU | SENSOR_TEMP_CPU_PACKAGE |
 		SENSOR_TEMP_MB | SENSOR_TEMP_VRM |
 		SENSOR_TEMP_T_SENSOR | SENSOR_FAN_CPU_OPT,
-	.mutex_path = ACPI_GLOBAL_LOCK_PSEUDO_PATH,
+	.mutex_path = ASUS_HW_ACCESS_MUTEX_SB_PCI0_SBRG_SIO1_MUT0,
 	.family = family_amd_800_series,
 };
 
-- 
2.51.0



