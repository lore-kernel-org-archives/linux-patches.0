Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D460A32C60;
	Thu, 11 Apr 2024 10:30:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712831415; cv=none; b=TwfUPeI15lraz0coWeQPBy+2eWeF2DTnoPkDjAwMkyqp83qDCdXk1q+4d1y/3fhlDjhdfBWZMsplVC2mQOzdc1Y5/Z9j7ZopwlpaOPywQuuG8Dz9EdQhgunHFOpotNhLqgSkfq2PDocfiEsyLV90v2FyqMdYNDzT++nr/Duc0s4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712831415; c=relaxed/simple;
	bh=hktiwryEAY1NJ58n7HYChZmz4K4sFQwrpXRNZY89qWI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XuLBVp0/4fQ4Qp0dx/8Wjp340F6nF8/p+jMT/Eqv7paY+xS1LM+t64SVXIg+wMqT+7YqNe9DQEMxelIxXyZeJYzjD6DsLWJVMjQtAOvsFTAAPl5y5tpYvmReJ1ywlF/DFO0TA+us7JJK34gE+xLXBdv8mvPVHadQcR9Dnh15xq0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g2Jadk3+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g2Jadk3+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59B2CC433F1;
	Thu, 11 Apr 2024 10:30:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712831415;
	bh=hktiwryEAY1NJ58n7HYChZmz4K4sFQwrpXRNZY89qWI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g2Jadk3+LuKOYJWMyaZNwJMtgkMlEMxOgeURzcKiQc3/Wi79y3hqwioxwN2wiOAGB
	 7YzTl20gp2UmL0ZzeCr0BD/Y4w7uHGOU9dFGHASggJdYOkQ5ReFBQtP4NGgah3ybB9
	 DIzCE9m+1abiHlRkBaBRXkHv5W2fhmb7QhRUGD2Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sebastian Fricke <sebastian.fricke@collabora.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 106/114] media: mediatek: vcodec: Fix oops when HEVC init fails
Date: Thu, 11 Apr 2024 11:57:13 +0200
Message-ID: <20240411095420.091836309@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095416.853744210@linuxfoundation.org>
References: <20240411095416.853744210@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicolas Dufresne <nicolas.dufresne@collabora.com>

[ Upstream commit 97c75ee5de060d271d80109b0c47cb6008439e5b ]

The stateless HEVC decoder saves the instance pointer in the context
regardless if the initialization worked or not. This caused a use after
free, when the pointer is freed in case of a failure in the deinit
function.
Only store the instance pointer when the initialization was successful,
to solve this issue.

 Hardware name: Acer Tomato (rev3 - 4) board (DT)
 pstate: 80400009 (Nzcv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
 pc : vcodec_vpu_send_msg+0x4c/0x190 [mtk_vcodec_dec]
 lr : vcodec_send_ap_ipi+0x78/0x170 [mtk_vcodec_dec]
 sp : ffff80008750bc20
 x29: ffff80008750bc20 x28: ffff1299f6d70000 x27: 0000000000000000
 x26: 0000000000000000 x25: 0000000000000000 x24: 0000000000000000
 x23: ffff80008750bc98 x22: 000000000000a003 x21: ffffd45c4cfae000
 x20: 0000000000000010 x19: ffff1299fd668310 x18: 000000000000001a
 x17: 000000040044ffff x16: ffffd45cb15dc648 x15: 0000000000000000
 x14: ffff1299c08da1c0 x13: ffffd45cb1f87a10 x12: ffffd45cb2f5fe80
 x11: 0000000000000001 x10: 0000000000001b30 x9 : ffffd45c4d12b488
 x8 : 1fffe25339380d81 x7 : 0000000000000001 x6 : ffff1299c9c06c00
 x5 : 0000000000000132 x4 : 0000000000000000 x3 : 0000000000000000
 x2 : 0000000000000010 x1 : ffff80008750bc98 x0 : 0000000000000000
 Call trace:
  vcodec_vpu_send_msg+0x4c/0x190 [mtk_vcodec_dec]
  vcodec_send_ap_ipi+0x78/0x170 [mtk_vcodec_dec]
  vpu_dec_deinit+0x1c/0x30 [mtk_vcodec_dec]
  vdec_hevc_slice_deinit+0x30/0x98 [mtk_vcodec_dec]
  vdec_if_deinit+0x38/0x68 [mtk_vcodec_dec]
  mtk_vcodec_dec_release+0x20/0x40 [mtk_vcodec_dec]
  fops_vcodec_release+0x64/0x118 [mtk_vcodec_dec]
  v4l2_release+0x7c/0x100
  __fput+0x80/0x2d8
  __fput_sync+0x58/0x70
  __arm64_sys_close+0x40/0x90
  invoke_syscall+0x50/0x128
  el0_svc_common.constprop.0+0x48/0xf0
  do_el0_svc+0x24/0x38
  el0_svc+0x38/0xd8
  el0t_64_sync_handler+0xc0/0xc8
  el0t_64_sync+0x1a8/0x1b0
 Code: d503201f f9401660 b900127f b900227f (f9400400)

Signed-off-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Fixes: 2674486aac7d ("media: mediatek: vcodec: support stateless hevc decoder")
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Sebastian Fricke <sebastian.fricke@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../mediatek/vcodec/decoder/vdec/vdec_hevc_req_multi_if.c       | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/mediatek/vcodec/decoder/vdec/vdec_hevc_req_multi_if.c b/drivers/media/platform/mediatek/vcodec/decoder/vdec/vdec_hevc_req_multi_if.c
index 06ed47df693bf..21836dd6ef85a 100644
--- a/drivers/media/platform/mediatek/vcodec/decoder/vdec/vdec_hevc_req_multi_if.c
+++ b/drivers/media/platform/mediatek/vcodec/decoder/vdec/vdec_hevc_req_multi_if.c
@@ -869,7 +869,6 @@ static int vdec_hevc_slice_init(struct mtk_vcodec_dec_ctx *ctx)
 	inst->vpu.codec_type = ctx->current_codec;
 	inst->vpu.capture_type = ctx->capture_fourcc;
 
-	ctx->drv_handle = inst;
 	err = vpu_dec_init(&inst->vpu);
 	if (err) {
 		mtk_vdec_err(ctx, "vdec_hevc init err=%d", err);
@@ -898,6 +897,7 @@ static int vdec_hevc_slice_init(struct mtk_vcodec_dec_ctx *ctx)
 	mtk_vdec_debug(ctx, "lat hevc instance >> %p, codec_type = 0x%x",
 		       inst, inst->vpu.codec_type);
 
+	ctx->drv_handle = inst;
 	return 0;
 error_free_inst:
 	kfree(inst);
-- 
2.43.0



