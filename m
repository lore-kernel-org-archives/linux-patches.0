Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 105181519AA;
	Wed,  5 Feb 2025 14:04:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738764245; cv=none; b=d2IfLVnzqG4HkRHZyltKarV9Wvo7NWtNOkITQ8hoZEqK+LcjFpJ+fku8pIn2xKkZU3WgPyG6FvioUcg8/J/SrwMw4zam++ZzbkO7CCz/KgTCxsrjb1EU+AouHZJJbPDSzWWeCJfVSeSUG4qS0U8FZCMd/jt2s47wOdEeaTfrWek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738764245; c=relaxed/simple;
	bh=irSJUiisFWwi/TrKrl8B0gWM1ygxrACN2IW2KbmgF4c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KyqrmEwUmkOnslbysUuv2Ku8S23jLU9gHCV61KLKqng+gyJ4JzmPQ+BpWCCGsYKbcYTjLnSuDs+YHfABwwoVcfni3DSMVFHDIw/nuSh2XJPhL2/KWNLVynYTMqjL44G5XmlKtqbMjWEBFANvhmCrkZtMEK2hRcA2wfsUmskm7y8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XMlx+bY5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XMlx+bY5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AA35C4CED1;
	Wed,  5 Feb 2025 14:04:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738764244;
	bh=irSJUiisFWwi/TrKrl8B0gWM1ygxrACN2IW2KbmgF4c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XMlx+bY5DVTs36ErR4yWpQIaB8Gqi0GjkSg4ZEphRhbZH7oQjt1s6WOziTVh1si/u
	 tjaNOBmOD2UMH+GBq8HeNdnzD8Q5M2jP0TtKeTEAlXzy8OK7IwkZ4n/jlqZxrlQDP0
	 hcAAKP4ODB52SHKCIEtZ1xc7iE0B84pEOrNx9IeQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Yan <andy.yan@rock-chips.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 060/623] drm/rockchip: vop2: Check linear format for Cluster windows on rk3566/8
Date: Wed,  5 Feb 2025 14:36:42 +0100
Message-ID: <20250205134458.522475516@linuxfoundation.org>
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
index 68b5c438cdaba..2abc68fe2d1ff 100644
--- a/drivers/gpu/drm/rockchip/rockchip_drm_vop2.c
+++ b/drivers/gpu/drm/rockchip/rockchip_drm_vop2.c
@@ -550,6 +550,16 @@ static bool rockchip_vop2_mod_supported(struct drm_plane *plane, u32 format,
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



