Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585829;
	b=K43MXzA8Z16RJ3PRmgH7qAVccuKaZoCxERNa8UTiXmZ/WgHmxOKpptd/JtN10P1Gm8ir
	 B0UwAX5enfBv7mEH/ofW6WqGymaTeWLVAMtIHXV/zA+8VZFCNx+N43irmx3H1n+lV0Q0R
	 efjzxTns/CqwIl4U/oeF33B3uDB1o9R6Tz+eyOXFCutacDCOKnqhWcQQ0keQKLpGho2JX
	 Mc8i9yhW9kX+tuw5tjwUd8DVYH4bCVR394Skus7hOvHJNTOpSzyfWRPfiZdeQj5cYCuat
	 aayELRhZChMG5BSU+NVfng0pBAW6UaYYy7tzBLMackEckc+JYRk0vm/GK4atiO9gSXQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585829;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=c+gFPSyAYNJkYEgSvrOjlD7mzNV0HcJDaFQcNMGovhw=;
	b=Gk/RZHGHf5AA13WKpcvUIXrhFyVuB5Cvu2kYOafD9YGyExqmA0i3rl3XzsAbLgbZlX8Q
	 EcDOWjCPQIf1P2IFaU7HTizGniREdQhF9cbCqcEloRU0oySoI2VKf1J6awELD7xxJIh6X
	 +q8h+DwpZj+UaKi8cmDMfOrGRJHbubid55rl8IlN0672dAZGTbp+27uGB2D5xsO+nAc1p
	 eV4zRnFbH8WcFVLtbmXvoKKofEXwayoSoUpRw3o2VSLKxa7gC5lH2i5TJhHNzuO00sqds
	 Ll0jebUUeucvw9NcyzYxTr+E8Vnx13GwGMhber8LFx6ADXgOmP3Nv+/xADTMfcNZSNQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=i4t9S7ac;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45F0960A6F44;
	Fri, 13 Nov 2026 16:03:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=i4t9S7ac
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD27E1F000C4;
	Fri, 13 Nov 2026 16:03:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585828;
	bh=c+gFPSyAYNJkYEgSvrOjlD7mzNV0HcJDaFQcNMGovhw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=i4t9S7acNx43e2fK1SZw+rM6cJCmHcqqgkEjYlYSa2HE1f1dPGwkIli9MfCOYk89X
	 3HpdZUhuIDtVEifHeRTq8dC5CoQ3sTA3pziQfyNYPXL0Q7bBBShLmjO3icr5O2DN3D
	 8rkiVtfD1AaE2UmFkqabrsEcMERwzgrIZhSlRYso=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lucas Stach <l.stach@pengutronix.de>,
	Christian Gmeiner <cgmeiner@igalia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 407/507] drm/etnaviv: Fix NULL dereference on unbind without PPU flop reset
Date: Fri, 13 Nov 2026 10:51:51 -0500
Message-ID: <20261113153810.529089468@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Gmeiner <cgmeiner@igalia.com>

[ Upstream commit a0560a12d8c1a03e925c5d9be8479da75663a40f ]

flop_reset_data_ppu is only allocated on GPUs that need the PPU flop
reset. However, etnaviv_unbind(..) frees it unconditionally, and
etnaviv_cmdbuf_free(..) dereferences cmdbuf->suballoc before checking
whether cmdbuf is NULL.

As a result, unloading the driver on GPUs that do not need the PPU
flop reset causes a NULL pointer dereference at address 0.

Fixes: 85ba57ad88cf ("drm/etnaviv: Add PPU flop reset")
Cc: stable@vger.kernel.org
Reviewed-by: Lucas Stach <l.stach@pengutronix.de>
Link: https://patch.msgid.link/20261102-etnaviv-unbind-flop-fix-v1-1-588fd16f6768@igalia.com
Signed-off-by: Christian Gmeiner <cgmeiner@igalia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/etnaviv/etnaviv_drv.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/etnaviv/etnaviv_drv.c b/drivers/gpu/drm/etnaviv/etnaviv_drv.c
index 08aca9035fc1a..ec1352c1b09fa 100644
--- a/drivers/gpu/drm/etnaviv/etnaviv_drv.c
+++ b/drivers/gpu/drm/etnaviv/etnaviv_drv.c
@@ -601,8 +601,10 @@ static void etnaviv_unbind(struct device *dev)
 
 	component_unbind_all(dev, drm);
 
-	etnaviv_cmdbuf_free(priv->flop_reset_data_ppu);
-	kfree(priv->flop_reset_data_ppu);
+	if (priv->flop_reset_data_ppu) {
+		etnaviv_cmdbuf_free(priv->flop_reset_data_ppu);
+		kfree(priv->flop_reset_data_ppu);
+	}
 
 	etnaviv_cmdbuf_suballoc_destroy(priv->cmdbuf_suballoc);
 
-- 
2.53.0



