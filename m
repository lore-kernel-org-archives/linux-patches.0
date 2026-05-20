Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EBD0364E89;
	Wed, 20 May 2026 17:15:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779297355; cv=none; b=Z6ORa9WwpEJPRyeNMLuuONuMbiXWwCWjpVy0PrpQSRyMBKoTvC5vEkxwt9y2fMwWg3vBBM9SIO0PBzcR4fCKQoR/auPwZOmCJhsiZbgZM/1pIq+jw7KCbeRxjcIQSLYdcdroohstHAzaysjafzJPXrpVH9jJEt9Xd/JeOdO4X88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779297355; c=relaxed/simple;
	bh=fVUvF1B4DiC0uEBTSy23h8Lsp7WVdHv0PLLXF4uGMrs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e+GP8xBKHo7FNzx1r2lPlS6L0OAWhE2Bx8V/nDf15EqX0F3i+mnrrLwGL+9F7WqGycXdowUq+3TdhG3UoqMaffZlGcSUiD593q7KGGOooWleRZiamDI5Gwhnvnfb6aEGMt7xA5n82Uu3TWNb2G/vVHf/6GJKkmrozWJtTOP4qO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=netfsJN0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="netfsJN0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 015141F000E9;
	Wed, 20 May 2026 17:15:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779297354;
	bh=J/0b6JYa5baVceLVzue8R2jIdsQTKN8Yi+SNjiPmHHw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=netfsJN0uiqBKLSDqkVHXjcvp+ZBrKmnGcB4TixXMDB2UEW9Eu3PGSNDpac58cCsI
	 fgiT8HCFNbEYerGbHCgdjgJjUGPUs/6Sc+uTD6RueMIAgT+Q9PS/8Yr6rhISVroMnW
	 nggq4+KyikORh/tMBNkdBu6mFuRQ3pF3p+ceXAu8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Patrik Jakobsson <patrik.r.jakobsson@gmail.com>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 7.0 1135/1146] drm/gma500/oaktrail_lvds: fix hang on init failure
Date: Wed, 20 May 2026 18:23:05 +0200
Message-ID: <20260520162213.940655129@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

commit 657a091ab6d01d0091b77660c75cfed573c9a53e upstream.

The LVDS init code looks up an I2C adapter using i2c_get_adapter() and
tries to read the EDID before falling back to allocating and registering
its own adapter.

The error handling does not separate these cases so on a late init
failure it will try to deregister and free also an adapter that had
previously been registered. Since i2c_get_adapter() takes another
reference to the adapter, deregistration hangs indefinitely while
waiting for the reference to be released.

Fix this by only destroying adapters allocated during LVDS init on
errors.

Fixes: a57ebfc0b4da ("drm/gma500: Make oaktrail lvds use ddc adapter from drm_connector")
Cc: stable@vger.kernel.org	# 6.0
Cc: Patrik Jakobsson <patrik.r.jakobsson@gmail.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Patrik Jakobsson <patrik.r.jakobsson@gmail.com>
Link: https://patch.msgid.link/20260508144446.59722-3-johan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/gma500/oaktrail_lvds.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/gma500/oaktrail_lvds.c
+++ b/drivers/gpu/drm/gma500/oaktrail_lvds.c
@@ -293,7 +293,7 @@ void oaktrail_lvds_init(struct drm_devic
 {
 	struct gma_encoder *gma_encoder;
 	struct gma_connector *gma_connector;
-	struct gma_i2c_chan *ddc_bus;
+	struct gma_i2c_chan *ddc_bus = NULL;
 	struct drm_connector *connector;
 	struct drm_encoder *encoder;
 	struct drm_psb_private *dev_priv = to_drm_psb_private(dev);
@@ -421,7 +421,8 @@ out:
 
 err_unlock:
 	mutex_unlock(&dev->mode_config.mutex);
-	gma_i2c_destroy(to_gma_i2c_chan(connector->ddc));
+	if (!IS_ERR_OR_NULL(ddc_bus))
+		gma_i2c_destroy(ddc_bus);
 	drm_encoder_cleanup(encoder);
 err_connector_cleanup:
 	drm_connector_cleanup(connector);


