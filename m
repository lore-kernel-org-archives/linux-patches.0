Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D231E36A36A;
	Sat, 12 Sep 2026 09:52:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789206746; cv=none; b=i6ifsZZNArX3BNWyknA8YBGXkNkb4hMjZZQHZSQFsVkQdcRhh4tHjng/1Ywo1oZU5ZXVg25/pdGTVVR79+IJ4EeM3g2gzY/H+mb5zSdwWyQsVhqvDI6brxjw2/pfHLfbZp6e1BCv1QnmMwD/smMcgB3uymiMOS00g3UKwsW+bKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789206746; c=relaxed/simple;
	bh=GyNl9+RyReOjQEFNWdB5KPK2HLihYpsNbcjg1CPH7QA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IE8uTYn5+0EInbsmGXRIdv2tIHIt4GY3Ji/IdmgWAWwY2q5F+bWLLk+z1dvm2zxMX4q4/ThVUcJ8o82ukf4wUMQslhtA08gwLDAZi7ugtxoDG45OxLxgrAZAdZ3dxauycs/HTEhmVvTNrKGzSJ6LeIXpAugOgnDenSKbqzSgKA4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T3QQv5+0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T3QQv5+0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BF161F000FF;
	Sat, 12 Sep 2026 09:52:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789206744;
	bh=/ZD0YHMq9E7wuAiz9u/t2gJDuTrk1fIUUBZwGtdFX9U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=T3QQv5+0WNs49t1KzAhSzUWWu8gf13tYNU6TS6NGBAomZruv08tUhAD699nHRwsfO
	 LzzhP0bThfqhJteDYID55p2CyUS8BBvRm5SZKnthPrHg8SsoorYFwc3LS6j8z/Nx67
	 Odalr0GFWRu5BpXzqdFhFPISatT7c0knVeO6Pnpg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	=?UTF-8?q?Niklas=20S=C3=B6derlund?= <niklas.soderlund+renesas@ragnatech.se>,
	Dan Carpenter <error27@gmail.com>,
	Daniel Lezcano <daniel.lezcano@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0268/1518] thermal/drivers/rcar: Fix error checking in probe()
Date: Sat, 12 Sep 2026 08:40:37 +0200
Message-ID: <20260912065629.548417587@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index fdd7afdc4ff69..27adc64757f55 100644
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



