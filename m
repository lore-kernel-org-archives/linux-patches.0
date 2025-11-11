Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 055E226560B;
	Tue, 11 Nov 2025 01:11:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823515; cv=none; b=t5/RAM5ReicTEqBK7ob5Apd4OsFxRoIpt0qH8oEr1egRMNyxIPwFg5Fpm6Z6iUxWUjzJGQCleM0BOmZXR52lcqCOAbesq1A9JoYDaM9B97ZPfDoz4DNwokJVN16yP9iZ3MLxIo+EppSXEmDKjv2RHpSHXDoPc2olsiS1s2+JLCw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823515; c=relaxed/simple;
	bh=0W68SUFM0hBj/JgO714gAoM3lpsCuggEtC69pqdIrh8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uQjJRD/IxF2rgtKxugT2pzduKBNAWNjwn6DHEHxgevdZ54U5VY0a3oQMiSX4TkH8uP1oAdn3rN0MmyIzWB10lOKrMV/DXizcAExwEo/wZ9c2T2oSkKFwcO5tgtTfhRTNFFqtqbdGputKd0j6kbMPWGAZkRWQwM7alcSEJ9Awtr0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bgiAx535; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bgiAx535"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BB84C4AF09;
	Tue, 11 Nov 2025 01:11:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823514;
	bh=0W68SUFM0hBj/JgO714gAoM3lpsCuggEtC69pqdIrh8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bgiAx535pr+Hc7lyJTnceQIT0I1rBB1Jx1OEBnQnYKlSrrbOSl4T+oS3Za2+jBOx7
	 SFUdjvmdZI4lxkEQzSGBTMfBmmtAIrE4wf0AXGl1jnpchqlZYG+q6dq8jH3Gq4IxP0
	 ZNEfaHzKP0Jw3FNRjx+BfXc9KX4atWsqD4WrCBfg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Javier Martinez Canillas <javierm@redhat.com>,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 288/849] drm/tidss: Remove early fb
Date: Tue, 11 Nov 2025 09:37:38 +0900
Message-ID: <20251111004543.372677008@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>

[ Upstream commit 942e54a372b44da3ffb0191b4d289d476256c861 ]

Add a call to drm_aperture_remove_framebuffers() to drop the possible
early fb (simplefb).

Reviewed-by: Javier Martinez Canillas <javierm@redhat.com>
Link: https://lore.kernel.org/r/20250416-tidss-splash-v1-2-4ff396eb5008@ideasonboard.com
Signed-off-by: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/tidss/tidss_drv.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/gpu/drm/tidss/tidss_drv.c b/drivers/gpu/drm/tidss/tidss_drv.c
index a1b12e52aca47..27d9a8fd541fc 100644
--- a/drivers/gpu/drm/tidss/tidss_drv.c
+++ b/drivers/gpu/drm/tidss/tidss_drv.c
@@ -8,6 +8,7 @@
 #include <linux/of.h>
 #include <linux/module.h>
 #include <linux/pm_runtime.h>
+#include <linux/aperture.h>
 
 #include <drm/clients/drm_client_setup.h>
 #include <drm/drm_atomic.h>
@@ -192,12 +193,20 @@ static int tidss_probe(struct platform_device *pdev)
 		goto err_irq_uninstall;
 	}
 
+	/* Remove possible early fb before setting up the fbdev */
+	ret = aperture_remove_all_conflicting_devices(tidss_driver.name);
+	if (ret)
+		goto err_drm_dev_unreg;
+
 	drm_client_setup(ddev, NULL);
 
 	dev_dbg(dev, "%s done\n", __func__);
 
 	return 0;
 
+err_drm_dev_unreg:
+	drm_dev_unregister(ddev);
+
 err_irq_uninstall:
 	tidss_irq_uninstall(ddev);
 
-- 
2.51.0



