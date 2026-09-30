Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC30A515884;
	Wed, 30 Sep 2026 16:44:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790786643; cv=none; b=ca+EWcguy5RMV59PJ5icSuD2HxPcrZW0CxrrxCumD7ma6ULiV3KcWuF2aOcYGDBELUOzYLuBR5ftS4fkZA5mv28PRz1GBcir87Sai84etHJWH6rNchJS9h7K2qcRPAgvJQJvThmxhmWC51wXvqz8Vo946pwiO1cGh8VB1XmGH+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790786643; c=relaxed/simple;
	bh=Q1MAlNd2MfR6Y+Gske4Qfr8t6d0gOZ4TpHKVz8FHKe8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HL9srHLeSixDQP3cKyGRo6iK2cmW+zhHu1xJW7SWzPfCn9QfcAe7qf+NecqzsZy8/UzP6nrCQIr3vH3zwU/6oew1uD9uLjdpmdKkcmKMm1AfIV2SmblDQ3Ce9PTVPRR+1LZrwd2CnrH9dCAe+4yuPbvtTY5jeLVkJBBpdScqGjk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BR98vqyX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BR98vqyX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE20E1F00898;
	Wed, 30 Sep 2026 16:44:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790786642;
	bh=D3hkClvrEjKhrVc7gXb6gEU5dNYrkjnh0mI9BLMwkuc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BR98vqyXQenhps3KNnHECcU3l2XD6/ixLW0kUWVP1bolqtRnVK5tIEjP2jQQwxuws
	 VVgd4H1Q3yTl4OemZv+iqYhwZJOrgjrGIENBSeyZbIEGmlUl2/8WKQiOI7DUH3J/m9
	 N8YBjdURUAoZVBEVIakdP+D1+R7rogmmDw2BBUIc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Subject: [PATCH 6.1 935/982] gpio: arizona: Fix runtime PM leak in arizona_gpio_direction_out()
Date: Wed, 30 Sep 2026 17:27:51 +0200
Message-ID: <20260930152436.824984365@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wentao Liang <vulab@iscas.ac.cn>

commit e9d810279f84b30738f7790c0ed15f8dd5b9024a upstream.

Switching a persistent GPIO line from input to output acquires a
runtime PM reference on the parent device, but if the subsequent
regmap_update_bits() fails the reference is never dropped and no later
direction_in() can balance it since the direction was never changed.
Drop the reference on the update failure path.

Fixes: 27a49ed17e22 ("gpio: arizona: Add support for GPIOs that need to be maintained")
Cc: stable@vger.kernel.org
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Reviewed-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://patch.msgid.link/20260916094701.2007509-1-vulab@iscas.ac.cn
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpio/gpio-arizona.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/drivers/gpio/gpio-arizona.c
+++ b/drivers/gpio/gpio-arizona.c
@@ -118,8 +118,12 @@ static int arizona_gpio_direction_out(st
 	if (value)
 		value = ARIZONA_GPN_LVL;
 
-	return regmap_update_bits(arizona->regmap, ARIZONA_GPIO1_CTRL + offset,
-				  ARIZONA_GPN_DIR | ARIZONA_GPN_LVL, value);
+	ret = regmap_update_bits(arizona->regmap, ARIZONA_GPIO1_CTRL + offset,
+				 ARIZONA_GPN_DIR | ARIZONA_GPN_LVL, value);
+	if (ret < 0 && (val & ARIZONA_GPN_DIR) && persistent)
+		pm_runtime_put_autosuspend(chip->parent);
+
+	return ret;
 }
 
 static void arizona_gpio_set(struct gpio_chip *chip, unsigned offset, int value)


