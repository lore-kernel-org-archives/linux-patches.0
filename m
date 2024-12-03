Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E1292C80;
	Tue,  3 Dec 2024 15:49:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733240959; cv=none; b=Z6NKsSbjuqgU2yZHAhA/2xImJpr5mq3ta01x02x/6EJ1RHCQAR5CD56Hr00vfL9FJR3t6uan0dvBDotrw+ig8DOXoTvBBYr/OUEiMy5EWOFwbAgdEhksCHSL3hrjy9GaupzYRqBZrKFJaq93eSFZ0ywSzo4j5T0w2Ph+jHuF9kI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733240959; c=relaxed/simple;
	bh=h+A1vpS25tvamGn0SWbrCJoIJEiPTCdKBNOpi+313Kw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J7qbqrRSMdrnVrMv1mfhFYQoLFz1aRzwcwwy5QjlJ6KKYtzjiQbKNtr5daXf8elBZZSxq5dxf+tvvUSWRYo9czv7U3fmJaIAODx2l6xK40nVoDd1vL++Wz1CA/HrhDWdr8AM0rShSjjkXKDJX4Nv+z4n9WNZNdCCSIvtLRJHZdM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oHyfQvAR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oHyfQvAR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 829D6C4CECF;
	Tue,  3 Dec 2024 15:49:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733240959;
	bh=h+A1vpS25tvamGn0SWbrCJoIJEiPTCdKBNOpi+313Kw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oHyfQvARU9x+AxeSyJeLNfM0d9h5OW5jRbAzgKs71g2yiMAOECD9c8CgKBHshmfR2
	 MtISeAUjaVVyMq2y9VV3JMRKQX1L837BVjtGnbNjTKGXr0DAmr5LYJLee/KpbUDziq
	 sm6KfCSPeR6tG5nXBSJ/frzPHjQMILf1FYD5ZGis=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Anderson <sean.anderson@linux.dev>,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 286/826] drm: zynqmp_kms: Unplug DRM device before removal
Date: Tue,  3 Dec 2024 15:40:13 +0100
Message-ID: <20241203144754.928312781@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index bd1368df78703..4556af2faa0f1 100644
--- a/drivers/gpu/drm/xlnx/zynqmp_kms.c
+++ b/drivers/gpu/drm/xlnx/zynqmp_kms.c
@@ -536,7 +536,7 @@ void zynqmp_dpsub_drm_cleanup(struct zynqmp_dpsub *dpsub)
 {
 	struct drm_device *drm = &dpsub->drm->dev;
 
-	drm_dev_unregister(drm);
+	drm_dev_unplug(drm);
 	drm_atomic_helper_shutdown(drm);
 	drm_encoder_cleanup(&dpsub->drm->encoder);
 	drm_kms_helper_poll_fini(drm);
-- 
2.43.0



