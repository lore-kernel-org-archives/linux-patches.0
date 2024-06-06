Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D4AA1BB69B;
	Thu,  6 Jun 2024 14:18:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683492; cv=none; b=u3tVwZIoJgB0T7zdoLtddb7D0OwXzDxY3Vd75WT0PHwaFXatFxg+M0NLleRoTXr/CYjTSOFpkzjLNJezPAeeAOqeSiATZcvV8cb5cXims/BuhDwp48F8wq+85YuZCITPN0vjKY+FrvXHH1K4DyU5UE3akWik630I/TlY5kG+6G0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683492; c=relaxed/simple;
	bh=irDl9U10VWg6h4GZu3JLtXpACoWqiYZi72IKlnZGWEM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k6fWMtAEf0/mE0lY2xwYv9+zd/JNeMOqi3UsyR0seecQVAPy2q4xNXgKilZ4rm30sNelN0rKYRSbFev6qNkzKN3a5qLpBu8oMX/80Ac0dZ3aXa7d2khgJceeJiva6yKEggkXog5YIaGq15wuL5jAY5mfoBFB299e4LtcVM3HuVI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X0sdsFrR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X0sdsFrR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6A49C2BD10;
	Thu,  6 Jun 2024 14:18:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683491;
	bh=irDl9U10VWg6h4GZu3JLtXpACoWqiYZi72IKlnZGWEM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X0sdsFrRax8y2bqr8N3LvF2n3wdjncO0yRIDaFfkyX1RT7/4P2YabXEwPRHUY9t8c
	 7WmIEOVC//L2sMAUi3+MY4vhxx/UE2T8M4PUTPZ7Co10RAYJ5w6DAnLyko0O5K1PKI
	 jZ7L59tFGaSZ7B4r/pSSS+M4U0AIZhWlDC0m1Jn8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wojciech Macek <wmacek@chromium.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	CK Hu <ck.hu@mediatek.com>,
	Chun-Kuang Hu <chunkuang.hu@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 372/473] drm/mediatek: dp: Fix mtk_dp_aux_transfer return value
Date: Thu,  6 Jun 2024 16:05:01 +0200
Message-ID: <20240606131712.188852452@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131659.786180261@linuxfoundation.org>
References: <20240606131659.786180261@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 4bea46ae4dbfb..c24eeb7ffde7d 100644
--- a/drivers/gpu/drm/mediatek/mtk_dp.c
+++ b/drivers/gpu/drm/mediatek/mtk_dp.c
@@ -2058,7 +2058,7 @@ static ssize_t mtk_dp_aux_transfer(struct drm_dp_aux *mtk_aux,
 
 	if (mtk_dp->bridge.type != DRM_MODE_CONNECTOR_eDP &&
 	    !mtk_dp->train_info.cable_plugged_in) {
-		ret = -EAGAIN;
+		ret = -EIO;
 		goto err;
 	}
 
-- 
2.43.0



