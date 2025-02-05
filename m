Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98C47142E86;
	Wed,  5 Feb 2025 13:50:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738763429; cv=none; b=YWjTwZ4smVxXDzijj51cJLO7AsrdyfxeOW2KkG1ngU4jWZverAE82FmbvXG6JWvMv3JmEquRsItohHGoGZTnRux6BfHJ0oPnpfKdnQdJAcur594UCmYUJdboTUPY8l7MvgXEr305pN45AmKc5oRTIH3WBq+48L+yygpFifKrHag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738763429; c=relaxed/simple;
	bh=q7t51iha14ddgDxUacYiWE3oE784cQYstbVb8pWx4K8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NJvfpFtSgSP4+vi2/k1EL4fwMhRBsoTbCCTH5adKCbMci1FRLuZwpBxWl78ONRJGDML+RlVaq4xBWdUdnQt9+5ToeLX1GkAG04lZZQ0+hzoaWYUgTz8Dujxxbhpro4B54UfYESHuTjXQ/u7XALDtaHOuyuM6MQ9MO4eai8+/x3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cdo80Wk9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cdo80Wk9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21949C4CED6;
	Wed,  5 Feb 2025 13:50:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738763429;
	bh=q7t51iha14ddgDxUacYiWE3oE784cQYstbVb8pWx4K8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cdo80Wk9YSlc6hTfxAwuggIvPaQ2CbapOv3BN05xHJkhQgTrQeHsS+nAswC8poWHm
	 KtN5xC4KiinQ/sV1dh/vT0zF30uk2Cv1O2CUx14aM0ybtoDHZ/+W8ZfAImJmw/VRpm
	 vBO9TWrnY/jV42KKkxBHEwJA5sYA5P6cDeta8mGM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Yan <andy.yan@rock-chips.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 032/393] drm/rockchip: vop2: Check linear format for Cluster windows on rk3566/8
Date: Wed,  5 Feb 2025 14:39:11 +0100
Message-ID: <20250205134421.531425157@linuxfoundation.org>
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

[ Upstream commit df063c0b8ffbdca486ab2f802e716973985d8f86 ]

The Cluster windows on rk3566/8 only support afbc mode.

Fixes: 604be85547ce ("drm/rockchip: Add VOP2 driver")
Signed-off-by: Andy Yan <andy.yan@rock-chips.com>
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Link: https://patchwork.freedesktop.org/patch/msgid/20241214081719.3330518-6-andyshrk@163.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/rockchip/rockchip_drm_vop2.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/gpu/drm/rockchip/rockchip_drm_vop2.c b/drivers/gpu/drm/rockchip/rockchip_drm_vop2.c
index 724b75cfb6b5b..abd88d2d7cabb 100644
--- a/drivers/gpu/drm/rockchip/rockchip_drm_vop2.c
+++ b/drivers/gpu/drm/rockchip/rockchip_drm_vop2.c
@@ -465,6 +465,16 @@ static bool rockchip_vop2_mod_supported(struct drm_plane *plane, u32 format,
 	if (modifier == DRM_FORMAT_MOD_INVALID)
 		return false;
 
+	if (vop2->data->soc_id == 3568 || vop2->data->soc_id == 3566) {
+		if (vop2_cluster_window(win)) {
+			if (modifier == DRM_FORMAT_MOD_LINEAR) {
+				drm_dbg_kms(vop2->drm,
+					    "Cluster window only supports format with afbc\n");
+				return false;
+			}
+		}
+	}
+
 	if (modifier == DRM_FORMAT_MOD_LINEAR)
 		return true;
 
-- 
2.39.5



