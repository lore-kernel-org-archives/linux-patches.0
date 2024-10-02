Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFE2D1D0493;
	Wed,  2 Oct 2024 14:09:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727878175; cv=none; b=kC2+Sz9tFbaC9E/fVQyu+cxoTimYyEzT09QXanLO0vFXzdsXrqnTl701q6BwUeka6OFd5LlKPqPNUixSfsG0nK/dI9RKLTxmM0TYwC99lRV3G6ogY1Mv1KbABZ7K5PdvHNWCS7EUfHqjPp5ctdqtvm1UF016/5Cdew5ds55udr8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727878175; c=relaxed/simple;
	bh=yzI6XNbqTgeeK2Pgb6lXkmvkMknzXGVkFX8m3FHnUas=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c+PXEe6pnQM4srshvXGoy0HFlQd7ovscOcH9f2TfC22BpanzlpEAGRVN6mHGSGAG48xLiw6KSQnw/5PJphCTA+qcbW8ITYuSwyJwgkGaNs/MZNW369xnX4/EEd2bj7lAXLyQDQP1R8gz3fgeRdpICDWZUTBF5Hbx3csFFUDvdzA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WrJcqM+i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WrJcqM+i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55E4BC4CEC2;
	Wed,  2 Oct 2024 14:09:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727878175;
	bh=yzI6XNbqTgeeK2Pgb6lXkmvkMknzXGVkFX8m3FHnUas=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WrJcqM+iGuPdikomnGspw3Jgd8sMiUKN7yp00/Cagv7WduwVROurKKOkNb48Lok8f
	 eDK6yY1/UdGnRo5ehsvCQzCyXfthHMMS9JPk1CxS3L+CfX4phFhFdSNxM5FRExuFuh
	 kiUZKA7IlZGIdxBZn4ToCnvwRo8btCyAwQl0bDbs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Javier Carrasco <javier.carrasco.cruz@gmail.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 325/634] leds: bd2606mvv: Fix device child node usage in bd2606mvv_probe()
Date: Wed,  2 Oct 2024 14:57:05 +0200
Message-ID: <20241002125823.929843090@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Javier Carrasco <javier.carrasco.cruz@gmail.com>

[ Upstream commit ffbf1fcb421429916a861cfc25dfe0c6387dda75 ]

The current implementation accesses the `child` fwnode handle outside of
fwnode_for_each_available_child_node() without incrementing its
refcount. Add the missing call to `fwnode_handle_get(child)`.

The cleanup process where `child` is accessed is not right either
because a single call to `fwnode_handle_put()` is carried out in case of
an error, ignoring unasigned nodes at the point when the error happens.
Keep `child` inside of the first loop, and use the helper pointer that
receives references via `fwnode_handle_get()` to handle the child nodes
within the second loop.

Moreover, the iterated nodes are direct children of the device node,
and the `device_for_each_child_node()` macro accounts for child node
availability. By restricting `child` to live within that loop, the
scoped version of it can be used to simplify the error handling.

`fwnode_for_each_available_child_node()` is meant to access the child
nodes of an fwnode, and therefore not direct child nodes of the device
node.

Use `device_for_each_child_node_scoped()` to indicate device's direct
child nodes.

Fixes: 8325642d2757 ("leds: bd2606mvv: Driver for the Rohm 6 Channel i2c LED driver")
Signed-off-by: Javier Carrasco <javier.carrasco.cruz@gmail.com>
Link: https://lore.kernel.org/r/20240721-device_for_each_child_node-available-v2-3-f33748fd8b2d@gmail.com
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/leds/leds-bd2606mvv.c | 23 ++++++++++-------------
 1 file changed, 10 insertions(+), 13 deletions(-)

diff --git a/drivers/leds/leds-bd2606mvv.c b/drivers/leds/leds-bd2606mvv.c
index 3fda712d2f809..c1181a35d0f76 100644
--- a/drivers/leds/leds-bd2606mvv.c
+++ b/drivers/leds/leds-bd2606mvv.c
@@ -69,16 +69,14 @@ static const struct regmap_config bd2606mvv_regmap = {
 
 static int bd2606mvv_probe(struct i2c_client *client)
 {
-	struct fwnode_handle *np, *child;
 	struct device *dev = &client->dev;
 	struct bd2606mvv_priv *priv;
 	struct fwnode_handle *led_fwnodes[BD2606_MAX_LEDS] = { 0 };
 	int active_pairs[BD2606_MAX_LEDS / 2] = { 0 };
 	int err, reg;
-	int i;
+	int i, j;
 
-	np = dev_fwnode(dev);
-	if (!np)
+	if (!dev_fwnode(dev))
 		return -ENODEV;
 
 	priv = devm_kzalloc(dev, sizeof(*priv), GFP_KERNEL);
@@ -94,20 +92,18 @@ static int bd2606mvv_probe(struct i2c_client *client)
 
 	i2c_set_clientdata(client, priv);
 
-	fwnode_for_each_available_child_node(np, child) {
+	device_for_each_child_node_scoped(dev, child) {
 		struct bd2606mvv_led *led;
 
 		err = fwnode_property_read_u32(child, "reg", &reg);
-		if (err) {
-			fwnode_handle_put(child);
+		if (err)
 			return err;
-		}
-		if (reg < 0 || reg >= BD2606_MAX_LEDS || led_fwnodes[reg]) {
-			fwnode_handle_put(child);
+
+		if (reg < 0 || reg >= BD2606_MAX_LEDS || led_fwnodes[reg])
 			return -EINVAL;
-		}
+
 		led = &priv->leds[reg];
-		led_fwnodes[reg] = child;
+		led_fwnodes[reg] = fwnode_handle_get(child);
 		active_pairs[reg / 2]++;
 		led->priv = priv;
 		led->led_no = reg;
@@ -130,7 +126,8 @@ static int bd2606mvv_probe(struct i2c_client *client)
 						     &priv->leds[i].ldev,
 						     &init_data);
 		if (err < 0) {
-			fwnode_handle_put(child);
+			for (j = i; j < BD2606_MAX_LEDS; j++)
+				fwnode_handle_put(led_fwnodes[j]);
 			return dev_err_probe(dev, err,
 					     "couldn't register LED %s\n",
 					     priv->leds[i].ldev.name);
-- 
2.43.0



