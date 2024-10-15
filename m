Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7BDB1CACD0;
	Tue, 15 Oct 2024 12:09:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728994141; cv=none; b=b0oB9zfTspY5Ypwmvx+y5nbwPRcOUxWtHBgiSe2QgATuKeqhY7Qj8jDerzVIZm2aHy0JPNjXIN4doQmEK3VQVeBzcYUAic/AMyQE9HWYWYb0iac0JtfWAHaYH2bW9fpcYA/nfwHEMv6FjVVXnPopcvRrY8auYUpH2jTT2Ag+oaE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728994141; c=relaxed/simple;
	bh=DiRSQLXmUmrZG0tqpnF3dHnX8gBGfZ/KScxnVXpDpOY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C94d7WEd3ZPJD7IdFYdvE+WIeeQVs+vPYkG41Dr4XCLiMu5QybB9zn0s4CIrUJYetZ2WWl054xHcv4NT1hdWmpy001PMIme1OU4u0zWsncoRmts/aUqypwpM7MLcfjMdYgkDz39jyqZaTkK+weQkxWH0MRvNRAdUJg/BwmGlvtg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Vd7gG14t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Vd7gG14t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1C92C4CEC6;
	Tue, 15 Oct 2024 12:09:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728994141;
	bh=DiRSQLXmUmrZG0tqpnF3dHnX8gBGfZ/KScxnVXpDpOY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Vd7gG14txcwYgfCYNdij7TwfOWCW1kKkCwuLn41y5FMaDNI+FrjFgbP0u7uBL/CUA
	 6g2LDJLh73CVrlxlXqRjFGHgGxt8ANqsj+KLkY5jYcniK+wkT1mmru25FwptUWXuZw
	 GIJqNX+VmTkm/wCLbPwlhue6ci9ZeS7KfWiMXcKc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rob Clark <robdclark@chromium.org>,
	Daniel Vetter <daniel.vetter@ffwll.ch>,
	Abhinav Kumar <quic_abhinavk@quicinc.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 588/691] drm/crtc: fix uninitialized variable use even harder
Date: Tue, 15 Oct 2024 13:28:56 +0200
Message-ID: <20241015112503.685820393@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rob Clark <robdclark@chromium.org>

[ Upstream commit b6802b61a9d0e99dcfa6fff7c50db7c48a9623d3 ]

DRM_MODESET_LOCK_ALL_BEGIN() has a hidden trap-door (aka retry loop),
which means we can't rely too much on variable initializers.

Fixes: 6e455f5dcdd1 ("drm/crtc: fix uninitialized variable use")
Signed-off-by: Rob Clark <robdclark@chromium.org>
Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Reviewed-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Tested-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org> # sc7180, sdm845
Link: https://patchwork.freedesktop.org/patch/msgid/20240212215534.190682-1-robdclark@gmail.com
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_crtc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/drm_crtc.c b/drivers/gpu/drm/drm_crtc.c
index c5e0c652766c8..e8cee1891fd60 100644
--- a/drivers/gpu/drm/drm_crtc.c
+++ b/drivers/gpu/drm/drm_crtc.c
@@ -832,6 +832,7 @@ int drm_mode_setcrtc(struct drm_device *dev, void *data,
 	connector_set = NULL;
 	fb = NULL;
 	mode = NULL;
+	num_connectors = 0;
 
 	DRM_MODESET_LOCK_ALL_END(dev, ctx, ret);
 
-- 
2.43.0



