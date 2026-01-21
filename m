Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 006FE354ADB;
	Wed, 21 Jan 2026 18:26:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769019975; cv=none; b=YSjoXFbFftEuzyDywotXtek52PMPIHJUTZlrBe5zFVAEFkGuC4VRQr8tChEPIX8PuKO600nTJnvQlcHyVUSztm/J+RfiNUZP1eX3eGHAyhCyFlNcOWo1p57j0An8/ydIUY0bq017Yh1a/Z+NErzxzHba3e+eQbJCA0U+5p/AkzY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769019975; c=relaxed/simple;
	bh=DvzUrdiTkK2tJ764u39oAAt7D/9sLqGBBC+5mGUVbq4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GepZi8JNlYkVq0Wbcli+7yOHXmB7/wnljfTG9HV4bGzlp/Vow5r1bh/L9VyZBTEXulKonHWlGAGi9G3LBCgN0kepWJK7dCF0KuxrjLUbeLp/nAYK+XV6x5cJ0cWC3zvR2N1epnautrTBMhDMJliiyO1YLcqNDu7q7x4v8xIfLG0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Du+iZE+D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Du+iZE+D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08264C4CEF1;
	Wed, 21 Jan 2026 18:26:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769019974;
	bh=DvzUrdiTkK2tJ764u39oAAt7D/9sLqGBBC+5mGUVbq4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Du+iZE+DTuXU11jg5KPFzKBBXpKqYQ3HJb8tE889O9878ropqIOBG981O3iYDGJ6m
	 GPupJGlPgS5bF6oNLM5+9qS7yHsCcbWJDSWzKNiJ416mVHm9MKPY9CgvUbc3m1m1se
	 zaluxG8zcA0SoHbGumGr2LJu73Goa2In1FtcCfV0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Yan <andy.yan@rock-chips.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 022/198] drm/rockchip: vop2: Add delay between poll registers
Date: Wed, 21 Jan 2026 19:14:10 +0100
Message-ID: <20260121181419.352285437@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260121181418.537774329@linuxfoundation.org>
References: <20260121181418.537774329@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Yan <andy.yan@rock-chips.com>

[ Upstream commit 9fae82450d8a5f9c8fa016cd15186e975609b2ac ]

According to the implementation of read_poll_timeout_atomic, if the
delay time is 0, it will only use a simple loop based on timeout_us to
decrement the count. Therefore, the final timeout time will differ
significantly from the set timeout time. So, here we set a specific
delay time to ensure that the calculation of the timeout duration
is accurate.

Fixes: 3e89a8c68354 ("drm/rockchip: vop2: Fix the update of LAYER/PORT select registers when there are multi display output on rk3588/rk3568")
Signed-off-by: Andy Yan <andy.yan@rock-chips.com>
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Link: https://patch.msgid.link/20250718064120.8811-1-andyshrk@163.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/rockchip/rockchip_vop2_reg.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/rockchip/rockchip_vop2_reg.c b/drivers/gpu/drm/rockchip/rockchip_vop2_reg.c
index cd8380f0eddc8..855386a6a9f5c 100644
--- a/drivers/gpu/drm/rockchip/rockchip_vop2_reg.c
+++ b/drivers/gpu/drm/rockchip/rockchip_vop2_reg.c
@@ -2104,7 +2104,7 @@ static void rk3568_vop2_wait_for_port_mux_done(struct vop2 *vop2)
 	 * Spin until the previous port_mux figuration is done.
 	 */
 	ret = readx_poll_timeout_atomic(rk3568_vop2_read_port_mux, vop2, port_mux_sel,
-					port_mux_sel == vop2->old_port_sel, 0, 50 * 1000);
+					port_mux_sel == vop2->old_port_sel, 10, 50 * 1000);
 	if (ret)
 		DRM_DEV_ERROR(vop2->dev, "wait port_mux done timeout: 0x%x--0x%x\n",
 			      port_mux_sel, vop2->old_port_sel);
@@ -2124,7 +2124,7 @@ static void rk3568_vop2_wait_for_layer_cfg_done(struct vop2 *vop2, u32 cfg)
 	 * Spin until the previous layer configuration is done.
 	 */
 	ret = readx_poll_timeout_atomic(rk3568_vop2_read_layer_cfg, vop2, atv_layer_cfg,
-					atv_layer_cfg == cfg, 0, 50 * 1000);
+					atv_layer_cfg == cfg, 10, 50 * 1000);
 	if (ret)
 		DRM_DEV_ERROR(vop2->dev, "wait layer cfg done timeout: 0x%x--0x%x\n",
 			      atv_layer_cfg, cfg);
-- 
2.51.0



