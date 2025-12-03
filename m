Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5170233B97E;
	Wed,  3 Dec 2025 16:11:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764778272; cv=none; b=JbfdppCA9k3GTzFlDskaDo+vqhi4KfJNSSk0aeGdRGr621y65+OEX6u4KhQ6fBR8Po1+QBd24AzPlLdhJpnVGyT7lPb3Sg4bf6Jg7SCb0MJkimeS6RIudFgiZ62Z3lsbV5BFNqrz4n/paE4nEWIuGYnFYerkJqEBwPOgikXLCeI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764778272; c=relaxed/simple;
	bh=/nHm66zBgfvpvgP41co/S+d9Y1fuXrUEokffL6MSGKc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O/AOijryA2bghXlf2zcQyx3kpiedfPc4mz5zrLw73E0M1pmlbrhLXgrYXBTlKQpHqg5tbblwwQywFEi5S/nEiu7iyR7+uA8SZtiqyD25wmjGgt86oTmcACwrqJ8YeQR037bW65uTZwrB0miKFTRnfDz8a/AaLYl/XO/vBtn8zT4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xyJRcKtA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xyJRcKtA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFFBEC4CEF5;
	Wed,  3 Dec 2025 16:11:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764778272;
	bh=/nHm66zBgfvpvgP41co/S+d9Y1fuXrUEokffL6MSGKc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xyJRcKtA6ioaTzTmud4q1hnlxA1jb/KDM0o99OkJJWu+m96GGb92klXqTD91Yeby4
	 hlGXzhG819bu7ilOYVLfKhIlkiuBupujBGNZ2Jv9hR0MhXbd5/OGVIuqb6UopJOSfU
	 Y38/46J2nsRGrIZEMoMJwmutkLv5esP32OdpDoug=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavel Zhigulin <Pavel.Zhigulin@kaspersky.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Kurt Kanzenbach <kurt@linutronix.de>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 295/392] net: dsa: hellcreek: fix missing error handling in LED registration
Date: Wed,  3 Dec 2025 16:27:25 +0100
Message-ID: <20251203152425.011115351@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152414.082328008@linuxfoundation.org>
References: <20251203152414.082328008@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pavel Zhigulin <Pavel.Zhigulin@kaspersky.com>

[ Upstream commit e6751b0b19a6baab219a62e1e302b8aa6b5a55b2 ]

The LED setup routine registered both led_sync_good
and led_is_gm devices without checking the return
values of led_classdev_register(). If either registration
failed, the function continued silently, leaving the
driver in a partially-initialized state and leaking
a registered LED classdev.

Add proper error handling

Fixes: 7d9ee2e8ff15 ("net: dsa: hellcreek: Add PTP status LEDs")
Signed-off-by: Pavel Zhigulin <Pavel.Zhigulin@kaspersky.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Acked-by: Kurt Kanzenbach <kurt@linutronix.de>
Link: https://patch.msgid.link/20251113135745.92375-1-Pavel.Zhigulin@kaspersky.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/hirschmann/hellcreek_ptp.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/hirschmann/hellcreek_ptp.c b/drivers/net/dsa/hirschmann/hellcreek_ptp.c
index b28baab6d56a1..763666480a8a8 100644
--- a/drivers/net/dsa/hirschmann/hellcreek_ptp.c
+++ b/drivers/net/dsa/hirschmann/hellcreek_ptp.c
@@ -367,8 +367,18 @@ static int hellcreek_led_setup(struct hellcreek *hellcreek)
 		hellcreek_set_brightness(hellcreek, STATUS_OUT_IS_GM, 1);
 
 	/* Register both leds */
-	led_classdev_register(hellcreek->dev, &hellcreek->led_sync_good);
-	led_classdev_register(hellcreek->dev, &hellcreek->led_is_gm);
+	ret = led_classdev_register(hellcreek->dev, &hellcreek->led_sync_good);
+	if (ret) {
+		dev_err(hellcreek->dev, "Failed to register sync_good LED\n");
+		goto out;
+	}
+
+	ret = led_classdev_register(hellcreek->dev, &hellcreek->led_is_gm);
+	if (ret) {
+		dev_err(hellcreek->dev, "Failed to register is_gm LED\n");
+		led_classdev_unregister(&hellcreek->led_sync_good);
+		goto out;
+	}
 
 	ret = 0;
 
-- 
2.51.0



