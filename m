Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0F0013AD0C;
	Thu, 11 Apr 2024 10:04:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712829858; cv=none; b=g6bCqWUuSehkpJ37kjzpp33Gike2OzAbCUMO+7z/sJHdQW0tlr69tG++a0akBEHuk9YNEIPsGsaknrqeSZoJMCoUW48YidHVbX+RR789hqOk8SLqYimCxzqtAEnPvYCQFXRtgxCbPQbjx1K0RSssU+rw24efhL2h/G9S3sOOjoA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712829858; c=relaxed/simple;
	bh=GHjKahdNjwIk5tV/x70p9xaPj5MvVu6ELFn1DojZyVA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tBPUg5yIIqqbdD4Aqfr+uJf5qQuIvYE/fW4oHFT87gOts7MVCb93qZ0u4mAQGi+CmjlE8VTBe31BK1dFyjR5JFN17LRr4T4Cbisbg7NtYqQQ054FiV0m1qircOkG1v7nyuk4VwKPDMHcb2ZCE39cZZ3tO3BW894g03bC4x1hC5o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v2TKkonr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v2TKkonr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4918DC43390;
	Thu, 11 Apr 2024 10:04:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712829858;
	bh=GHjKahdNjwIk5tV/x70p9xaPj5MvVu6ELFn1DojZyVA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v2TKkonrtxvRVa3VLnBrMjEB3v5RSXGeW/v8QkNxOq1Euotv5rPaP0KGbBUw5tZei
	 VaLpBDXhA2rHT0LeVYGszxRRcuCgIYdfKR2DxERge7jXWRC20hyXv2gNnQRE6MjBUy
	 rB0k3Uqr8XWYtS3YCSf5JLfbAywV8bZNNbqoX9zU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Stevenson <dave.stevenson@raspberrypi.org>,
	Jacopo Mondi <jacopo@jmondi.org>,
	Nicolas Saenz Julienne <nsaenzjulienne@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 130/175] staging: mmal-vchiq: Fix client_component for 64 bit kernel
Date: Thu, 11 Apr 2024 11:55:53 +0200
Message-ID: <20240411095423.478576061@linuxfoundation.org>
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

[ Upstream commit 22e64b486adc4785542f8002c3af4c895490f841 ]

The MMAL client_component field is used with the event
mechanism to allow the client to identify the component for
which the event is generated.
The field is only 32bits in size, therefore we can't use a
pointer to the component in a 64 bit kernel.

Component handles are already held in an array per VCHI
instance, so use the array index as the client_component handle
to avoid having to create a new IDR for this purpose.

Signed-off-by: Dave Stevenson <dave.stevenson@raspberrypi.org>
Signed-off-by: Jacopo Mondi <jacopo@jmondi.org>
Signed-off-by: Nicolas Saenz Julienne <nsaenzjulienne@suse.de>
Link: https://lore.kernel.org/r/20200629150945.10720-5-nsaenzjulienne@suse.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: f37e76abd614 ("staging: vc04_services: fix information leak in create_component()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/vc04_services/bcm2835-camera/mmal-vchiq.c | 8 +++++++-
 drivers/staging/vc04_services/bcm2835-camera/mmal-vchiq.h | 1 +
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/vc04_services/bcm2835-camera/mmal-vchiq.c b/drivers/staging/vc04_services/bcm2835-camera/mmal-vchiq.c
index 4f128c75c0f6c..2794df22224ad 100644
--- a/drivers/staging/vc04_services/bcm2835-camera/mmal-vchiq.c
+++ b/drivers/staging/vc04_services/bcm2835-camera/mmal-vchiq.c
@@ -920,7 +920,7 @@ static int create_component(struct vchiq_mmal_instance *instance,
 
 	/* build component create message */
 	m.h.type = MMAL_MSG_TYPE_COMPONENT_CREATE;
-	m.u.component_create.client_component = (u32)(unsigned long)component;
+	m.u.component_create.client_component = component->client_component;
 	strncpy(m.u.component_create.name, name,
 		sizeof(m.u.component_create.name));
 
@@ -1626,6 +1626,12 @@ int vchiq_mmal_component_init(struct vchiq_mmal_instance *instance,
 		goto unlock;
 	}
 
+	/* We need a handle to reference back to our component structure.
+	 * Use the array index in instance->component rather than rolling
+	 * another IDR.
+	 */
+	component->client_component = idx;
+
 	ret = create_component(instance, component, name);
 	if (ret < 0)
 		goto unlock;
diff --git a/drivers/staging/vc04_services/bcm2835-camera/mmal-vchiq.h b/drivers/staging/vc04_services/bcm2835-camera/mmal-vchiq.h
index ee5eb6d4d080d..d20d5182577d6 100644
--- a/drivers/staging/vc04_services/bcm2835-camera/mmal-vchiq.h
+++ b/drivers/staging/vc04_services/bcm2835-camera/mmal-vchiq.h
@@ -91,6 +91,7 @@ struct vchiq_mmal_component {
 	struct vchiq_mmal_port input[MAX_PORT_COUNT]; /* input ports */
 	struct vchiq_mmal_port output[MAX_PORT_COUNT]; /* output ports */
 	struct vchiq_mmal_port clock[MAX_PORT_COUNT]; /* clock ports */
+	u32 client_component;	/* Used to ref back to client struct */
 };
 
 int vchiq_mmal_init(struct vchiq_mmal_instance **out_instance);
-- 
2.43.0



