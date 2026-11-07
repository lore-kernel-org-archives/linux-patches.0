Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063122;
	b=a3+c03RPfXeuk36rI4BASh/H7RdZagm1pL450v4BtFWzvRGpMuxUhsOh6qV/5/LODuzb
	 tgNvdLnrjDZt1BcAYclSyWaWvqRIFGaxqmQavWEcDINWcAr9QKGMQls8i+U/PREYQ7k9K
	 EmwwQy2r7whcA23/t362BtOzZS0Z3xUsrD3VSdy23uNYLnP4i2B1dt/42Imi7RJS/myvX
	 l/jc5Bb9LHGRG7iSP8AQvC3/K0NRy6jiFmx2ffIDJAXpiH/TNzQbZcLpC160XFlywq/Lr
	 5xTbTkeaSgrOxTFwvHwOKb/n7rdvoU7gX0rsC/ffmuh6nNEw2FlNTiRHPl8EA0uIXxg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063122;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SQ8HBuj3Ir41uet2qv+6DU3+vLQykvPY/8BamGqPOMc=;
	b=cLOuiYQpJ9q1T2ILOAejdJW6X3FbQD0FAgqfiaaSTVe5yGWcD58JOErncp6fKa4FFgFt
	 yyaZ9yf6YKVdHB3Cp0XlY+rRjQXICzRyGa6ovrLHxo0dccTWo+L+2wKuo1YLSJuFJrQAQ
	 woe8gdvhrF7C49N6X0xVuQ2tR/wkAO3t2TuMy/FqWLPEzqf0+Muhwq5qNeHihuTM3zun5
	 4WYpC5HNKOK2ak37OqHtifxIy26AcJkgiOfSPcE56ua8bb7oz58ZyogdxH3jzYowN3MkY
	 EGRy15PDV8k43w08TjBa06MPR1MIhbGmcvfrBbRiguH4/iyrKZxF/mrKJlFaC5bFPaw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=P+vKZG4o;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BED18606A33B;
	Sat,  7 Nov 2026 14:52:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=P+vKZG4o
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E78C1F0089F;
	Sat,  7 Nov 2026 14:52:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063121;
	bh=SQ8HBuj3Ir41uet2qv+6DU3+vLQykvPY/8BamGqPOMc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=P+vKZG4oK21Ttg1bvfrKnJA37dKsD5XBh4wDEZSIicC9YmCe8ccRfJzxeijEkcoO5
	 gvrsf/VF1hF2fqFhZ64seJxzOrtQq8a9uafTjHPMkYqfiV+wOA0RNWhk4nXR8D7K1p
	 M8O8tMEMXBCRoHj45gYiLH2K4wEc/avgIy1X+Tfc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 350/869] media: mtk-jpeg: Fix runtime PM leak in mtk_jpegenc_worker()
Date: Sat,  7 Nov 2026 08:50:32 -0500
Message-ID: <20261107134904.247353656@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wentao Liang <vulab@iscas.ac.cn>

[ Upstream commit 7ec8fd17f3a8059dcf94101065a35d0136031794 ]

pm_runtime_get_sync() leaves the device's runtime PM usage count
incremented even when it fails, and a failed clk_prepare_enable()
drops the reference as well.  mtk_jpegenc_worker() jumps to enc_end
in both cases, which does not call pm_runtime_put(), so the
reference taken by the successful resume is leaked.

Use pm_runtime_resume_and_get() for the resume failure and release
the reference explicitly when the clock cannot be enabled, as
mtk_jpegdec_worker() already does.

Fixes: 5fb1c2361e56 ("mtk-jpegenc: add jpeg encode worker interface")
Cc: stable@vger.kernel.org
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Reviewed-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/mediatek/jpeg/mtk_jpeg_core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/mediatek/jpeg/mtk_jpeg_core.c b/drivers/media/platform/mediatek/jpeg/mtk_jpeg_core.c
index fa47d2fb94aa0..0e2bb13f071af 100644
--- a/drivers/media/platform/mediatek/jpeg/mtk_jpeg_core.c
+++ b/drivers/media/platform/mediatek/jpeg/mtk_jpeg_core.c
@@ -1630,7 +1630,7 @@ static void mtk_jpegenc_worker(struct work_struct *work)
 	v4l2_m2m_buf_copy_metadata(src_buf, dst_buf, true);
 
 	mtk_jpegenc_set_hw_param(ctx, hw_id, src_buf, dst_buf);
-	ret = pm_runtime_get_sync(comp_jpeg[hw_id]->dev);
+	ret = pm_runtime_resume_and_get(comp_jpeg[hw_id]->dev);
 	if (ret < 0) {
 		dev_err(jpeg->dev, "%s : %d, pm_runtime_get_sync fail !!!\n",
 			__func__, __LINE__);
@@ -1641,6 +1641,7 @@ static void mtk_jpegenc_worker(struct work_struct *work)
 	if (ret) {
 		dev_err(jpeg->dev, "%s : %d, jpegenc clk_prepare_enable fail\n",
 			__func__, __LINE__);
+		pm_runtime_put(comp_jpeg[hw_id]->dev);
 		goto enc_end;
 	}
 
-- 
2.53.0



