Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43A5682495;
	Wed, 19 Jun 2024 13:18:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718803108; cv=none; b=AdV0I8dY7oU5EGwr552LT0b+83QZNcZDCFd50SGWHVW15BD1NA4Rcov1ShfYTNw+e1gaLmg6RwXt0p6Rvb9DRXe6u6lzFEDcxixN9DKhSQiNx8aWzBIC1Kdtm4NBcDhGfLofurezCdKC9rpzy//EpkbdEpGkQ/Q82rSWIPnTRLk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718803108; c=relaxed/simple;
	bh=SVvsGqhoOKlpq2El0rN5FSypTv+SapiFWmp2H70Y8/E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SVWkY+KGYhCuNBsk6bRnJfbkXNTNIWRM6x88JZUZY6neWpcBezsiIfm+n/jtBsBGJJr+FV5P8IKpyvs5LKYjlz9JXYBPwGL2yGnVadIFDF4nLr82bevWB68chMjkgJ6XG6xSMLsmrDULdQg3Ah2ld6WHaRaeHNkI8bPagyuR+/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oYLZfsCa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oYLZfsCa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82CD7C32786;
	Wed, 19 Jun 2024 13:18:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718803108;
	bh=SVvsGqhoOKlpq2El0rN5FSypTv+SapiFWmp2H70Y8/E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oYLZfsCadS6UooHoUY/DPilsc+EeEu3Ajococ1ew0GzhjeuXh2gbbMkhWPBMbZ1/y
	 i7pGBovjKzIfKLFvJS10A3F/YR+XBiAvgw91dSGAityXZdCSdUPggho9H7R3OA6lLu
	 T6Wonluri5KGG2grG2aJPAQDHYQ3YdfNimykauHo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Simon Horman <horms@kernel.org>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 156/281] net dsa: qca8k: fix usages of device_get_named_child_node()
Date: Wed, 19 Jun 2024 14:55:15 +0200
Message-ID: <20240619125615.842487114@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125609.836313103@linuxfoundation.org>
References: <20240619125609.836313103@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit d029edefed39647c797c2710aedd9d31f84c069e ]

The documentation for device_get_named_child_node() mentions this
important point:

"
The caller is responsible for calling fwnode_handle_put() on the
returned fwnode pointer.
"

Add fwnode_handle_put() to avoid leaked references.

Fixes: 1e264f9d2918 ("net: dsa: qca8k: add LEDs basic support")
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/qca/qca8k-leds.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/qca/qca8k-leds.c b/drivers/net/dsa/qca/qca8k-leds.c
index 811ebeeff4ed7..43ac68052baf9 100644
--- a/drivers/net/dsa/qca/qca8k-leds.c
+++ b/drivers/net/dsa/qca/qca8k-leds.c
@@ -431,8 +431,11 @@ qca8k_parse_port_leds(struct qca8k_priv *priv, struct fwnode_handle *port, int p
 		init_data.devicename = kasprintf(GFP_KERNEL, "%s:0%d",
 						 priv->internal_mdio_bus->id,
 						 port_num);
-		if (!init_data.devicename)
+		if (!init_data.devicename) {
+			fwnode_handle_put(led);
+			fwnode_handle_put(leds);
 			return -ENOMEM;
+		}
 
 		ret = devm_led_classdev_register_ext(priv->dev, &port_led->cdev, &init_data);
 		if (ret)
@@ -441,6 +444,7 @@ qca8k_parse_port_leds(struct qca8k_priv *priv, struct fwnode_handle *port, int p
 		kfree(init_data.devicename);
 	}
 
+	fwnode_handle_put(leds);
 	return 0;
 }
 
@@ -471,9 +475,13 @@ qca8k_setup_led_ctrl(struct qca8k_priv *priv)
 		 * the correct port for LED setup.
 		 */
 		ret = qca8k_parse_port_leds(priv, port, qca8k_port_to_phy(port_num));
-		if (ret)
+		if (ret) {
+			fwnode_handle_put(port);
+			fwnode_handle_put(ports);
 			return ret;
+		}
 	}
 
+	fwnode_handle_put(ports);
 	return 0;
 }
-- 
2.43.0



