Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE26028137F;
	Thu, 13 Feb 2025 14:32:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739457163; cv=none; b=Cri40E7439bW+UfqlGMCCTFzDgnjlVQR7JguPVux8FfQhMpAyW8YyGJtcJt1q9R452OrdYn6OY16D6/DemDH5NmIa1vWqWaod9sDxk1P6Tt6cShKNgJl68GQ72G93frtTL4kwddMNPZi+b59+BVH5A1PeWgQBLyBC1aHoVkU2aM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739457163; c=relaxed/simple;
	bh=hqa56YLesLW9VFM1BUEDysprGwUQnm+c0NZFJzrKU5g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W6dBh9Gxi1FxVq8/T9MyHiZ+MCkCYCz8jDpn2KA6awtuNAmI5A5Bu0aMlvVLYH6nAPszhpsv+NwW6kKxkVUkptt8MOcKeAeBpcgoG0fpD619CPyEvng5x372Dps8wF176JikC04ZERrdP8zYDw5v4t09FcuzZnCGgzg2PDoZIhE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VYyu0eWL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VYyu0eWL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1ED3CC4CED1;
	Thu, 13 Feb 2025 14:32:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739457162;
	bh=hqa56YLesLW9VFM1BUEDysprGwUQnm+c0NZFJzrKU5g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VYyu0eWLg1ZSRzmGYjmb1ze5j2jZ95gYktjJK/hDymwjrIuyugrUUPFSzTsBPyK/p
	 jpumbuZeoEnBmLcQd5XQ7QLfsjwXGtRYtbnGrx5wkaiKgx8f93CMF4O/WrtB4aUv4l
	 bT13h+L3cEIi8ysO3kQ5Zq2UJXggXjwhb73YcZ+U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxime Ripard <mripard@kernel.org>,
	Raphael Gallais-Pou <rgallaispou@gmail.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 034/422] drm/sti: hdmi: use eld_mutex to protect access to connector->eld
Date: Thu, 13 Feb 2025 15:23:03 +0100
Message-ID: <20250213142437.872373882@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142436.408121546@linuxfoundation.org>
References: <20250213142436.408121546@linuxfoundation.org>
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

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit e99c0b517bcd53cf61f998a3c4291333401cb391 ]

Reading access to connector->eld can happen at the same time the
drm_edid_to_eld() updates the data. Take the newly added eld_mutex in
order to protect connector->eld from concurrent access.

Reviewed-by: Maxime Ripard <mripard@kernel.org>
Acked-by: Raphael Gallais-Pou <rgallaispou@gmail.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20241206-drm-connector-eld-mutex-v2-9-c9bce1ee8bea@linaro.org
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/sti/sti_hdmi.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/sti/sti_hdmi.c b/drivers/gpu/drm/sti/sti_hdmi.c
index 847470f747c0e..3c8f3532c7972 100644
--- a/drivers/gpu/drm/sti/sti_hdmi.c
+++ b/drivers/gpu/drm/sti/sti_hdmi.c
@@ -1225,7 +1225,9 @@ static int hdmi_audio_get_eld(struct device *dev, void *data, uint8_t *buf, size
 	struct drm_connector *connector = hdmi->drm_connector;
 
 	DRM_DEBUG_DRIVER("\n");
+	mutex_lock(&connector->eld_mutex);
 	memcpy(buf, connector->eld, min(sizeof(connector->eld), len));
+	mutex_unlock(&connector->eld_mutex);
 
 	return 0;
 }
-- 
2.39.5



