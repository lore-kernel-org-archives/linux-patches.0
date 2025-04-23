Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7A7E263F2D;
	Wed, 23 Apr 2025 15:03:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745420590; cv=none; b=F7z0azx37jOPRbPRSKc2efrFk1DdMFPIe0F8UsG38YV485ciZOMs3m67YRJCTEZUitzl07VMr64oSLeCJnxHT/ILQ7+j6EVO+gkZ5RLYCgOA/ZKkOfeKKzLTHvXU+dAsmKYyh3SY10exwZK6nc54blhLEh29hsdik9qNwHF2M3Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745420590; c=relaxed/simple;
	bh=o62NYw+JbA7SXYimpVcp1ddg/BNwKybROR4ZyGKPXvQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a9jjK9ovdJ4BO7yVvStUd2c0vDC9i5IrU8A8aMMvVRSM7GP0v/VWM9oqgaAmu5WeOLSZpWoHCpxxFJECNWqCrnE/LJBWZtcZkbplmBJG2pTFrohbgY9bDIYeVcLhOzRVxIKzFu1ojXSojbVSbeJ4SoDDhI6cT7QQyOWz2cCWWBE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sZlv5aLR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sZlv5aLR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 378D9C4CEE2;
	Wed, 23 Apr 2025 15:03:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745420590;
	bh=o62NYw+JbA7SXYimpVcp1ddg/BNwKybROR4ZyGKPXvQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sZlv5aLRxjfpbnv5NVX8nulCM6yFOW8hgKixCfrS+nrNi6NdHg3S815pOOD6OgQTE
	 uzFFlakfLxmPPn7IhRgiqSgsxeLBn6B9P9g8Xm6QpOgfJjJ3whvCD0AzCTXLp6YPCM
	 nb7UdE2QYh5K3p7mu6m2OVCeDURZKwvL+ELha/os=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abhinav Kumar <quic_abhinavk@quicinc.com>,
	Jessica Zhang <quic_jesszhan@quicinc.com>,
	Maxime Ripard <mripard@kernel.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 091/393] drm: allow encoder mode_set even when connectors change for crtc
Date: Wed, 23 Apr 2025 16:39:47 +0200
Message-ID: <20250423142647.052116742@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142643.246005366@linuxfoundation.org>
References: <20250423142643.246005366@linuxfoundation.org>
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

From: Abhinav Kumar <quic_abhinavk@quicinc.com>

[ Upstream commit 7e182cb4f5567f53417b762ec0d679f0b6f0039d ]

In certain use-cases, a CRTC could switch between two encoders
and because the mode being programmed on the CRTC remains
the same during this switch, the CRTC's mode_changed remains false.
In such cases, the encoder's mode_set also gets skipped.

Skipping mode_set on the encoder for such cases could cause an issue
because even though the same CRTC mode was being used, the encoder
type could have changed like the CRTC could have switched from a
real time encoder to a writeback encoder OR vice-versa.

Allow encoder's mode_set to happen even when connectors changed on a
CRTC and not just when the mode changed.

Signed-off-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Signed-off-by: Jessica Zhang <quic_jesszhan@quicinc.com>
Reviewed-by: Maxime Ripard <mripard@kernel.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20241211-abhinavk-modeset-fix-v3-1-0de4bf3e7c32@quicinc.com
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_atomic_helper.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/drm_atomic_helper.c b/drivers/gpu/drm/drm_atomic_helper.c
index 554d4468aa7c0..f3681970887cc 100644
--- a/drivers/gpu/drm/drm_atomic_helper.c
+++ b/drivers/gpu/drm/drm_atomic_helper.c
@@ -1373,7 +1373,7 @@ crtc_set_mode(struct drm_device *dev, struct drm_atomic_state *old_state)
 		mode = &new_crtc_state->mode;
 		adjusted_mode = &new_crtc_state->adjusted_mode;
 
-		if (!new_crtc_state->mode_changed)
+		if (!new_crtc_state->mode_changed && !new_crtc_state->connectors_changed)
 			continue;
 
 		drm_dbg_atomic(dev, "modeset on [ENCODER:%d:%s]\n",
-- 
2.39.5



