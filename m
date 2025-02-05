Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76DE815198D;
	Wed,  5 Feb 2025 14:01:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738764117; cv=none; b=BFHBjxSSfI1E0zNpxgmrfxx+9yZx5qzk8SZgyQ9qdvgD4c+yUCKC3NTIgon4cBY00/o8an32EELj2Z2HGQngSfch/EveQfP3FpRYuaerU9hOIu4wPqJgA+8RmJtSj+UW716LD7AAr8e80bwvBtHDJF7YiGENUwTtQwV/aoVV4T4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738764117; c=relaxed/simple;
	bh=v9Plnu6OOzIG8ZNV/AJPE36Q9XrmrKw1tmRNDphhZoU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qmx05vYR7aKSCYieesP5Q8g/YcRvsr0dXfvw7mdBbZRW/YuXehEnFpLg10NI0rcwGtHrmpMPihWH8vlingjafe1NmOApLpVit6CCEZA2GX2vYzi32kB0gLpdaaQJtjfLxhpx/lqiwwWPjW5oMYm3IbcdzLEVgRSOIXCLaPJgrpE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t2u8sWlD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t2u8sWlD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D734CC4CED1;
	Wed,  5 Feb 2025 14:01:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738764117;
	bh=v9Plnu6OOzIG8ZNV/AJPE36Q9XrmrKw1tmRNDphhZoU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t2u8sWlDD9lxwWxdkZGxamHjwzOvaKqdiz0H2yIREBDZjT/qq7sRWJk9LvAqTf/HF
	 RhzFbAyKmq07w4ipkZm5UKwlFVU44Il1gXu1jvLCpCmnsCS7e2FbIN3FfPYY7vaODv
	 UPdaqQdjaI2M3K23Q4NlraVM3fswMWcQ/5+TR2nY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Derek Foreman <derek.foreman@collabora.com>,
	Andy Yan <andy.yan@rock-chips.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 049/623] drm/rockchip: vop2: Fix the mixer alpha setup for layer 0
Date: Wed,  5 Feb 2025 14:36:31 +0100
Message-ID: <20250205134458.106425182@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Yan <andy.yan@rock-chips.com>

[ Upstream commit 6b4dfdcde3573a12b72d2869dabd4ca37ad7e9c7 ]

The alpha setup should start from the second layer, the current calculation
starts incorrectly from the first layer, a negative offset will be obtained
in the following formula:

offset = (mixer_id + zpos - 1) * 0x10

Fixes: 604be85547ce ("drm/rockchip: Add VOP2 driver")
Tested-by: Derek Foreman <derek.foreman@collabora.com>
Signed-off-by: Andy Yan <andy.yan@rock-chips.com>
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Link: https://patchwork.freedesktop.org/patch/msgid/20241209122943.2781431-7-andyshrk@163.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/rockchip/rockchip_drm_vop2.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/gpu/drm/rockchip/rockchip_drm_vop2.c b/drivers/gpu/drm/rockchip/rockchip_drm_vop2.c
index 594923303a850..630a204440ba8 100644
--- a/drivers/gpu/drm/rockchip/rockchip_drm_vop2.c
+++ b/drivers/gpu/drm/rockchip/rockchip_drm_vop2.c
@@ -2248,6 +2248,12 @@ static void vop2_setup_alpha(struct vop2_video_port *vp)
 		struct vop2_win *win = to_vop2_win(plane);
 		int zpos = plane->state->normalized_zpos;
 
+		/*
+		 * Need to configure alpha from second layer.
+		 */
+		if (zpos == 0)
+			continue;
+
 		if (plane->state->pixel_blend_mode == DRM_MODE_BLEND_PREMULTI)
 			premulti_en = 1;
 		else
-- 
2.39.5



