Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82D96442384;
	Fri,  7 Aug 2026 15:12:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786115554; cv=none; b=Mei0Xv5VaedJKt8/UyeHs/9qqstOilt6hdiodL2ZC/5Rpt+p9+4jHE75/e76knH9ENnYqONgJH87joryHlcrJr+wNtELvuO27ZB2TmcJ+yV8SCddIq6owFz9sD1OFNvV2aCgbaNLCHrgt0LPVssvoUVoDG3ZvpK/exRUkYg36Qw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786115554; c=relaxed/simple;
	bh=OMncygVvPjNwihCi2JUyH+E8Vllj0XCeKF+sM7p7JzE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kHjnOlnVribw4ZT1Cy2HuPCVFhV38Z7M1tR38qeHaPRXzGnuId1OGmgovEbwCD6xKN7CPRtCFOA9L+kNhGueTqs4482qquFSGm5uVlRYlKdDyfd41EZ2yAEjdq0dDyLNOyh14w4wlR7RX33kSVLvATEIVJw30YkjWPOfSyWbRsU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lOQQqR8n; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lOQQqR8n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A88F81F000E9;
	Fri,  7 Aug 2026 15:12:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786115551;
	bh=mbAMpfOMNVppCYscdEFl2G9RKyzWroFjzRgTtHREnm0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lOQQqR8nl24tVYRNtsLdn3CWwlch/otdHbxplgw8iH87SMlJvtXGw7SfImK6sH9aA
	 tAG+40YZ9qV4W/TnOsHer+ODAF3RZ3CLM1UAIBEfzXFAhochx9A1bdoX1K5sgzp0Qx
	 cROn4yS71oQQzYjygG/SKvdZYI5i5uzGvklP6R/I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	Johan Hovold <johan@kernel.org>,
	Luca Ceresoli <luca.ceresoli@bootlin.com>
Subject: [PATCH 6.18 315/396] drm/bridge: display-connector: Fix I2C adapter resource leak
Date: Fri,  7 Aug 2026 16:37:55 +0200
Message-ID: <20260807143431.059896189@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143424.272339768@linuxfoundation.org>
References: <20260807143424.272339768@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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


