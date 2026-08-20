Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99C4237A858;
	Thu, 20 Aug 2026 16:47:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787244428; cv=none; b=PnkN3x6I5GwSM+su1XqeS1SBStelZoMZ8BOFlHzHGK/JZf6t5JldGsEFoytviENgxDGYo3H+bLuo/hK065uO3H82xDvwybrmDfKxwLd9JNerW9p0YcdMi19T4m2jWF6VcYkdjX16y6IqkctoYc87QNOXPC4MSwAON8hQ91qS1hE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787244428; c=relaxed/simple;
	bh=TR5Dw60X5j8rA8mkPCmhlsmyd9qb46WA+73zieGAHY4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FygdM9dtvsUWnC66+l3tka1NQKzwWA268KxnlEoGfadIjZ2SkRqxTYIJzJDndQMKD3AgJpa7SMaJ92B1T0djUaEVFVlSbaV5+apOjiMbaEs0wR9L0qT9K1k0IhdwrHSLpw6qNeIRELyxq/bv5QLEfFKmYEJRJipQ5sh8g3SkBmk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I5d/dcro; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I5d/dcro"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B81E81F00A3F;
	Thu, 20 Aug 2026 16:47:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787244427;
	bh=irpq8PN64FgoZ/3vBymhRxU0DGFPdc2VmXkrxWBW92Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=I5d/dcroWpbBPm+ZpAmA933vR5zUgANyDL/MB86BWQXhQao5ddbg5EUNuWwIDfsmv
	 h70wC52FMdMq+n/g+Gvd33k2GtCVAASuAhRfD2HGEceKTZf3xgKxCAKz5Pa0sqctXV
	 MG+iXhft4HFo7KeQrz591vMT9QfOGw87w8sF8F9E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Li <Frank.Li@nxp.com>,
	Mirela Rabulea <mirela.rabulea@nxp.com>,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 165/235] media: v4l2-fwnode: Fix subdev owner overwritten in v4l2_async_register_subdev_sensor()
Date: Thu, 20 Aug 2026 16:56:41 +0200
Message-ID: <20260820145221.496908039@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145216.426568665@linuxfoundation.org>
References: <20260820145216.426568665@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mirela Rabulea <mirela.rabulea@nxp.com>

[ Upstream commit 06cb687a5132fcffe624c0070576ab852ac6b568 ]

The v4l2 helper v4l2_async_register_subdev_sensor() calls
v4l2_async_register_subdev(), which is a macro that expands to
__v4l2_async_register_subdev(sd,THIS_MODULE). Since the macro is expanded
inside v4l2-fwnode.c, THIS_MODULE resolves to the v4l2-fwnode module
rather than the sensor driver module that originally set sd->owner. When
v4l2-fwnode is built-in, THIS_MODULE evaluates to NULL, which then
overwrites the sensor driver's owner with NULL.

This causes the problem that the sensor module's reference count is never
incremented during async registration, so the module can be removed while
the subdevice is still in use by a notifier (e.g., a CSI-2 receiver
bridge driver).

Fix this by renaming v4l2_async_register_subdev_sensor() to
__v4l2_async_register_subdev_sensor() with an added explicit module
argument and introducing a wrapper macro:
    #define v4l2_async_register_subdev_sensor(sd) \
        __v4l2_async_register_subdev_sensor(sd, THIS_MODULE)

This ensures the sensor driver module is properly referenced even when
the sensor driver does not init the owner field before calling
v4l2_async_register_subdev_sensor() and prevents premature module removal.

Fixes: aef69d54755d ("media: v4l: fwnode: Add a convenience function for registering sensors")
Cc: stable@vger.kernel.org
Suggested-by: Frank Li <Frank.Li@nxp.com>
Link: https://lore.kernel.org/linux-media/20240315073125.275501-2-sakari.ailus@linux.intel.com/
Signed-off-by: Mirela Rabulea <mirela.rabulea@nxp.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/v4l2-core/v4l2-fwnode.c |    7 ++++---
 include/media/v4l2-async.h            |    5 ++++-
 2 files changed, 8 insertions(+), 4 deletions(-)

--- a/drivers/media/v4l2-core/v4l2-fwnode.c
+++ b/drivers/media/v4l2-core/v4l2-fwnode.c
@@ -1337,7 +1337,8 @@ int v4l2_async_notifier_parse_fwnode_sen
 }
 EXPORT_SYMBOL_GPL(v4l2_async_notifier_parse_fwnode_sensor_common);
 
-int v4l2_async_register_subdev_sensor_common(struct v4l2_subdev *sd)
+int __v4l2_async_register_subdev_sensor_common(struct v4l2_subdev *sd,
+					       struct module *module)
 {
 	struct v4l2_async_notifier *notifier;
 	int ret;
@@ -1360,7 +1361,7 @@ int v4l2_async_register_subdev_sensor_co
 	if (ret < 0)
 		goto out_cleanup;
 
-	ret = v4l2_async_register_subdev(sd);
+	ret = __v4l2_async_register_subdev(sd, module);
 	if (ret < 0)
 		goto out_unregister;
 
@@ -1377,7 +1378,7 @@ out_cleanup:
 
 	return ret;
 }
-EXPORT_SYMBOL_GPL(v4l2_async_register_subdev_sensor_common);
+EXPORT_SYMBOL_GPL(__v4l2_async_register_subdev_sensor_common);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Sakari Ailus <sakari.ailus@linux.intel.com>");
--- a/include/media/v4l2-async.h
+++ b/include/media/v4l2-async.h
@@ -321,8 +321,11 @@ int __v4l2_async_register_subdev(struct
  * An error is returned if the module is no longer loaded on any attempts
  * to register it.
  */
+#define v4l2_async_register_subdev_sensor_common(sd) \
+	__v4l2_async_register_subdev_sensor_common(sd, THIS_MODULE)
 int __must_check
-v4l2_async_register_subdev_sensor_common(struct v4l2_subdev *sd);
+__v4l2_async_register_subdev_sensor_common(struct v4l2_subdev *sd,
+					   struct module *module);
 
 /**
  * v4l2_async_unregister_subdev - unregisters a sub-device to the asynchronous


