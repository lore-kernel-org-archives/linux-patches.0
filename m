Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98D4E3FB3B;
	Thu, 13 Feb 2025 15:21:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739460099; cv=none; b=uPm/n6QS8PSflfKQdUdeqsqvZ5rMKRPXy1R2kluWyNjv+Vd82vXi1CyPUBassls4P20jQVPt1eUQGtFIqp7MbAydbJnVWkDArgSsE/r1ETLzIcn8WT9/PBa/kqG91GQ9vuzC3FNXZC6o9WkxALgW3lUQpo09YXnS4tzDFMJJcZs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739460099; c=relaxed/simple;
	bh=O45R/26DId1UNxq7gky2q5orQc9DpBAWRdFAc4W92jk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YWdVfIGPyBo06oGO7wvYmT2R4fA6w4ZRFYV4zRgXHDPg9Eb7ll2PLVMG94XAq1t1CZsIheOCDRdg+0URKzjt4jwJ06c6iqgBvluTKFSfbscmeKwGUalA1KRTWz9g1PBgTyxiRryxl4CMaR1RBu05+tKarg8HSGMGA2tbUqD+zk4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QuKW9pjC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QuKW9pjC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0656FC4CED1;
	Thu, 13 Feb 2025 15:21:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739460099;
	bh=O45R/26DId1UNxq7gky2q5orQc9DpBAWRdFAc4W92jk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QuKW9pjCCSWd5YiqRFNClYc+WXA/+wK5xiJr9cRSpVF0ibvbH48C3/npoWvypwogf
	 OcPUTjeyg/tE8vkiXCgOv0o39rs5qQ5YXIjdaQT38A1sQyDYX8Qj/2KieaEOcYc1LJ
	 KWSiT0Qi+oU93uxzKcBmSGH72OBpmzTQB9Q/QC2M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxime Ripard <mripard@kernel.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 015/273] drm/bridge: ite-it66121: use eld_mutex to protect access to connector->eld
Date: Thu, 13 Feb 2025 15:26:27 +0100
Message-ID: <20250213142407.964280058@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142407.354217048@linuxfoundation.org>
References: <20250213142407.354217048@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 8f5846b76d594..2381cd1cba879 100644
--- a/drivers/gpu/drm/bridge/ite-it66121.c
+++ b/drivers/gpu/drm/bridge/ite-it66121.c
@@ -1452,8 +1452,10 @@ static int it66121_audio_get_eld(struct device *dev, void *data,
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



