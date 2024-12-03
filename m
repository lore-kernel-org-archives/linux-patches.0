Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D4F61F6689;
	Tue,  3 Dec 2024 14:35:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733236524; cv=none; b=O/t6EAHS6qfaaGHvRWEZeegIAY+HMlVMIKN1prm47V08gTc4/GX7RoTcUYEYM2WZ0lPeGwnSPGHrDZPyikOqltSK6Ojz6wBN957EVyGoQP54lvs89+mwJ4bBd1/R7QJl5EuL9ZoQZv3C/P8Zyfu6cpbGsnuWLqALiX555w6tjO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733236524; c=relaxed/simple;
	bh=dNq6cf9PIi23aqZ5hDz8JGFygZUbjBiNhqoImhE685E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hTCLe1q7uGONqsY+M0O7ffLwc4sbPBssscmUFns0tBmS0PixC6jF0t+tgz5zBAsgccQJmDmuzZeXPthq5owhVA9QAZAlQiG9BxfbNSFdEBn0APBGx5fIFSpsl6XMHes6I6AuYxZxiOKT3BflI+s6laoh4kVSAC36UWNWwTTqm6A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GmRpnC43; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GmRpnC43"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8164CC4CECF;
	Tue,  3 Dec 2024 14:35:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733236524;
	bh=dNq6cf9PIi23aqZ5hDz8JGFygZUbjBiNhqoImhE685E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GmRpnC436d993r8M/VOKv5+CIpU4FLhrhRSufD2V1dwwFOnePQfOD8xTurlr7tEUB
	 32QZ/3/a1ipcOj9BW+z7x7OxNTCJwqpp/uTrG9YSPZQEplP7XiQLy7fhwkjyunBKed
	 ymVEB0lfKNjhbGvKmnZBK5nlWp1vQslz0YkkZiEo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Emil Velikov <emil.velikov@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 045/138] drm/fsl-dcu: Use GEM CMA object functions
Date: Tue,  3 Dec 2024 15:31:14 +0100
Message-ID: <20241203141925.283780453@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203141923.524658091@linuxfoundation.org>
References: <20241203141923.524658091@linuxfoundation.org>
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

From: Thomas Zimmermann <tzimmermann@suse.de>

[ Upstream commit 929027087f527ef1d9e906e4ebeca7eb3a36042e ]

Create GEM objects with drm_gem_cma_create_object_default_funcs(), which
allocates the object and sets CMA's default object functions. Corresponding
callbacks in struct drm_driver are cleared. No functional changes are made.

Driver and object-function instances use the same callback functions, with
the exception of vunmap. The implementation of vunmap is empty and left out
in CMA's default object functions.

v3:
	* convert to DRIVER_OPS macro in a separate patch

Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Reviewed-by: Emil Velikov <emil.velikov@collabora.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20200605073247.4057-11-tzimmermann@suse.de
Stable-dep-of: ffcde9e44d3e ("drm: fsl-dcu: enable PIXCLK on LS1021A")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/fsl-dcu/fsl_dcu_drm_drv.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/fsl-dcu/fsl_dcu_drm_drv.c b/drivers/gpu/drm/fsl-dcu/fsl_dcu_drm_drv.c
index 3eab7b4c16b2b..a21c348f9a5e4 100644
--- a/drivers/gpu/drm/fsl-dcu/fsl_dcu_drm_drv.c
+++ b/drivers/gpu/drm/fsl-dcu/fsl_dcu_drm_drv.c
@@ -144,14 +144,10 @@ static struct drm_driver fsl_dcu_drm_driver = {
 	.irq_handler		= fsl_dcu_drm_irq,
 	.irq_preinstall		= fsl_dcu_irq_uninstall,
 	.irq_uninstall		= fsl_dcu_irq_uninstall,
-	.gem_free_object_unlocked = drm_gem_cma_free_object,
-	.gem_vm_ops		= &drm_gem_cma_vm_ops,
+	.gem_create_object	= drm_gem_cma_create_object_default_funcs,
 	.prime_handle_to_fd	= drm_gem_prime_handle_to_fd,
 	.prime_fd_to_handle	= drm_gem_prime_fd_to_handle,
-	.gem_prime_get_sg_table	= drm_gem_cma_prime_get_sg_table,
 	.gem_prime_import_sg_table = drm_gem_cma_prime_import_sg_table,
-	.gem_prime_vmap		= drm_gem_cma_prime_vmap,
-	.gem_prime_vunmap	= drm_gem_cma_prime_vunmap,
 	.gem_prime_mmap		= drm_gem_cma_prime_mmap,
 	.dumb_create		= drm_gem_cma_dumb_create,
 	.fops			= &fsl_dcu_drm_fops,
-- 
2.43.0



