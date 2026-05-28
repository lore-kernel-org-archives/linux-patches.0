Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EB542F691F;
	Thu, 28 May 2026 20:06:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779998787; cv=none; b=IuBKxP+cQULdHOFkMJUVV/0ahJooFHirswIFoIiaPBpcAW0tEsDDX7oAmQZQu7WTyrYUUH13W2CyAugyL5Oiivf/IorZmf0ZAhSoGY7LWt7mFoUrGgQTZbxI6oNXe8G82LbbnyHw/y0hhZUzgVdlJ/xAlopnv0jnzXPgdUTNwKE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779998787; c=relaxed/simple;
	bh=wvU2z8GjfFO2z/sehMin5Y3wMWsA8UviIYrhTExNSH4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ud1vhqW0Ham5wbO3NcMmV2B3iX+rV99/K9JKQolLdeiC2PNgOCLwqmHFAA4V5sQ4OdUA5yOEqMDeNsq/M9PhuWX5OxiKgzr9AJIhqEUyyEsHl9iA8WONB0qnoKpIv8SUDISXjrmkxUHFssY3ZDHH4bNf2GTeClV74p0ev/LdxaA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Eoq9DSyR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Eoq9DSyR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 841531F000E9;
	Thu, 28 May 2026 20:06:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779998786;
	bh=Z3lrefzaQxafsB56Y1kHCF1LvU3GK64OHtijSyhvK6c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Eoq9DSyRTJSOwQ4y1xSQLke6FzkxNfBHpzxRwd4Latt1PuBl9f521IT23jiVugx3+
	 zpLPA2b99CuBhz142Te0darIPk4QJ4sBZvURgbNDOYRGmUJf1lAbz2wBaxIwtGWk5I
	 aamq5syg7xszuTMgk1dVMuTV6ivCyqYlItG5ecGQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	John.Harrison@Igalia.com,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 297/461] drm/msm/dpu: dont mix devm and drmm functions
Date: Thu, 28 May 2026 21:47:06 +0200
Message-ID: <20260528194655.817968094@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
References: <20260528194646.819809818@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>

[ Upstream commit c0c70a11365cba7fba25a77463582bcec0f7846e ]

Mixing devm and drmm functions will result in a use-after-free on msm
driver teardown if userspace keeps a reference on the drm device:
The WB connector data will be destroyed because of the use of
devm_kzalloc()), while the usersoace still can try interacting with the
WB connector (which uses drmm_ functions).

Change dpu_writeback_init() to use drmm_.

Fixes: 0b37ac63fc9d ("drm/msm/dpu: use drmm_writeback_connector_init()")
Reported-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Closes: https://lore.kernel.org/r/78c764b8-44cf-4db5-88e7-807a85954518@wanadoo.fr
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Reviewed-by: John.Harrison@Igalia.com
Patchwork: https://patchwork.freedesktop.org/patch/722656/
Link: https://lore.kernel.org/r/20260505-wb-drop-encoder-v5-1-42567b7c7af2@oss.qualcomm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/disp/dpu1/dpu_writeback.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/msm/disp/dpu1/dpu_writeback.c b/drivers/gpu/drm/msm/disp/dpu1/dpu_writeback.c
index 7545c0293efbd..6f2370c9dd988 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_writeback.c
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_writeback.c
@@ -5,6 +5,7 @@
 
 #include <drm/drm_edid.h>
 #include <drm/drm_framebuffer.h>
+#include <drm/drm_managed.h>
 
 #include "dpu_writeback.h"
 
@@ -125,7 +126,7 @@ int dpu_writeback_init(struct drm_device *dev, struct drm_encoder *enc,
 	struct dpu_wb_connector *dpu_wb_conn;
 	int rc = 0;
 
-	dpu_wb_conn = devm_kzalloc(dev->dev, sizeof(*dpu_wb_conn), GFP_KERNEL);
+	dpu_wb_conn = drmm_kzalloc(dev, sizeof(*dpu_wb_conn), GFP_KERNEL);
 	if (!dpu_wb_conn)
 		return -ENOMEM;
 
-- 
2.53.0



