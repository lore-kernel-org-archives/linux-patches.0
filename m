Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A81C01C03
	for <patches@lists.linux.dev>; Mon, 20 Mar 2023 15:15:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2779CC4339B;
	Mon, 20 Mar 2023 15:15:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1679325328;
	bh=YAq+Bf7ra3cq1nrDi5rHRjehqZChJcH6ijEaUwTFk00=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aDcgsp0Gok/B4h+HWZuIKB/vpEEVVDxih8x0Mk8K3dHuSbFgpxmlggGhz/qC7AxgS
	 lQu5/bTvhpcujhMpScx6UzX5thcnKkz7xB/PXYCLjf1J9crPjtwvyBUvJ9DtrkU5Be
	 8sV4UfIxTwjI3psEzc6XyzUfFkWJeaxcieV9+kTk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxime Ripard <mripard@kernel.org>,
	Johan Hovold <johan+linaro@kernel.org>,
	Maxime Ripard <maxime@cerno.tech>
Subject: [PATCH 5.15 091/115] drm/sun4i: fix missing component unbind on bind errors
Date: Mon, 20 Mar 2023 15:55:03 +0100
Message-Id: <20230320145453.230740845@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145449.336983711@linuxfoundation.org>
References: <20230320145449.336983711@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Johan Hovold <johan+linaro@kernel.org>

commit c22f2ff8724b49dce2ae797e9fbf4bc0fa91112f upstream.

Make sure to unbind all subcomponents when binding the aggregate device
fails.

Fixes: 9026e0d122ac ("drm: Add Allwinner A10 Display Engine support")
Cc: stable@vger.kernel.org      # 4.7
Cc: Maxime Ripard <mripard@kernel.org>
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Link: https://patchwork.freedesktop.org/patch/msgid/20230306103242.4775-1-johan+linaro@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/sun4i/sun4i_drv.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/sun4i/sun4i_drv.c
+++ b/drivers/gpu/drm/sun4i/sun4i_drv.c
@@ -94,12 +94,12 @@ static int sun4i_drv_bind(struct device
 	/* drm_vblank_init calls kcalloc, which can fail */
 	ret = drm_vblank_init(drm, drm->mode_config.num_crtc);
 	if (ret)
-		goto cleanup_mode_config;
+		goto unbind_all;
 
 	/* Remove early framebuffers (ie. simplefb) */
 	ret = drm_aperture_remove_framebuffers(false, &sun4i_drv_driver);
 	if (ret)
-		goto cleanup_mode_config;
+		goto unbind_all;
 
 	sun4i_framebuffer_init(drm);
 
@@ -118,6 +118,8 @@ static int sun4i_drv_bind(struct device
 
 finish_poll:
 	drm_kms_helper_poll_fini(drm);
+unbind_all:
+	component_unbind_all(dev, NULL);
 cleanup_mode_config:
 	drm_mode_config_cleanup(drm);
 	of_reserved_mem_device_release(dev);


