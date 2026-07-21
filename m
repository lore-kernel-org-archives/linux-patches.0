Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3675E39A7FD;
	Tue, 21 Jul 2026 19:13:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784661215; cv=none; b=l8K3PGHaXcDU7LJUwF1lQ5cW6laIXN6oTBWm1CIoJscnA6NfIJ+IwdjmF/GQI73aEYSgE+dnfamhqOL6RbgcK9uyzkcnuoRT3dmYqM+T8Ndy4jNiZBsa21r9ni/KKKBaFYqixPZX3OCFSLdQTEOJ3QMid4lKaU6pLxXL0XczTtc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784661215; c=relaxed/simple;
	bh=xrM4qVzuTlhAApamm8Ftk6c2ljmDmia7mhZlbuN+CMw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WVu/upXORXeEGdzMW0ng9tY52TRXhV99mPyVFVgJygh5I6KXMRg+AyYt5sBzjr7EKNGohNlsbgGBmB7whxc1+exzRU2Hw6zZNGVW9HTspNnRB2zNXDxZGXJtf8AK4q6NOWOWTB1JBgIYNQVKaaOO/gNElH3VTUZdKwNDj27OSSo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cI5LC/ki; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cI5LC/ki"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C8FC1F000E9;
	Tue, 21 Jul 2026 19:13:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784661214;
	bh=jJ8XbehLvWvL+NMiVnDPKW3oo9HIipEX+WOminKx1MI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cI5LC/ki1YH06rOJJubeoM+kCqpYdu3jtgDL1YH0rgisVCYVmTOy0kWT3Uy2eB0rX
	 GXzmE4Za2Zij12pKgN04ujo4O8HScBSlRCye3SRHC7av7+t9JUqm+Ol2ZNbtjVFX8w
	 +IB9P9e7Pme0Z30jxh6LI+fq0O5k1NHp8JPzjUmg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Yang <mmyangfl@gmail.com>,
	Linus Walleij <linusw@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1273/2077] net: dsa: realtek: fix memory leak in rtl8366rb_setup_led()
Date: Tue, 21 Jul 2026 17:15:46 +0200
Message-ID: <20260721152622.845020977@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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



