Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EB3D1DF269;
	Wed, 19 Feb 2025 09:06:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739955966; cv=none; b=jt9FTE8kP3mEbTtljU/Om0eyYebEwYGC/DRyK5ZZJWG+vEkY+YanV1wrnBvRGQZ4vq4vkskPCU7IUq8v1OZPXAu+lBaaYxbr8/5r11mfN/p75A6okBY6zqTLpzKhyU37sScnr9RZFtTqX+w7SutOqGsGJBSOY243sKDI/xsfUlQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739955966; c=relaxed/simple;
	bh=rveYCOSljugGyjzkJawj5EhteHNIWWynscSEf+X0+aY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jR5vHurOg3E3rC7n/h6LB4XAgYWwFB8FPPER5iBnYQsgtWfJLOAQUuFA2+RuM98Tt9fM4BEV3l39vW5oYVNtdokRbv9P+GxoHX1EwNjMHxnompkhcTkHDxbmgg3sURWCABbbX32vmkPgO4D7xGOBOWa783SFGTxgpMFhWUduKjY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jn1TMyRb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jn1TMyRb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF023C4CED1;
	Wed, 19 Feb 2025 09:06:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739955966;
	bh=rveYCOSljugGyjzkJawj5EhteHNIWWynscSEf+X0+aY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jn1TMyRbQFjaHkt7tCqc2Lo9gfT7O+5r5sqDboiGm5s4RcILU211WzdO42WHStXKM
	 adTlEbtfwuTaY3HUWq3W1BtieZZoXfL0euetz0FTrCUM+kIZX7z4Hv571jTaPRJGj1
	 djeqBnXdKS36eUSuyZwsHYWExbN1Go0VlVBou6I4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Derek Foreman <derek.foreman@collabora.com>,
	Andy Yan <andy.yan@rock-chips.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 020/578] drm/rockchip: vop2: Fix the mixer alpha setup for layer 0
Date: Wed, 19 Feb 2025 09:20:24 +0100
Message-ID: <20250219082653.687524832@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 71c961e92c12a..470a39a278b34 100644
--- a/drivers/gpu/drm/rockchip/rockchip_drm_vop2.c
+++ b/drivers/gpu/drm/rockchip/rockchip_drm_vop2.c
@@ -1826,6 +1826,12 @@ static void vop2_setup_alpha(struct vop2_video_port *vp)
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



