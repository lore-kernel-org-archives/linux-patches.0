Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 727FC4E77FD;
	Wed, 30 Sep 2026 18:36:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790793365; cv=none; b=r7ZYKIZFEuZKBGXLQFkBz05i36QdOvjb15iVJYOf/lNxVVBW7Fx6Ot4vxh2QixOvIUI1OwM3w+VIVdEaZVYyN02XSmFW3T1Ee862QoxuEzV0Do/4LbPIq2DszwCQ6MpYEvUq33lOfdQuaJ26L+7OdzDnaWTZWo5lC4PxrwpayUU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790793365; c=relaxed/simple;
	bh=D2a3iMiv2KiVAIWyqPyx6CuNsBIn2aL4eHGSBh38XvI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Sa8qfe8x+EYuBV6CCeiFL8F+T4GClRUIbMoCGy1yIayfm1XkK+4xVsAzSZeXJSwl/GKlbnLxPAXaOXLKt/7lmGnDkaf6vZk2ovls9z7mt92FgMRko/MRquL/gnhVgVwhAqWVSru8A/jhf6TLL/BDJ7fiArJVwitPeEb/ttqpLVE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QrdPQTop; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QrdPQTop"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE9AF1F000FF;
	Wed, 30 Sep 2026 18:36:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790793364;
	bh=o+/df4b6DRHmWSh5r2Gzh00q0LJTnUmam2h13FkTx8k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QrdPQTopQ5X/s2qHcQME91U8XE2JVIecLtoWaYrhTwzDfYrebA1w0WejbdTaUnyIR
	 V6atJC2shOUDBvvgXEl/S/wJx2b9SQt0qt6xEczpCzgcX5hG08kGfPjKbMnIk2jW2z
	 J47VvxMOSz9qZYbatAm6/TOeDff8KC+eB8oktLOs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Subject: [PATCH 6.18 230/395] gpio: arizona: Fix runtime PM leak in arizona_gpio_direction_out()
Date: Wed, 30 Sep 2026 17:28:12 +0200
Message-ID: <20260930152345.652972520@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152340.591469096@linuxfoundation.org>
References: <20260930152340.591469096@linuxfoundation.org>
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
@@ -115,8 +115,12 @@ static int arizona_gpio_direction_out(st
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
 
 static int arizona_gpio_set(struct gpio_chip *chip, unsigned int offset,


