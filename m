Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 878ADBA48
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 18:15:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F16F4C433EF;
	Tue,  7 Mar 2023 18:15:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678212930;
	bh=duQg89uPMqHR04oddaNUlefwEp7GrqY2PPYVRwM7fIw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AXvqWvyfrNJI2ZmH98xDQ9X761Ih7Ir80uAASIgVKItOeeES3QL6IkKFvYRUJDMiB
	 bv+H1zEanuime4xVkUrNZkxDUCe+u/wZiRZI4+u9/te3OF1tObCJzmtbwXX1qYSg13
	 XGMfEPcSy+zHc3GaWD+dreWJ3YSgwvZhVlzzCNVI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiasheng Jiang <jiasheng@iscas.ac.cn>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 313/885] drm/msm/mdp5: Add check for kzalloc
Date: Tue,  7 Mar 2023 17:54:07 +0100
Message-Id: <20230307170015.739002119@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jiasheng Jiang <jiasheng@iscas.ac.cn>

[ Upstream commit 13fcfcb2a9a4787fe4e49841d728f6f2e9fa6911 ]

As kzalloc may fail and return NULL pointer,
it should be better to check the return value
in order to avoid the NULL pointer dereference.

Fixes: 1cff7440a86e ("drm/msm: Convert to using __drm_atomic_helper_crtc_reset() for reset.")
Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Patchwork: https://patchwork.freedesktop.org/patch/514154/
Link: https://lore.kernel.org/r/20221206074819.18134-1-jiasheng@iscas.ac.cn
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/disp/mdp5/mdp5_crtc.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/msm/disp/mdp5/mdp5_crtc.c b/drivers/gpu/drm/msm/disp/mdp5/mdp5_crtc.c
index e86421c69bd1f..86036dd4e1e82 100644
--- a/drivers/gpu/drm/msm/disp/mdp5/mdp5_crtc.c
+++ b/drivers/gpu/drm/msm/disp/mdp5/mdp5_crtc.c
@@ -1139,7 +1139,10 @@ static void mdp5_crtc_reset(struct drm_crtc *crtc)
 	if (crtc->state)
 		mdp5_crtc_destroy_state(crtc, crtc->state);
 
-	__drm_atomic_helper_crtc_reset(crtc, &mdp5_cstate->base);
+	if (mdp5_cstate)
+		__drm_atomic_helper_crtc_reset(crtc, &mdp5_cstate->base);
+	else
+		__drm_atomic_helper_crtc_reset(crtc, NULL);
 }
 
 static const struct drm_crtc_funcs mdp5_crtc_no_lm_cursor_funcs = {
-- 
2.39.2



