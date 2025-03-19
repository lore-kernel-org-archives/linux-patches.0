Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E09F71DDC2B;
	Wed, 19 Mar 2025 14:35:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742394957; cv=none; b=ua45u5CE7URd7qkHza+Ri7Y7wc2vqQS22lxhVmB3XtHU7qI4PoO0k/h3OrDrx3txpEWlCImyOR6PpJ9X3F2DIba8M2atpy+YhI3eiCPYgUt2arRxvVLeKHHpYYX1X8PpkGBPARPtXRRV9tqmRsxiW2k8qlLlrUbrpUvhs9+6JeU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742394957; c=relaxed/simple;
	bh=BBvVMF9jPCLk8X6Il9TV86QY/tqJYRjBbK0c6EdXpGM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ME+NVZLaW5C1dF7ulbnAU6Rqq+7t33UyBuN8P+C1Znre5Zn8tCv6zNB41d6ALktxfq+9UfdDP4tqy/SIl7JKcCVp7x5JI8iYH4akwaHmP9zMDuKty2N9eyComI4wrXHvkQv728IsScdNRCKq6RkPIdd1NN0MXfwRk7HH2mvlDPg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z59Iwv5X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z59Iwv5X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6AD2C4CEE4;
	Wed, 19 Mar 2025 14:35:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742394956;
	bh=BBvVMF9jPCLk8X6Il9TV86QY/tqJYRjBbK0c6EdXpGM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z59Iwv5X51QHHVGwTzAHiDh2LWyxdCY3Ujp2i8nur3l/M9RsJRkbuKGVLL8aT9w7M
	 MYCWPOnRE++PezcopmQaL99LTGtBkYdgcsU+uFG1iF++JldRWqWsJqABsQxFj0Xi/f
	 ESvYQINpluSCvrNCCPs8B6d+fXb4hr0r+szXNtrU=
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
Subject: [PATCH 6.13 183/241] drm/amd/display: Disable unneeded hpd interrupts during dm_init
Date: Wed, 19 Mar 2025 07:30:53 -0700
Message-ID: <20250319143032.254116936@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143027.685727358@linuxfoundation.org>
References: <20250319143027.685727358@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
@@ -894,8 +894,16 @@ void amdgpu_dm_hpd_init(struct amdgpu_de
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
 		struct amdgpu_dm_connector *amdgpu_dm_connector;
@@ -908,10 +916,31 @@ void amdgpu_dm_hpd_init(struct amdgpu_de
 
 		dc_link = amdgpu_dm_connector->dc_link;
 
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
@@ -921,12 +950,6 @@ void amdgpu_dm_hpd_init(struct amdgpu_de
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
@@ -942,7 +965,7 @@ void amdgpu_dm_hpd_fini(struct amdgpu_de
 	struct drm_device *dev = adev_to_drm(adev);
 	struct drm_connector *connector;
 	struct drm_connector_list_iter iter;
-	int i;
+	int irq_type;
 
 	drm_connector_list_iter_begin(dev, &iter);
 	drm_for_each_connector_iter(connector, &iter) {
@@ -956,9 +979,18 @@ void amdgpu_dm_hpd_fini(struct amdgpu_de
 		dc_link = amdgpu_dm_connector->dc_link;
 
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
@@ -968,10 +1000,4 @@ void amdgpu_dm_hpd_fini(struct amdgpu_de
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


