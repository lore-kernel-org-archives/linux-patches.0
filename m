Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4344C3A6F0A;
	Fri,  7 Aug 2026 15:47:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786117630; cv=none; b=gS/eJqGyvmcaLLojo9fzbGZ05phLU/+oKr6f46SI+WaufZvMI/7RliyOPgYtKjPuqQXefRXo9tUlPUIHVTPlvGz7DKsVkz1a9xgzYgRe4SaH2ohvIiuW0RGQwguQW6ZfZM6m4gzRSDPC59TKCgv7NT+XENx70eVGTxihifJrDbI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786117630; c=relaxed/simple;
	bh=XQK+i5TBJ3qf7OCs5EwahMOeMt4HTvsIVq9EJulEh7o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TGANiot809QQEaMSJRa90tW/R7sHan5reLW0UtDqPGjuiyllLOmQjepi8qWFy7v57UIeAxB506S4KQdK4XKuPbqP/UlfrMuKMt+PeLot09ORsl8pFjOp6XDogswBp9blryu2DggiE4W26PQLcI138vXGAKr4LjGimOl3CGFNRT0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RmCzpXcA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RmCzpXcA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A06611F000E9;
	Fri,  7 Aug 2026 15:47:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786117629;
	bh=4Wz7NkojfGeFkUugLzwiX9BDqC84ulBp1XUBlqeXy7g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RmCzpXcA0fbqmS69rOu5XyRdscxGR2CRcH7qsdv1l9/7JjH7nFs1F+jiYh3v3FIeA
	 ePB2tcv/OsMBYtqKkvQ1GV1qsjRBByXdVt7XEC9BQPV0BZ4Tbby/PUD7XIXqKsTNQC
	 lS4lZULYQ3cd7U8pDcAAarmnHyDK3JqFZafoTbRA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	Johan Hovold <johan@kernel.org>,
	Luca Ceresoli <luca.ceresoli@bootlin.com>
Subject: [PATCH 7.1 385/438] drm/bridge: display-connector: Fix I2C adapter resource leak
Date: Fri,  7 Aug 2026 16:39:41 +0200
Message-ID: <20260807143436.175077140@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
References: <20260807143428.008222056@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>

commit 6a39ca1286dd97ad02bb8e03bbb65ee05368d778 upstream.

If the probe function returns an error after getting the I2C adapter for
DDC, the reference to the adapter is never released. Fix it by releasing
it in the bridge .destroy() handler.

There is no need to test the ddc pointer with !IS_ERR(), as
of_get_i2c_adapter_by_node() returns NULL on error.

Fixes: 2e2bf3a5584d ("drm/bridge: display-connector: add DP support")
Cc: stable@vger.kernel.org
Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Reviewed-by: Johan Hovold <johan@kernel.org>
Reviewed-by: Luca Ceresoli <luca.ceresoli@bootlin.com>
Link: https://patch.msgid.link/20260717184836.2017386-1-laurent.pinchart+renesas@ideasonboard.com
Signed-off-by: Luca Ceresoli <luca.ceresoli@bootlin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/bridge/display-connector.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/bridge/display-connector.c
+++ b/drivers/gpu/drm/bridge/display-connector.c
@@ -40,6 +40,13 @@ static int display_connector_attach(stru
 	return flags & DRM_BRIDGE_ATTACH_NO_CONNECTOR ? 0 : -EINVAL;
 }
 
+static void display_connector_destroy(struct drm_bridge *bridge)
+{
+	struct display_connector *conn = to_display_connector(bridge);
+
+	i2c_put_adapter(conn->bridge.ddc);
+}
+
 static enum drm_connector_status display_connector_detect(struct drm_bridge *bridge)
 {
 	struct display_connector *conn = to_display_connector(bridge);
@@ -177,6 +184,7 @@ static u32 *display_connector_get_input_
 
 static const struct drm_bridge_funcs display_connector_bridge_funcs = {
 	.attach = display_connector_attach,
+	.destroy = display_connector_destroy,
 	.detect = display_connector_bridge_detect,
 	.edid_read = display_connector_edid_read,
 	.atomic_get_output_bus_fmts = display_connector_get_output_bus_fmts,
@@ -403,9 +411,6 @@ static void display_connector_remove(str
 		regulator_disable(conn->supply);
 
 	drm_bridge_remove(&conn->bridge);
-
-	if (!IS_ERR(conn->bridge.ddc))
-		i2c_put_adapter(conn->bridge.ddc);
 }
 
 static const struct of_device_id display_connector_match[] = {


