Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB80E33437A;
	Thu, 27 Nov 2025 15:03:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764255791; cv=none; b=CGIzNxt5JUxjw5Qy5irwVuTfFaTdZElB6OvXuuZzL8BvyHDjEkVhxEHvWmA3wAdVSMQkKUWWA8nEbNkTPfkpK0Ezq2lBeZT58e1QLpjgaHhmC+VZJ3dTrCBjma60BkxC8WyjOZrBVDEvrURHLQe0vNn99lRjl1nPmuShlHYDeH4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764255791; c=relaxed/simple;
	bh=3q8hc6a/c2FSVaBgo47d/tJYElNQGw8t7LljN+bWO3E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=khJSs4IiFlJt9SS1l3Oc48h84ukLHO5uasyMNmaSmP+HdFxO4Pa+eWS5b5uagtVaNzDTilRB75k8Opd3stJmBH2TzYE+fsJDa66qRtpQbBx5ksGbWiuTXt8TVtChUYQD3FN9VVkqzVRfHhbosR0gmVW4jtkXxTdpfNMl+gmMhBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=la11u1Em; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="la11u1Em"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 767C3C4CEF8;
	Thu, 27 Nov 2025 15:03:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764255790;
	bh=3q8hc6a/c2FSVaBgo47d/tJYElNQGw8t7LljN+bWO3E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=la11u1Emn5UJIHhWc5eCMkNd8daimE3bXiKzAqgXD6xXogOiMDQEhishK2vguGlk/
	 elIWyPQxGWhIqIKJxJu4rZZrxo5wBoSXwAeDysRIOFUj3PaoR8VIje9bNELBYmwZjh
	 zkvqE6V/OyFm0M4Ibs5JAhrgIoWnnNytS9XHnLB8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavel Zhigulin <Pavel.Zhigulin@kaspersky.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Kurt Kanzenbach <kurt@linutronix.de>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 098/175] net: dsa: hellcreek: fix missing error handling in LED registration
Date: Thu, 27 Nov 2025 15:45:51 +0100
Message-ID: <20251127144046.538902311@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251127144042.945669935@linuxfoundation.org>
References: <20251127144042.945669935@linuxfoundation.org>
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
index bfe21f9f7dcd3..cb23bea9c21b8 100644
--- a/drivers/net/dsa/hirschmann/hellcreek_ptp.c
+++ b/drivers/net/dsa/hirschmann/hellcreek_ptp.c
@@ -376,8 +376,18 @@ static int hellcreek_led_setup(struct hellcreek *hellcreek)
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



