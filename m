Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 480C7DF71;
	Mon,  6 Jan 2025 15:40:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736178016; cv=none; b=irTkW2Q3FGIqtqtXPuIylVYl/VDeetwc6ZOye2KZL2VA1yNhFAHLUaLf+ef6Ii+CFNwg3LwJIJGhC5MJAYahEjcGoJfWnkqpqDyDH0HSO5GFOeKvCs4SHpfEQlMQ9TMyLG4acryU9LyOTtNr6iVsIb0lojteWswy537ppBDxUlk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736178016; c=relaxed/simple;
	bh=yxXgGizMDGX5qOCc5+YwPVtSk6fpzsCuoK907s1y4Rg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VFsxjcSkCgVFjgSIvwMS71lq+TYw4BL81q1/3moSvxMU+uxphxHCCJBaFuF60598/CAP5Jj2MXCQGcirzJVDSPrpRJGUs2PZ2He+UJoxjSEPZ1EhPeq59hFQNEIymJjerUBymy5V4ornyhxbPDmsgX/13eLcVKFCf4bYiRNa744=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UXQRohLm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UXQRohLm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2BA5C4CED2;
	Mon,  6 Jan 2025 15:40:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736178016;
	bh=yxXgGizMDGX5qOCc5+YwPVtSk6fpzsCuoK907s1y4Rg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UXQRohLmKhgqCOHwaWk00PhDaDyv/H0t1lHlYQjUCmVk6ZHhKjskVfPLffI+0eL3V
	 8bWWXGIlep9yzoAuPFB3Ln7gDgHhh6zNOAGM0VNTeP1/kPr8eo8KuWhMgZaCC/COIR
	 doUH1jTXDRoWc1Dt2tRqTcQOFq46jJMGL5qUi+7k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	Biju Das <biju.das.jz@bp.renesas.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Subject: [PATCH 6.12 134/156] drm: adv7511: Fix use-after-free in adv7533_attach_dsi()
Date: Mon,  6 Jan 2025 16:17:00 +0100
Message-ID: <20250106151146.779896302@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151141.738050441@linuxfoundation.org>
References: <20250106151141.738050441@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Biju Das <biju.das.jz@bp.renesas.com>

commit 81adbd3ff21c1182e06aa02c6be0bfd9ea02d8e8 upstream.

The host_node pointer was assigned and freed in adv7533_parse_dt(), and
later, adv7533_attach_dsi() uses the same. Fix this use-after-free issue
by dropping of_node_put() in adv7533_parse_dt() and calling of_node_put()
in error path of probe() and also in the remove().

Fixes: 1e4d58cd7f88 ("drm/bridge: adv7533: Create a MIPI DSI device")
Cc: stable@vger.kernel.org
Reviewed-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20241119192040.152657-2-biju.das.jz@bp.renesas.com
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/bridge/adv7511/adv7511_drv.c |   10 ++++++++--
 drivers/gpu/drm/bridge/adv7511/adv7533.c     |    2 --
 2 files changed, 8 insertions(+), 4 deletions(-)

--- a/drivers/gpu/drm/bridge/adv7511/adv7511_drv.c
+++ b/drivers/gpu/drm/bridge/adv7511/adv7511_drv.c
@@ -1241,8 +1241,10 @@ static int adv7511_probe(struct i2c_clie
 		return ret;
 
 	ret = adv7511_init_regulators(adv7511);
-	if (ret)
-		return dev_err_probe(dev, ret, "failed to init regulators\n");
+	if (ret) {
+		dev_err_probe(dev, ret, "failed to init regulators\n");
+		goto err_of_node_put;
+	}
 
 	/*
 	 * The power down GPIO is optional. If present, toggle it from active to
@@ -1363,6 +1365,8 @@ err_i2c_unregister_edid:
 	i2c_unregister_device(adv7511->i2c_edid);
 uninit_regulators:
 	adv7511_uninit_regulators(adv7511);
+err_of_node_put:
+	of_node_put(adv7511->host_node);
 
 	return ret;
 }
@@ -1371,6 +1375,8 @@ static void adv7511_remove(struct i2c_cl
 {
 	struct adv7511 *adv7511 = i2c_get_clientdata(i2c);
 
+	of_node_put(adv7511->host_node);
+
 	adv7511_uninit_regulators(adv7511);
 
 	drm_bridge_remove(&adv7511->bridge);
--- a/drivers/gpu/drm/bridge/adv7511/adv7533.c
+++ b/drivers/gpu/drm/bridge/adv7511/adv7533.c
@@ -181,8 +181,6 @@ int adv7533_parse_dt(struct device_node
 	if (!adv->host_node)
 		return -ENODEV;
 
-	of_node_put(adv->host_node);
-
 	adv->use_timing_gen = !of_property_read_bool(np,
 						"adi,disable-timing-generator");
 


