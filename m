Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624534;
	b=TQq1GUNkckMc5E5L9NhrFbeeiaNvS/muTInW0Qv1ztyicd5QGUWpLb6M3kTClel2OmuW
	 VUz9GzofHgFJEC9zqK82/HOHRPWdKAKf9JiPJbFQhpBl3+yRZKlSFgnQwavVw9hzem4rO
	 GyeZAIhiy6eTjpOie0SUDPD+IqloOxdaaKJSJIXL+7lpMBg9T0XvyeRmcqnldrHKAwTJ+
	 LMhKyyRGBvq6/oNS26/YmubJJ0yrTVv6vHkotyCwxaDC0ITw17V+Y9og6Ip59e4K3ktND
	 VsC6srjL3vaubNJlyEvhQbzu9oKtWfusxVPNqdKpOl4ec+vemZWbjGpycZRHKh3u4rA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624534;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+wiRpsml4fQqWmmGnvwV8CBycIG6sZoV51YOPxM02rI=;
	b=jfm+CgDA+3zb7+Fl3o3UroGxu5/RAjBGP76gyvx5xMm27oCZx6V0Jr0quwOjpqAc3au4
	 J9hhy8eznS1EJ9/mgq2vfY8N4B6Asjt4UD8DWRlX3cMaGC2x61hE8RnzoXKdUCwa+KMHa
	 unLxnhxZ03S0L3Itu6n4QjX5aDhHk7F7xayecQt167ZW1cTIQCDqygrASxcVnNfALQVmG
	 4VfE9eguzp/5x1+yArdwPg2V+19gJZppulueGf6FTC7fOuYjY8yU5EWDjImbEvhynC8es
	 mUrM1TSDbl4/zhapqzWTnD8xxlR51LuikCdbFfULRXrAllRTpYFEH0CKgOeioVGaOeg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rSgzm7+t;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F6B4606A33B;
	Wed, 25 Nov 2026 16:35:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rSgzm7+t
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A13791F000C0;
	Wed, 25 Nov 2026 16:35:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624534;
	bh=+wiRpsml4fQqWmmGnvwV8CBycIG6sZoV51YOPxM02rI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rSgzm7+tbXkL46s1qLE215JYpGcP5fVw5mI0sfccOytycoAFKbYnv+0P30U/IVdWF
	 ZxL4DcmIK0cBcQDvaRdZXjL4liMdJMdF7MkV5IZeX0EKXfojD+EKatEy2dN4ypDg6q
	 BF9siZYaxtpILogzMOQA1fmj4qy6em02udM+0gK0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Munique Feitoza <muniquefeitoz4@gmail.com>,
	Dave Airlie <airlied@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 222/816] drm/nouveau: Fix CE channel creation on pre-Kepler GPUs
Date: Wed, 25 Nov 2026 15:29:30 +0100
Message-ID: <20261125143854.344348407@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Munique Feitoza <muniquefeitoz4@gmail.com>

[ Upstream commit a2b7b707d75e605d31fb3d85a6b27f8bb2a01413 ]

Commit 04e0481526e3 ("nouveau/dmem: Fix privileged error in copy engine
channel") changed nouveau_accel_ce_init() to unconditionally request a
privileged channel (priv = true) when calling nouveau_channel_new().

However, privileged channels (func->ramfc->priv) are only supported on
Kepler (gk104_chan_ramfc) and newer FIFO implementations. On pre-Kepler
GPUs that expose a Copy Engine runlist, func->ramfc->priv is false,
which causes nvkm_chan_new_() to reject the channel creation with
-EINVAL:

  nouveau 0000:01:00.0: DRM: failed to create ce channel, -22

Only request a privileged CE channel when device->info.family >=
NV_DEVICE_INFO_V0_KEPLER.

Fixes: 04e0481526e3 ("nouveau/dmem: Fix privileged error in copy engine channel")
Signed-off-by: Munique Feitoza <muniquefeitoz4@gmail.com>
Reviewed-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Link: https://patch.msgid.link/20261030202809.28723-1-muniquefeitoz4@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/nouveau/nouveau_drm.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/nouveau/nouveau_drm.c b/drivers/gpu/drm/nouveau/nouveau_drm.c
index 904e236ed5104..38d01bd5f0c82 100644
--- a/drivers/gpu/drm/nouveau/nouveau_drm.c
+++ b/drivers/gpu/drm/nouveau/nouveau_drm.c
@@ -320,6 +320,7 @@ static void
 nouveau_accel_ce_init(struct nouveau_drm *drm)
 {
 	struct nvif_device *device = &drm->client.device;
+	bool priv;
 	u64 runm;
 	int ret = 0;
 
@@ -332,7 +333,11 @@ nouveau_accel_ce_init(struct nouveau_drm *drm)
 		return;
 	}
 
-	ret = nouveau_channel_new(&drm->client, true, runm, NvDmaFB, NvDmaTT, &drm->cechan);
+	/* priv copy engine only works on kepler and newer. */
+	priv = device->info.family >= NV_DEVICE_INFO_V0_KEPLER;
+
+	ret = nouveau_channel_new(&drm->client, priv, runm, NvDmaFB, NvDmaTT,
+				  &drm->cechan);
 	if (ret)
 		NV_ERROR(drm, "failed to create ce channel, %d\n", ret);
 }
-- 
2.53.0



