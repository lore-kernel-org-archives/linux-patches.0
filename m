Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4318A263F4D;
	Tue,  8 Apr 2025 12:29:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744115373; cv=none; b=dkwySJyGv1jbLuAgZ/FKuH3Pnc4sJ63/7lm38/tb+4oCKR6WSu+4H4+XRjoOcPf8B87odO+TQiQqKm5YJN5vZgJ645xTUqt5Qjp7RWn48O47f03ejB+hZoVZMcIRCrDrYEHz9shs3EioGEspPIdu30mk4EIFTRzG/uWD2C9MlQg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744115373; c=relaxed/simple;
	bh=OYKxhML6i7nOsUu9cclVIW3PQNhAlanIXSkE+ZwZQz4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SZDqpSIt+RmB2PxZmawHN1Z8CCf5TgXzci8dYAe6LWHMaXOqO2YL0PY0TtxOY3xYjMv6oZCVbw+PZLM2uRAksMKaSFFzR+AyynW0ROevjS7GqG9MidUpPmEQFRb1C58lqn9ihHjLxRdNLqyICyO+tHCTOrPMaInphFbYYPo25S8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nBVCApdL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nBVCApdL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 677B8C4CEE5;
	Tue,  8 Apr 2025 12:29:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744115372;
	bh=OYKxhML6i7nOsUu9cclVIW3PQNhAlanIXSkE+ZwZQz4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nBVCApdLZNk52azOfPLlqKnavxFM65rWLk/CaGE93OZ5A4JwVGiUwdwBK72BXzvPA
	 Nssrs04KG7PY5Gtp5Lk/fBtwE7JonhpcV59VZxQXoAUwr3Y89sHUfozel8epX3eanx
	 mEoe97jwVrEYpfR2H3UznGcIPjHGGlfoIvIFadyM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nihar Chaithanya <niharchaithanya@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 423/499] staging: gpib: agilent_82357a: Handle gpib_register_driver() errors
Date: Tue,  8 Apr 2025 12:50:35 +0200
Message-ID: <20250408104901.776191854@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104851.256868745@linuxfoundation.org>
References: <20250408104851.256868745@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nihar Chaithanya <niharchaithanya@gmail.com>

[ Upstream commit 9e43ebc613e2adb9b9e900e11a4099e104b61f2d ]

The usb_register() function can fail and returns an error value which
is not returned. The function gpib_register_driver() can also fail
which can result in semi-registered module.

In case gpib_register_driver() fails unregister the previous usb driver
registering function. Return the error value if gpib_register_driver()
or usb_register() functions fail. Add pr_err when registering driver
fails also indicating the error value.

Signed-off-by: Nihar Chaithanya <niharchaithanya@gmail.com>
Link: https://lore.kernel.org/r/20241230185633.175690-4-niharchaithanya@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 8491e73a5223 ("staging: gpib: Fix Oops after disconnect in agilent usb")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../staging/gpib/agilent_82357a/agilent_82357a.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/gpib/agilent_82357a/agilent_82357a.c b/drivers/staging/gpib/agilent_82357a/agilent_82357a.c
index bf05fb4a736b3..261fb6d2e9916 100644
--- a/drivers/staging/gpib/agilent_82357a/agilent_82357a.c
+++ b/drivers/staging/gpib/agilent_82357a/agilent_82357a.c
@@ -1691,12 +1691,24 @@ static struct usb_driver agilent_82357a_bus_driver = {
 static int __init agilent_82357a_init_module(void)
 {
 	int i;
+	int ret;
 
 	pr_info("agilent_82357a_gpib driver loading");
 	for (i = 0; i < MAX_NUM_82357A_INTERFACES; ++i)
 		agilent_82357a_driver_interfaces[i] = NULL;
-	usb_register(&agilent_82357a_bus_driver);
-	gpib_register_driver(&agilent_82357a_gpib_interface, THIS_MODULE);
+
+	ret = usb_register(&agilent_82357a_bus_driver);
+	if (ret) {
+		pr_err("agilent_82357a: usb_register failed: error = %d\n", ret);
+		return ret;
+	}
+
+	ret = gpib_register_driver(&agilent_82357a_gpib_interface, THIS_MODULE);
+	if (ret) {
+		pr_err("agilent_82357a: gpib_register_driver failed: error = %d\n", ret);
+		usb_deregister(&agilent_82357a_bus_driver);
+		return ret;
+	}
 
 	return 0;
 }
-- 
2.39.5



