Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B65F3E00A8;
	Fri, 15 May 2026 16:17:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778861842; cv=none; b=oofiFcMnvuKtQzQk+Kn51RBhYXFqgEmzXwQRxRKBwUNinVTOVEOloUqRwmDNkiUm09WJPU955i/RiDULx+EQutTQY698K7EwVJgAAsIJgFEMoZQjalNOXZstArI2Scr9PR3JWZ3SIP9uYCgv2sd9JZ7secy1R8UNvkeNVPigoKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778861842; c=relaxed/simple;
	bh=OYooqRXL2cuhs9pMDRd2APjMv3Gbn1laYxWyCo4PQOI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g9bWbGx9M/fNRsmJXXZabJxpK2oExCdk79jZqMy/AvvriUgPffd0pnTEbkv+Qd5EfO6N3oHZbpwQYn5th+exYOlUIkmzd9iDt4QDxUHkT93lcU3bgBouYUckoDUz27kSbNq5m06ah8v9HnPkz0uDb9Hk5a0WW9hz5ROz1qfLemk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qf1jnVxO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qf1jnVxO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 206F5C2BCB0;
	Fri, 15 May 2026 16:17:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778861842;
	bh=OYooqRXL2cuhs9pMDRd2APjMv3Gbn1laYxWyCo4PQOI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qf1jnVxOOJvBikB2t/VHTCyOMysUMoph7kF2DWuWZDNRENNrGnJ89sMFzd78z2DsJ
	 koy30mGYvZTGfhE/fPwiFv1G/XymZVWbST6JR65AIAbCNiBI6xCbzKLD94VFuIsVx0
	 41bMsN2+BYEaFFlIG96Ewg7gtilC49cAzdVHj9II=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tomi Valkeinen <tomi.valkeinen+renesas@ideasonboard.com>,
	Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
	Jacopo Mondi <jacopo.mondi@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.18 010/188] media: renesas: vsp1: Fix NULL pointer deref on module unload
Date: Fri, 15 May 2026 17:47:07 +0200
Message-ID: <20260515154657.532956092@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154657.309489048@linuxfoundation.org>
References: <20260515154657.309489048@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tomi Valkeinen <tomi.valkeinen+renesas@ideasonboard.com>

commit 58b1e9664d8f74d55d8411cc7a7b275a76a6f24f upstream.

When unloading the module on gen 4, we hit a NULL pointer dereference.
This is caused by the cleanup code calling vsp1_drm_cleanup() where it
should be calling vsp1_vspx_cleanup().

Fix this by checking the IP version and calling the drm or vspx function
accordingly, the same way as the init code does.

Fixes: d06c1a9f348d ("media: vsp1: Add VSPX support")
Cc: stable@vger.kernel.org
Signed-off-by: Tomi Valkeinen <tomi.valkeinen+renesas@ideasonboard.com>
Reviewed-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Reviewed-by: Jacopo Mondi <jacopo.mondi@ideasonboard.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/renesas/vsp1/vsp1_drv.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/renesas/vsp1/vsp1_drv.c b/drivers/media/platform/renesas/vsp1/vsp1_drv.c
index 2de515c497eb..627b5046fa80 100644
--- a/drivers/media/platform/renesas/vsp1/vsp1_drv.c
+++ b/drivers/media/platform/renesas/vsp1/vsp1_drv.c
@@ -240,8 +240,12 @@ static void vsp1_destroy_entities(struct vsp1_device *vsp1)
 		media_device_unregister(&vsp1->media_dev);
 	media_device_cleanup(&vsp1->media_dev);
 
-	if (!vsp1->info->uapi)
-		vsp1_drm_cleanup(vsp1);
+	if (!vsp1->info->uapi) {
+		if (vsp1->info->version == VI6_IP_VERSION_MODEL_VSPX_GEN4)
+			vsp1_vspx_cleanup(vsp1);
+		else
+			vsp1_drm_cleanup(vsp1);
+	}
 }
 
 static int vsp1_create_entities(struct vsp1_device *vsp1)
-- 
2.54.0



