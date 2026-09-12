Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AC6B2F531B;
	Sat, 12 Sep 2026 12:10:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789215037; cv=none; b=jlhx5IokqN3vSW9QDcHEI8ZtBTqItM5hoDQPhP2m8fdwosXqrtaruDHjjlohANoOERUnK/L1+/TF39e4noNnALQR9LP7eLmcdGZIObo5qm52bFgutX2aGnvITjCiI1rZmVA7Erxn9f81oTSmSDqi/HyqVGzjrrYlt+GyG8yS/UA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789215037; c=relaxed/simple;
	bh=CIQreDR7mxznwe6kfS5Gg3LI7oT6sMhVyPo8Cw06GT4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cRyIdI9ErQ0r56ypwqLKrYQZAX1GrPK2bvS83jnzqrizpbbDHcHoT+XL9uO9v4u8SYO3FQpp/Erzu3QGyDaHZoLoBkWdtAo0Wbstlrspq7tYZq6s9DdVfWsoT1CUzpsYWOhg9AeGTnwFPx5BjT2a3X4dbIMKrfFiWgr/b7wHO7g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dWn+ZZLy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dWn+ZZLy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F82A1F000FF;
	Sat, 12 Sep 2026 12:10:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789215036;
	bh=bdW/5rd69pituJXPAo0NMtAXoXb6KDpLEvrSStsILIY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dWn+ZZLyS4shrYTkAG5K0APwkBTv/wi5pKJ393FP2FrXSLszrxXHd31oaljGzQtsd
	 Vp/y2ahRE5nsBPwxpWJYwo77VkZLP/xvN238BogNTH7UJEOvAgGzHZ9X+8x81AcZY8
	 fcnftAibq5fywekXsr2sBImrKyCYvBg3XgMrx/p8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	=?UTF-8?q?Niklas=20S=C3=B6derlund?= <niklas.soderlund+renesas@ragnatech.se>,
	Dan Carpenter <error27@gmail.com>,
	Daniel Lezcano <daniel.lezcano@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0449/1376] thermal/drivers/rcar: Fix error checking in probe()
Date: Sat, 12 Sep 2026 08:47:55 +0200
Message-ID: <20260912065617.539394528@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <error27@gmail.com>

[ Upstream commit dd04ad1cdabcad51e34b74b4e91b9aeb7180d05d ]

This code accidentally calls thermal_zone_device_enable() before checking
whether thermal_zone_device_register_with_trips() failed.  Move the call
until later to avoid an error pointer dereference of "priv->zone".

The driver works differently depending on if we are using OF thermal or
not.  We use thermal_add_hwmon_sysfs() if we are using OF thermal and
call thermal_zone_device_enable() if not.  We can share same error check
for if either of these fail.

Moving the thermal_zone_device_enable() call is a bit cleaner as well.
The original code used a three step process to cleanup:
1. Call thermal_zone_device_unregister() to cleanup.
2. Set priv->zone to an error pointer to preserve the error code.
3. Set priv->zone to NULL to avoid a second call to
   thermal_zone_device_unregister() in the rcar_thermal_remove()
   function.

Now we can just do a direct goto error_unregister and rcar_thermal_remove()
handles the cleanup properly.

Fixes: bbcf90c0646a ("thermal: Explicitly enable non-changing thermal zone devices")
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
Signed-off-by: Dan Carpenter <error27@gmail.com>
Signed-off-by: Daniel Lezcano <daniel.lezcano@kernel.org>
Link: https://patch.msgid.link/aj5WnseULiwgmlWv@stanley.mountain
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thermal/renesas/rcar_thermal.c | 15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

diff --git a/drivers/thermal/renesas/rcar_thermal.c b/drivers/thermal/renesas/rcar_thermal.c
index ddc8341e5c3fa..00517681a8bb1 100644
--- a/drivers/thermal/renesas/rcar_thermal.c
+++ b/drivers/thermal/renesas/rcar_thermal.c
@@ -492,12 +492,6 @@ static int rcar_thermal_probe(struct platform_device *pdev)
 				"rcar_thermal", trips, ARRAY_SIZE(trips), priv,
 						&rcar_thermal_zone_ops, NULL, 0,
 						idle);
-
-			ret = thermal_zone_device_enable(priv->zone);
-			if (ret) {
-				thermal_zone_device_unregister(priv->zone);
-				priv->zone = ERR_PTR(ret);
-			}
 		}
 		if (IS_ERR(priv->zone)) {
 			dev_err(dev, "can't register thermal zone\n");
@@ -506,11 +500,12 @@ static int rcar_thermal_probe(struct platform_device *pdev)
 			goto error_unregister;
 		}
 
-		if (chip->use_of_thermal) {
+		if (chip->use_of_thermal)
 			ret = thermal_add_hwmon_sysfs(priv->zone);
-			if (ret)
-				goto error_unregister;
-		}
+		else
+			ret = thermal_zone_device_enable(priv->zone);
+		if (ret)
+			goto error_unregister;
 
 		rcar_thermal_irq_enable(priv);
 
-- 
2.53.0



