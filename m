Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBA361F63CD;
	Sun,  7 Sep 2025 20:43:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757277836; cv=none; b=Hm1uq1DNMDLgOLsIoPfyOMIi5HjzHHo5mGywIgZsvrYypdFRgj9yZ1ej9cee3QC26HWSztzVRpOHq8O4alLabsTsJWGZpT338Y1Hoq++/INrQ2FSX8eosKg23EW7JrZMKYTBZ5XNw8UsodgJF7uY/lsFbsJj6hBlgJ65/iOYL+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757277836; c=relaxed/simple;
	bh=btuZ+k7tSRZbl0Sil1Xkv0EDDvclb6/cEqi3Q3jfROk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mpWQRSg2oHNNZXvSLYixiDeeFsmJKGFoPzLRY2IOkB0rUUqfkb+MbhtVn3TD9ZJdg4arsg2J/YUoknC7w9YdRZb2VvvS/HQPwpXPn6VVnJuNKZZFhbq6CX3TISDDJez3CLciX5lnBGAsYzcoq6VqFXSWgMBB51t9zKzATXHOa7A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f7/Ny+mz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f7/Ny+mz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64451C4CEF0;
	Sun,  7 Sep 2025 20:43:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757277835;
	bh=btuZ+k7tSRZbl0Sil1Xkv0EDDvclb6/cEqi3Q3jfROk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f7/Ny+mzBWE6M2LKxPifcBUbfK/0MH3NJ1EOrRe6dCwS5I6K+2HYNZJo/033FASlx
	 si76ouhtO1bMstTbYKl3vkpNRitnS5hMMfc2gtyd41iSEYQ0VdqamYjODHKLgx0wP0
	 GGtqNSD58bUFhhUE0bpuMythoj96RIj3pNiSMA0s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miaoqian Lin <linmq006@gmail.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.16 138/183] net: dsa: mv88e6xxx: Fix fwnode reference leaks in mv88e6xxx_port_setup_leds
Date: Sun,  7 Sep 2025 21:59:25 +0200
Message-ID: <20250907195619.071890114@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195615.802693401@linuxfoundation.org>
References: <20250907195615.802693401@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miaoqian Lin <linmq006@gmail.com>

commit f63e7c8a83892781f6ceb55566f9497639c44555 upstream.

Fix multiple fwnode reference leaks:

1. The function calls fwnode_get_named_child_node() to get the "leds" node,
   but never calls fwnode_handle_put(leds) to release this reference.

2. Within the fwnode_for_each_child_node() loop, the early return
   paths that don't properly release the "led" fwnode reference.

This fix follows the same pattern as commit d029edefed39
("net dsa: qca8k: fix usages of device_get_named_child_node()")

Fixes: 94a2a84f5e9e ("net: dsa: mv88e6xxx: Support LED control")
Cc: stable@vger.kernel.org
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Link: https://patch.msgid.link/20250901073224.2273103-1-linmq006@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/dsa/mv88e6xxx/leds.c |   17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

--- a/drivers/net/dsa/mv88e6xxx/leds.c
+++ b/drivers/net/dsa/mv88e6xxx/leds.c
@@ -779,7 +779,8 @@ int mv88e6xxx_port_setup_leds(struct mv8
 			continue;
 		if (led_num > 1) {
 			dev_err(dev, "invalid LED specified port %d\n", port);
-			return -EINVAL;
+			ret = -EINVAL;
+			goto err_put_led;
 		}
 
 		if (led_num == 0)
@@ -823,17 +824,25 @@ int mv88e6xxx_port_setup_leds(struct mv8
 		init_data.devname_mandatory = true;
 		init_data.devicename = kasprintf(GFP_KERNEL, "%s:0%d:0%d", chip->info->name,
 						 port, led_num);
-		if (!init_data.devicename)
-			return -ENOMEM;
+		if (!init_data.devicename) {
+			ret = -ENOMEM;
+			goto err_put_led;
+		}
 
 		ret = devm_led_classdev_register_ext(dev, l, &init_data);
 		kfree(init_data.devicename);
 
 		if (ret) {
 			dev_err(dev, "Failed to init LED %d for port %d", led_num, port);
-			return ret;
+			goto err_put_led;
 		}
 	}
 
+	fwnode_handle_put(leds);
 	return 0;
+
+err_put_led:
+	fwnode_handle_put(led);
+	fwnode_handle_put(leds);
+	return ret;
 }


