Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9ED1A1774B;
	Thu, 18 Jan 2024 10:55:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705575332; cv=none; b=SZV1d8JS/D+vr1tzerStSukABvhP5Ykgbc4gAPhUUMVwvKfOh+5372PqBPqjlV1DEwyCqMHus7Lf/ghy3vA9/YuqVTsBtmlGVl/4wNFoy2Nd8n6i0TzmZWKhOv+IMQwA/E5cRrduyoCFQmydC5hrnRXMcxzBXGXF8pSPBWP7j24=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705575332; c=relaxed/simple;
	bh=YBLivcxtcdL+TqUvy0C7dOv/DV8rKMBpJOszR30/X8k=;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:User-Agent:X-stable:
	 X-Patchwork-Hint:MIME-Version:Content-Transfer-Encoding; b=arZFEMbHP3TyemrYqZW7KzGaIQxxLTzXUIPV1dhkbFDvuDXMzovRftNfvVJv1B3ed+RtTPYNhAH2EF3GdFaXMoLv/suRSaiFo3SDdRk+phzvLCVauUAM917ibeft2R3CZ5Xb7z8gqVwgwr1UFW83qHUo+XuCcq2Alf0FnHpfSk0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dBBBLPy8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dBBBLPy8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D1FDC433C7;
	Thu, 18 Jan 2024 10:55:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705575332;
	bh=YBLivcxtcdL+TqUvy0C7dOv/DV8rKMBpJOszR30/X8k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dBBBLPy8p95K54o1i/floaGUEXPJO3wW0IKM6WbiK5yvhdlQUc3431H7Uop9iJcQo
	 I07R58unhG8NiuLLAYcuetK4xyRHI9do5XS1Ai6s+oXtGQBB7khfcbvNWLi4qx31bO
	 /fr2BW+/aNVstkQUWNb+aV7kiH9t0o666e7LSTrU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Armin Wolf <W_Armin@gmx.de>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 065/150] hwmon: (corsair-psu) Fix probe when built-in
Date: Thu, 18 Jan 2024 11:48:07 +0100
Message-ID: <20240118104322.984448655@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240118104320.029537060@linuxfoundation.org>
References: <20240118104320.029537060@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 904890598c11..2c7c92272fe3 100644
--- a/drivers/hwmon/corsair-psu.c
+++ b/drivers/hwmon/corsair-psu.c
@@ -899,7 +899,23 @@ static struct hid_driver corsairpsu_driver = {
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



