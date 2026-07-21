Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56E8346AA9A;
	Tue, 21 Jul 2026 15:33:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648032; cv=none; b=BQVKBLEPB2VN5MbOiPSj5GaYj1+fJXSNj36zBp6aIygxhrqxMf04pqxS5oG84hIjavxrfz0f3iz3s9Jv3+H2blaPBGz2d3+02YzP+TTZLtiErzvExAeGfEaJBwUaKoOlc6i6Mfk3ABC1M/og6IZG7L1Wiq9zccYok2t0d0K0gz0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648032; c=relaxed/simple;
	bh=40vTOitFESOTvX2prJ8xOohbkxxVkXlMlU3MeGcCr7A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jul1b6G1rzR9ILRgg9aoDNmsqiegowO7L1UyskBQD7PteEa0p/oPC68KYf1CIxuBXzVkN9auKb/d+ZFFrxZWMBMFUfF8n93qrp9D0ND3FxS1sPYk9/RSYrce4QCfGsUKfpi+L8HPz5KMEJZ7N9MN+od/WTIhK339FSUcdK4JOuM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UPKH5do/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UPKH5do/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE21B1F000E9;
	Tue, 21 Jul 2026 15:33:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648031;
	bh=6YWk6rGHmd+PQCJFqFd3wp287QX98VBdPbTDM1qeIbo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UPKH5do/Eg7BpI7tZfqrgjzcrPqeBsGQ4dZczZQRpDXmLn/2Nchqsi6zRC2xYmLrs
	 5UuR28dsSmSsUAB6mlaxP0LlP8HkCKuip9mpOCkICob5UEbq5myJzwbA4oECqCGCeC
	 HOBVlCHNdj56Mf6Q/3FLW6JBh7ZYQyvFTCg+AB/Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cristian Ciocaltea <cristian.ciocaltea@collabora.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0047/2077] drm/rockchip: dw_dp: Fix null-ptr-deref in dw_dp_remove()
Date: Tue, 21 Jul 2026 16:55:20 +0200
Message-ID: <20260721152553.798899065@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cristian Ciocaltea <cristian.ciocaltea@collabora.com>

[ Upstream commit 9456381d8b60bb7dd42f2f04afe5ee4ce6e0bc12 ]

Attempting to access driver data in the platform driver ->remove()
callback may lead to a null pointer dereference since there is no
guaranty that the component ->bind() callback invoking
platform_set_drvdata() was executed.

A common scenario is when Rockchip DRM driver didn't manage to run
component_bind_all() because of an (unrelated) error causing early
return from rockchip_drm_bind().

Drop the unnecessary call to platform_get_drvdata() and, instead,
reference the target device structure via platform_device.

Fixes: d68ba7bac955 ("drm/rockchip: Add RK3588 DPTX output support")
Signed-off-by: Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Link: https://patch.msgid.link/20260310-drm-rk-fixes-v2-3-645ecfb43f49@collabora.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/rockchip/dw_dp-rockchip.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/rockchip/dw_dp-rockchip.c b/drivers/gpu/drm/rockchip/dw_dp-rockchip.c
index 532af476d250a5..8945a245398ca4 100644
--- a/drivers/gpu/drm/rockchip/dw_dp-rockchip.c
+++ b/drivers/gpu/drm/rockchip/dw_dp-rockchip.c
@@ -133,9 +133,7 @@ static int dw_dp_probe(struct platform_device *pdev)
 
 static void dw_dp_remove(struct platform_device *pdev)
 {
-	struct rockchip_dw_dp *dp = platform_get_drvdata(pdev);
-
-	component_del(dp->dev, &dw_dp_rockchip_component_ops);
+	component_del(&pdev->dev, &dw_dp_rockchip_component_ops);
 }
 
 static const struct dw_dp_plat_data rk3588_dp_plat_data = {
-- 
2.53.0



