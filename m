Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC46B2210DF;
	Thu, 12 Dec 2024 15:59:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734019169; cv=none; b=q12XDrJf1krdSlUhOa/bcEE9lw1QIn9bn0SZpkhh8Gzn8UYuk4t4eQmo4UrFHLquAJiwzRZ+/bokbxkD0Eb5h46enmEXNmkjXQJllBqpGCSSgL4pqBD05TEVJY3exL/6iTjt8ytkwgV4aJCkVcbMmJA29jRjLYCtYQ4QhV7IVlc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734019169; c=relaxed/simple;
	bh=2eQCoER30fb+nqSKAVW4llTuCdWHCNmpIDwxUXgUFMg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Df/NIvm8aLZNrkGV2xR5/pafCDmEfiYovkdlocU1uuQglwAxCtuuchbV1WP6tNS9mbiuwd6mfbPnLhNkobHdDMHYFtGXtGDPGB/CTyuzentFbDtAN/BZOMhCn8jhY8FPxH5iQbIXhVtyrR1TMGBG5d6zJ9RqsCoQphfy5kLW1uU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N9FljDL+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N9FljDL+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59048C4CECE;
	Thu, 12 Dec 2024 15:59:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734019168;
	bh=2eQCoER30fb+nqSKAVW4llTuCdWHCNmpIDwxUXgUFMg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N9FljDL+G+3m0kAVR/4UgpSlb6OuD2uG96tM/yDnABAPr2NoGDFQ3rdYUafitl99d
	 vgl8+eGBe/Rh9ISTvXOVqdJsdQkcRMOcBZNW4sDbhiDKF+So9DeG06h3FksrrlGiQ/
	 xWIe6KOPtPm2JfQ1hfnqe4AduMfEIJnHVJOISO6k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 137/772] drm/imx/ipuv3: Use IRQF_NO_AUTOEN flag in request_irq()
Date: Thu, 12 Dec 2024 15:51:22 +0100
Message-ID: <20241212144355.597791235@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 89585b31b985e..5f423a2e0ede3 100644
--- a/drivers/gpu/drm/imx/ipuv3-crtc.c
+++ b/drivers/gpu/drm/imx/ipuv3-crtc.c
@@ -410,14 +410,12 @@ static int ipu_drm_bind(struct device *dev, struct device *master, void *data)
 	}
 
 	ipu_crtc->irq = ipu_plane_irq(ipu_crtc->plane[0]);
-	ret = devm_request_irq(ipu_crtc->dev, ipu_crtc->irq, ipu_irq_handler, 0,
-			"imx_drm", ipu_crtc);
+	ret = devm_request_irq(ipu_crtc->dev, ipu_crtc->irq, ipu_irq_handler,
+			       IRQF_NO_AUTOEN, "imx_drm", ipu_crtc);
 	if (ret < 0) {
 		dev_err(ipu_crtc->dev, "irq request failed with %d.\n", ret);
 		return ret;
 	}
-	/* Only enable IRQ when we actually need it to trigger work. */
-	disable_irq(ipu_crtc->irq);
 
 	return 0;
 }
-- 
2.43.0



