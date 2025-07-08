Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7E9B1DF74F;
	Tue,  8 Jul 2025 16:39:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751992764; cv=none; b=CiGseZwNdbT1pqcdlvL0qLNVbl1wPm9tRmNvBJEeQ4SNn/TnINYI5m6cOW0W6Ki0cL9kyWGOkOjYxw+udpP2LQPqubM/BF6WNSaEqsILalAGuPxW88qrpyWUuXM5kBQAsLiddB9d3GOFPj8SatrX286kOqqwN3ZBVN6DvlGoke0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751992764; c=relaxed/simple;
	bh=GjrKHGWjp21g31qqCF8tBAIRV5A/a9DjpNalJACwJP4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e9YLoVBupMvJjBCqV8TmLTuGkcuewodeUQ44t/Y4aK/S3LkMto2AuePzVN0K0sH+Cn14F4l85Yt1nTJmM2SeZgs78tL7LfznjYKz6kERNm3hM5qU/p5GyJAwZnXZGeDf0aUH2AP+sQ6LKhq2CIeUwR9kyJfbp2G8qCbfKMNaNsA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EurZloTu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EurZloTu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 514E5C4CEED;
	Tue,  8 Jul 2025 16:39:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751992764;
	bh=GjrKHGWjp21g31qqCF8tBAIRV5A/a9DjpNalJACwJP4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EurZloTu2rTLUvff79XXQwM9YS4PT8mzLBuCx5nbCC01NmqNWkjKt/K9tTlC4lU19
	 9ISvR5GO/nrvNdVdqDW57ZZEkJZRaAc5Mmu1GE2BbZ+C71qf1yuuSXxA5MMk0AfkqF
	 PIdJRqYOz9AHXzPU08VbAN+d1V77IOh+QAysb5p8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 073/232] drm/bridge: aux-hpd-bridge: fix assignment of the of_node
Date: Tue,  8 Jul 2025 18:21:09 +0200
Message-ID: <20250708162243.363319871@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162241.426806072@linuxfoundation.org>
References: <20250708162241.426806072@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>

[ Upstream commit e8537cad824065b0425fb0429e762e14a08067c2 ]

Perform fix similar to the one in the commit 85e444a68126 ("drm/bridge:
Fix assignment of the of_node of the parent to aux bridge").

The assignment of the of_node to the aux HPD bridge needs to mark the
of_node as reused, otherwise driver core will attempt to bind resources
like pinctrl, which is going to fail as corresponding pins are already
marked as used by the parent device.
Fix that by using the device_set_of_node_from_dev() helper instead of
assigning it directly.

Fixes: e560518a6c2e ("drm/bridge: implement generic DP HPD bridge")
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://lore.kernel.org/r/20250608-fix-aud-hpd-bridge-v1-1-4641a6f8e381@oss.qualcomm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/aux-hpd-bridge.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/bridge/aux-hpd-bridge.c b/drivers/gpu/drm/bridge/aux-hpd-bridge.c
index 6886db2d9e00c..8e889a38fad00 100644
--- a/drivers/gpu/drm/bridge/aux-hpd-bridge.c
+++ b/drivers/gpu/drm/bridge/aux-hpd-bridge.c
@@ -64,10 +64,11 @@ struct auxiliary_device *devm_drm_dp_hpd_bridge_alloc(struct device *parent, str
 	adev->id = ret;
 	adev->name = "dp_hpd_bridge";
 	adev->dev.parent = parent;
-	adev->dev.of_node = of_node_get(parent->of_node);
 	adev->dev.release = drm_aux_hpd_bridge_release;
 	adev->dev.platform_data = of_node_get(np);
 
+	device_set_of_node_from_dev(&adev->dev, parent);
+
 	ret = auxiliary_device_init(adev);
 	if (ret) {
 		of_node_put(adev->dev.platform_data);
-- 
2.39.5



