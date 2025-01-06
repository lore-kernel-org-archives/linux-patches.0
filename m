Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DED91D9595;
	Mon,  6 Jan 2025 15:33:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736177584; cv=none; b=QIJ3kiHPo3/97YZqgZ6gl4qbTEpmWN557OfpS53rq6N2wqUzZxRgFAw91iF3jYHO9JYgG6MhHOl2g1iCFK43jVVigH3a0xdD7ioaeS8UzkcKoULmDyMU/tXVzMfzIRjP0OwKNSEfmk1tuupIkWu5b64TOhugfjIvzz/sc3swGNc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736177584; c=relaxed/simple;
	bh=3vi9X005PrzTtZiLwl97hSBzl46zhkL0oT0TfYH+3P0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LtlgUNHENJxv2uWbnm4sYI2A700AXYCF7/2ofwZnqHDDD9XNds/onwsXqxHbK3Syh2FDiudRRLDqu0pIGmGTKlsLR3wukOwD/bVm85i7QfCFuHcJX2sH5b72VpBpMWYbTGZvDYPBsREABLGExMIsXUmvOD8cNLsGj1LEaWmFTSA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Tm4qoFbO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Tm4qoFbO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDC39C4CED6;
	Mon,  6 Jan 2025 15:33:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736177584;
	bh=3vi9X005PrzTtZiLwl97hSBzl46zhkL0oT0TfYH+3P0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Tm4qoFbOhuseS825Q5kNCb/06IGS+RXG5KkRZPEMf1GbP1xMXtpBrHucwGnbyxqOq
	 D0Y729owl/BQiIwpbKXrVi2UTuZi2OB5YPxZsBbcrZEBQ1E3btrYq97o0u77QDpMSI
	 jIYS4XuWU3zCGplmCzqejrKUGDY4rQ1rLoDz29cM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	Biju Das <biju.das.jz@bp.renesas.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Subject: [PATCH 6.6 211/222] drm: adv7511: Fix use-after-free in adv7533_attach_dsi()
Date: Mon,  6 Jan 2025 16:16:55 +0100
Message-ID: <20250106151158.754184810@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151150.585603565@linuxfoundation.org>
References: <20250106151150.585603565@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1225,8 +1225,10 @@ static int adv7511_probe(struct i2c_clie
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
@@ -1346,6 +1348,8 @@ err_i2c_unregister_edid:
 	i2c_unregister_device(adv7511->i2c_edid);
 uninit_regulators:
 	adv7511_uninit_regulators(adv7511);
+err_of_node_put:
+	of_node_put(adv7511->host_node);
 
 	return ret;
 }
@@ -1354,6 +1358,8 @@ static void adv7511_remove(struct i2c_cl
 {
 	struct adv7511 *adv7511 = i2c_get_clientdata(i2c);
 
+	of_node_put(adv7511->host_node);
+
 	adv7511_uninit_regulators(adv7511);
 
 	drm_bridge_remove(&adv7511->bridge);
--- a/drivers/gpu/drm/bridge/adv7511/adv7533.c
+++ b/drivers/gpu/drm/bridge/adv7511/adv7533.c
@@ -184,8 +184,6 @@ int adv7533_parse_dt(struct device_node
 	if (!adv->host_node)
 		return -ENODEV;
 
-	of_node_put(adv->host_node);
-
 	adv->use_timing_gen = !of_property_read_bool(np,
 						"adi,disable-timing-generator");
 


