Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C068526B09D;
	Thu, 13 Feb 2025 14:59:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739458746; cv=none; b=FJNyLMHK13V3SEIMPd0qZAW51jJMUrzpKIPpvcUEkFfcOFg9Ys4+x8cAbThtjaKwJaaSgxuCSj8KDK96gdRtFCy4e6jC1Q4QzOLZXqk5L4EtXUqkVvsD0/ZCa6ys6kFBYTvxSTThqLpDbr2zul1AfhJJwvolYgo4MPG+sqiWnJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739458746; c=relaxed/simple;
	bh=L5ERSfdYb87gzCb9sXF0zOohqEFtR8H6Nr3xZ6AsvFs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=boUmaGkqnKTuWQPlWeC1EhKtPgU0/WeyDhHtI4t7SuLZBUDnFTUQY461pQzHAUNX7bd+h8bI23ozJkolUcLth9RRw/0793dt9O1RKs0AVOswbMED+PhcY/1Pp2HiZs1/knZ0mloLD9tGRPTDXTgMOmGyG2FwOPO0cM2e1rc7374=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MPB3TxCY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MPB3TxCY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2471C4CED1;
	Thu, 13 Feb 2025 14:59:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739458746;
	bh=L5ERSfdYb87gzCb9sXF0zOohqEFtR8H6Nr3xZ6AsvFs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MPB3TxCYe+CERjej/M9CLtKrejgTCfFr4e8/p2amkNsPoS0g1kIdE2Diu1ksEEgZn
	 kfIKpJjRgGdJdFDpLaAolUtuemvdii88MFmpWsqzSHHhLIKvHoQe6o9pixTcWQ8/66
	 YL6O7WMVqniL2OPjeVWTU+VV/j60Qc/HeHTBWwk0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxime Ripard <mripard@kernel.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 034/443] drm/bridge: ite-it66121: use eld_mutex to protect access to connector->eld
Date: Thu, 13 Feb 2025 15:23:19 +0100
Message-ID: <20250213142441.942018462@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142440.609878115@linuxfoundation.org>
References: <20250213142440.609878115@linuxfoundation.org>
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

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit 39ead6e02ea7d19b421e9d42299d4293fed3064e ]

Reading access to connector->eld can happen at the same time the
drm_edid_to_eld() updates the data. Take the newly added eld_mutex in
order to protect connector->eld from concurrent access.

Reviewed-by: Maxime Ripard <mripard@kernel.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20241206-drm-connector-eld-mutex-v2-3-c9bce1ee8bea@linaro.org
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/ite-it66121.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/bridge/ite-it66121.c b/drivers/gpu/drm/bridge/ite-it66121.c
index 35ae3f0e8f51f..940083e5d2ddb 100644
--- a/drivers/gpu/drm/bridge/ite-it66121.c
+++ b/drivers/gpu/drm/bridge/ite-it66121.c
@@ -1450,8 +1450,10 @@ static int it66121_audio_get_eld(struct device *dev, void *data,
 		dev_dbg(dev, "No connector present, passing empty EDID data");
 		memset(buf, 0, len);
 	} else {
+		mutex_lock(&ctx->connector->eld_mutex);
 		memcpy(buf, ctx->connector->eld,
 		       min(sizeof(ctx->connector->eld), len));
+		mutex_unlock(&ctx->connector->eld_mutex);
 	}
 	mutex_unlock(&ctx->lock);
 
-- 
2.39.5



