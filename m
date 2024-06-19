Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1BAE12FB31;
	Wed, 19 Jun 2024 13:07:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718802421; cv=none; b=iMmLjsKEjmSYWqIFoAiind3pJaVg+12ldPewwqyfZAzLhluCGU8J1EV/cujTPtjORtW+S8gpBA6WWzL9jODE+kLsJRc/OeocSR+edwKKDESd7hpjipO6RG+i7aQPa1dVhTS1GWpj2XivXg1Sfpdwg9+LmxFGPO1y3VcVHPZyxZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718802421; c=relaxed/simple;
	bh=NRiF4HD4ZWoQS8ZAv+bu+HOowb/FZwUm3yQ888vJYFk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bfr1279QkXWpyecdkwKlvBkvOLBJA8DGyswSSO9KR1L8g2UsdhHFcO4KkoE7Ez8Wt5ET2AJazKKgpXWgATekD/aQZRP2yORkXORggCMQVhRz9fzhcISUBXbhDBQek6SKhKZ6GbRkcoMympMxJChzRY85NYE1rZKmpr20PdZVcc0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NriLUh4/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NriLUh4/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BCBDC2BBFC;
	Wed, 19 Jun 2024 13:07:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718802420;
	bh=NRiF4HD4ZWoQS8ZAv+bu+HOowb/FZwUm3yQ888vJYFk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NriLUh4/KlvNaeYpoA1cUu+h/bqFnuabGAbfn+B5mSJdhzuddsP4ZUA2XfQkNa3p9
	 VCVtHeFzx2730Y1FhWWUe5Ana8HidBPPZqkQzXHPuXLA8HAQf4BQkx5u695xl4/uo8
	 jWs264aI67iVDVsLsjDRePQfM836OTQydWaJzJIw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Simon Horman <horms@kernel.org>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 150/267] net dsa: qca8k: fix usages of device_get_named_child_node()
Date: Wed, 19 Jun 2024 14:55:01 +0200
Message-ID: <20240619125612.104007047@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125606.345939659@linuxfoundation.org>
References: <20240619125606.345939659@linuxfoundation.org>
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
index e8c16e76e34bb..77a79c2494022 100644
--- a/drivers/net/dsa/qca/qca8k-leds.c
+++ b/drivers/net/dsa/qca/qca8k-leds.c
@@ -431,8 +431,11 @@ qca8k_parse_port_leds(struct qca8k_priv *priv, struct fwnode_handle *port, int p
 		init_data.devname_mandatory = true;
 		init_data.devicename = kasprintf(GFP_KERNEL, "%s:0%d", ds->slave_mii_bus->id,
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



