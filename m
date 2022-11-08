Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F413C15CAE
	for <patches@lists.linux.dev>; Tue,  8 Nov 2022 14:02:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42DD4C433C1;
	Tue,  8 Nov 2022 14:02:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667916122;
	bh=Vmo3ZHg1pN7KwuHV1CJhSuXf8BQVVmcDqJbW4/gHbJg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Qsc6FvXcJ9ct+JWAsJHwml/i3Dea/a7/Qcwr59IH+O79dNd4wAjfAsPrSPG7vkGXi
	 Tw9cswTaHhvqqCJXH7U+GA17Ocglf49XIwn33iykqi+LwXbaGjOjwWs4XnPhNUaWxw
	 Z/4sya3VACzKFAOAvKJIL1Ug33dGUEUraMHqgC+w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Dafna Hirschfeld <dafna@fastmail.com>,
	Paul Elder <paul.elder@ideasonboard.com>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 069/144] media: rkisp1: Dont pass the quantization to rkisp1_csm_config()
Date: Tue,  8 Nov 2022 14:39:06 +0100
Message-Id: <20221108133348.189690530@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133345.346704162@linuxfoundation.org>
References: <20221108133345.346704162@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

[ Upstream commit 711d91497e203b058cf0a08c0f7d41c04efbde76 ]

The rkisp1_csm_config() function takes a pointer to the rkisp1_params
structure which contains the quantization value. There's no need to pass
it separately to the function. Drop it from the function parameters.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Reviewed-by: Dafna Hirschfeld <dafna@fastmail.com>
Reviewed-by: Paul Elder <paul.elder@ideasonboard.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/rockchip/rkisp1/rkisp1-params.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/media/platform/rockchip/rkisp1/rkisp1-params.c b/drivers/media/platform/rockchip/rkisp1/rkisp1-params.c
index 8fa5b0abf1f9..8461e88c1288 100644
--- a/drivers/media/platform/rockchip/rkisp1/rkisp1-params.c
+++ b/drivers/media/platform/rockchip/rkisp1/rkisp1-params.c
@@ -751,7 +751,7 @@ static void rkisp1_ie_enable(struct rkisp1_params *params, bool en)
 	}
 }
 
-static void rkisp1_csm_config(struct rkisp1_params *params, bool full_range)
+static void rkisp1_csm_config(struct rkisp1_params *params)
 {
 	static const u16 full_range_coeff[] = {
 		0x0026, 0x004b, 0x000f,
@@ -765,7 +765,7 @@ static void rkisp1_csm_config(struct rkisp1_params *params, bool full_range)
 	};
 	unsigned int i;
 
-	if (full_range) {
+	if (params->quantization == V4L2_QUANTIZATION_FULL_RANGE) {
 		for (i = 0; i < ARRAY_SIZE(full_range_coeff); i++)
 			rkisp1_write(params->rkisp1, full_range_coeff[i],
 				     RKISP1_CIF_ISP_CC_COEFF_0 + i * 4);
@@ -1235,11 +1235,7 @@ static void rkisp1_params_config_parameter(struct rkisp1_params *params)
 	rkisp1_param_set_bits(params, RKISP1_CIF_ISP_HIST_PROP,
 			      rkisp1_hst_params_default_config.mode);
 
-	/* set the  range */
-	if (params->quantization == V4L2_QUANTIZATION_FULL_RANGE)
-		rkisp1_csm_config(params, true);
-	else
-		rkisp1_csm_config(params, false);
+	rkisp1_csm_config(params);
 
 	spin_lock_irq(&params->config_lock);
 
-- 
2.35.1



