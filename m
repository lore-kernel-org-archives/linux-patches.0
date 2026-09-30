Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D02132D594F;
	Wed, 30 Sep 2026 18:37:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790793431; cv=none; b=Lx0NRs/t8vjLmE3DHXRPL5QW4+cRtLAeaOIvVUionMETOMDWKgfZH3fOdf0K7Lcvo4YxJ2JcOdsonqnalpCZzHGyOOhezjZ5vltweGE8HiSN9/dnIcf+lx8tNlx7h+VMS3syA+oUhcubSTQGr22plQNvNEtCh51mp5P/yJxH5YI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790793431; c=relaxed/simple;
	bh=W9a/YTS+zlAOAsdZ4Q/8cZrFQOFBnRPsK9Atr+dxPn4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IFHyaC0Qb0Ls3cdYWC+o2EZy9zC78ODMJfTk2o6yA18KeFyvoxBexrQW51tA2dUdcw0XObNBFYx/CHWUM2SCPQMCI/xYLOUY1M1v0VohMfDsfUc1/lNDwGp8dEhAp+/Pbl+841DEj3nzitASbDmMMWT1FkReLDGOj6LS7nIE1L8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MxQMq4x6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MxQMq4x6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0155E1F000FF;
	Wed, 30 Sep 2026 18:37:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790793429;
	bh=7kqAbMYQuHF9su06gr6382zIj9aAoIVkHegjJbChxgc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MxQMq4x6kKalU2ULZ7Q5URU/ZGLiaqRaudFv9brab2za23G1goy2025x/FdVRuyXR
	 iKLcYR2aBZRTRHzpFekMm3InYPYtU9ApSTSa49SHsI3EdUAYMevf8Ob12ICIRd3W0S
	 Wi5daJ0YuqjLQn3+ZdwPweubzpx+RfzPjAuq+yc0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Lyude Paul <lyude@redhat.com>
Subject: [PATCH 6.18 251/395] drm/nouveau: Fix runtime PM leak in nouveau_connector_detect()
Date: Wed, 30 Sep 2026 17:28:33 +0200
Message-ID: <20260930152346.097323899@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152340.591469096@linuxfoundation.org>
References: <20260930152340.591469096@linuxfoundation.org>
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

From: Wentao Liang <vulab@iscas.ac.cn>

commit 1e04611d3735543bd80a67d9d13dc13f503746fb upstream.

If nvif_outp_edid_get() fails, nouveau_connector_detect() returns
early without dropping the runtime PM reference taken at the start
of the function, keeping the device powered on until the next
successful detect.

Balance the reference on the error path like the other exit paths
do.

Fixes: 0cd7e0718139 ("drm/nouveau/disp: add output method to fetch edid")
Cc: stable@vger.kernel.org
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Reviewed-by: Lyude Paul <lyude@redhat.com>
Signed-off-by: Lyude Paul <lyude@redhat.com>
Link: https://patch.msgid.link/20260916180342.2090360-1-vulab@iscas.ac.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/nouveau/nouveau_connector.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/nouveau/nouveau_connector.c
+++ b/drivers/gpu/drm/nouveau/nouveau_connector.c
@@ -600,8 +600,11 @@ nouveau_connector_detect(struct drm_conn
 				new_edid = drm_get_edid(connector, nv_encoder->i2c);
 		} else {
 			ret = nvif_outp_edid_get(&nv_encoder->outp, (u8 **)&new_edid);
-			if (ret < 0)
+			if (ret < 0) {
+				pm_runtime_mark_last_busy(dev->dev);
+				pm_runtime_put_autosuspend(dev->dev);
 				return connector_status_disconnected;
+			}
 		}
 
 		nouveau_connector_set_edid(nv_connector, new_edid);


