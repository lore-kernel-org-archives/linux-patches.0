Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A660646D0BD;
	Tue, 21 Jul 2026 18:19:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784657945; cv=none; b=b38coj0CCh0tgARIKvjnDJNbsbqHDxUHG6wqg5bfAt3sjQjSaT6ZhynrwBfq7ujtGg1XZ6yvfWSgQ0VuQnFIoIWjTiQp/1QnbRwgBikPxpq2XEpN6W5y9iK01ihACHZutFHpvmySdWBYcxd8qssVAgMs1NmDmjhaHkLl3hEkaLg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784657945; c=relaxed/simple;
	bh=r1fqfch6s2A9iGsHCBU0n8ef0IaNTQO0RqWzh0hQSBU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qSX5FCc1OZep9NA/bdY6e+zZljsQ04JC0QFd13YsE2VHPTOFFsrv/TplYBaGsDhF8ZPVTPssFYeWy24P7HFHcZ2UhuJWjZ1aATeDsJ3b+Gpq6bmn6PQMAaN47ZZyqst/NNvUO0pFxZ56XTUYmcxg3L5P4ugToUkJebzDIYdKT8Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N37AY6l0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N37AY6l0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 182E61F000E9;
	Tue, 21 Jul 2026 18:19:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784657944;
	bh=VAmzLXSL+1pO8oDgGPxWyr/4Q0LDlN2JCtblyWV6D2I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=N37AY6l0MS1Nqcm3GTNPHW3TXBcVHx0+k43IOtLiPXbCHs3RCb9Y6CPynxZXJkLWf
	 rQ4G4HH+fvwg2a1eDxvWy/BFqiDTEFLs593PIG/RQK+j32YwWxA1LQ/6XQIgxzfuu5
	 JtBR/Wo748D766FFZMICsGBF8kVPo2/1UsoRvLJc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Yang <mmyangfl@gmail.com>,
	Linus Walleij <linusw@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0930/1611] net: dsa: realtek: fix memory leak in rtl8366rb_setup_led()
Date: Tue, 21 Jul 2026 17:17:26 +0200
Message-ID: <20260721152536.303527805@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

From: David Yang <mmyangfl@gmail.com>

[ Upstream commit 056a5087d87ead77dedbe9cf5bde53b7cd4b4651 ]

led_classdev_register_ext() only reads init_data.devicename - it never
stores the pointer. However, the caller allocated devicename with
kasprintf() but never freed it, leaking the string memory.

Fix it with a stack buffer to avoid dynamic buffers completely.

Fixes: 32d617005475 ("net: dsa: realtek: add LED drivers for rtl8366rb")
Signed-off-by: David Yang <mmyangfl@gmail.com>
Reviewed-by: Linus Walleij <linusw@kernel.org>
Link: https://patch.msgid.link/20260618140200.1888707-1-mmyangfl@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/realtek/rtl8366rb-leds.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/dsa/realtek/rtl8366rb-leds.c b/drivers/net/dsa/realtek/rtl8366rb-leds.c
index 509ffd3f8db5cb..ba50d311cb1515 100644
--- a/drivers/net/dsa/realtek/rtl8366rb-leds.c
+++ b/drivers/net/dsa/realtek/rtl8366rb-leds.c
@@ -89,6 +89,7 @@ static int rtl8366rb_setup_led(struct realtek_priv *priv, struct dsa_port *dp,
 	struct led_init_data init_data = { };
 	enum led_default_state state;
 	struct rtl8366rb_led *led;
+	char name[64];
 	u32 led_group;
 	int ret;
 
@@ -129,10 +130,9 @@ static int rtl8366rb_setup_led(struct realtek_priv *priv, struct dsa_port *dp,
 	init_data.fwnode = led_fwnode;
 	init_data.devname_mandatory = true;
 
-	init_data.devicename = kasprintf(GFP_KERNEL, "Realtek-%d:0%d:%d",
-					 dp->ds->index, dp->index, led_group);
-	if (!init_data.devicename)
-		return -ENOMEM;
+	snprintf(name, sizeof(name), "Realtek-%d:0%d:%d",
+		 dp->ds->index, dp->index, led_group);
+	init_data.devicename = name;
 
 	ret = devm_led_classdev_register_ext(priv->dev, &led->cdev, &init_data);
 	if (ret) {
-- 
2.53.0



