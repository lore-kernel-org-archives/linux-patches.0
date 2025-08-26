Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C4D317332C;
	Tue, 26 Aug 2025 11:40:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756208420; cv=none; b=uNO86oTawjeEDqH7TJG/lUHdr/xB9EnpX6LkgJ35jiAcyfYWi1U7iGHRoBdGfyxJEZETqMx0vr7xYum5t8d8Vc5e1eq//lAK6eNF8uZ4HTSR0vzcnY7MiQvMsz0wXj07dQH84cGNJ4DZb/b7hylcgC1E3g1gYslHVUZxD/nv66o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756208420; c=relaxed/simple;
	bh=eLZOQQ6YYkCu3xLQe/NcyTnvCAsgr5ZLhqbWS2imLWE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UlaDMeq5nM8Ht4AehHmy30dUJueNkZ1FoxEjMhtSfxXZZ2RO8MBD+POCfZceiIwKpg7KstESyo7oM8EaX60BwKyETniHov2kMFAqtF5BZBd6mx+X0MgKxOzGHQbTWfkMTevIXqOkDulkR12s6sMmfmOudqjppCbCVs9z7ZXc/OE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eo7oe7UH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eo7oe7UH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9F4BC4CEF1;
	Tue, 26 Aug 2025 11:40:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756208420;
	bh=eLZOQQ6YYkCu3xLQe/NcyTnvCAsgr5ZLhqbWS2imLWE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eo7oe7UHWEsGxCyk82grE7atA9gorwwQrsGWyEDevdH2fqns3siasTv3tYk6vc+UG
	 fZVGFd7zVOmixWM9x/kvCElkvUaZX00PUDqeB6aBuoKlABCnYvUKVWFAgaZcg5GuTo
	 hQ2V0zAfGC0feyaYqdXpeCfT3Qi+muz1KuT+208s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Gaignard <benjamin.gaignard@collabora.com>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 6.12 103/322] media: verisilicon: Fix AV1 decoder clock frequency
Date: Tue, 26 Aug 2025 13:08:38 +0200
Message-ID: <20250826110918.263684213@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110915.169062587@linuxfoundation.org>
References: <20250826110915.169062587@linuxfoundation.org>
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

From: Nicolas Dufresne <nicolas.dufresne@collabora.com>

commit 01350185fe02ae3ea2c12d578e06af0d5186f33e upstream.

The desired clock frequency was correctly set to 400MHz in the device tree
but was lowered by the driver to 300MHz breaking 4K 60Hz content playback.
Fix the issue by removing the driver call to clk_set_rate(), which reduce
the amount of board specific code.

Fixes: 003afda97c65 ("media: verisilicon: Enable AV1 decoder on rk3588")
Cc: stable@vger.kernel.org
Reviewed-by: Benjamin Gaignard <benjamin.gaignard@collabora.com>
Reviewed-by: Philipp Zabel <p.zabel@pengutronix.de>
Signed-off-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/verisilicon/rockchip_vpu_hw.c |    9 ---------
 1 file changed, 9 deletions(-)

--- a/drivers/media/platform/verisilicon/rockchip_vpu_hw.c
+++ b/drivers/media/platform/verisilicon/rockchip_vpu_hw.c
@@ -17,7 +17,6 @@
 
 #define RK3066_ACLK_MAX_FREQ (300 * 1000 * 1000)
 #define RK3288_ACLK_MAX_FREQ (400 * 1000 * 1000)
-#define RK3588_ACLK_MAX_FREQ (300 * 1000 * 1000)
 
 #define ROCKCHIP_VPU981_MIN_SIZE 64
 
@@ -440,13 +439,6 @@ static int rk3066_vpu_hw_init(struct han
 	return 0;
 }
 
-static int rk3588_vpu981_hw_init(struct hantro_dev *vpu)
-{
-	/* Bump ACLKs to max. possible freq. to improve performance. */
-	clk_set_rate(vpu->clocks[0].clk, RK3588_ACLK_MAX_FREQ);
-	return 0;
-}
-
 static int rockchip_vpu_hw_init(struct hantro_dev *vpu)
 {
 	/* Bump ACLK to max. possible freq. to improve performance. */
@@ -807,7 +799,6 @@ const struct hantro_variant rk3588_vpu98
 	.codec_ops = rk3588_vpu981_codec_ops,
 	.irqs = rk3588_vpu981_irqs,
 	.num_irqs = ARRAY_SIZE(rk3588_vpu981_irqs),
-	.init = rk3588_vpu981_hw_init,
 	.clk_names = rk3588_vpu981_vpu_clk_names,
 	.num_clocks = ARRAY_SIZE(rk3588_vpu981_vpu_clk_names)
 };


