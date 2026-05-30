Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C172274FDC;
	Sat, 30 May 2026 18:19:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780165190; cv=none; b=HI1di8FSr3idhhYylvX7bqFmD2WN20xyXdGlS7LMdOB54FTnDiMjm5/Opda0qCBNvptRJOUv0nyS5ID26FnebvvkVAVffs7S6inyi2O7mGn+sKMPWS2qzPI78jJwc9yF92iuy4XxQtgwQ0iXARb19n6LWO44OHcseq6BSygirio=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780165190; c=relaxed/simple;
	bh=LTn3/gkg+vO34+e9VKg3/FfJRvI27PggI0VgnU3Dap4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ApsU12D96FGbdWZdyYFbk2WQwpgaLH1OnBMaS/m/jhW3PosTwOlev5vskpusU8chmM7ZzzVbyKJXEIAkSBlwig5/9kL4Jobd3cglbOmvP6uoCb9NkxvAxnR71iuN0S0Hq5GWMHNeAzP5t9cuwmBu5eUCu4rgf8f/RVv2UjoMi1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pg/qYPxT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pg/qYPxT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFFD91F00893;
	Sat, 30 May 2026 18:19:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780165189;
	bh=xq/GWCd5c/XxmW9675B+UPh8h9WUHJVjsk2SK3pjhZM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pg/qYPxTzoy6+2VgL+F87ggcI+jrK6I+ePdOZOuj4ckAtw9go99veZRXDenMxh6iV
	 7TIZ6JBUVdgnMc2C0+RJxQa+z2Z2k1Uct0etfQ7EIzKLN1eJYORe+HEysEF/9kPLYf
	 MwqEZ8mCzZ9GOAIlQxFj/iuNKUMvGI8WlH08mFNQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kent Gibson <warthog618@gmail.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 775/776] gpio: cdev: check if uAPI v2 config attributes are correctly zeroed
Date: Sat, 30 May 2026 18:08:09 +0200
Message-ID: <20260530160259.729481435@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

From: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>

[ Upstream commit 3e6ccd790ed69bedd3d9626d01dd35cf9821c121 ]

We check the padding of other uAPI v2 structures but not that of line
config attributes. For used attributes: check if their padding is
zeroed, for unused: check if the entire structure is zeroed.

Fixes: 3c0d9c635ae2 ("gpiolib: cdev: support GPIO_V2_GET_LINE_IOCTL and GPIO_V2_LINE_GET_VALUES_IOCTL")
Reviewed-by: Kent Gibson <warthog618@gmail.com>
Link: https://patch.msgid.link/20260521-gpio-cdev-attr-padding-check-v3-1-ec3bcbe2e358@oss.qualcomm.com
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpiolib-cdev.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/gpio/gpiolib-cdev.c b/drivers/gpio/gpiolib-cdev.c
index 58ad8328bedc2..b1e4571401c9a 100644
--- a/drivers/gpio/gpiolib-cdev.c
+++ b/drivers/gpio/gpiolib-cdev.c
@@ -1011,6 +1011,7 @@ static int gpio_v2_line_flags_validate(u64 flags)
 static int gpio_v2_line_config_validate(struct gpio_v2_line_config *lc,
 					unsigned int num_lines)
 {
+	size_t unused_attrs;
 	unsigned int i;
 	u64 flags;
 	int ret;
@@ -1018,9 +1019,21 @@ static int gpio_v2_line_config_validate(struct gpio_v2_line_config *lc,
 	if (lc->num_attrs > GPIO_V2_LINE_NUM_ATTRS_MAX)
 		return -EINVAL;
 
+	unused_attrs = GPIO_V2_LINE_NUM_ATTRS_MAX - lc->num_attrs;
+
 	if (!mem_is_zero(lc->padding, sizeof(lc->padding)))
 		return -EINVAL;
 
+	for (i = 0; i < lc->num_attrs; i++) {
+		if (lc->attrs[i].attr.padding != 0)
+			return -EINVAL;
+	}
+
+	if (unused_attrs) {
+		if (!mem_is_zero(&lc->attrs[lc->num_attrs], unused_attrs * sizeof(*lc->attrs)))
+			return -EINVAL;
+	}
+
 	for (i = 0; i < num_lines; i++) {
 		flags = gpio_v2_line_config_flags(lc, i);
 		ret = gpio_v2_line_flags_validate(flags);
-- 
2.53.0



