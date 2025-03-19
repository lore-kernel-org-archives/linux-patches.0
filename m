Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B76791DF258;
	Wed, 19 Mar 2025 14:41:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742395272; cv=none; b=srPCpc3fcOm2kiVBsJvqQzt8CJUifWRIgw/mM6E7X8zSkW8KD68U2jCQ5TWSxI3P9IqZjLE2k1F0oQEFGzkELLVurBds6HBOtuh3X5V3Vog2JJTF9SJPEh3tZgnFbysy8fBFB3W6Oahoa4CXEtoL2rqLCA3eNlvaixJrrp0RPtg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742395272; c=relaxed/simple;
	bh=K7r8tFroOS4xG336iIuEwdTIa9jRtg7p2A2pHiqEd4k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pCnvObfOlNItGasII7ey4OCjPoY7jBUut1FPlZsQnGvkiK5LctoomFZYsA6pmXUd//gEHjVlLqHZiQEAgt0S+GMR0NhdSlqkyr/+dRAheB6B/LFWWajtWH6ZN1Sm9CA/d2PY3w5/+m3tya7TKgQnQFAPDuKVDqIbuEwWvEyCpP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n6m80fNP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n6m80fNP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BF94C4CEE4;
	Wed, 19 Mar 2025 14:41:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742395272;
	bh=K7r8tFroOS4xG336iIuEwdTIa9jRtg7p2A2pHiqEd4k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n6m80fNPtDkSI5ZzILb+phXX24mI0dCTKkLI9j/utzgA74KjH/s/zKrUh1GLiYk23
	 icNNFgVVziFvG7PmeQ+wC/uOrt0+0RLdJYUU8wywqSxRB66hP5FKNOI1c4l5w606xz
	 UXn6O4x+oHm7nGoOYR2ahTBcAv2rA9TR410nKf50=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Harry Wentland <harry.wentland@amd.com>,
	Leo Li <sunpeng.li@amd.com>,
	Tom Chung <chiahsuan.chung@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>
Subject: [PATCH 6.6 123/166] drm/amd/display: Disable unneeded hpd interrupts during dm_init
Date: Wed, 19 Mar 2025 07:31:34 -0700
Message-ID: <20250319143023.346326455@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143019.983527953@linuxfoundation.org>
References: <20250319143019.983527953@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Leo Li <sunpeng.li@amd.com>

commit 40b8c14936bd2726354c856251f6baed9869e760 upstream.

[Why]

It seems HPD interrupts are enabled by default for all connectors, even
if the hpd source isn't valid. An eDP for example, does not have a valid
hpd source (but does have a valid hpdrx source; see construct_phy()).
Thus, eDPs should have their hpd interrupt disabled.

In the past, this wasn't really an issue. Although the driver gets
interrupted, then acks by writing to hw registers, there weren't any
subscribed handlers that did anything meaningful (see
register_hpd_handlers()).

But things changed with the introduction of IPS. s2idle requires that
the driver allows IPS for DMUB fw to put hw to sleep. Since register
access requires hw to be awake, the driver will block IPS entry to do
so. And no IPS means no hw sleep during s2idle.

This was the observation on DCN35 systems with an eDP. During suspend,
the eDP toggled its hpd pin as part of the panel power down sequence.
The driver was then interrupted, and acked by writing to registers,
blocking IPS entry.

[How]

Since DC marks eDP connections as having invalid hpd sources (see
construct_phy()), DM should disable them at the hw level. Do so in
amdgpu_dm_hpd_init() by disabling all hpd ints first, then selectively
enabling ones for connectors that have valid hpd sources.

Cc: Mario Limonciello <mario.limonciello@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Reviewed-by: Harry Wentland <harry.wentland@amd.com>
Signed-off-by: Leo Li <sunpeng.li@amd.com>
Signed-off-by: Tom Chung <chiahsuan.chung@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 7b1ba19eb15f88e70782642ce2d934211269337b)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_irq.c |   64 ++++++++++++------
 1 file changed, 45 insertions(+), 19 deletions(-)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_irq.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_irq.c
@@ -891,8 +891,16 @@ void amdgpu_dm_hpd_init(struct amdgpu_de
 	struct drm_device *dev = adev_to_drm(adev);
 	struct drm_connector *connector;
 	struct drm_connector_list_iter iter;
+	int irq_type;
 	int i;
 
+	/* First, clear all hpd and hpdrx interrupts */
+	for (i = DC_IRQ_SOURCE_HPD1; i <= DC_IRQ_SOURCE_HPD6RX; i++) {
+		if (!dc_interrupt_set(adev->dm.dc, i, false))
+			drm_err(dev, "Failed to clear hpd(rx) source=%d on init\n",
+				i);
+	}
+
 	drm_connector_list_iter_begin(dev, &iter);
 	drm_for_each_connector_iter(connector, &iter) {
 		struct amdgpu_dm_connector *amdgpu_dm_connector =
@@ -900,10 +908,31 @@ void amdgpu_dm_hpd_init(struct amdgpu_de
 
 		const struct dc_link *dc_link = amdgpu_dm_connector->dc_link;
 
+		/*
+		 * Get a base driver irq reference for hpd ints for the lifetime
+		 * of dm. Note that only hpd interrupt types are registered with
+		 * base driver; hpd_rx types aren't. IOW, amdgpu_irq_get/put on
+		 * hpd_rx isn't available. DM currently controls hpd_rx
+		 * explicitly with dc_interrupt_set()
+		 */
 		if (dc_link->irq_source_hpd != DC_IRQ_SOURCE_INVALID) {
-			dc_interrupt_set(adev->dm.dc,
-					dc_link->irq_source_hpd,
-					true);
+			irq_type = dc_link->irq_source_hpd - DC_IRQ_SOURCE_HPD1;
+			/*
+			 * TODO: There's a mismatch between mode_info.num_hpd
+			 * and what bios reports as the # of connectors with hpd
+			 * sources. Since the # of hpd source types registered
+			 * with base driver == mode_info.num_hpd, we have to
+			 * fallback to dc_interrupt_set for the remaining types.
+			 */
+			if (irq_type < adev->mode_info.num_hpd) {
+				if (amdgpu_irq_get(adev, &adev->hpd_irq, irq_type))
+					drm_err(dev, "DM_IRQ: Failed get HPD for source=%d)!\n",
+						dc_link->irq_source_hpd);
+			} else {
+				dc_interrupt_set(adev->dm.dc,
+						 dc_link->irq_source_hpd,
+						 true);
+			}
 		}
 
 		if (dc_link->irq_source_hpd_rx != DC_IRQ_SOURCE_INVALID) {
@@ -913,12 +942,6 @@ void amdgpu_dm_hpd_init(struct amdgpu_de
 		}
 	}
 	drm_connector_list_iter_end(&iter);
-
-	/* Update reference counts for HPDs */
-	for (i = DC_IRQ_SOURCE_HPD1; i <= adev->mode_info.num_hpd; i++) {
-		if (amdgpu_irq_get(adev, &adev->hpd_irq, i - DC_IRQ_SOURCE_HPD1))
-			drm_err(dev, "DM_IRQ: Failed get HPD for source=%d)!\n", i);
-	}
 }
 
 /**
@@ -934,7 +957,7 @@ void amdgpu_dm_hpd_fini(struct amdgpu_de
 	struct drm_device *dev = adev_to_drm(adev);
 	struct drm_connector *connector;
 	struct drm_connector_list_iter iter;
-	int i;
+	int irq_type;
 
 	drm_connector_list_iter_begin(dev, &iter);
 	drm_for_each_connector_iter(connector, &iter) {
@@ -943,9 +966,18 @@ void amdgpu_dm_hpd_fini(struct amdgpu_de
 		const struct dc_link *dc_link = amdgpu_dm_connector->dc_link;
 
 		if (dc_link->irq_source_hpd != DC_IRQ_SOURCE_INVALID) {
-			dc_interrupt_set(adev->dm.dc,
-					dc_link->irq_source_hpd,
-					false);
+			irq_type = dc_link->irq_source_hpd - DC_IRQ_SOURCE_HPD1;
+
+			/* TODO: See same TODO in amdgpu_dm_hpd_init() */
+			if (irq_type < adev->mode_info.num_hpd) {
+				if (amdgpu_irq_put(adev, &adev->hpd_irq, irq_type))
+					drm_err(dev, "DM_IRQ: Failed put HPD for source=%d!\n",
+						dc_link->irq_source_hpd);
+			} else {
+				dc_interrupt_set(adev->dm.dc,
+						 dc_link->irq_source_hpd,
+						 false);
+			}
 		}
 
 		if (dc_link->irq_source_hpd_rx != DC_IRQ_SOURCE_INVALID) {
@@ -955,10 +987,4 @@ void amdgpu_dm_hpd_fini(struct amdgpu_de
 		}
 	}
 	drm_connector_list_iter_end(&iter);
-
-	/* Update reference counts for HPDs */
-	for (i = DC_IRQ_SOURCE_HPD1; i <= adev->mode_info.num_hpd; i++) {
-		if (amdgpu_irq_put(adev, &adev->hpd_irq, i - DC_IRQ_SOURCE_HPD1))
-			drm_err(dev, "DM_IRQ: Failed put HPD for source=%d!\n", i);
-	}
 }


