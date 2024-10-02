Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 137661D043F;
	Wed,  2 Oct 2024 13:37:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727876238; cv=none; b=rj0ibedo86Zq98EKf+9HNFwg/Qw3fEIjggXOFou/lG6Uhq6hZ0qeK/2kZHl5pyMcj6HUcpStePBJckHmTZOffwZQXBoJOrPx2liFDzRId532dupPlSkDCmZetIqQrB7htd8zI0yUeIEKVMwDJG+2W5KRijva6ykp5AEuQeQDnGA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727876238; c=relaxed/simple;
	bh=MYrM2GTfxpCoymF4ezfxYf1z5KhkMjOX5nq50I8fCog=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HBNHoNP+GG/cZrp56QFY1NV9b4hPZzp2e+0G3dCmAcsm/IrgDdj8h9nepCRKGjhkawSThYAneg3IOalflkgxe2yb4bO9fv7S5GWD0M+CG4xas/KbBgE9O5NMmj8GtrSEX6I6yQPegz6MnSo8n7omyWc5ipTi10oyjNOMWGBRI8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oy5AFE7d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oy5AFE7d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70243C4CEC5;
	Wed,  2 Oct 2024 13:37:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727876237;
	bh=MYrM2GTfxpCoymF4ezfxYf1z5KhkMjOX5nq50I8fCog=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oy5AFE7dfA1BaB1DkRZHYvB3WLF3GQxfldT7GFWmjEQg89jEnsJ1o67I3rDARdf4o
	 dh1tOYUonf304ldEpPYtD+X/VrPAQsslD+u5ERkN99HSD6nIGO3nfLT+GlyiPY0VSM
	 DD9mqs66DgsteHFePKyv7zZxQwJyyn90PgrUnaoI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Javier Carrasco <javier.carrasco.cruz@gmail.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 375/695] leds: pca995x: Fix device child node usage in pca995x_probe()
Date: Wed,  2 Oct 2024 14:56:13 +0200
Message-ID: <20241002125837.429449450@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
index a5b32eaba7248..3e56ce90b4b92 100644
--- a/drivers/leds/leds-pca995x.c
+++ b/drivers/leds/leds-pca995x.c
@@ -102,11 +102,10 @@ static const struct regmap_config pca995x_regmap = {
 static int pca995x_probe(struct i2c_client *client)
 {
 	struct fwnode_handle *led_fwnodes[PCA995X_MAX_OUTPUTS] = { 0 };
-	struct fwnode_handle *child;
 	struct device *dev = &client->dev;
 	struct pca995x_chip *chip;
 	struct pca995x_led *led;
-	int i, btype, reg, ret;
+	int i, j, btype, reg, ret;
 
 	btype = (unsigned long)device_get_match_data(&client->dev);
 
@@ -124,7 +123,7 @@ static int pca995x_probe(struct i2c_client *client)
 
 	i2c_set_clientdata(client, chip);
 
-	device_for_each_child_node(dev, child) {
+	device_for_each_child_node_scoped(dev, child) {
 		ret = fwnode_property_read_u32(child, "reg", &reg);
 		if (ret)
 			return ret;
@@ -133,7 +132,7 @@ static int pca995x_probe(struct i2c_client *client)
 			return -EINVAL;
 
 		led = &chip->leds[reg];
-		led_fwnodes[reg] = child;
+		led_fwnodes[reg] = fwnode_handle_get(child);
 		led->chip = chip;
 		led->led_no = reg;
 		led->ldev.brightness_set_blocking = pca995x_brightness_set;
@@ -152,7 +151,8 @@ static int pca995x_probe(struct i2c_client *client)
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



