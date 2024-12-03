Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04A6D1F8925;
	Tue,  3 Dec 2024 15:45:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733240720; cv=none; b=lz23bdi9/SE1rvN4yrrWtwpxhNI1RBZuTYBxY/HFtQBxHqrIw/y9nT/ONhk3SB7Gc2V/URtkJuov2qnVak/0UkmjOP4WGu10bKxkyGalgJv0EH33k8KNqHBSa/ElbDYgE6NB9yhAgMMSO2uw4NZjnspcVdDA27l32YzlTyCeeTA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733240720; c=relaxed/simple;
	bh=czYKVQGEpX79SOQIpFhJumVF3S1i7bGmhUaoUD7RVnM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=te8ZSTIZRBZArCuFPX5eWs05K742DgdnAcP2/d1JyCr0lrDvferyOtNySkeMwD6efptw4BQbg4PlIyA+4ZNGs2wteD6cX/F4aU8LdsuUMulXr+2D3dba6aWe6Iyi0TJv6XOsWwADY1rywL2AX4i1320HlloWRJscG4eBG5WItjA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vnPUOhFM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vnPUOhFM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68D3DC4CECF;
	Tue,  3 Dec 2024 15:45:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733240719;
	bh=czYKVQGEpX79SOQIpFhJumVF3S1i7bGmhUaoUD7RVnM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vnPUOhFM5KZ0QQ6LwDeUVI6Jv61+4/x06yfT6BxoWrp7cO74fyZKS9pJhxNCDfFvm
	 UjrQNckN1zk28qgUGu+bnIqhkaIHFqZ1rtUMHpm8N4Zg/DsqPRR0ea7ZHrxQfhKKR4
	 frpdLxnqaKSFJhJRIFtLM4T22+X9R4PbkCd2rrgI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pin-yen Lin <treapking@chromium.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Douglas Anderson <dianders@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 217/826] drm/bridge: anx7625: Drop EDID cache on bridge power off
Date: Tue,  3 Dec 2024 15:39:04 +0100
Message-ID: <20241203144752.205769882@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pin-yen Lin <treapking@chromium.org>

[ Upstream commit 00ae002116a14c2e6a342c4c9ae080cdbb9b4b21 ]

The bridge might miss the display change events when it's powered off.
This happens when a user changes the external monitor when the system
is suspended and the embedded controller doesn't not wake AP up.

It's also observed that one DP-to-HDMI bridge doesn't work correctly
when there is no EDID read after it is powered on.

Drop the cache to force an EDID read after system resume to fix this.

Fixes: 8bdfc5dae4e3 ("drm/bridge: anx7625: Add anx7625 MIPI DSI/DPI to DP")
Signed-off-by: Pin-yen Lin <treapking@chromium.org>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20240926092931.3870342-2-treapking@chromium.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/analogix/anx7625.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/bridge/analogix/anx7625.c b/drivers/gpu/drm/bridge/analogix/anx7625.c
index a2e9bb485c366..a2675b121fe44 100644
--- a/drivers/gpu/drm/bridge/analogix/anx7625.c
+++ b/drivers/gpu/drm/bridge/analogix/anx7625.c
@@ -2551,6 +2551,8 @@ static int __maybe_unused anx7625_runtime_pm_suspend(struct device *dev)
 	mutex_lock(&ctx->lock);
 
 	anx7625_stop_dp_work(ctx);
+	if (!ctx->pdata.panel_bridge)
+		anx7625_remove_edid(ctx);
 	anx7625_power_standby(ctx);
 
 	mutex_unlock(&ctx->lock);
-- 
2.43.0



