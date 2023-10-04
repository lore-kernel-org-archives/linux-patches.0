Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21AE81D523
	for <patches@lists.linux.dev>; Wed,  4 Oct 2023 18:04:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 986DFC433C7;
	Wed,  4 Oct 2023 18:04:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696442676;
	bh=e/ZOhKi+uJzwu3s+23MWtiwP84fYqA8U2cWOU/e+nyQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ygTBQfHwbzwQ/cf3aGwWqvhKm+QzwNneuI+IlArq+m38wS92Ol8MX/AwTX//rU/PH
	 CanoN5tG8sOKTYJ09zJLbBHACsGmzBvULs65+2dxQvDC0HJJ5iHDPQFV9NW2hB8AgJ
	 pPlhbcWPzIBWP1lecWlgnQk6e9jRJEnlZBDEVeOw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Evan Green <evgreen@chromium.org>,
	Peter Rosin <peda@axentia.se>,
	Wolfram Sang <wsa@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 070/183] =?UTF-8?q?i2c:=20mux:=20gpio:=C2=A0Replace=20custom=20acpi=5Fget?= =?UTF-8?q?=5Flocal=5Faddress()?=
Date: Wed,  4 Oct 2023 19:55:01 +0200
Message-ID: <20231004175206.811986852@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231004175203.943277832@linuxfoundation.org>
References: <20231004175203.943277832@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit 379920f5c013c49e0a740634972faf77e26d4ac3 ]

Recently ACPI gained the acpi_get_local_address() API which may be used
instead of home grown i2c_mux_gpio_get_acpi_adr().

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Evan Green <evgreen@chromium.org>
Acked-by: Peter Rosin <peda@axentia.se>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Stable-dep-of: db6aee6083a5 ("i2c: mux: gpio: Add missing fwnode_handle_put()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/muxes/i2c-mux-gpio.c | 43 ++------------------------------
 1 file changed, 2 insertions(+), 41 deletions(-)

diff --git a/drivers/i2c/muxes/i2c-mux-gpio.c b/drivers/i2c/muxes/i2c-mux-gpio.c
index bac415a52b780..31e6eb1591bb9 100644
--- a/drivers/i2c/muxes/i2c-mux-gpio.c
+++ b/drivers/i2c/muxes/i2c-mux-gpio.c
@@ -49,45 +49,6 @@ static int i2c_mux_gpio_deselect(struct i2c_mux_core *muxc, u32 chan)
 	return 0;
 }
 
-#ifdef CONFIG_ACPI
-
-static int i2c_mux_gpio_get_acpi_adr(struct device *dev,
-				     struct fwnode_handle *fwdev,
-				     unsigned int *adr)
-
-{
-	unsigned long long adr64;
-	acpi_status status;
-
-	status = acpi_evaluate_integer(ACPI_HANDLE_FWNODE(fwdev),
-				       METHOD_NAME__ADR,
-				       NULL, &adr64);
-
-	if (!ACPI_SUCCESS(status)) {
-		dev_err(dev, "Cannot get address\n");
-		return -EINVAL;
-	}
-
-	*adr = adr64;
-	if (*adr != adr64) {
-		dev_err(dev, "Address out of range\n");
-		return -ERANGE;
-	}
-
-	return 0;
-}
-
-#else
-
-static int i2c_mux_gpio_get_acpi_adr(struct device *dev,
-				     struct fwnode_handle *fwdev,
-				     unsigned int *adr)
-{
-	return -EINVAL;
-}
-
-#endif
-
 static int i2c_mux_gpio_probe_fw(struct gpiomux *mux,
 				 struct platform_device *pdev)
 {
@@ -141,9 +102,9 @@ static int i2c_mux_gpio_probe_fw(struct gpiomux *mux,
 			fwnode_property_read_u32(child, "reg", values + i);
 
 		} else if (is_acpi_node(child)) {
-			rc = i2c_mux_gpio_get_acpi_adr(dev, child, values + i);
+			rc = acpi_get_local_address(ACPI_HANDLE_FWNODE(child), values + i);
 			if (rc)
-				return rc;
+				return dev_err_probe(dev, rc, "Cannot get address\n");
 		}
 
 		i++;
-- 
2.40.1



