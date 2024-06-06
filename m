Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2D1619753E;
	Thu,  6 Jun 2024 14:09:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717682982; cv=none; b=Xp0SrnVM552jhn5ILA0jONd7GbxvBwJ4WdYCeYdmu2y0hFMAIzx150NpTjSlL1uKhASbQD7uudb6bSohDXB01UqJZfeJWpFXHwa+PRxkQfVmQFOpUop94FP3aRRhk5cvQS2E9VrO6e3xxmwKNKbzEDVarBKb5dwRse/IcB+yGvw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717682982; c=relaxed/simple;
	bh=CffEr3wslm1qOz3Pbl5gop9UTVXexnvknkF3MqDhDfk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hTbCePZ2MVzBK2+CB3OJVqKBNq6wAXNgMZZTav52QuOw4fMXGBAuI9+DKk2rZVYHngWZprL3wDDXb9RvuC5V+r1uBGboxdXn+7AMWbrqXEhlvF3veWVFfzb3Gl175MWslL7o0D1WS16GurCFu5E40zySno7EOHTzDFer6NpqOGs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S3g/fmH4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S3g/fmH4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D31E3C32781;
	Thu,  6 Jun 2024 14:09:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717682981;
	bh=CffEr3wslm1qOz3Pbl5gop9UTVXexnvknkF3MqDhDfk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S3g/fmH4/gVIp7kHRnMeGlN3wKQhBLVP/CVOA/X5EFr2YND82RNHOSzWKv2Hs/67r
	 F0idZ4aiWyOSIu1m/HwJg87do3h/cYqETvrRtcCNrT6DrWVIdmNQfkIy8QccsuMb0I
	 QWrTOlsqPNUtgBzMswk8KrOnWgfsmJQzWDOG1B7E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wojciech Macek <wmacek@chromium.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	CK Hu <ck.hu@mediatek.com>,
	Chun-Kuang Hu <chunkuang.hu@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 165/374] drm/mediatek: dp: Fix mtk_dp_aux_transfer return value
Date: Thu,  6 Jun 2024 16:02:24 +0200
Message-ID: <20240606131657.434161761@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131651.683718371@linuxfoundation.org>
References: <20240606131651.683718371@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wojciech Macek <wmacek@chromium.org>

[ Upstream commit 8431fff9e0f3fc1c5844cf99a73b49b63ceed481 ]

In case there is no DP device attached to the port the
transfer function should return IO error, similar to what
other drivers do.
In case EAGAIN is returned then any read from /dev/drm_dp_aux
device ends up in an infinite loop as the upper layers
constantly repeats the transfer request.

Fixes: f70ac097a2cf ("drm/mediatek: Add MT8195 Embedded DisplayPort driver")
Signed-off-by: Wojciech Macek <wmacek@chromium.org>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Reviewed-by: CK Hu <ck.hu@mediatek.com>
Link: https://patchwork.kernel.org/project/dri-devel/patch/20240417103819.990512-1-wmacek@chromium.org/
Signed-off-by: Chun-Kuang Hu <chunkuang.hu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/mediatek/mtk_dp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/mediatek/mtk_dp.c b/drivers/gpu/drm/mediatek/mtk_dp.c
index 0ba72102636aa..536366956447a 100644
--- a/drivers/gpu/drm/mediatek/mtk_dp.c
+++ b/drivers/gpu/drm/mediatek/mtk_dp.c
@@ -2104,7 +2104,7 @@ static ssize_t mtk_dp_aux_transfer(struct drm_dp_aux *mtk_aux,
 
 	if (mtk_dp->bridge.type != DRM_MODE_CONNECTOR_eDP &&
 	    !mtk_dp->train_info.cable_plugged_in) {
-		ret = -EAGAIN;
+		ret = -EIO;
 		goto err;
 	}
 
-- 
2.43.0



