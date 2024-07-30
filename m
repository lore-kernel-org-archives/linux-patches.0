Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A4E7155CB3;
	Tue, 30 Jul 2024 16:47:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722358028; cv=none; b=AToyp37C1RdqcTsV69g80ZT2pZn1ITQV5rQ/TQISE2Bd3f8kVDomIew6EceSwp1NKKAz8p9QonM9gaZGwKNYvZ8CQRajY2ovl9prUM5J3lmMSTKxlRNqSUcFZaFuI9NqqZvK8n5q7Hfciz6COsfTzJUJmqdeLL6owuZrDf75AoU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722358028; c=relaxed/simple;
	bh=8Zsyozzsw9oiLHZSKRaTokoTWPqsfznviqYWcWRKsIM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OEK5g26S1PzqwUHmxTP4SGFpup0tFj+2MpE8fiVYRHJeTbY4BgU1cTBGnhz6aK4W8j9oESGh4/vCiSe/ywzmRCPNtKe5Knbw/G+8UuIlT1c2YdnSYqofvxURGhLf3LuhJOXmzecJdZHNKLdVoBdQ7zXd2NAhHNJq7lwaXdqkWpo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NXAlh7Fq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NXAlh7Fq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA8CEC4AF0C;
	Tue, 30 Jul 2024 16:47:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722358028;
	bh=8Zsyozzsw9oiLHZSKRaTokoTWPqsfznviqYWcWRKsIM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NXAlh7Fq1p6CxCnifBRflDnfBI0+DmAsifg8yWvHE9GwaxHf5h7lZKwNV2MPlkmgk
	 zBAN8WntYaFDnOZC4fFJCXyiY4T0+ixWwj5zYlmzRLqM+vPSFa+AZVg/FwzV76YV17
	 ay8xdE7850WPe9oayPyRK+jBaqReXUObnUJbOwNc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Anderson <sean.anderson@linux.dev>,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 316/809] drm: zynqmp_kms: Fix AUX bus not getting unregistered
Date: Tue, 30 Jul 2024 17:43:12 +0200
Message-ID: <20240730151737.085050484@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Anderson <sean.anderson@linux.dev>

[ Upstream commit 0743dafefd3f2b92116213f2225ea355001b7948 ]

drm_encoder_cleanup is responsible for calling drm_bridge_detach for
each bridge attached to the encoder. zynqmp_dp_bridge_detach is in turn
responsible for unregistering the AUX bus. However, we never ended up
calling drm_encoder_cleanup in the remove or error paths, so the AUX bus
would stick around after the rest of the driver had been removed.

I don't really understand why drm_mode_config_cleanup doesn't call
drm_encoder_cleanup for us. It will call destroy (which for
simple_encoder is drm_encoder_cleanup) on encoders in the mode_config's
encoder_list.

Should drm_encoder_cleanup get called before or after
drm_atomic_helper_shutdown?

Fixes: 2dfd045c8435 ("drm: xlnx: zynqmp_dpsub: Register AUX bus at bridge attach time")
Signed-off-by: Sean Anderson <sean.anderson@linux.dev>
Signed-off-by: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240503192922.2172314-2-sean.anderson@linux.dev
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xlnx/zynqmp_kms.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/xlnx/zynqmp_kms.c b/drivers/gpu/drm/xlnx/zynqmp_kms.c
index 43bf416b33d5c..f25583ce92e60 100644
--- a/drivers/gpu/drm/xlnx/zynqmp_kms.c
+++ b/drivers/gpu/drm/xlnx/zynqmp_kms.c
@@ -433,23 +433,28 @@ static int zynqmp_dpsub_kms_init(struct zynqmp_dpsub *dpsub)
 				DRM_BRIDGE_ATTACH_NO_CONNECTOR);
 	if (ret) {
 		dev_err(dpsub->dev, "failed to attach bridge to encoder\n");
-		return ret;
+		goto err_encoder;
 	}
 
 	/* Create the connector for the chain of bridges. */
 	connector = drm_bridge_connector_init(&dpsub->drm->dev, encoder);
 	if (IS_ERR(connector)) {
 		dev_err(dpsub->dev, "failed to created connector\n");
-		return PTR_ERR(connector);
+		ret = PTR_ERR(connector);
+		goto err_encoder;
 	}
 
 	ret = drm_connector_attach_encoder(connector, encoder);
 	if (ret < 0) {
 		dev_err(dpsub->dev, "failed to attach connector to encoder\n");
-		return ret;
+		goto err_encoder;
 	}
 
 	return 0;
+
+err_encoder:
+	drm_encoder_cleanup(encoder);
+	return ret;
 }
 
 static void zynqmp_dpsub_drm_release(struct drm_device *drm, void *res)
@@ -529,5 +534,6 @@ void zynqmp_dpsub_drm_cleanup(struct zynqmp_dpsub *dpsub)
 
 	drm_dev_unregister(drm);
 	drm_atomic_helper_shutdown(drm);
+	drm_encoder_cleanup(&dpsub->drm->encoder);
 	drm_kms_helper_poll_fini(drm);
 }
-- 
2.43.0



