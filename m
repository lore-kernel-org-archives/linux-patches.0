Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3C0B42A9B;
	Tue, 27 May 2025 17:49:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748368196; cv=none; b=TktbXJAIPQrNs9kJxLY1XRYZNNREZzUZ7mTuAy3nuNeyjf4DqBlWyW6/hXfljgA4ERJ7kkCiR5EWj9iWActw24wRMrRAik9dTSbNzt8clBF4q/CxukCqd42+0yc13uf8EbU2O4jwLHXnz/rsik77OdyB6JXLCVMa2DHRGFP50NA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748368196; c=relaxed/simple;
	bh=E5f0YhWKkF2CPFp3YyLKDoPTqQBUq+DdvG8ONSyMgKc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oM15xtvfG34PP2b+uijZVWGHbR/OOe0DHKwp6ChZH1gC/NjLdwfAf2gywe5EREk6vzj+7knpE9eBvIPHlhlCiG/1ju7Meih+nTHdVeFXLyG+e7CRMmKNOILz/c6IgOxrjFd+8FrNIEu4VLyulPUMBwNGk51uFYdmqOO9WzE1+H4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=txhV02YR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="txhV02YR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3697FC4CEE9;
	Tue, 27 May 2025 17:49:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748368196;
	bh=E5f0YhWKkF2CPFp3YyLKDoPTqQBUq+DdvG8ONSyMgKc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=txhV02YR6nWBHVPfgHJ063mktIIJutYZE1vkQZBqQwIaQnKNW6xTBI8u739pUVG8S
	 a1uduWOj//8fOcLb4wmVsD/tqb6l+oizMuOSRRst2HF2Jb7MfHgdBfVTNM/k97ivPA
	 PDaDVb3e1Rp2CSOQ2omcM38nJk6DK5+WA6tYysJo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jessica Zhang <quic_jesszhan@quicinc.com>,
	Maxime Ripard <mripard@kernel.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 629/783] drm: Add valid clones check
Date: Tue, 27 May 2025 18:27:06 +0200
Message-ID: <20250527162538.761635378@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jessica Zhang <quic_jesszhan@quicinc.com>

[ Upstream commit 41b4b11da02157c7474caf41d56baae0e941d01a ]

Check that all encoders attached to a given CRTC are valid
possible_clones of each other.

Signed-off-by: Jessica Zhang <quic_jesszhan@quicinc.com>
Reviewed-by: Maxime Ripard <mripard@kernel.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20241216-concurrent-wb-v4-3-fe220297a7f0@quicinc.com
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_atomic_helper.c | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/drivers/gpu/drm/drm_atomic_helper.c b/drivers/gpu/drm/drm_atomic_helper.c
index 32902f77f00dd..40e4e1b6c9110 100644
--- a/drivers/gpu/drm/drm_atomic_helper.c
+++ b/drivers/gpu/drm/drm_atomic_helper.c
@@ -574,6 +574,30 @@ mode_valid(struct drm_atomic_state *state)
 	return 0;
 }
 
+static int drm_atomic_check_valid_clones(struct drm_atomic_state *state,
+					 struct drm_crtc *crtc)
+{
+	struct drm_encoder *drm_enc;
+	struct drm_crtc_state *crtc_state = drm_atomic_get_new_crtc_state(state,
+									  crtc);
+
+	drm_for_each_encoder_mask(drm_enc, crtc->dev, crtc_state->encoder_mask) {
+		if (!drm_enc->possible_clones) {
+			DRM_DEBUG("enc%d possible_clones is 0\n", drm_enc->base.id);
+			continue;
+		}
+
+		if ((crtc_state->encoder_mask & drm_enc->possible_clones) !=
+		    crtc_state->encoder_mask) {
+			DRM_DEBUG("crtc%d failed valid clone check for mask 0x%x\n",
+				  crtc->base.id, crtc_state->encoder_mask);
+			return -EINVAL;
+		}
+	}
+
+	return 0;
+}
+
 /**
  * drm_atomic_helper_check_modeset - validate state object for modeset changes
  * @dev: DRM device
@@ -745,6 +769,10 @@ drm_atomic_helper_check_modeset(struct drm_device *dev,
 		ret = drm_atomic_add_affected_planes(state, crtc);
 		if (ret != 0)
 			return ret;
+
+		ret = drm_atomic_check_valid_clones(state, crtc);
+		if (ret != 0)
+			return ret;
 	}
 
 	/*
-- 
2.39.5



