Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12E65146A64;
	Thu, 11 Apr 2024 10:23:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712831008; cv=none; b=iBEd429r2Kw/DWEpORI007bPgNvmw3p33OTAAN7LFo8G+KUpZAMCcBZAELGCmrPZ60kJBSvp2pFaiLnTBn6A+I9T7w1Gh3QpOugG+7H6MRkAORwJ9sBhA+wmLRBJWrw9T0WCq9UQSrN+MJbeNre7JoBCANjJlCis0XvSeSuc70A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712831008; c=relaxed/simple;
	bh=LEerFEamXMJ+2uPbmrFMb/MlrCFlU/Y2ci8emdM3JrU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LZJIXBMfUodQzBB+FO2D+zmZGiVV+avi2EyzkidTHHAkv1myvKkdwv6U7m7/hxcgQY2jAp3YNALwjkp8/mHeVSHv2MvKF0ydmNHq+4YB9cf+Lp5cXV6srqwuncEOx1MYqW974K0LRh+6sm13zqvrYGuRSpfr32IeG4o3R9wht6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c+P4F+zU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c+P4F+zU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C4B2C433C7;
	Thu, 11 Apr 2024 10:23:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712831007;
	bh=LEerFEamXMJ+2uPbmrFMb/MlrCFlU/Y2ci8emdM3JrU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c+P4F+zUSGGnXsldOepO12mDDj8K//TL7onZ3Bbgo+G3YA0xTEWDbDbL0F9NkXR7A
	 r3/KZSTVM0V4Nly5vFmAzs2NITPymLb/k+p0oaPCgwJzAk3iHyQdkmUTmR0IFf7La3
	 1bmoZIA/j5mm32D8cGcEYPUU7G+JHgIXaXeuj5Ac=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Stevenson <dave.stevenson@raspberrypi.org>,
	Jacopo Mondi <jacopo@jmondi.org>,
	Nicolas Saenz Julienne <nsaenzjulienne@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 154/215] staging: mmal-vchiq: Allocate and free components as required
Date: Thu, 11 Apr 2024 11:56:03 +0200
Message-ID: <20240411095429.510834414@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095424.875421572@linuxfoundation.org>
References: <20240411095424.875421572@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Stevenson <dave.stevenson@raspberrypi.org>

[ Upstream commit 8c589e1794a31e9a381916b0280260ab601e4d6e ]

The existing code assumed that there would only ever be 4 components,
and never freed the entries once used.
Allow arbitrary creation and destruction of components.

Signed-off-by: Dave Stevenson <dave.stevenson@raspberrypi.org>
Signed-off-by: Jacopo Mondi <jacopo@jmondi.org>
Signed-off-by: Nicolas Saenz Julienne <nsaenzjulienne@suse.de>
Link: https://lore.kernel.org/r/20200623164235.29566-3-nsaenzjulienne@suse.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: f37e76abd614 ("staging: vc04_services: fix information leak in create_component()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../vc04_services/bcm2835-camera/mmal-vchiq.c | 29 ++++++++++++-------
 .../vc04_services/bcm2835-camera/mmal-vchiq.h |  1 +
 2 files changed, 20 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/vc04_services/bcm2835-camera/mmal-vchiq.c b/drivers/staging/vc04_services/bcm2835-camera/mmal-vchiq.c
index 1c180ead4a20b..9b47ba4d2d3cd 100644
--- a/drivers/staging/vc04_services/bcm2835-camera/mmal-vchiq.c
+++ b/drivers/staging/vc04_services/bcm2835-camera/mmal-vchiq.c
@@ -31,8 +31,11 @@
 #define USE_VCHIQ_ARM
 #include "interface/vchi/vchi.h"
 
-/* maximum number of components supported */
-#define VCHIQ_MMAL_MAX_COMPONENTS 4
+/*
+ * maximum number of components supported.
+ * This matches the maximum permitted by default on the VPU
+ */
+#define VCHIQ_MMAL_MAX_COMPONENTS 64
 
 /*#define FULL_MSG_DUMP 1*/
 
@@ -167,8 +170,6 @@ struct vchiq_mmal_instance {
 	/* protect accesses to context_map */
 	struct mutex context_map_lock;
 
-	/* component to use next */
-	int component_idx;
 	struct vchiq_mmal_component component[VCHIQ_MMAL_MAX_COMPONENTS];
 
 	/* ordered workqueue to process all bulk operations */
@@ -1616,18 +1617,24 @@ int vchiq_mmal_component_init(struct vchiq_mmal_instance *instance,
 {
 	int ret;
 	int idx;		/* port index */
-	struct vchiq_mmal_component *component;
+	struct vchiq_mmal_component *component = NULL;
 
 	if (mutex_lock_interruptible(&instance->vchiq_mutex))
 		return -EINTR;
 
-	if (instance->component_idx == VCHIQ_MMAL_MAX_COMPONENTS) {
+	for (idx = 0; idx < VCHIQ_MMAL_MAX_COMPONENTS; idx++) {
+		if (!instance->component[idx].in_use) {
+			component = &instance->component[idx];
+			component->in_use = 1;
+			break;
+		}
+	}
+
+	if (!component) {
 		ret = -EINVAL;	/* todo is this correct error? */
 		goto unlock;
 	}
 
-	component = &instance->component[instance->component_idx];
-
 	ret = create_component(instance, component, name);
 	if (ret < 0) {
 		pr_err("%s: failed to create component %d (Not enough GPU mem?)\n",
@@ -1678,8 +1685,6 @@ int vchiq_mmal_component_init(struct vchiq_mmal_instance *instance,
 			goto release_component;
 	}
 
-	instance->component_idx++;
-
 	*component_out = component;
 
 	mutex_unlock(&instance->vchiq_mutex);
@@ -1689,6 +1694,8 @@ int vchiq_mmal_component_init(struct vchiq_mmal_instance *instance,
 release_component:
 	destroy_component(instance, component);
 unlock:
+	if (component)
+		component->in_use = 0;
 	mutex_unlock(&instance->vchiq_mutex);
 
 	return ret;
@@ -1710,6 +1717,8 @@ int vchiq_mmal_component_finalise(struct vchiq_mmal_instance *instance,
 
 	ret = destroy_component(instance, component);
 
+	component->in_use = 0;
+
 	mutex_unlock(&instance->vchiq_mutex);
 
 	return ret;
diff --git a/drivers/staging/vc04_services/bcm2835-camera/mmal-vchiq.h b/drivers/staging/vc04_services/bcm2835-camera/mmal-vchiq.h
index 47897e81ec586..4e34728d87e53 100644
--- a/drivers/staging/vc04_services/bcm2835-camera/mmal-vchiq.h
+++ b/drivers/staging/vc04_services/bcm2835-camera/mmal-vchiq.h
@@ -82,6 +82,7 @@ struct vchiq_mmal_port {
 };
 
 struct vchiq_mmal_component {
+	u32 in_use:1;
 	u32 enabled:1;
 	u32 handle;  /* VideoCore handle for component */
 	u32 inputs;  /* Number of input ports */
-- 
2.43.0



