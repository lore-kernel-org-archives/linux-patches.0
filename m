Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AC141459F6;
	Wed,  5 Feb 2025 13:55:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738763734; cv=none; b=Vb2jHN7lt6Oajg9eMCG3RbxIoDDdV10YutYjoWQFXYETuL2DZD0VyfXMTXKBDeUTxYs1AGZgCw7MNl4/22VH9/rVnRuMzIuU3xTY5QXl0yJ0zUxBlCZ7DfRgQ0HbjgcQ0BAoo7pHOe9X+PGCCcCbja8Cq+SHVZngHL/ZjSI8SGA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738763734; c=relaxed/simple;
	bh=kfLZ0feUFMfPGh5DQbmeVPpZPdabTkI4m+4NorV/2pQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N7D5YNhda6CuV7y670A41Zt4X600edPMfTzvO26nMwW+Y3Kw10PC1jEpykoe+wep6gvp4Iu4spz4TXjxE12aj7talzgBxP4INvAtPrvdIql9sAR+qekqJRNHEKcid6x40zCq/tQgb0OiO3Cmgls0/w14ULEWr5AXJgXve6h9d/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Mt5JrRoc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Mt5JrRoc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC676C4CED1;
	Wed,  5 Feb 2025 13:55:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738763734;
	bh=kfLZ0feUFMfPGh5DQbmeVPpZPdabTkI4m+4NorV/2pQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Mt5JrRocOtyP285nUKeFJY40+bJDXdhjwfakQcEMQVGUokQ5iIwLSScaXGv1asIAl
	 cz1KCz430RpTqLIwZJ9qGnFHqSqGVGs9rCpjGXZ28Yds1iTPtEb7mCOQWoOANqBu6C
	 9gCkOxrfwCKJ/hq+Ase7vHxM8Qn29Gvcssn7SryQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Yan <andy.yan@rock-chips.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 052/590] drm/rockchip: vop2: Check linear format for Cluster windows on rk3566/8
Date: Wed,  5 Feb 2025 14:36:47 +0100
Message-ID: <20250205134457.246783470@linuxfoundation.org>
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



