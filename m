Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C277135A6D;
	Tue, 23 Jan 2024 01:08:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705972114; cv=none; b=r08ev9Iv4G1gXOze0ysjCFgjLXDt09YWIhMDORmn1ylZZfGuKCsltXhYdooJuVS2r3CIOL2phaAZ1VZDUhpG4Kw17w/nDNYV7AIitBACCg84S5DOkbYwHfLvoYQgneLK82oHx6ZHqdRnCrsf4QQcBgOP+0OKN4de/Uk7taUmvs8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705972114; c=relaxed/simple;
	bh=Bk6GrOuF/zE7yB626ZMNBjLbGql1YPM6akWzWA1OkL0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Or7zM4sbhjA+iU6b0GDWB6djCurDPgHD+3cINRsQ3m/JpVNEaXnox8LWGFHBHgrlUjEukQUamTKMvBOa1fnY8hwg2LQ55ylm0nmUhI9bh+Aq8hafqjq5d5z28ZUFHu53rJp3kwz7t6PCWlYsYKDYn74eANgDkaTW4HQ2dyyBd6w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tjX0uu7X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tjX0uu7X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC99DC43390;
	Tue, 23 Jan 2024 01:08:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705972114;
	bh=Bk6GrOuF/zE7yB626ZMNBjLbGql1YPM6akWzWA1OkL0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tjX0uu7XBaIWjkFLLiSe9lBl833PdILsSyE9WFkLzJl0it06F92bjakDZqQw8qV5e
	 PrgOpQbxWDBKDRhQ4ojrcc3fEjovwlGr8onIqLyz0JjTJapvyfbRtTOJhfhiBQcCfi
	 9kaAGtD8gyO0tlwFEvHFkcEtNwm+Gk4Xp3pH0cuI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Armin Wolf <W_Armin@gmx.de>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 024/374] hwmon: (corsair-psu) Fix probe when built-in
Date: Mon, 22 Jan 2024 15:54:40 -0800
Message-ID: <20240122235745.476034975@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235744.598274724@linuxfoundation.org>
References: <20240122235744.598274724@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Armin Wolf <W_Armin@gmx.de>

[ Upstream commit 307004e8b254ad28e150b63f299ab9caa4bc7c3e ]

It seems that when the driver is built-in, the HID bus is
initialized after the driver is loaded, which whould cause
module_hid_driver() to fail.
Fix this by registering the driver after the HID bus using
late_initcall() in accordance with other hwmon HID drivers.

Signed-off-by: Armin Wolf <W_Armin@gmx.de>
Link: https://lore.kernel.org/r/20231207210723.222552-1-W_Armin@gmx.de
[groeck: Dropped "compile tested" comment; the patch has been tested
 but the tester did not provide a Tested-by: tag]
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/corsair-psu.c | 18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff --git a/drivers/hwmon/corsair-psu.c b/drivers/hwmon/corsair-psu.c
index 14389fd7afb8..ae983e715110 100644
--- a/drivers/hwmon/corsair-psu.c
+++ b/drivers/hwmon/corsair-psu.c
@@ -808,7 +808,23 @@ static struct hid_driver corsairpsu_driver = {
 	.reset_resume	= corsairpsu_resume,
 #endif
 };
-module_hid_driver(corsairpsu_driver);
+
+static int __init corsair_init(void)
+{
+	return hid_register_driver(&corsairpsu_driver);
+}
+
+static void __exit corsair_exit(void)
+{
+	hid_unregister_driver(&corsairpsu_driver);
+}
+
+/*
+ * With module_init() the driver would load before the HID bus when
+ * built-in, so use late_initcall() instead.
+ */
+late_initcall(corsair_init);
+module_exit(corsair_exit);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Wilken Gottwalt <wilken.gottwalt@posteo.net>");
-- 
2.43.0



