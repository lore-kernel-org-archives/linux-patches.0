Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E01C20F8F
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 19:17:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC7F3C433C8;
	Fri, 21 Jul 2023 19:17:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689967035;
	bh=Be8t/y5FCYER+ihA77EkbOVokf2zSSkimbGV2Vgbjyk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WOMqNbHQk1UcgbW0koblocOPDYUa3AhaeYc4rSXqkHxIp35MU4qIspoR5Voq1AHi1
	 KBuAY8nFusdzWJ0owwmi6JdJcBlvl1px1G/2wKRll8+m2SFEkl80ELY+qE0E1Gc+Yn
	 YXOSiWeVZLRnwp1XvxgwyOWUkqI9lbZWk6oDQl4I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephen Boyd <swboyd@chromium.org>,
	Douglas Anderson <dianders@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 009/223] drm/bridge: ti-sn65dsi86: Fix auxiliary bus lifetime
Date: Fri, 21 Jul 2023 18:04:22 +0200
Message-ID: <20230721160521.271404350@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160520.865493356@linuxfoundation.org>
References: <20230721160520.865493356@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Douglas Anderson <dianders@chromium.org>

[ Upstream commit 7aa83fbd712a6f08ffa67890061f26d140c2a84f ]

Memory for the "struct device" for any given device isn't supposed to
be released until the device's release() is called. This is important
because someone might be holding a kobject reference to the "struct
device" and might try to access one of its members even after any
other cleanup/uninitialization has happened.

Code analysis of ti-sn65dsi86 shows that this isn't quite right. When
the code was written, it was believed that we could rely on the fact
that the child devices would all be freed before the parent devices
and thus we didn't need to worry about a release() function. While I
still believe that the parent's "struct device" is guaranteed to
outlive the child's "struct device" (because the child holds a kobject
reference to the parent), the parent's "devm" allocated memory is a
different story. That appears to be freed much earlier.

Let's make this better for ti-sn65dsi86 by allocating each auxiliary
with kzalloc and then free that memory in the release().

Fixes: bf73537f411b ("drm/bridge: ti-sn65dsi86: Break GPIO and MIPI-to-eDP bridge into sub-drivers")
Suggested-by: Stephen Boyd <swboyd@chromium.org>
Reviewed-by: Stephen Boyd <swboyd@chromium.org>
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20230613065812.v2.1.I24b838a5b4151fb32bccd6f36397998ea2df9fbb@changeid
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/ti-sn65dsi86.c | 35 +++++++++++++++++----------
 1 file changed, 22 insertions(+), 13 deletions(-)

diff --git a/drivers/gpu/drm/bridge/ti-sn65dsi86.c b/drivers/gpu/drm/bridge/ti-sn65dsi86.c
index d16775c973c4e..b89f7f7ca1885 100644
--- a/drivers/gpu/drm/bridge/ti-sn65dsi86.c
+++ b/drivers/gpu/drm/bridge/ti-sn65dsi86.c
@@ -170,10 +170,10 @@
  * @pwm_refclk_freq: Cache for the reference clock input to the PWM.
  */
 struct ti_sn65dsi86 {
-	struct auxiliary_device		bridge_aux;
-	struct auxiliary_device		gpio_aux;
-	struct auxiliary_device		aux_aux;
-	struct auxiliary_device		pwm_aux;
+	struct auxiliary_device		*bridge_aux;
+	struct auxiliary_device		*gpio_aux;
+	struct auxiliary_device		*aux_aux;
+	struct auxiliary_device		*pwm_aux;
 
 	struct device			*dev;
 	struct regmap			*regmap;
@@ -468,27 +468,34 @@ static void ti_sn65dsi86_delete_aux(void *data)
 	auxiliary_device_delete(data);
 }
 
-/*
- * AUX bus docs say that a non-NULL release is mandatory, but it makes no
- * sense for the model used here where all of the aux devices are allocated
- * in the single shared structure. We'll use this noop as a workaround.
- */
-static void ti_sn65dsi86_noop(struct device *dev) {}
+static void ti_sn65dsi86_aux_device_release(struct device *dev)
+{
+	struct auxiliary_device *aux = container_of(dev, struct auxiliary_device, dev);
+
+	kfree(aux);
+}
 
 static int ti_sn65dsi86_add_aux_device(struct ti_sn65dsi86 *pdata,
-				       struct auxiliary_device *aux,
+				       struct auxiliary_device **aux_out,
 				       const char *name)
 {
 	struct device *dev = pdata->dev;
+	struct auxiliary_device *aux;
 	int ret;
 
+	aux = kzalloc(sizeof(*aux), GFP_KERNEL);
+	if (!aux)
+		return -ENOMEM;
+
 	aux->name = name;
 	aux->dev.parent = dev;
-	aux->dev.release = ti_sn65dsi86_noop;
+	aux->dev.release = ti_sn65dsi86_aux_device_release;
 	device_set_of_node_from_dev(&aux->dev, dev);
 	ret = auxiliary_device_init(aux);
-	if (ret)
+	if (ret) {
+		kfree(aux);
 		return ret;
+	}
 	ret = devm_add_action_or_reset(dev, ti_sn65dsi86_uninit_aux, aux);
 	if (ret)
 		return ret;
@@ -497,6 +504,8 @@ static int ti_sn65dsi86_add_aux_device(struct ti_sn65dsi86 *pdata,
 	if (ret)
 		return ret;
 	ret = devm_add_action_or_reset(dev, ti_sn65dsi86_delete_aux, aux);
+	if (!ret)
+		*aux_out = aux;
 
 	return ret;
 }
-- 
2.39.2



