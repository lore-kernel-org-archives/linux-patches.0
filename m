Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F6F251A73A;
	Wed, 30 Sep 2026 17:31:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790789486; cv=none; b=Q5uooD68rV+f/XBmV5rEn+dK7CH7FvzqIjF1z84hWePXcdni0f+eDrqeygg0I6PpgVqhncvWGCdflxXdFtq0LplrrJ8SPWdlE6LxP9dEsX+1afNmQm09SvtnqakO8Si+H0nNcX+d5onKcW5xMSyOc8Easw1G9tNPVS1Q1zEPPEA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790789486; c=relaxed/simple;
	bh=LozJN8CMquwLNJ3F0ehJUYe/5UQSuWf0qUj7DcZ9VG0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PT9v2HwXx2AqJ42D8QnMQDgDKXgw2XXAg524vBTeNM733MaQmyWLw1oVsEyeugQYr4dkFe9g845TGOYRGBkXtzJtOFQirolKNRyQKBihRRV5Ls2NSLNEdBSUNvzFZQ83czOrmO4vdhYmZxw6085C+mEQqppYVocl6WGOQWYrlas=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ioDye+Lk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ioDye+Lk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CED31F000FF;
	Wed, 30 Sep 2026 17:31:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790789485;
	bh=WU8N5Sh1PCBCnM6cais8BniYwltIOxFsvmOozXNgeBc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ioDye+LkX2SGVEcBzOOrQayKHoZYmrqC03uh5cPKsUJS3P9tVBImDFwtXIRBLcoiA
	 2fAK2pFxYLYX1ewQbZVZWCrRGtV0Lt+ZhPTGiTg6NmLS5WXBLruqPijJQ3xfaoGuFm
	 xPajJHAicDrrtDd39G1J5qmKOkkMOAniCHRONEe0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Lyude Paul <lyude@redhat.com>
Subject: [PATCH 6.12 492/877] drm/nouveau: Fix runtime PM leak in nouveau_connector_detect()
Date: Wed, 30 Sep 2026 17:23:23 +0200
Message-ID: <20260930152425.278430421@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -601,8 +601,11 @@ nouveau_connector_detect(struct drm_conn
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


