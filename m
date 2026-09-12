Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 014053BC680;
	Sat, 12 Sep 2026 07:07:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789196826; cv=none; b=PDs80i9Gz35xM1NLuqNzIh0slczM8M0DWn9GIrs8DCRpXXY6KZOPGZqSSwGPQoevay8+6yaaxezgdzJSUMzIJvCnjiu6vXQ5t03BlysBHSJw8B3o7NPpScLU4PeZdBQJtMsgw37WdheYV8V5JFjwzKdLaiEMhzJApAEPQwco4us=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789196826; c=relaxed/simple;
	bh=OqDkCEp3vyoilPQoxTIXVzdWt7Ho/ZhZmrr0VjIIuw4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H/n0xKw/rXCR1PDUQ9k8GUg3S7va9bFfuxz2kJEl0KEzsetazTDWN35V69MrszSMbRB09GCJPvybKx1P6Sb0Dd3Eh6yrOKiFHauCNTF92ZcVCCUAV6cEpIa1Mx1uOPB8i7BrDItDSCVpUOJf4VCUa5+tL8jjao3uccBePiByNK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dq4POKKz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dq4POKKz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D056B1F000FF;
	Sat, 12 Sep 2026 07:07:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789196821;
	bh=BhYYM0/uty4l4uB1WYNEnlSw+TbOZlBAFj6/6Qw/qM0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dq4POKKz9fzzvD/bRADkhK+8qhgdbNoOzj1jospC73D1W2TFcBKKRgwDIEL4zbsVy
	 N/eLEEmQpqs6iXMiDgLi6nDHZZKrG78Ht/c0kWYYKPN3rWtmY9hAw6jW6jHbOk1Whi
	 g9lOcEZhvVfYN41U6eqJInc9/+HHcJHXJoAHzzeE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cristian Ciocaltea <cristian.ciocaltea@collabora.com>,
	Andy Yan <andy.yan@rock-chips.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0042/1815] drm/rockchip: vop2: Fix wrong wait target in layer cfg done check
Date: Sat, 12 Sep 2026 08:29:52 +0200
Message-ID: <20260912065650.009096706@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cristian Ciocaltea <cristian.ciocaltea@collabora.com>

[ Upstream commit 9f5670802df085ad343146561e69bac43e9905d2 ]

rk3568_vop2_setup_layer_mixer() waits for the previous Video Port (VP)
layer configuration to take effect before writing a new one to the
shared RK3568_OVL_LAYER_SEL shadow register.  However, it passes
vop2->old_layer_sel to rk3568_vop2_wait_for_layer_cfg_done() as the
expected value, which at that point already contains the new VP layer.

This causes the wait to poll for a value that has not been written to
the shadow register yet, resulting in spurious timeouts when two
non-blocking atomic commits race:

  rockchip-drm display-subsystem: [drm] *ERROR* wait layer cfg done timeout [...]

Pass the local old_layer_sel instead, which still holds the value
captured from vop2->old_layer_sel before it was overwritten, i.e. the
previous VP target that the hardware is expected to latch.

Fixes: 3e89a8c68354 ("drm/rockchip: vop2: Fix the update of LAYER/PORT select registers when there are multi display output on rk3588/rk3568")
Signed-off-by: Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
Reviewed-by: Andy Yan <andy.yan@rock-chips.com>
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Link: https://patch.msgid.link/20260504-vop2-layer-cfg-tmout-v1-1-730226a7331e@collabora.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/rockchip/rockchip_vop2_reg.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/rockchip/rockchip_vop2_reg.c b/drivers/gpu/drm/rockchip/rockchip_vop2_reg.c
index 17eda592b1833..fcf73a4327ab1 100644
--- a/drivers/gpu/drm/rockchip/rockchip_vop2_reg.c
+++ b/drivers/gpu/drm/rockchip/rockchip_vop2_reg.c
@@ -2306,7 +2306,7 @@ static void rk3568_vop2_setup_layer_mixer(struct vop2_video_port *vp)
 		 * Changes of other VPs' overlays have not taken effect
 		 */
 		if (cfg_done)
-			rk3568_vop2_wait_for_layer_cfg_done(vop2, vop2->old_layer_sel);
+			rk3568_vop2_wait_for_layer_cfg_done(vop2, old_layer_sel);
 	}
 
 	vop2_writel(vop2, RK3568_OVL_LAYER_SEL, layer_sel);
-- 
2.53.0



