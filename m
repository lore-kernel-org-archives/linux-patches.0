Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BEF01459F6;
	Wed,  5 Feb 2025 13:55:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738763747; cv=none; b=k7zWi1sD/d10Rz02YJg/WiO9bN+xnLCdppw3daBuowjJ+Q9uHp574NKCh6rXaEoM++jU4L3vNzIdILI8jVZTv6QVcFVCu0+AJY+ocQO82nrduThOxuEGDTKVWScs3PpL9/Bg42Z+xPuHPmTDC0NZlCqjwlao8MPzpPlQYwNX7Ks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738763747; c=relaxed/simple;
	bh=nombFYdWthUHcIPAl8k1uS3qVQts9MOFUZsjFc25Dsk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uvKjzNwY4MENErqJeqMZOMS07p98oYT8hi/ZXzjzVQB/Q9ats5FWcV7s2I+ei5+Z7I64qmdEBX+/9lvrUlUg1SMlbrq+5gKTzpbyD4Okqc52HId7TX0347yqEIpitmiM2kvDynlMhIBVsJPaYzXp63oylBYCbfnvbfcbjTIODtM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A8/wAgHE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A8/wAgHE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90BBFC4CED1;
	Wed,  5 Feb 2025 13:55:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738763747;
	bh=nombFYdWthUHcIPAl8k1uS3qVQts9MOFUZsjFc25Dsk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A8/wAgHE84/XQvyl/DcUydBHcPwfsz1yZsmZSb2dwKda+fvVQzm3zY+UnL5DErg5T
	 KmJzR2+bu7Hp+PKv76pfxgBFg0Csep4MzcVa4q8UsoINhUfk4PObsgLZM2NI7vqwZN
	 dui1kEIGTKr0TZHSGIcG3gTRawkjnUusMk3zP2z4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Yan <andy.yan@rock-chips.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 053/590] drm/rockchip: vop2: Add check for 32 bpp format for rk3588
Date: Wed,  5 Feb 2025 14:36:48 +0100
Message-ID: <20250205134457.285098962@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Yan <andy.yan@rock-chips.com>

[ Upstream commit 7e8a56c703c67bfa8d3f71a0c1c297bb1252b897 ]

RK3588 only support DRM_FORMAT_XRGB2101010/XBGR2101010 in afbc mode.

Fixes: 5a028e8f062f ("drm/rockchip: vop2: Add support for rk3588")
Signed-off-by: Andy Yan <andy.yan@rock-chips.com>
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Link: https://patchwork.freedesktop.org/patch/msgid/20241214081719.3330518-7-andyshrk@163.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/rockchip/rockchip_drm_vop2.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/gpu/drm/rockchip/rockchip_drm_vop2.c b/drivers/gpu/drm/rockchip/rockchip_drm_vop2.c
index 2abc68fe2d1ff..6082b1c179aeb 100644
--- a/drivers/gpu/drm/rockchip/rockchip_drm_vop2.c
+++ b/drivers/gpu/drm/rockchip/rockchip_drm_vop2.c
@@ -560,6 +560,15 @@ static bool rockchip_vop2_mod_supported(struct drm_plane *plane, u32 format,
 		}
 	}
 
+	if (format == DRM_FORMAT_XRGB2101010 || format == DRM_FORMAT_XBGR2101010) {
+		if (vop2->data->soc_id == 3588) {
+			if (!rockchip_afbc(plane, modifier)) {
+				drm_dbg_kms(vop2->drm, "Only support 32 bpp format with afbc\n");
+				return false;
+			}
+		}
+	}
+
 	if (modifier == DRM_FORMAT_MOD_LINEAR)
 		return true;
 
-- 
2.39.5



