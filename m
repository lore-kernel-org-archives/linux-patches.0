Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062189;
	b=2PLxq+lHiSGvbU/mqui3M7XxxTKciiNdhwUxdILLxFWU+dLF0jclICpxDaLf3Mh+/bNM
	 G6R43MdA5UF4h5+PDGyIFAzK1a8Afr8+qMuGCU36ORLviCp/yhjunLKb/HlskiT7hVtSF
	 7S2jyaZHdU/Jq4/ohLmm5lUCOcDMbcjyZ8quvB7ld3abyn9xMKVvnjkc36i0JSD7/rGdi
	 /s/+sXX6VkM4tcju11ehetasdZ4VqAfuMOFqn3G4GxCHCXxEPC3bD58JikVYA3zV8jDtz
	 N2tEsZ2w6tZC4+3fkjoqSgR0MLM5C6EvpAda72yqd2aeL7/6f5qWKjdFSVSgB4PS/3w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062189;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ksI65YZ6Hc0DMkCBWWRTWAtJwm0bSjDcpiqGEROD+Gk=;
	b=2NdPE6IQ5eEPrTUw2hpNGjPBnDB88QdnUsaUAVQhUcxjDXNu2i6a1lBAr2xDFS3DGP2c
	 QxHkkrXz4VbmQ3zgZRfdJ3h8CNbW7T9A4/8lgowAUdC/ej7AwHCrfsqbx5Q8Fp17ReNlR
	 3dnKTh1D7vvsar6uF2D9+sTcrzStVRREbSM18oVwEyGzt3cTHQR3vnfriLoVE9hEgG66U
	 uJfIoqkV6GQkB2HcGic+JjdRll4O2wgNCotNlzcpHKnUeELFfEfdaDDVjR5GOCmrnyrpD
	 c7scDOZ4F8uvIjhBRsgAcHVljCIXunr+DYwT+L6PFmGPCT74vEx3Ni2BX4VAtNeCQ9A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tOZVuuFj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 907AF606A326;
	Sat,  7 Nov 2026 14:36:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tOZVuuFj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D5DA1F008A4;
	Sat,  7 Nov 2026 14:36:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062189;
	bh=ksI65YZ6Hc0DMkCBWWRTWAtJwm0bSjDcpiqGEROD+Gk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tOZVuuFjoxaqdE1kOjsjsDj6z+a9AOJwDS+8QwI67+qfSAPW0Tvg6Va7SHtnOHr2z
	 NisJy4Mp8NcwZqyBNwSaKb0hfs5aI16qJPGWcXdWgigHoDlowEcqO0xpQn3AIPFM9B
	 PlifYQIFc+PbI0CtSb0mkys9EAb2dhch5IdBnc64=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1146/1536] media: mtk-jpeg: Fix runtime PM leak in mtk_jpegdec_worker()
Date: Sat,  7 Nov 2026 08:52:42 -0500
Message-ID: <20261107135029.910329850@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wentao Liang <vulab@iscas.ac.cn>

[ Upstream commit befd4506174addc5e85641b4ef304c9247b48c55 ]

pm_runtime_get_sync() leaves the device's runtime PM usage count
incremented even when it fails.  mtk_jpegdec_worker() jumps to
dec_end on that failure, which does not call pm_runtime_put(), so
the reference taken by the failed resume is leaked.

Use pm_runtime_resume_and_get() instead, which drops the reference
again when resuming the device fails.

Fixes: dedc21500334 ("media: mtk-jpegdec: add jpeg decode worker interface")
Cc: stable@vger.kernel.org
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Reviewed-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/mediatek/jpeg/mtk_jpeg_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/mediatek/jpeg/mtk_jpeg_core.c b/drivers/media/platform/mediatek/jpeg/mtk_jpeg_core.c
index 45868f0218393..9d0244b52baed 100644
--- a/drivers/media/platform/mediatek/jpeg/mtk_jpeg_core.c
+++ b/drivers/media/platform/mediatek/jpeg/mtk_jpeg_core.c
@@ -1743,7 +1743,7 @@ static void mtk_jpegdec_worker(struct work_struct *work)
 	jpeg_dst_buf->frame_num = ctx->total_frame_num;
 
 	mtk_jpegdec_set_hw_param(ctx, hw_id, src_buf, dst_buf);
-	ret = pm_runtime_get_sync(comp_jpeg[hw_id]->dev);
+	ret = pm_runtime_resume_and_get(comp_jpeg[hw_id]->dev);
 	if (ret < 0) {
 		dev_err(jpeg->dev, "%s : %d, pm_runtime_get_sync fail !!!\n",
 			__func__, __LINE__);
-- 
2.53.0



