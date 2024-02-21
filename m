Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 058E969DF6;
	Wed, 21 Feb 2024 13:19:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708521567; cv=none; b=HoE+R/t850idX9Pg9izZPnumZGhKcPYCxyrKPpOo8MD3lHfjdlfYNYZXJ7ES1f+KrUsM/MCSNTO1L97HMgwkrbsCfNtj9Phj/GpFi2sxKnun3U7HKn8Ixe7r8JY1+5oXfyeuAvBEF7N0lggxMnmdluSQWTlUH9AIGhUa0dbRbS0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708521567; c=relaxed/simple;
	bh=H3GLAT/qIh6pN3bKvays8y2ULfYfINWjOqEkUXmhg7g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ePFkdAnK8ut9YI+wgSqOu+hgz67PikgYaZy8fWKsZoqNN4Jy+ls0GMauV6l9NXG4RZHiKGp3TdRxfPQbrWB5K69jd980CUY7bQBm0Io7Z37VQsFuY2YXKMu3eLyqSIeLBJXUK0KHD5VyqV4ANA/KYETmG0rNjhFFcribxPoCkRU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZphRk5vl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZphRk5vl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68B10C433C7;
	Wed, 21 Feb 2024 13:19:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708521566;
	bh=H3GLAT/qIh6pN3bKvays8y2ULfYfINWjOqEkUXmhg7g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZphRk5vlGq99q7L2a7lB+/CnqZuge6mIXgT9WgrBX46dLu+YXYTXHNo6FEiEVgGvC
	 2qdrbQ7nZ/PFc53fdRAeAEfarIgyXQ1cJtiZv6cPGWm5a8o16TdC0GZKMY6jFVyJpo
	 4idC8MdgIhtPaT42N8kYukSUmiHi3yIDMmD/U9i4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxime Ripard <mripard@kernel.org>,
	Douglas Anderson <dianders@chromium.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Inki Dae <inki.dae@samsung.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 107/202] drm/exynos: Call drm_atomic_helper_shutdown() at shutdown/unbind time
Date: Wed, 21 Feb 2024 14:06:48 +0100
Message-ID: <20240221125935.212087219@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125931.742034354@linuxfoundation.org>
References: <20240221125931.742034354@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Douglas Anderson <dianders@chromium.org>

[ Upstream commit 16ac5b21b31b439f03cdf44c153c5f5af94fb3eb ]

Based on grepping through the source code this driver appears to be
missing a call to drm_atomic_helper_shutdown() at system shutdown time
and at driver unbind time. Among other things, this means that if a
panel is in use that it won't be cleanly powered off at system
shutdown time.

The fact that we should call drm_atomic_helper_shutdown() in the case
of OS shutdown/restart and at driver remove (or unbind) time comes
straight out of the kernel doc "driver instance overview" in
drm_drv.c.

A few notes about this fix:
- When adding drm_atomic_helper_shutdown() to the unbind path, I added
  it after drm_kms_helper_poll_fini() since that's when other drivers
  seemed to have it.
- Technically with a previous patch, ("drm/atomic-helper:
  drm_atomic_helper_shutdown(NULL) should be a noop"), we don't
  actually need to check to see if our "drm" pointer is NULL before
  calling drm_atomic_helper_shutdown(). We'll leave the "if" test in,
  though, so that this patch can land without any dependencies. It
  could potentially be removed later.
- This patch also makes sure to set the drvdata to NULL in the case of
  bind errors to make sure that shutdown can't access freed data.

Suggested-by: Maxime Ripard <mripard@kernel.org>
Reviewed-by: Maxime Ripard <mripard@kernel.org>
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Tested-by: Marek Szyprowski <m.szyprowski@samsung.com>
Reviewed-by: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Inki Dae <inki.dae@samsung.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/exynos/exynos_drm_drv.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/gpu/drm/exynos/exynos_drm_drv.c b/drivers/gpu/drm/exynos/exynos_drm_drv.c
index b599f74692e5..db09e2055c86 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_drv.c
+++ b/drivers/gpu/drm/exynos/exynos_drm_drv.c
@@ -410,6 +410,7 @@ static int exynos_drm_bind(struct device *dev)
 	drm_release_iommu_mapping(drm);
 err_free_private:
 	kfree(private);
+	dev_set_drvdata(dev, NULL);
 err_free_drm:
 	drm_dev_put(drm);
 
@@ -424,6 +425,7 @@ static void exynos_drm_unbind(struct device *dev)
 
 	exynos_drm_fbdev_fini(drm);
 	drm_kms_helper_poll_fini(drm);
+	drm_atomic_helper_shutdown(drm);
 
 	component_unbind_all(drm->dev, drm);
 	drm_mode_config_cleanup(drm);
@@ -461,9 +463,18 @@ static int exynos_drm_platform_remove(struct platform_device *pdev)
 	return 0;
 }
 
+static void exynos_drm_platform_shutdown(struct platform_device *pdev)
+{
+	struct drm_device *drm = platform_get_drvdata(pdev);
+
+	if (drm)
+		drm_atomic_helper_shutdown(drm);
+}
+
 static struct platform_driver exynos_drm_platform_driver = {
 	.probe	= exynos_drm_platform_probe,
 	.remove	= exynos_drm_platform_remove,
+	.shutdown = exynos_drm_platform_shutdown,
 	.driver	= {
 		.name	= "exynos-drm",
 		.pm	= &exynos_drm_pm_ops,
-- 
2.43.0



