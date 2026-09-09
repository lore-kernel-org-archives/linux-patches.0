Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 857DD563299;
	Wed,  9 Sep 2026 14:10:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788963001; cv=none; b=CQTMY4km7JPVYDeH9BQer93BrKUE9lUFa0vbnnoTwsglY9nAHvSMoSfzaAQSbafxdvDWLqrklYcTNHctA+dVwg5zWJTkwvK2JbNacPIZXU8ffqYMHCDxAbCBzb1Kd+m0qaGb9mB/2xDxsybaHLOeNymuEePo/BBnntgVYU89HFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788963001; c=relaxed/simple;
	bh=phieCVqV5G0kpYRDdKKngN/Mt24msH87XoXdIz3W2sA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CU8s8umRonyuZlNs+YnEPl+HCv7NdtIf+ZpM1690OBWR87OYe56IjCrg/u7Hi7TigUSNtFR6FAsisk7sVZoPN1zAAAogvz+7ofw7oRB/c8HWWDQPGcvfIRuqFdJ8m3KiLb/E9r4GoIwLEfiug6lc0/ABFw4Oi2Joye2sPoqCX/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tQMaVPjF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tQMaVPjF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD60E1F00A3A;
	Wed,  9 Sep 2026 14:09:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788963000;
	bh=oYqEZ84hDocW849YqMQY6P4dwrTdtyjF7KoOy9hcFWg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tQMaVPjFgn0zNUIx8NujIyJSLe0umhq0WdRofRsc50ZWDyurwGviZWihln3IVSkUA
	 zd7XQrFqep5Kg0x6rmUblaIFej9YfZUoG8z7fe/OtP/j3iNf3nWeZbCsUhfUzUU8a1
	 4hwi0JSE+Rec66/LZaPgMVcjM/E9myJOA4C/+wkQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Douglas Anderson <dianders@chromium.org>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 7.2 478/556] drm/panel-edp: fix i2c adapter leak on probe failure
Date: Wed,  9 Sep 2026 15:42:38 +0200
Message-ID: <20260909134247.352418449@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

commit e2a9e291275a74e309a21cbb1def6296a72d6aed upstream.

Make sure to drop the i2c adapter reference on probe failure (e.g.
probe deferral) and on driver unbind also if a devicetree redundantly
uses the 'ddc-i2c-bus' property to point to the aux ddc bus.

Fixes: cc5a3fc041f0 ("drm/panel: panel-simple: Stash DP AUX bus; allow using it for DDC")
Cc: stable@vger.kernel.org	# 5.15
Reported-by: Douglas Anderson <dianders@chromium.org>
Link: https://lore.kernel.org/r/CAD=FV=VZPhzHU+Pet2m3L+Pqc7mOPfZC-f5p0OuNL79wNZPxRg@mail.gmail.com
Signed-off-by: Johan Hovold <johan@kernel.org>
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Link: https://patch.msgid.link/20260717143119.1815106-2-johan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/panel/panel-edp.c |   19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

--- a/drivers/gpu/drm/panel/panel-edp.c
+++ b/drivers/gpu/drm/panel/panel-edp.c
@@ -831,6 +831,13 @@ exit:
 	return 0;
 }
 
+static void panel_edp_put_adapter(void *_adap)
+{
+	struct i2c_adapter *adap = _adap;
+
+	put_device(&adap->dev);
+}
+
 static int panel_edp_probe(struct device *dev, const struct panel_desc *desc,
 			   struct drm_dp_aux *aux)
 {
@@ -878,6 +885,11 @@ static int panel_edp_probe(struct device
 
 		if (!panel->ddc)
 			return -EPROBE_DEFER;
+
+		err = devm_add_action_or_reset(dev, panel_edp_put_adapter,
+					       panel->ddc);
+		if (err)
+			return err;
 	} else if (aux) {
 		panel->ddc = &aux->ddc;
 	}
@@ -889,7 +901,7 @@ static int panel_edp_probe(struct device
 
 	err = drm_panel_of_backlight(&panel->base);
 	if (err)
-		goto err_finished_ddc_init;
+		return err;
 
 	/*
 	 * We use runtime PM for prepare / unprepare since those power the panel
@@ -936,9 +948,6 @@ static int panel_edp_probe(struct device
 err_finished_pm_runtime:
 	pm_runtime_dont_use_autosuspend(dev);
 	pm_runtime_disable(dev);
-err_finished_ddc_init:
-	if (panel->ddc && (!panel->aux || panel->ddc != &panel->aux->ddc))
-		put_device(&panel->ddc->dev);
 
 	return err;
 }
@@ -982,8 +991,6 @@ static void panel_edp_remove(struct devi
 
 	pm_runtime_dont_use_autosuspend(dev);
 	pm_runtime_disable(dev);
-	if (panel->ddc && (!panel->aux || panel->ddc != &panel->aux->ddc))
-		put_device(&panel->ddc->dev);
 
 	drm_edid_free(panel->drm_edid);
 	panel->drm_edid = NULL;


