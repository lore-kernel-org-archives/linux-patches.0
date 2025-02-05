Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51F9313C9C4;
	Wed,  5 Feb 2025 13:49:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738763340; cv=none; b=FM2l7rJxYsNr3Ionf3gL4KK10zvaXhz6Q33k9Gf0o+S7ARZzNsYLtyefjQwMPDeaNWI7+WCOYk/RnJcRLTzFOzmdlaJp5xbUY5zEtD9XGZzYc4c/5ipfzO0pMDVVkOPz3D/GsvCwMpdTeRJAiCY/RR1Xy1TRAYlX4Mw7iGkKkFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738763340; c=relaxed/simple;
	bh=C0rvdFMZxD5gNwQnQshomLR9dw09NkCp6FeyEB8fIxA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C+QKJxK0Kv5JxVKb5RGP7lilUO0gv5luinXwNGKRuLpiKj+x4/O1cwwP01BOfI5iTqwfvMLIidUUJLd4QvYvquMuvE9jCx5ysonwwTYmDBvq6tnvdNfMACLwf5YJbAYBeXszSPRVb4GP5MzK7RqDNzHFh8U8bfi7k9tFaKBtZYs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0wAbFkxa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0wAbFkxa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0092C4CED1;
	Wed,  5 Feb 2025 13:48:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738763340;
	bh=C0rvdFMZxD5gNwQnQshomLR9dw09NkCp6FeyEB8fIxA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0wAbFkxaSfHp263RfD9cNh5ZzIr8XCP2MMR0eQO1lhHjYe42RN1UjTq6VKYPFQtGs
	 tjnZtdlzVFLKb5RQ6TD4krrs1kXjPckZahBFgmmuJxp+1MeMoQm7S3/Vsu2ZCihlqg
	 JH3Us/i9h7BVB/rFHiqtkhK/cqPf8h0GKUaoY3Ng=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Derek Foreman <derek.foreman@collabora.com>,
	Andy Yan <andy.yan@rock-chips.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 028/393] drm/rockchip: vop2: Fix the mixer alpha setup for layer 0
Date: Wed,  5 Feb 2025 14:39:07 +0100
Message-ID: <20250205134421.377242265@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134420.279368572@linuxfoundation.org>
References: <20250205134420.279368572@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index f8fdbdf52e907..f7a3b05701e9a 100644
--- a/drivers/gpu/drm/rockchip/rockchip_drm_vop2.c
+++ b/drivers/gpu/drm/rockchip/rockchip_drm_vop2.c
@@ -1830,6 +1830,12 @@ static void vop2_setup_alpha(struct vop2_video_port *vp)
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



