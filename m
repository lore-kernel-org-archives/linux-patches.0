Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46308BA48
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 18:13:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99FABC433EF;
	Tue,  7 Mar 2023 18:13:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678212811;
	bh=6+FfswvVs2gGDbAwqPIHDDREVeKGJFoUp7uWASgp2rM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f12qEd401KTFULnwJEziGBy3r+c1SJff9uHgYc8ydRtwW9CvtbzkThlDZfHxadSOh
	 zwXMGwRS1V3Z5tJvU6MvO6ymcFGYuBW5aVeEvbQpmTb+w69XkF/UO90O7DSPCluiJC
	 tHXPyR02K0J0mq0JtvFCrc2O4CTIZRxruBpc2+BA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiasheng Jiang <jiasheng@iscas.ac.cn>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 277/885] drm/msm/hdmi: Add missing check for alloc_ordered_workqueue
Date: Tue,  7 Mar 2023 17:53:31 +0100
Message-Id: <20230307170014.039243267@linuxfoundation.org>
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

[ Upstream commit afe4cb96153a0d8003e4e4ebd91b5c543e10df84 ]

Add check for the return value of alloc_ordered_workqueue as it may return
NULL pointer and cause NULL pointer dereference in `hdmi_hdcp.c` and
`hdmi_hpd.c`.

Fixes: c6a57a50ad56 ("drm/msm/hdmi: add hdmi hdcp support (V3)")
Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Patchwork: https://patchwork.freedesktop.org/patch/517211/
Link: https://lore.kernel.org/r/20230106023011.3985-1-jiasheng@iscas.ac.cn
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/hdmi/hdmi.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/gpu/drm/msm/hdmi/hdmi.c b/drivers/gpu/drm/msm/hdmi/hdmi.c
index 8cd5d50639a53..333cedc11f215 100644
--- a/drivers/gpu/drm/msm/hdmi/hdmi.c
+++ b/drivers/gpu/drm/msm/hdmi/hdmi.c
@@ -255,6 +255,10 @@ static struct hdmi *msm_hdmi_init(struct platform_device *pdev)
 	devm_pm_runtime_enable(&pdev->dev);
 
 	hdmi->workq = alloc_ordered_workqueue("msm_hdmi", 0);
+	if (!hdmi->workq) {
+		ret = -ENOMEM;
+		goto fail;
+	}
 
 	hdmi->i2c = msm_hdmi_i2c_init(hdmi);
 	if (IS_ERR(hdmi->i2c)) {
-- 
2.39.2



