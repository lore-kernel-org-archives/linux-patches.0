Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC9561991D3;
	Thu,  6 Jun 2024 14:21:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683676; cv=none; b=KWNgu2TvLNW+cX2gqjsGzXUdYaFYvSwn5s7L9tkt/A8s+c0OL7xsHbBDM9P2ym3BwXnt4aTwQSSwPRActrmYhaeoGi6w7kOAabWlzOYPHFKBKyOYO3lp1fBFjVkniBohv4dcKRNPznV2Ghh3/46Cu/Rr4kGZ4o2DJcWmndOUzGA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683676; c=relaxed/simple;
	bh=KaFDxI31qN4V1KkVl2mjeuitre4M4Wq6CX0qds9yqps=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LQevqYtTdNKsx+S3GvKKHdH+ruY3MAJ/qRN66ra2cYyOn82se6nGMZLghqr9IDK0ILvy+UMDvLtZVaVfD1NsM16cOUO8IOvC9BRiNQB/pkzdkv8YZJf+dPc5QB1Phxv0j2mWgbd0dDo2DKRtTTvGLLvbQLAJlis+J2TkxluJDiU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LW5/Lnqu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LW5/Lnqu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D4AFC2BD10;
	Thu,  6 Jun 2024 14:21:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683676;
	bh=KaFDxI31qN4V1KkVl2mjeuitre4M4Wq6CX0qds9yqps=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LW5/LnquxscQ5Ey3fcTBOtwEgGQ/GZSGN2RuJUABFaji8ckf+PWHuqP7BBJeQOKpe
	 7Lbnovqiuyl2mOG5djXJDqWRPT8IhbJFrKQ++97/ERnFamfLVjfr92JWrFUUU7tWH5
	 1kv73hm0hQyEAVPviX5wH3gRSzLveKbaVGmUIIGg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wojciech Macek <wmacek@chromium.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	CK Hu <ck.hu@mediatek.com>,
	Chun-Kuang Hu <chunkuang.hu@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 574/744] drm/mediatek: dp: Fix mtk_dp_aux_transfer return value
Date: Thu,  6 Jun 2024 16:04:06 +0200
Message-ID: <20240606131750.874154042@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 4052a3133b576..af03a22772fed 100644
--- a/drivers/gpu/drm/mediatek/mtk_dp.c
+++ b/drivers/gpu/drm/mediatek/mtk_dp.c
@@ -2080,7 +2080,7 @@ static ssize_t mtk_dp_aux_transfer(struct drm_dp_aux *mtk_aux,
 
 	if (mtk_dp->bridge.type != DRM_MODE_CONNECTOR_eDP &&
 	    !mtk_dp->train_info.cable_plugged_in) {
-		ret = -EAGAIN;
+		ret = -EIO;
 		goto err;
 	}
 
-- 
2.43.0



