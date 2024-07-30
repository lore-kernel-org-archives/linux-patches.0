Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F2AD1A6195;
	Tue, 30 Jul 2024 16:54:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722358448; cv=none; b=evrQAuBn53pe/e6ppG0YX+/qzWuPOXwaTgMv0+tk9p0IaDRkrhf/qtEzPjTh9ScdcAwLDjhIhg2UPcoQXBpTH3V9M8L8DGh78PZyN/6g4or3YL2iiyPjNRRKsHDM43P1/MEOojkJrQ/OfAgm0349vrOOlVt0kliESOcDqj/oHtA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722358448; c=relaxed/simple;
	bh=Xd5Lf4vnHCoG4pWj4R/wTekavn0LiR6pzTOgUk+iWQk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VdWsrB3i4Bq6PojLGXEDbNAaH4Nuut/Tc5Y0rVgLb4XCaPGCWY+ZLJ3cZAy8RMSk5Nn0yQW8myD9MF1g+VcBKBTzb1ruyvvaQvKUzC59VNl6ILLv0NGuImGZBDHhY2DN/FOyiK8lP5MAoiD3fSwkjiY666bbiP3IAKrImIhOL8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jLSK8+65; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jLSK8+65"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AF3FC32782;
	Tue, 30 Jul 2024 16:54:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722358448;
	bh=Xd5Lf4vnHCoG4pWj4R/wTekavn0LiR6pzTOgUk+iWQk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jLSK8+65ENyMFt0JpGQYOkZNoojbpIEMhi9eZTSMhd/Ib9ht6hQJ+IIovhr417bJS
	 qPVLzU/+N4NkygdpJkKyUDHkmE6AYzJFGyAXjHLpswUveCTyx2p30n/Dyia3WvXwTd
	 NY/2G25A7bM1XPDRWcaGygv3kk4nf6vAvjAHan3E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Walle <mwalle@kernel.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Jani Nikula <jani.nikula@intel.com>,
	Chun-Kuang Hu <chunkuang.hu@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 360/809] drm/mediatek/dp: Fix spurious kfree()
Date: Tue, 30 Jul 2024 17:43:56 +0200
Message-ID: <20240730151738.866543556@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Walle <mwalle@kernel.org>

[ Upstream commit 8ad49a92cff4bab13eb2f2725243f5f31eff3f3b ]

drm_edid_to_sad() might return an error or just zero. If that is the
case, we must not free the SADs because there was no allocation in
the first place.

Fixes: dab12fa8d2bd ("drm/mediatek/dp: fix memory leak on ->get_edid callback audio detection")
Signed-off-by: Michael Walle <mwalle@kernel.org>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Reviewed-by: Jani Nikula <jani.nikula@intel.com>
Link: https://patchwork.kernel.org/project/linux-mediatek/patch/20240604083337.1879188-1-mwalle@kernel.org/
Signed-off-by: Chun-Kuang Hu <chunkuang.hu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/mediatek/mtk_dp.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/mediatek/mtk_dp.c b/drivers/gpu/drm/mediatek/mtk_dp.c
index 536366956447a..ada12927bbacf 100644
--- a/drivers/gpu/drm/mediatek/mtk_dp.c
+++ b/drivers/gpu/drm/mediatek/mtk_dp.c
@@ -2073,9 +2073,15 @@ static const struct drm_edid *mtk_dp_edid_read(struct drm_bridge *bridge,
 		 */
 		const struct edid *edid = drm_edid_raw(drm_edid);
 		struct cea_sad *sads;
+		int ret;
 
-		audio_caps->sad_count = drm_edid_to_sad(edid, &sads);
-		kfree(sads);
+		ret = drm_edid_to_sad(edid, &sads);
+		/* Ignore any errors */
+		if (ret < 0)
+			ret = 0;
+		if (ret)
+			kfree(sads);
+		audio_caps->sad_count = ret;
 
 		/*
 		 * FIXME: This should use connector->display_info.has_audio from
-- 
2.43.0



