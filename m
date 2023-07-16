Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7E4C8F74
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:08:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4715CC433C9;
	Sun, 16 Jul 2023 20:08:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689538138;
	bh=KLMhJYRoHcQ75yALAQ01hjy4S7d0Ql28OKdUyS6SF38=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IenDPff6FMttc+Hqyad9IMCXFMJQJII793c4zr049qxF7bBsGNsjoiiTkBQZXY7X1
	 wBUdcMIQFn0EkY9WL0CtoHS4UmSFyC+bUbe/SaBmHhbd/n0I2DwGs5nRnmrzH+herY
	 IXQYKRjbwk/GzyDrIVucR/+UJ8fl4pMuF1//QIog=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuogee Hsieh <quic_khsieh@quicinc.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Marijn Suijten <marijn.suijten@somainline.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 343/800] drm/msm/dpu: always clear every individual pending flush mask
Date: Sun, 16 Jul 2023 21:43:16 +0200
Message-ID: <20230716194957.048079628@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194949.099592437@linuxfoundation.org>
References: <20230716194949.099592437@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Kuogee Hsieh <quic_khsieh@quicinc.com>

[ Upstream commit 625cbb077007698060b12d0ae5657a4d8411b153 ]

There are two tiers of pending flush control, top level and
individual hardware block. Currently only the top level of
flush mask is reset to 0 but the individual pending flush masks
of particular hardware blocks are left at their previous values,
eventually accumulating all possible bit values and typically
flushing more than necessary.
Reset all individual hardware block flush masks to 0 to avoid
accidentally flushing them.

Changes in V13:
-- rewording commit text
-- add an empty space line as suggested

Changes in V14:
-- add Fixes tag

Fixes: 73bfb790ac78 ("msm:disp:dpu1: setup display datapath for SC7180 target")
Signed-off-by: Kuogee Hsieh <quic_khsieh@quicinc.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Marijn Suijten <marijn.suijten@somainline.org>
Patchwork: https://patchwork.freedesktop.org/patch/539508/
Link: https://lore.kernel.org/r/1685036458-22683-8-git-send-email-quic_khsieh@quicinc.com
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/disp/dpu1/dpu_hw_ctl.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_ctl.c b/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_ctl.c
index e57faf5906a8b..f6270b7a0b140 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_ctl.c
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_ctl.c
@@ -117,6 +117,9 @@ static inline void dpu_hw_ctl_clear_pending_flush(struct dpu_hw_ctl *ctx)
 	trace_dpu_hw_ctl_clear_pending_flush(ctx->pending_flush_mask,
 				     dpu_hw_ctl_get_flush_register(ctx));
 	ctx->pending_flush_mask = 0x0;
+	ctx->pending_intf_flush_mask = 0;
+	ctx->pending_wb_flush_mask = 0;
+	ctx->pending_merge_3d_flush_mask = 0;
 
 	memset(ctx->pending_dspp_flush_mask, 0,
 		sizeof(ctx->pending_dspp_flush_mask));
-- 
2.39.2



