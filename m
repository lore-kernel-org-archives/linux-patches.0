Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AB3D189910;
	Tue,  8 Oct 2024 12:59:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728392397; cv=none; b=dk3TRBAoccyj+AVpJ6MKMQXxgmC3wliK11rR2u2Hz7GcZ6AeEwG3nopVcFDY7mLCdhRKtSXHGq8u8r1iXlNTMo/8GrQSj3O0Y4bxyqFx8TJde0NykOje0tNuurlqKqQ+bjvJCcR3PKjVK7ewzB5S9Lav9TyJemBJ6xUcy7mvA+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728392397; c=relaxed/simple;
	bh=f20q/1ItGkV2tGgE8XkqMvf3/GY0MyiW4ERGEX5EfpQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X/dAmExMlFmLrEgAvxnwvEZdGB2IYXZolaqJ2sK9HrCDahBqvQsLJycb8pLDg4x+5ZU0DPHi9S4GyAbxOnW3D5FvP1HTtI+18EjC+A6rkRkEFueXJzZTHQzX/8Lcro9mQ1FuZc8LHxYNWUwkKVEb5ub+Tf/a6x64zp5HuAyQ1Xk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c55CbBMg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c55CbBMg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD55CC4CEC7;
	Tue,  8 Oct 2024 12:59:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728392397;
	bh=f20q/1ItGkV2tGgE8XkqMvf3/GY0MyiW4ERGEX5EfpQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c55CbBMgP32pDOk/8kKmOWUa+nMEvm+F0VudYVT7rNNNwWrQEXiatCrSJCzN6dMJP
	 jqNEts0+j6EjTvLZvGinwkLneU+O0IPnxgUSbswO2bWDvNbLEItxEPxzlWNZzU4zCC
	 FNgvaJssB0mLpB+7aUKpinScVY+ZjwT9HVbTm5s0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Val Packett <val@packett.cool>,
	Heiko Stuebner <heiko@sntech.de>
Subject: [PATCH 6.11 403/558] drm/rockchip: vop: clear DMA stop bit on RK3066
Date: Tue,  8 Oct 2024 14:07:13 +0200
Message-ID: <20241008115718.138088741@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Val Packett <val@packett.cool>

commit 6b44aa559d6c7f4ea591ef9d2352a7250138d62a upstream.

The RK3066 VOP sets a dma_stop bit when it's done scanning out a frame
and needs the driver to acknowledge that by clearing the bit.

Unless we clear it "between" frames, the RGB output only shows noise
instead of the picture. atomic_flush is the place for it that least
affects other code (doing it on vblank would require converting all
other usages of the reg_lock to spin_(un)lock_irq, which would affect
performance for everyone).

This seems to be a redundant synchronization mechanism that was removed
in later iterations of the VOP hardware block.

Fixes: f4a6de855eae ("drm: rockchip: vop: add rk3066 vop definitions")
Cc: stable@vger.kernel.org
Signed-off-by: Val Packett <val@packett.cool>
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Link: https://patchwork.freedesktop.org/patch/msgid/20240624204054.5524-2-val@packett.cool
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/rockchip/rockchip_drm_vop.c |    4 ++++
 drivers/gpu/drm/rockchip/rockchip_drm_vop.h |    1 +
 drivers/gpu/drm/rockchip/rockchip_vop_reg.c |    1 +
 3 files changed, 6 insertions(+)

--- a/drivers/gpu/drm/rockchip/rockchip_drm_vop.c
+++ b/drivers/gpu/drm/rockchip/rockchip_drm_vop.c
@@ -1583,6 +1583,10 @@ static void vop_crtc_atomic_flush(struct
 	VOP_AFBC_SET(vop, enable, s->enable_afbc);
 	vop_cfg_done(vop);
 
+	/* Ack the DMA transfer of the previous frame (RK3066). */
+	if (VOP_HAS_REG(vop, common, dma_stop))
+		VOP_REG_SET(vop, common, dma_stop, 0);
+
 	spin_unlock(&vop->reg_lock);
 
 	/*
--- a/drivers/gpu/drm/rockchip/rockchip_drm_vop.h
+++ b/drivers/gpu/drm/rockchip/rockchip_drm_vop.h
@@ -122,6 +122,7 @@ struct vop_common {
 	struct vop_reg lut_buffer_index;
 	struct vop_reg gate_en;
 	struct vop_reg mmu_en;
+	struct vop_reg dma_stop;
 	struct vop_reg out_mode;
 	struct vop_reg standby;
 };
--- a/drivers/gpu/drm/rockchip/rockchip_vop_reg.c
+++ b/drivers/gpu/drm/rockchip/rockchip_vop_reg.c
@@ -466,6 +466,7 @@ static const struct vop_output rk3066_ou
 };
 
 static const struct vop_common rk3066_common = {
+	.dma_stop = VOP_REG(RK3066_SYS_CTRL0, 0x1, 0),
 	.standby = VOP_REG(RK3066_SYS_CTRL0, 0x1, 1),
 	.out_mode = VOP_REG(RK3066_DSP_CTRL0, 0xf, 0),
 	.cfg_done = VOP_REG(RK3066_REG_CFG_DONE, 0x1, 0),


