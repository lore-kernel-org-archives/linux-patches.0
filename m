Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35447134C1
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 10:50:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB384C433C8;
	Tue, 25 Jul 2023 10:50:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690282208;
	bh=SIdMNdHwOykpvJw2UBDj+eDuA1AZO7AuF6tLVh2vUiY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N7ogXODkN3ybdm7MpbIWYHOiEaSTGmimgYi2xw/7++vT/6MH5IIjGtliySZvUNKY6
	 qfy0UDIqfuTaHZq+hbGywY9e9/aDATmL6KV0ZUb5mCU8k88/CxwnkXR/bIaR5FCYY7
	 j50/JcZjRdAJ9UG35QpQBvsQdGYClosmO9nPtJgY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ben Skeggs <bskeggs@redhat.com>,
	Karol Herbst <kherbst@redhat.com>
Subject: [PATCH 6.4 047/227] drm/nouveau/disp: PIOR DP uses GPIO for HPD, not PMGR AUX interrupts
Date: Tue, 25 Jul 2023 12:43:34 +0200
Message-ID: <20230725104516.749275114@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230725104514.821564989@linuxfoundation.org>
References: <20230725104514.821564989@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ben Skeggs <bskeggs@redhat.com>

commit 2b5d1c29f6c4cb19369ef92881465e5ede75f4ef upstream.

Fixes crash on boards with ANX9805 TMDS/DP encoders.

Cc: stable@vger.kernel.org # 6.4+
Signed-off-by: Ben Skeggs <bskeggs@redhat.com>
Reviewed-by: Karol Herbst <kherbst@redhat.com>
Signed-off-by: Karol Herbst <kherbst@redhat.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20230719044051.6975-2-skeggsb@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/nouveau/nvkm/engine/disp/uconn.c |   29 +++++++++++++++--------
 1 file changed, 19 insertions(+), 10 deletions(-)

--- a/drivers/gpu/drm/nouveau/nvkm/engine/disp/uconn.c
+++ b/drivers/gpu/drm/nouveau/nvkm/engine/disp/uconn.c
@@ -81,20 +81,29 @@ nvkm_uconn_uevent(struct nvkm_object *ob
 		return -ENOSYS;
 
 	list_for_each_entry(outp, &conn->disp->outps, head) {
-		if (outp->info.connector == conn->index && outp->dp.aux) {
-			if (args->v0.types & NVIF_CONN_EVENT_V0_PLUG  ) bits |= NVKM_I2C_PLUG;
-			if (args->v0.types & NVIF_CONN_EVENT_V0_UNPLUG) bits |= NVKM_I2C_UNPLUG;
-			if (args->v0.types & NVIF_CONN_EVENT_V0_IRQ   ) bits |= NVKM_I2C_IRQ;
-
-			return nvkm_uevent_add(uevent, &device->i2c->event, outp->dp.aux->id, bits,
-					       nvkm_uconn_uevent_aux);
-		}
+		if (outp->info.connector == conn->index)
+			break;
+	}
+
+	if (&outp->head == &conn->disp->outps)
+		return -EINVAL;
+
+	if (outp->dp.aux && !outp->info.location) {
+		if (args->v0.types & NVIF_CONN_EVENT_V0_PLUG  ) bits |= NVKM_I2C_PLUG;
+		if (args->v0.types & NVIF_CONN_EVENT_V0_UNPLUG) bits |= NVKM_I2C_UNPLUG;
+		if (args->v0.types & NVIF_CONN_EVENT_V0_IRQ   ) bits |= NVKM_I2C_IRQ;
+
+		return nvkm_uevent_add(uevent, &device->i2c->event, outp->dp.aux->id, bits,
+				       nvkm_uconn_uevent_aux);
 	}
 
 	if (args->v0.types & NVIF_CONN_EVENT_V0_PLUG  ) bits |= NVKM_GPIO_HI;
 	if (args->v0.types & NVIF_CONN_EVENT_V0_UNPLUG) bits |= NVKM_GPIO_LO;
-	if (args->v0.types & NVIF_CONN_EVENT_V0_IRQ)
-		return -EINVAL;
+	if (args->v0.types & NVIF_CONN_EVENT_V0_IRQ) {
+		/* TODO: support DP IRQ on ANX9805 and remove this hack. */
+		if (!outp->info.location)
+			return -EINVAL;
+	}
 
 	return nvkm_uevent_add(uevent, &device->gpio->event, conn->info.hpd, bits,
 			       nvkm_uconn_uevent_gpio);


