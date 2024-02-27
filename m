Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9577854FA5;
	Tue, 27 Feb 2024 13:36:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709040991; cv=none; b=eYBsgVKiZntCyJ5nedrTmdU15N2yTwtg73fC0+VYW7YNVtJm8hK6cXpugOhixnivfNEPJqZmAhYDAB5NFRMHkgcMcUsG/7uKVW5e8gUTcKVD4Xd5pW+9ui8JGHZne+RWtQLGLkNgi07zU8i/chnVZjOGLLK2kh5jEbESYx7b3+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709040991; c=relaxed/simple;
	bh=ZkaJ2UhqRUk4FCN2M+MkA6LB3g6p7W7oaKigC95Qr/w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WnnsNRr75NNLs1/8aH9w+hprCMuCRzmAZ16iVRiNg6XuAL9lAKlxU2A7usEfnEAqFSmlYEpRdKFMrucvabjuBVt299pDjrZJoD4/MeUDyzzTuPqMQnjpzdDqHIlrtpkkRbDFG+dN71qu6Vn/UzbAjFx7rHbBDEeHh6XSxHR8IY4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lFajpdpt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lFajpdpt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2220FC433F1;
	Tue, 27 Feb 2024 13:36:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709040991;
	bh=ZkaJ2UhqRUk4FCN2M+MkA6LB3g6p7W7oaKigC95Qr/w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lFajpdptdBksC6aKtTaBBURnYzCVXoKoyEqFu13iOpseKqUrlhZVeoMEy5XMzWAw3
	 5pwp04KuyPRxuZS/38i8AtbnPVqJjsn8YJxtSXN2ITHZ3qv4sCVlzzFNSm5AYJodlh
	 zY275Z/aT4Cc+Z7xATnQfGd/qiyIsuUGYTUw4A4o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aurabindo Pillai <aurabindo.pillai@amd.com>,
	Rodrigo Siqueira <rodrigo.siqueira@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Wayne Lin <wayne.lin@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.7 152/334] drm/amd/display: adjust few initialization order in dm
Date: Tue, 27 Feb 2024 14:20:10 +0100
Message-ID: <20240227131635.363480102@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131630.636392135@linuxfoundation.org>
References: <20240227131630.636392135@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wayne Lin <wayne.lin@amd.com>

commit 22e1dc4b2fec17af70f297a4295c5f19a0f3fbeb upstream.

[Why]
Observe error message "Can't retrieve aconnector in hpd_rx_irq_offload_work"
when boot up with a mst tbt4 dock connected. After analyzing, there are few
parts needed to be adjusted:

1. hpd_rx_offload_wq[].aconnector is not initialzed before the dmub outbox
hpd_irq handler get registered which causes the error message.

2. registeration of hpd and hpd_rx_irq event for usb4 dp tunneling is not
aligned with legacy interface sequence

[How]
Put DMUB_NOTIFICATION_HPD and DMUB_NOTIFICATION_HPD_IRQ handler
registration into register_hpd_handlers() to align other interfaces and
get hpd_rx_offload_wq[].aconnector initialized earlier than that.

Leave DMUB_NOTIFICATION_AUX_REPLY registered as it was since we need that
while calling dc_link_detect(). USB4 connection status will be proactively
detected by dc_link_detect_connection_type() in amdgpu_dm_initialize_drm_device()

Cc: Stable <stable@vger.kernel.org>
Reviewed-by: Aurabindo Pillai <aurabindo.pillai@amd.com>
Acked-by: Rodrigo Siqueira <rodrigo.siqueira@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Wayne Lin <wayne.lin@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c |   37 ++++++++++------------
 1 file changed, 18 insertions(+), 19 deletions(-)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -1810,21 +1810,12 @@ static int amdgpu_dm_init(struct amdgpu_
 			DRM_ERROR("amdgpu: fail to register dmub aux callback");
 			goto error;
 		}
-		if (!register_dmub_notify_callback(adev, DMUB_NOTIFICATION_HPD, dmub_hpd_callback, true)) {
-			DRM_ERROR("amdgpu: fail to register dmub hpd callback");
-			goto error;
-		}
-		if (!register_dmub_notify_callback(adev, DMUB_NOTIFICATION_HPD_IRQ, dmub_hpd_callback, true)) {
-			DRM_ERROR("amdgpu: fail to register dmub hpd callback");
-			goto error;
-		}
-	}
-
-	/* Enable outbox notification only after IRQ handlers are registered and DMUB is alive.
-	 * It is expected that DMUB will resend any pending notifications at this point, for
-	 * example HPD from DPIA.
-	 */
-	if (dc_is_dmub_outbox_supported(adev->dm.dc)) {
+		/* Enable outbox notification only after IRQ handlers are registered and DMUB is alive.
+		 * It is expected that DMUB will resend any pending notifications at this point. Note
+		 * that hpd and hpd_irq handler registration are deferred to register_hpd_handlers() to
+		 * align legacy interface initialization sequence. Connection status will be proactivly
+		 * detected once in the amdgpu_dm_initialize_drm_device.
+		 */
 		dc_enable_dmub_outbox(adev->dm.dc);
 
 		/* DPIA trace goes to dmesg logs only if outbox is enabled */
@@ -3494,6 +3485,14 @@ static void register_hpd_handlers(struct
 	int_params.requested_polarity = INTERRUPT_POLARITY_DEFAULT;
 	int_params.current_polarity = INTERRUPT_POLARITY_DEFAULT;
 
+	if (dc_is_dmub_outbox_supported(adev->dm.dc)) {
+		if (!register_dmub_notify_callback(adev, DMUB_NOTIFICATION_HPD, dmub_hpd_callback, true))
+			DRM_ERROR("amdgpu: fail to register dmub hpd callback");
+
+		if (!register_dmub_notify_callback(adev, DMUB_NOTIFICATION_HPD_IRQ, dmub_hpd_callback, true))
+			DRM_ERROR("amdgpu: fail to register dmub hpd callback");
+	}
+
 	list_for_each_entry(connector,
 			&dev->mode_config.connector_list, head)	{
 
@@ -3519,10 +3518,6 @@ static void register_hpd_handlers(struct
 					handle_hpd_rx_irq,
 					(void *) aconnector);
 		}
-
-		if (adev->dm.hpd_rx_offload_wq)
-			adev->dm.hpd_rx_offload_wq[connector->index].aconnector =
-				aconnector;
 	}
 }
 
@@ -4493,6 +4488,10 @@ static int amdgpu_dm_initialize_drm_devi
 
 		link = dc_get_link_at_index(dm->dc, i);
 
+		if (dm->hpd_rx_offload_wq)
+			dm->hpd_rx_offload_wq[aconnector->base.index].aconnector =
+				aconnector;
+
 		if (!dc_link_detect_connection_type(link, &new_connection_type))
 			DRM_ERROR("KMS: Failed to detect connector\n");
 


