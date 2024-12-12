Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A758813CA93;
	Thu, 12 Dec 2024 17:17:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734023851; cv=none; b=T8O9JoL9cGyfOm0pkKqYHoBKQWTV3SKTSPtX6PjChlxhQhzgc8wzHfg4T9tgN3UfceDQ5760XBKlNcg9x9lFCf1RVOdlY5sWR8qeD2+IETGNn43QmMZGC8fUkb9ilJbAAIGvNYFmLDLM659kPz+L0HBCY+Roau7ote3CdIUN/Rs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734023851; c=relaxed/simple;
	bh=Xe52mUzsx50wZL3TOY+DKWiNKLdTGBp0XUkMyWgdRBQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hQepCW8oIvcdZbfgIGUhbjCgS+13iUZMx7gW+p03OVaWKHaDp/JwgGyESYasMub1eNtzSJa66zPhTcGJJXKPWs3VyDueRnjrQT9MBY6NvqDwO7jfFp67QpttcW5YsoXyYm9TNWqG6E/KxV3GgXQyK7JqIeR+D3T/qRPs0hIZ/lE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U+D5ry6E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U+D5ry6E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2846DC4CECE;
	Thu, 12 Dec 2024 17:17:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734023851;
	bh=Xe52mUzsx50wZL3TOY+DKWiNKLdTGBp0XUkMyWgdRBQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U+D5ry6Ez8gb5jOtSK1w4uUTKsMh1tUrZPawfBL8NR4yWvbsbzXi0pgQB+pcL8T62
	 r3+2Cx+CUNYsm0XEQFEETY7moQhApmiUdVyJEV29YI+aFLHhe5m/P/8lVAJTjPgw4+
	 6kmb96vV0SlDdrTJzjvoUIsZ1pb6aCY8njOhnmEg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 104/459] drm/imx/ipuv3: Use IRQF_NO_AUTOEN flag in request_irq()
Date: Thu, 12 Dec 2024 15:57:22 +0100
Message-ID: <20241212144257.619635464@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144253.511169641@linuxfoundation.org>
References: <20241212144253.511169641@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jinjie Ruan <ruanjinjie@huawei.com>

[ Upstream commit 40004709a3d3b07041a473a163ca911ef04ab8bd ]

disable_irq() after request_irq() still has a time gap in which
interrupts can come. request_irq() with IRQF_NO_AUTOEN flag will
disable IRQ auto-enable when request IRQ.

Fixes: 47b1be5c0f4e ("staging: imx/drm: request irq only after adding the crtc")
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
Reviewed-by: Philipp Zabel <p.zabel@pengutronix.de>
Link: https://patchwork.freedesktop.org/patch/msgid/20240912083020.3720233-4-ruanjinjie@huawei.com
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/imx/ipuv3-crtc.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/imx/ipuv3-crtc.c b/drivers/gpu/drm/imx/ipuv3-crtc.c
index fd9d8e51837fa..d6e5821c14c1d 100644
--- a/drivers/gpu/drm/imx/ipuv3-crtc.c
+++ b/drivers/gpu/drm/imx/ipuv3-crtc.c
@@ -406,14 +406,12 @@ static int ipu_crtc_init(struct ipu_crtc *ipu_crtc,
 	}
 
 	ipu_crtc->irq = ipu_plane_irq(ipu_crtc->plane[0]);
-	ret = devm_request_irq(ipu_crtc->dev, ipu_crtc->irq, ipu_irq_handler, 0,
-			"imx_drm", ipu_crtc);
+	ret = devm_request_irq(ipu_crtc->dev, ipu_crtc->irq, ipu_irq_handler,
+			       IRQF_NO_AUTOEN, "imx_drm", ipu_crtc);
 	if (ret < 0) {
 		dev_err(ipu_crtc->dev, "irq request failed with %d.\n", ret);
 		goto err_put_plane1_res;
 	}
-	/* Only enable IRQ when we actually need it to trigger work. */
-	disable_irq(ipu_crtc->irq);
 
 	return 0;
 
-- 
2.43.0



