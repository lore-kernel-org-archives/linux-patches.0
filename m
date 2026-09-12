Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81B063B5310;
	Sat, 12 Sep 2026 07:06:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789196805; cv=none; b=buez4nNmw9KDAQo3QwsM1jTRwvjHQGhWEJp2PUZyo8IFidhuwkbLACFkiqvT+gDgdNvanwf/yiVnaCDypqTPOUXiFywcI8ueWxcNMhmRx0BfEKzK3xcDBU7zhOl6voerb7Kk3jCqZirjdlI1kzg4p+qr6Y2OVBrcH/skYqa5WgA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789196805; c=relaxed/simple;
	bh=4rr3WX9vJGPcOO3wI6MmJPLeujFuOWTbZWipRYXb240=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bDM+yhER2+49EvmbJ0Bd+LaVBJxxOvMVycsw44ngLQyelNexlfKa4WcYn/MvVtve04uEvh5JdKkhS6dq7Jl+/0Ln+hizhH0BkPe4m7/Xr3935SnNy8Uyx0jHDRmUoOJ8niyBOc9X/IAQRpd1msG0uycWLcQG/KaNXgEl6ag7reM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ov58BIuY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ov58BIuY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E1CA1F00899;
	Sat, 12 Sep 2026 07:06:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789196802;
	bh=z2EjB3Ae9zV+mDLzhNCnz6mHlaBPI3aiOKrD5i0HPMo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ov58BIuYTO0fJududGSoI4y1xllYF8LCtC8nmHHtRDY2FGLFjolbER2idkU9kaAR/
	 AY7W9bfAzyfTnEp16jygSC67u34nlwyxrOB/sKPV4TRz+fWBo7X/A6y8u3aSJLV8/H
	 DMA35RTScnHIoMw8stEznKKxNiZh71imUkHhJa5s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Yan <andy.yan@rock-chips.com>,
	Cristian Ciocaltea <cristian.ciocaltea@collabora.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0039/1815] drm/bridge: synopsys: dw-dp: Support unregistering the AUX channel
Date: Sat, 12 Sep 2026 08:29:49 +0200
Message-ID: <20260912065649.939700194@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cristian Ciocaltea <cristian.ciocaltea@collabora.com>

[ Upstream commit ed04e8e2307f35b3d8d49a554faf5e72d3d224e6 ]

The DisplayPort AUX channel gets initialized and registered during
dw_dp_bind(), but it is never unregistered, which may lead to resource
leaks and/or use-after-free.

Add the missing dw_dp_unbind() function to allow the users of the
library to handle the required cleanup, i.e. unregister the AUX adapter.

Fixes: 86eecc3a9c2e ("drm/bridge: synopsys: Add DW DPTX Controller support library")
Reviewed-by: Andy Yan <andy.yan@rock-chips.com>
Signed-off-by: Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Link: https://patch.msgid.link/20260601-drm-rk-fixes-v4-1-c3f3f123e1da@collabora.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/synopsys/dw-dp.c | 6 ++++++
 include/drm/bridge/dw_dp.h              | 1 +
 2 files changed, 7 insertions(+)

diff --git a/drivers/gpu/drm/bridge/synopsys/dw-dp.c b/drivers/gpu/drm/bridge/synopsys/dw-dp.c
index 21541be094c47..36ee6e027af52 100644
--- a/drivers/gpu/drm/bridge/synopsys/dw-dp.c
+++ b/drivers/gpu/drm/bridge/synopsys/dw-dp.c
@@ -2093,6 +2093,12 @@ struct dw_dp *dw_dp_bind(struct device *dev, struct drm_encoder *encoder,
 }
 EXPORT_SYMBOL_GPL(dw_dp_bind);
 
+void dw_dp_unbind(struct dw_dp *dp)
+{
+	drm_dp_aux_unregister(&dp->aux);
+}
+EXPORT_SYMBOL_GPL(dw_dp_unbind);
+
 MODULE_AUTHOR("Andy Yan <andyshrk@163.com>");
 MODULE_DESCRIPTION("DW DP Core Library");
 MODULE_LICENSE("GPL");
diff --git a/include/drm/bridge/dw_dp.h b/include/drm/bridge/dw_dp.h
index 25363541e69d5..22105c3e8e4d6 100644
--- a/include/drm/bridge/dw_dp.h
+++ b/include/drm/bridge/dw_dp.h
@@ -24,4 +24,5 @@ struct dw_dp_plat_data {
 
 struct dw_dp *dw_dp_bind(struct device *dev, struct drm_encoder *encoder,
 			 const struct dw_dp_plat_data *plat_data);
+void dw_dp_unbind(struct dw_dp *dp);
 #endif /* __DW_DP__ */
-- 
2.53.0



