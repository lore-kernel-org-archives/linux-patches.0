Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 994A71F868E;
	Tue, 17 Dec 2024 17:28:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734456501; cv=none; b=tfvo1sfbbUGxTEGnAL4SYuBOqAcStMi7CqcQ8qO49ly6ZfvR4DMtndxkEKu6jMNOiCU+v7wixUkf9239QKEPTVe3zg/iygL5q5PtKlOfqjiTp7YjQogDad67bmICRQ8LSzAn2zTuDmdxNt0IyG9+5z6HvT/lWzlFri9VabkYU+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734456501; c=relaxed/simple;
	bh=FSYK5fT9/9qtb1izu4KDeCalibAm9d65b/A/8P4x3JI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ETkXaQbqqhIGfCYet63uW/2uJ78oXOnp4wVsiELzeeqYS2r/dQM4N6Z7TekvAnDzrPbQ4dd+7/T5/87T4+Bl76ga/Sp4HUpEGm4IDTmyBGUDYNKgeLM4LGopVBXMY2fk3xbaXQsmq6zDZi7SAWRycc57OFuBcRSLvWTSLDt8uUU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g1V3h+DC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g1V3h+DC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AEE4C4CED7;
	Tue, 17 Dec 2024 17:28:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734456501;
	bh=FSYK5fT9/9qtb1izu4KDeCalibAm9d65b/A/8P4x3JI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g1V3h+DCQLIPt3bA3PwJHEYIzqfM1p1uaV2xuhuEXlLhcerdIoBJbZAmDjjVwerVQ
	 dhZ9ctswVPJ+X1S+Lx72ipIEI/wTC2uMG50ojnNibeQLNw3IS5FWVthbJCYHCYH2Qh
	 +x80LVkvghCj4e0xIuPY1JnaK6UqZlthQzkczC/8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: [PATCH 6.12 049/172] usb: typec: anx7411: fix OF node reference leaks in anx7411_typec_switch_probe()
Date: Tue, 17 Dec 2024 18:06:45 +0100
Message-ID: <20241217170548.300534131@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241217170546.209657098@linuxfoundation.org>
References: <20241217170546.209657098@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>

commit ef42b906df5c57d0719b69419df9dfd25f25c161 upstream.

The refcounts of the OF nodes obtained by of_get_child_by_name() calls
in anx7411_typec_switch_probe() are not decremented. Replace them with
device_get_named_child_node() calls and store the return values to the
newly created fwnode_handle fields in anx7411_data, and call
fwnode_handle_put() on them in the error path and in the unregister
functions.

Fixes: e45d7337dc0e ("usb: typec: anx7411: Use of_get_child_by_name() instead of of_find_node_by_name()")
Cc: stable@vger.kernel.org
Signed-off-by: Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://lore.kernel.org/r/20241126014909.3687917-1-joe@pf.is.s.u-tokyo.ac.jp
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/anx7411.c |   19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

--- a/drivers/usb/typec/anx7411.c
+++ b/drivers/usb/typec/anx7411.c
@@ -290,6 +290,8 @@ struct anx7411_data {
 	struct power_supply *psy;
 	struct power_supply_desc psy_desc;
 	struct device *dev;
+	struct fwnode_handle *switch_node;
+	struct fwnode_handle *mux_node;
 };
 
 static u8 snk_identity[] = {
@@ -1099,6 +1101,7 @@ static void anx7411_unregister_mux(struc
 	if (ctx->typec.typec_mux) {
 		typec_mux_unregister(ctx->typec.typec_mux);
 		ctx->typec.typec_mux = NULL;
+		fwnode_handle_put(ctx->mux_node);
 	}
 }
 
@@ -1107,6 +1110,7 @@ static void anx7411_unregister_switch(st
 	if (ctx->typec.typec_switch) {
 		typec_switch_unregister(ctx->typec.typec_switch);
 		ctx->typec.typec_switch = NULL;
+		fwnode_handle_put(ctx->switch_node);
 	}
 }
 
@@ -1114,28 +1118,29 @@ static int anx7411_typec_switch_probe(st
 				      struct device *dev)
 {
 	int ret;
-	struct device_node *node;
 
-	node = of_get_child_by_name(dev->of_node, "orientation_switch");
-	if (!node)
+	ctx->switch_node = device_get_named_child_node(dev, "orientation_switch");
+	if (!ctx->switch_node)
 		return 0;
 
-	ret = anx7411_register_switch(ctx, dev, &node->fwnode);
+	ret = anx7411_register_switch(ctx, dev, ctx->switch_node);
 	if (ret) {
 		dev_err(dev, "failed register switch");
+		fwnode_handle_put(ctx->switch_node);
 		return ret;
 	}
 
-	node = of_get_child_by_name(dev->of_node, "mode_switch");
-	if (!node) {
+	ctx->mux_node = device_get_named_child_node(dev, "mode_switch");
+	if (!ctx->mux_node) {
 		dev_err(dev, "no typec mux exist");
 		ret = -ENODEV;
 		goto unregister_switch;
 	}
 
-	ret = anx7411_register_mux(ctx, dev, &node->fwnode);
+	ret = anx7411_register_mux(ctx, dev, ctx->mux_node);
 	if (ret) {
 		dev_err(dev, "failed register mode switch");
+		fwnode_handle_put(ctx->mux_node);
 		ret = -ENODEV;
 		goto unregister_switch;
 	}


