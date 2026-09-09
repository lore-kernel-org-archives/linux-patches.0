Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 975A7585977;
	Wed,  9 Sep 2026 14:31:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788964316; cv=none; b=gq5JhGuHtqYSUXgJsoEwHtCaurzSVZ5fVUiTOTES7EJSM7zbwamqjT3Gvn6npsM2i7PIK0sQw2axdQBFZKrSk7W4Mh2h9hClWVtoNsBNgvh2MD2tJM321DqDlXGzEgvvAX2L8XTm5perDGohXmpfvl1o3YgwDWqWHBIwUlsTa7w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788964316; c=relaxed/simple;
	bh=g4jqp+MZjYnotO9G+v8QgntI1oUnLjKqyVg1Xrt2wKw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kB0Pu3CeQ0lLfjb8iLIkGBZdLKWenTu1XNmMce5xOod9ncduBXTOpKo5MbIOlOmEQNuP09qgAeEnmy9aZlJ+KCiwjHHwu9fk5ZKwY/c1vHBQchwK4sSKFFPferLbqQNfkTAOvtKt5VssfsOkxds5AJE5hqYkstLE0ZvQ59U1Ahc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sdws2yv3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sdws2yv3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F37081F00A3D;
	Wed,  9 Sep 2026 14:31:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788964315;
	bh=T16laK8U1KRyKKhcT3lWIA/UZisGjIqWbpkISA4IrIU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sdws2yv3mPWEz4U04A0Mmm+qwNMIRJiIBNbbqplsFHyjadKfyhFHBg1reP1xrhei4
	 tGQE/Dak0za+7Oc+SgW607E+LvFUWundpuSgr31R9Tpor+TtawMxBroot1YEIK2n+Z
	 IgMFJ3flI1AhC/IvZXjORBbYDPNwyvK57Vbek+Yc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Yongbang Shi <shiyongbang@huawei.com>,
	Rongrong Zou <zourongrong@gmail.com>,
	Sean Paul <seanpaul@chromium.org>,
	Xinliang Liu <xinliang.liu@linaro.org>,
	Dmitry Baryshkov <lumag@kernel.org>,
	Baihan Li <libaihan@huawei.com>
Subject: [PATCH 6.18 381/583] drm/hibmc: Fix list of formats on the primary plane
Date: Wed,  9 Sep 2026 15:41:06 +0200
Message-ID: <20260909134251.208088619@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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

From: Thomas Zimmermann <tzimmermann@suse.de>

commit 0e682e136c466ae37c62f18099f591c096260ee0 upstream.

Remove all formats from the primary plane that are unsupported for
various reasons.

* Formats with alpha channel: planes should not announce alpha channels
unless they support transparency. There's no transparency support in
the primary plane's implementation.

* Formats with BGR order. The common format is in RGB channel order.
There's no BGR support in the primary plane's implementation.

* RGB888: atomic_update programs the format from cpp[0] * 8 / 16. For
RGB888's cpp value of 3 this returns 1.5; rounded to 1. Programming
the value of 1 to HIBMC_CRT_DISP_CTL_FORMAT sets up RGB565. Hence, the
output is distorted. This can be tested by booting with video=1024x768-24.

Removing all unsupported formats leaves XRGB8888 and RGB565. Both of
which are supported and work correctly.

Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Fixes: da52605eea8f ("drm/hisilicon/hibmc: Add support for display engine")
Reviewed-by: Yongbang Shi <shiyongbang@huawei.com>
Cc: Rongrong Zou <zourongrong@gmail.com>
Cc: Sean Paul <seanpaul@chromium.org>
Cc: Xinliang Liu <xinliang.liu@linaro.org>
Cc: Dmitry Baryshkov <lumag@kernel.org>
Cc: Yongbang Shi <shiyongbang@huawei.com>
Cc: Baihan Li <libaihan@huawei.com>
Cc: <stable@vger.kernel.org> # v4.10+
Link: https://patch.msgid.link/20260618123142.92298-3-tzimmermann@suse.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/hisilicon/hibmc/hibmc_drm_de.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/drivers/gpu/drm/hisilicon/hibmc/hibmc_drm_de.c
+++ b/drivers/gpu/drm/hisilicon/hibmc/hibmc_drm_de.c
@@ -153,10 +153,8 @@ static void hibmc_plane_atomic_update(st
 }
 
 static const u32 channel_formats1[] = {
-	DRM_FORMAT_RGB565, DRM_FORMAT_BGR565, DRM_FORMAT_RGB888,
-	DRM_FORMAT_BGR888, DRM_FORMAT_XRGB8888, DRM_FORMAT_XBGR8888,
-	DRM_FORMAT_RGBA8888, DRM_FORMAT_BGRA8888, DRM_FORMAT_ARGB8888,
-	DRM_FORMAT_ABGR8888
+	DRM_FORMAT_XRGB8888,
+	DRM_FORMAT_RGB565,
 };
 
 static const struct drm_plane_funcs hibmc_plane_funcs = {


