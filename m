Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3877F1D07B9;
	Wed,  2 Oct 2024 14:39:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727879941; cv=none; b=MsqaTLuFb4vTWwogHIsWhwUywORWHvNU+V1EUIWR2Xth9Vi3scOGjHPAiTjNnh2eBKi1qpqp63cvBz0+1ZRj+xUYZhGdEl3DNGKpGKVVfmvVR0BoW7jF8R/OlQoiezK8gR4nSmI+NQVIid71tcdrP5PV/BZH+a+yL1yowfdcENg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727879941; c=relaxed/simple;
	bh=1CWD6j7vY4sqKQgWsRhMfCX1RY7eO6pTFqvJcSuLXJI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uqqoLIaVWbNrVrmcKZEnNWr6BvUpVChoAa7nLzIrXGr141CZtHzHPQPFAny3171crSls7akKYCMxCSOo4Fww15ff+vpKTNvaSpxxBPZc1aQJ4/j2NECgsDV+x1lrvojCykETjDVkh2ppNrTSUj2hr2JvGcWGIcYHgtdj6UZk6YA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HqO3w3Qx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HqO3w3Qx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88B32C4CEC2;
	Wed,  2 Oct 2024 14:39:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727879941;
	bh=1CWD6j7vY4sqKQgWsRhMfCX1RY7eO6pTFqvJcSuLXJI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HqO3w3QxaN5BWPcS2/v/HONkX9qn5yGktLp/SKxdBs9ICDxqh7aMPn/Y1+de6xq6Q
	 V0rN664pTxAbV9SjN95No89ipzWcoeUoUi9iAPlmg29zSPOrhqiDJ+bAiP/Yfe0rLV
	 pxh3ph7S8AkGAmSNhOycSV1KubDAsETBViZQa7TA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Javier Carrasco <javier.carrasco.cruz@gmail.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 290/538] leds: pca995x: Fix device child node usage in pca995x_probe()
Date: Wed,  2 Oct 2024 14:58:49 +0200
Message-ID: <20241002125803.704160018@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
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

From: Javier Carrasco <javier.carrasco.cruz@gmail.com>

[ Upstream commit 82c5ada1f9d05902a4ccb926c7ce34e2fe699283 ]

The current implementation accesses the `child` fwnode handle outside of
device_for_each_child_node() without incrementing its refcount.

Add the missing call to `fwnode_handle_get(child)`.

The cleanup process where `child` is accessed is not right either
because a single call to `fwnode_handle_put()` is carried out in case of
an error, ignoring unasigned nodes at the point when the error happens.

Keep `child` inside of the first loop, and use the helper pointer that
receives references via `fwnode_handle_get()` to handle the child nodes
within the second loop. Keeping `child` inside the first node has also
the advantage that the scoped version of the loop can be used.

Fixes: ee4e80b2962e ("leds: pca995x: Add support for PCA995X chips")
Signed-off-by: Javier Carrasco <javier.carrasco.cruz@gmail.com>
Link: https://lore.kernel.org/r/20240807-leds-pca995x-fix-fwnode-usage-v1-1-8057c84dc583@gmail.com
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/leds/leds-pca995x.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/leds/leds-pca995x.c b/drivers/leds/leds-pca995x.c
index 83bc9669544c3..11c7bb69573e8 100644
--- a/drivers/leds/leds-pca995x.c
+++ b/drivers/leds/leds-pca995x.c
@@ -120,12 +120,11 @@ static const struct regmap_config pca995x_regmap = {
 static int pca995x_probe(struct i2c_client *client)
 {
 	struct fwnode_handle *led_fwnodes[PCA995X_MAX_OUTPUTS] = { 0 };
-	struct fwnode_handle *child;
 	struct device *dev = &client->dev;
 	const struct pca995x_chipdef *chipdef;
 	struct pca995x_chip *chip;
 	struct pca995x_led *led;
-	int i, reg, ret;
+	int i, j, reg, ret;
 
 	chipdef = device_get_match_data(&client->dev);
 
@@ -143,7 +142,7 @@ static int pca995x_probe(struct i2c_client *client)
 
 	i2c_set_clientdata(client, chip);
 
-	device_for_each_child_node(dev, child) {
+	device_for_each_child_node_scoped(dev, child) {
 		ret = fwnode_property_read_u32(child, "reg", &reg);
 		if (ret)
 			return ret;
@@ -152,7 +151,7 @@ static int pca995x_probe(struct i2c_client *client)
 			return -EINVAL;
 
 		led = &chip->leds[reg];
-		led_fwnodes[reg] = child;
+		led_fwnodes[reg] = fwnode_handle_get(child);
 		led->chip = chip;
 		led->led_no = reg;
 		led->ldev.brightness_set_blocking = pca995x_brightness_set;
@@ -171,7 +170,8 @@ static int pca995x_probe(struct i2c_client *client)
 						     &chip->leds[i].ldev,
 						     &init_data);
 		if (ret < 0) {
-			fwnode_handle_put(child);
+			for (j = i; j < PCA995X_MAX_OUTPUTS; j++)
+				fwnode_handle_put(led_fwnodes[j]);
 			return dev_err_probe(dev, ret,
 					     "Could not register LED %s\n",
 					     chip->leds[i].ldev.name);
-- 
2.43.0



