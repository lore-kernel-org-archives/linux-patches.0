Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30DA447F53;
	Fri,  6 Dec 2024 14:59:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733497188; cv=none; b=OoozzYmUpjc5Xdxak7sBqnw9qf6B+g7AkhviYp/2h56YTFzlS736ljQDYyevonlAYq3SWFzAY8u32FCOn26SI7S8rFf2ciIExIXuBI9rHNaG8Atl4acxj9W6LgJw8bU4Ptv7wQ8/ZnIu/8DCu6lXpEyCPIHfl+++qNLL4NQaREg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733497188; c=relaxed/simple;
	bh=UHuYgkaPq9e68e5K7ZTzR2IfvYBxkf2QtvGhzslZHCg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SD0o93sBGRY9xUvWLkSZqI3L5HCjEEGJAPPf88foC5u6uhzprPOYPXM3fUjNUpmlTVexo98M6GtILCilsq3TmkuRhx82gkjxgdyUUGnIJU78xU4lxQwdipmMmx2j9eWqhF2W1RT+D+KuDbGwobQgIknqm/WCWySMPWnfPOjaZHM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=URLEbiUt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="URLEbiUt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 946EFC4CED1;
	Fri,  6 Dec 2024 14:59:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733497188;
	bh=UHuYgkaPq9e68e5K7ZTzR2IfvYBxkf2QtvGhzslZHCg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=URLEbiUtEUZZLeu445ynidw7GzZTW1FzsucMLfoTUkwvEnP61qGyad0WMvberCBxM
	 clloimgw9w1IRwu43naPCuOvYx35hOMzj0AWJtxwSSCVQ9r6PrvaFFJXWCIYvCuKmR
	 aAx/AOf+iGE9hAGa52w9KXKt6r49Tq7dCzgeaUpw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Anderson <sean.anderson@linux.dev>,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 220/676] drm: zynqmp_kms: Unplug DRM device before removal
Date: Fri,  6 Dec 2024 15:30:39 +0100
Message-ID: <20241206143701.932579984@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Anderson <sean.anderson@linux.dev>

[ Upstream commit 2e07c88914fc5289c21820b1aa94f058feb38197 ]

Prevent userspace accesses to the DRM device from causing
use-after-frees by unplugging the device before we remove it. This
causes any further userspace accesses to result in an error without
further calls into this driver's internals.

Fixes: d76271d22694 ("drm: xlnx: DRM/KMS driver for Xilinx ZynqMP DisplayPort Subsystem")
Closes: https://lore.kernel.org/dri-devel/4d8f4c9b-2efb-4774-9a37-2f257f79b2c9@linux.dev/
Signed-off-by: Sean Anderson <sean.anderson@linux.dev>
Signed-off-by: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240809193600.3360015-2-sean.anderson@linux.dev
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xlnx/zynqmp_kms.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/xlnx/zynqmp_kms.c b/drivers/gpu/drm/xlnx/zynqmp_kms.c
index 44d4a510ad7d6..ccb6e065dc6d1 100644
--- a/drivers/gpu/drm/xlnx/zynqmp_kms.c
+++ b/drivers/gpu/drm/xlnx/zynqmp_kms.c
@@ -533,7 +533,7 @@ void zynqmp_dpsub_drm_cleanup(struct zynqmp_dpsub *dpsub)
 {
 	struct drm_device *drm = &dpsub->drm->dev;
 
-	drm_dev_unregister(drm);
+	drm_dev_unplug(drm);
 	drm_atomic_helper_shutdown(drm);
 	drm_encoder_cleanup(&dpsub->drm->encoder);
 	drm_kms_helper_poll_fini(drm);
-- 
2.43.0



