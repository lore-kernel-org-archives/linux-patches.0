Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 661B61EA65;
	Thu, 28 May 2026 20:28:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780000122; cv=none; b=rOkZN216IMwR//mNQz2A6svhC6jM6L3YMZYR8JBABTDC8G+C5mN97oxeMGRIfAueiiqZPiANk+H3mQ0XeTuolNznvYJLTfe+3uRgZf68BlKBV7dy7CKKVMit6lChaIaNTB9QBgEMCnUyIQCSQZ+JoAk51a5Rc3I2x93K2uzMetg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780000122; c=relaxed/simple;
	bh=3/RNdyASp0D3453Jz2Um389MnWN9E5sdaMcWu5cXzhU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fdtFpjIkxGujrlnKT7LnhrtAuhyCHccBpb1R4UMduLzJzEwfz5LHpnD+FWMqqnpV3wMKfWzm4ty516r8RMaDLGnyGJGongrAf49GikY0d07eCm547n+jyViUKmaDecL1E2G8ElxmQqvoXFUvLpS1E9GbisB/iD81MEhJai8fq/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lZJK6XJR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lZJK6XJR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C46001F000E9;
	Thu, 28 May 2026 20:28:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780000121;
	bh=BlTH07+j/XmIJL0V4FtHrdDZ+08Gs4ltTS2D2uvqjQI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lZJK6XJRTa+kMepBxUAd7Mq8ySW6UXXee8IBTzIviRI7O7IKKwettiTB42MUJDzrC
	 d8i+n8Hfx3mev+e+0M0SXUq1tDfqhZ/OgHJL4xr/e173JMEmRz2hqYHo3GXUCzw7FI
	 WwqMQCyVLs5ZDFak7KRJjN/sXk6f0UqGtf0s3N4Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	John.Harrison@Igalia.com,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 273/377] drm/msm/dpu: dont mix devm and drmm functions
Date: Thu, 28 May 2026 21:48:31 +0200
Message-ID: <20260528194646.269305439@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194638.371537336@linuxfoundation.org>
References: <20260528194638.371537336@linuxfoundation.org>
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



