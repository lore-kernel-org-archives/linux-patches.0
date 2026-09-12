Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58B9A3542F8;
	Sat, 12 Sep 2026 09:41:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789206105; cv=none; b=tHlVS6cUbEjy7u/qz5WXQfb8x0jFNT3rbGQ7Cgwc914+BZO+8euPni0PEwbNac5p+HZw7lve9WJ6tBe1Baw42SnPTX2axZ0j9p3epCU/ByMsc/fv3QIuqbqw7vkbsfoECmzqiytg4/yqrhsBdioPkBkHUlJ8erV7OF+xmJN3cuI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789206105; c=relaxed/simple;
	bh=GwhnPXWTn7Br2lMGwXCQ0j9KEMUvm9bAYI+MboXeQPY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AacGY5LXC/BBbNjFvcsdSRywIXdxffRKRYzjBhfhlkHHZgwiizBGf/qrzUHUcBawm4qoPQMn8IkH9horP9KzAQW2da47KCj25CcbdfyjTynGhSE5BjXVVEaW2K0yQ3bXU4ltpe3nmMbmCmt9fCDEqySIKGnFqNYawHkXakaA/h4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ev5h6yz4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ev5h6yz4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2FF91F000FF;
	Sat, 12 Sep 2026 09:41:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789206104;
	bh=Exia+t5vJuhSM97TrsSCpKfI/tEghV2eJqYvdbatCv4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ev5h6yz4PlA/k+4oV+hHauO+WmVDy1HEovoZSThYVGkAbN1mYF+1MEtvPm7k2DwuO
	 SYJuJlrWq1JBryRjJAaJ2JFvPysDxyoTZpylTjLMHFnc2AuK8uRrOOanHZTaJV2i4P
	 3/eNdvornLwUkSDrYBtkUfABbCc496FHUTstKPoA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Yan <andy.yan@rock-chips.com>,
	Cristian Ciocaltea <cristian.ciocaltea@collabora.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0095/1518] drm/bridge: synopsys: dw-dp: Support unregistering the AUX channel
Date: Sat, 12 Sep 2026 08:37:44 +0200
Message-ID: <20260912065625.626066703@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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
index e82960163018a..70f64eb89998f 100644
--- a/drivers/gpu/drm/bridge/synopsys/dw-dp.c
+++ b/drivers/gpu/drm/bridge/synopsys/dw-dp.c
@@ -2098,6 +2098,12 @@ struct dw_dp *dw_dp_bind(struct device *dev, struct drm_encoder *encoder,
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
index d05df49fd8846..ab5c0a9b01aeb 100644
--- a/include/drm/bridge/dw_dp.h
+++ b/include/drm/bridge/dw_dp.h
@@ -17,4 +17,5 @@ struct dw_dp_plat_data {
 
 struct dw_dp *dw_dp_bind(struct device *dev, struct drm_encoder *encoder,
 			 const struct dw_dp_plat_data *plat_data);
+void dw_dp_unbind(struct dw_dp *dp);
 #endif /* __DW_DP__ */
-- 
2.53.0



