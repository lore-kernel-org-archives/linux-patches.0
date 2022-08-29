Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E30CC2F43;
	Mon, 29 Aug 2022 16:55:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D01FAC433C1;
	Mon, 29 Aug 2022 16:55:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1661792103;
	bh=HiXBOm9dvzWK6mHglRBKim5I3iQDy4svVep8E5b0sME=;
	h=From:To:Cc:Subject:Date:From;
	b=FoHQL1KrEzneppmN3SgxX1IImlY1zrOwvKJF+GUdJRm5+H/HpCnTOtgJ6h/aNK/J4
	 JM2GTtzIl/wrW9a9+cmiP629/xcU8pZmfxHUA7R+HulqRJ7dWt7eTLiQnyT+725A5j
	 XcVNJUAlfLSx8hSA29R+DX++apn0uqdeFHVPhTDAUIEDGXcq5yVtMoQiFEKrzn0lWs
	 jCyEob3iychWRCGKEn3iLg7EYBwckUhb1c6jEBku8PHjerkshTRWyowPeiBiv6gVPx
	 L3+bvNz+IWCI1ePD5z1S6HukDWKta+RxSBSwaXEGZg/zGor8U6PgwxWpTskJKfcSTZ
	 7cguOZzgEcctg==
From: Nathan Chancellor <nathan@kernel.org>
To: Rob Clark <robdclark@gmail.com>,
	Abhinav Kumar <quic_abhinavk@quicinc.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Cc: Sean Paul <sean@poorly.run>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Tom Rix <trix@redhat.com>,
	linux-arm-msm@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	freedreno@lists.freedesktop.org,
	linux-kernel@vger.kernel.org,
	llvm@lists.linux.dev,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>
Subject: [PATCH] drm/msm/dsi: Remove use of device_node in dsi_host_parse_dt()
Date: Mon, 29 Aug 2022 09:54:50 -0700
Message-Id: <20220829165450.217628-1-nathan@kernel.org>
X-Mailer: git-send-email 2.37.2
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Clang warns:

  drivers/gpu/drm/msm/dsi/dsi_host.c:1903:14: error: variable 'device_node' is uninitialized when used here [-Werror,-Wuninitialized]
          of_node_put(device_node);
                      ^~~~~~~~~~~
  drivers/gpu/drm/msm/dsi/dsi_host.c:1870:44: note: initialize the variable 'device_node' to silence this warning
          struct device_node *endpoint, *device_node;
                                                    ^
                                                    = NULL
  1 error generated.

device_node's assignment was removed but not all of its uses. Remove the
call to of_node_put() and the variable declaration to clean up the
warning.

Fixes: 5f8cdece42ff ("drm/msm/dsi: switch to DRM_PANEL_BRIDGE")
Link: https://github.com/ClangBuiltLinux/linux/issues/1700
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 drivers/gpu/drm/msm/dsi/dsi_host.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/msm/dsi/dsi_host.c b/drivers/gpu/drm/msm/dsi/dsi_host.c
index 57a4c0fa614b..7fbf391c024f 100644
--- a/drivers/gpu/drm/msm/dsi/dsi_host.c
+++ b/drivers/gpu/drm/msm/dsi/dsi_host.c
@@ -1867,7 +1867,7 @@ static int dsi_host_parse_dt(struct msm_dsi_host *msm_host)
 {
 	struct device *dev = &msm_host->pdev->dev;
 	struct device_node *np = dev->of_node;
-	struct device_node *endpoint, *device_node;
+	struct device_node *endpoint;
 	int ret = 0;
 
 	/*
@@ -1900,8 +1900,6 @@ static int dsi_host_parse_dt(struct msm_dsi_host *msm_host)
 		}
 	}
 
-	of_node_put(device_node);
-
 err:
 	of_node_put(endpoint);
 

base-commit: 5f8cdece42ff0c615e213b6619d29487f9f409d7
-- 
2.37.2

