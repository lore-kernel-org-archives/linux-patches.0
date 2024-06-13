Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 993391448DA;
	Thu, 13 Jun 2024 11:58:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718279891; cv=none; b=s6sZkLCKIojNpIYq14Ir3rG1hoVdC1nc8yx/Ev9dGtQp4M73ThdhgkkvntfjxFpYYKs3qMXHDnDluS5qv5/Jtz3ecQMT2vmOVZhh/ByFUwsSSP7uwVguH7UXojDpkE/LKOaAzMqANdcrd+Zt4nDc9oO1JZ80tnLccL+JqTmu1LY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718279891; c=relaxed/simple;
	bh=M8fweLmCN3II2gSCTmsERsE1gP+Zl2vxypiCe1OgEyE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=La+nlq1aW8t1pfhDsEe2Tc5sDUAP2LUmWU2XwQq2VHWtVkjSi5hbbqoPkqe+HE2jbrZ2YYpuP4AES8CUFlbXHjnB/P+UFtrJuOTOKSUBLI/ipcoKSWjwAjDPD2qIa8i57uulAm0rTweT1yxGHD+hGzeXkiSF7uRZy5iGORwbIhE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d3ilpfOG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d3ilpfOG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1902CC2BBFC;
	Thu, 13 Jun 2024 11:58:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718279891;
	bh=M8fweLmCN3II2gSCTmsERsE1gP+Zl2vxypiCe1OgEyE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d3ilpfOG2jH0fMw49Ugpky1G44j9jBPkVRTdfyixvfaekff0NyE91V1r/8JP+K0yH
	 Bw6X2UBZGu+CVZRRev9GoqmaU7bbvunuXoZdW9C+/2IfGg6N/bLF1dUqVvJ2V3/ILy
	 M42Q4kbhYzyqGDMp/BgV4kp82yhrIcUiCAjW9VNs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Justin Green <greenjustin@chromium.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	CK Hu <ck.hu@mediatek.com>,
	Chun-Kuang Hu <chunkuang.hu@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 071/202] drm/mediatek: Add 0 size check to mtk_drm_gem_obj
Date: Thu, 13 Jun 2024 13:32:49 +0200
Message-ID: <20240613113230.517582945@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.759341286@linuxfoundation.org>
References: <20240613113227.759341286@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Justin Green <greenjustin@chromium.org>

[ Upstream commit 1e4350095e8ab2577ee05f8c3b044e661b5af9a0 ]

Add a check to mtk_drm_gem_init if we attempt to allocate a GEM object
of 0 bytes. Currently, no such check exists and the kernel will panic if
a userspace application attempts to allocate a 0x0 GBM buffer.

Tested by attempting to allocate a 0x0 GBM buffer on an MT8188 and
verifying that we now return EINVAL.

Fixes: 119f5173628a ("drm/mediatek: Add DRM Driver for Mediatek SoC MT8173.")
Signed-off-by: Justin Green <greenjustin@chromium.org>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Reviewed-by: CK Hu <ck.hu@mediatek.com>
Link: https://patchwork.kernel.org/project/dri-devel/patch/20240307180051.4104425-1-greenjustin@chromium.org/
Signed-off-by: Chun-Kuang Hu <chunkuang.hu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/mediatek/mtk_drm_gem.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/mediatek/mtk_drm_gem.c b/drivers/gpu/drm/mediatek/mtk_drm_gem.c
index 5f87d56d2d1d8..de15cf6105d97 100644
--- a/drivers/gpu/drm/mediatek/mtk_drm_gem.c
+++ b/drivers/gpu/drm/mediatek/mtk_drm_gem.c
@@ -21,6 +21,9 @@ static struct mtk_drm_gem_obj *mtk_drm_gem_init(struct drm_device *dev,
 
 	size = round_up(size, PAGE_SIZE);
 
+	if (size == 0)
+		return ERR_PTR(-EINVAL);
+
 	mtk_gem_obj = kzalloc(sizeof(*mtk_gem_obj), GFP_KERNEL);
 	if (!mtk_gem_obj)
 		return ERR_PTR(-ENOMEM);
-- 
2.43.0



