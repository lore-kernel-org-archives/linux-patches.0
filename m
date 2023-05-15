Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8454CFBE7
	for <patches@lists.linux.dev>; Mon, 15 May 2023 17:23:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF09BC433D2;
	Mon, 15 May 2023 17:23:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684171413;
	bh=Pyqsw5IXrPmyOBnapPVlztltsAHgDZ2SFc8qaCQf+fY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Uv8cSkXVo1MhI9LMWiDP0v9TQlZj2d/LjzXxZLGekhZJJIw7TryII3fe7o0Tsxi/Q
	 WenXIOVsc+IxRC2PQ8UwDA3DGBz6tl5i4c3KSeyCn2pnOJsAujx4e1SBMjn0JYIstb
	 mKnHpE6332IDEQXckNa5oZmwPYXNvR7hsxTmkAR4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abhinav Kumar <quic_abhinavk@quicinc.com>,
	Johan Hovold <johan+linaro@kernel.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Subject: [PATCH 6.2 171/242] drm/msm: fix NULL-deref on snapshot tear down
Date: Mon, 15 May 2023 18:28:17 +0200
Message-Id: <20230515161727.009032843@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161721.802179972@linuxfoundation.org>
References: <20230515161721.802179972@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Johan Hovold <johan+linaro@kernel.org>

commit a465353b9250802f87b97123e33a17f51277f0b1 upstream.

In case of early initialisation errors and on platforms that do not use
the DPU controller, the deinitilisation code can be called with the kms
pointer set to NULL.

Fixes: 98659487b845 ("drm/msm: add support to take dpu snapshot")
Cc: stable@vger.kernel.org      # 5.14
Cc: Abhinav Kumar <quic_abhinavk@quicinc.com>
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Patchwork: https://patchwork.freedesktop.org/patch/525099/
Link: https://lore.kernel.org/r/20230306100722.28485-4-johan+linaro@kernel.org
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/msm/msm_drv.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/msm/msm_drv.c
+++ b/drivers/gpu/drm/msm/msm_drv.c
@@ -241,7 +241,8 @@ static int msm_drm_uninit(struct device
 		msm_fbdev_free(ddev);
 #endif
 
-	msm_disp_snapshot_destroy(ddev);
+	if (kms)
+		msm_disp_snapshot_destroy(ddev);
 
 	drm_mode_config_cleanup(ddev);
 


