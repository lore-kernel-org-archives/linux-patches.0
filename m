Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C33551448F3;
	Thu, 11 Apr 2024 10:06:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712829971; cv=none; b=u/uq7MkJr/kCpgyRc00LwKICugHnWH6eJPuUkrftDclT2+lRJbSY8ZnFMU551u/SLdCyp89kkUmkLyld7Mi/LmzusIXG9x5Xeo51OXUdD1Z+XQePVji+24SNQlkNHS/FULm6jiVcXsNhjSj6feD+BSnvPFETgDACtRZ/nT7W0N4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712829971; c=relaxed/simple;
	bh=Ey7Qbbr7U2j72en2S5n/9slBerJ7Zl4w5ZrM4V6G4h8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gvk/USjBXiqE/aisIpqKTtJdgolkPmLI/Tc7sa0WNwVjvJcZC3JAanosvk+xoqygwQE51YtQrMRVhpoFjalGdUt3Y7xAB8kUYXqLbpL9LY+IIfUVAZZ31JXEHea9t9FK/zsQg9f+xKfSv2pdNhI8w1q5YCHkcJt20LBlIHo48xk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ws1tQHrs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ws1tQHrs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12BABC433C7;
	Thu, 11 Apr 2024 10:06:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712829971;
	bh=Ey7Qbbr7U2j72en2S5n/9slBerJ7Zl4w5ZrM4V6G4h8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ws1tQHrsuGHowtj/HpZYLHtQR/L3NyiqpvQFF1L+qYSweav2pow/s+hLTFWUfQ6D0
	 pxV4aoMplBO52w5UwFHbGuL/vQZ7iDBXRvpZNv+DaR49ADdkUKvFmPL62sGQXyz++C
	 8oLMlxrCmvRZokbKHVUKKfxIrbkLAUEdJzMjmfzw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Stevenson <dave.stevenson@raspberrypi.org>,
	Jacopo Mondi <jacopo@jmondi.org>,
	Nicolas Saenz Julienne <nsaenzjulienne@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 129/175] staging: mmal-vchiq: Allocate and free components as required
Date: Thu, 11 Apr 2024 11:55:52 +0200
Message-ID: <20240411095423.448851609@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095419.532012976@linuxfoundation.org>
References: <20240411095419.532012976@linuxfoundation.org>
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
index 00c943516ba38..4f128c75c0f6c 100644
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
 
@@ -165,8 +168,6 @@ struct vchiq_mmal_instance {
 	/* protect accesses to context_map */
 	struct mutex context_map_lock;
 
-	/* component to use next */
-	int component_idx;
 	struct vchiq_mmal_component component[VCHIQ_MMAL_MAX_COMPONENTS];
 };
 
@@ -1607,18 +1608,24 @@ int vchiq_mmal_component_init(struct vchiq_mmal_instance *instance,
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
 	if (ret < 0)
 		goto unlock;
@@ -1666,8 +1673,6 @@ int vchiq_mmal_component_init(struct vchiq_mmal_instance *instance,
 			goto release_component;
 	}
 
-	instance->component_idx++;
-
 	*component_out = component;
 
 	mutex_unlock(&instance->vchiq_mutex);
@@ -1677,6 +1682,8 @@ int vchiq_mmal_component_init(struct vchiq_mmal_instance *instance,
 release_component:
 	destroy_component(instance, component);
 unlock:
+	if (component)
+		component->in_use = 0;
 	mutex_unlock(&instance->vchiq_mutex);
 
 	return ret;
@@ -1698,6 +1705,8 @@ int vchiq_mmal_component_finalise(struct vchiq_mmal_instance *instance,
 
 	ret = destroy_component(instance, component);
 
+	component->in_use = 0;
+
 	mutex_unlock(&instance->vchiq_mutex);
 
 	return ret;
diff --git a/drivers/staging/vc04_services/bcm2835-camera/mmal-vchiq.h b/drivers/staging/vc04_services/bcm2835-camera/mmal-vchiq.h
index b3c231e619c90..ee5eb6d4d080d 100644
--- a/drivers/staging/vc04_services/bcm2835-camera/mmal-vchiq.h
+++ b/drivers/staging/vc04_services/bcm2835-camera/mmal-vchiq.h
@@ -81,6 +81,7 @@ struct vchiq_mmal_port {
 };
 
 struct vchiq_mmal_component {
+	u32 in_use:1;
 	u32 enabled:1;
 	u32 handle;  /* VideoCore handle for component */
 	u32 inputs;  /* Number of input ports */
-- 
2.43.0



