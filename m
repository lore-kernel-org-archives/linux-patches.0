Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1AEC79C9
	for <patches@lists.linux.dev>; Thu, 12 Jan 2023 14:22:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07B0EC433F1;
	Thu, 12 Jan 2023 14:22:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673533338;
	bh=hFbmR7gR+7jajMcgCu5cDRzh/eQ8Iz8PMcJQW5e1N3c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eFiwT0M06SPpPKfHUT5RReued8IOWbsKDcq/ZT1zAyflq7fh64FkRxXaWAsmsCbWm
	 d8BWfmtnajUwqAZRiaXKOS3dj1c2R337OCrQgks5ps1Dhr4AYmzGNdzNSq8AkQOuqL
	 tUkKuAq0UhLmP+pkXMy9Xsq3tB4mj+hmqVFXW9Nk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mukesh Ojha <quic_mojha@quicinc.com>,
	Luca Weiss <luca.weiss@fairphone.com>,
	Caleb Connolly <caleb.connolly@linaro.org>,
	Sibi Sankar <quic_sibis@quicinc.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 447/783] remoteproc: qcom_q6v5_pas: disable wakeup on probe fail or remove
Date: Thu, 12 Jan 2023 14:52:43 +0100
Message-Id: <20230112135544.970179672@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Luca Weiss <luca.weiss@fairphone.com>

[ Upstream commit 9a70551996e699fda262e8d54bbd41739d7aad6d ]

Leaving wakeup enabled during probe fail (-EPROBE_DEFER) or remove makes
the subsequent probe fail.

[    3.749454] remoteproc remoteproc0: releasing 3000000.remoteproc
[    3.752949] qcom_q6v5_pas: probe of 3000000.remoteproc failed with error -17
[    3.878935] remoteproc remoteproc0: releasing 4080000.remoteproc
[    3.887602] qcom_q6v5_pas: probe of 4080000.remoteproc failed with error -17
[    4.319552] remoteproc remoteproc0: releasing 8300000.remoteproc
[    4.332716] qcom_q6v5_pas: probe of 8300000.remoteproc failed with error -17

Fix this by disabling wakeup in both cases so the driver can properly
probe on the next try.

Fixes: a781e5aa5911 ("remoteproc: core: Prevent system suspend during remoteproc recovery")
Fixes: dc86c129b4fb ("remoteproc: qcom: pas: Mark devices as wakeup capable")
Reviewed-by: Mukesh Ojha <quic_mojha@quicinc.com>
Signed-off-by: Luca Weiss <luca.weiss@fairphone.com>
Reviewed-by: Caleb Connolly <caleb.connolly@linaro.org>
Reviewed-by: Sibi Sankar <quic_sibis@quicinc.com>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20221118090816.100012-1-luca.weiss@fairphone.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/remoteproc/qcom_q6v5_pas.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/remoteproc/qcom_q6v5_pas.c b/drivers/remoteproc/qcom_q6v5_pas.c
index 0678b417707e..99b206b00456 100644
--- a/drivers/remoteproc/qcom_q6v5_pas.c
+++ b/drivers/remoteproc/qcom_q6v5_pas.c
@@ -472,6 +472,7 @@ static int adsp_probe(struct platform_device *pdev)
 detach_active_pds:
 	adsp_pds_detach(adsp, adsp->active_pds, adsp->active_pd_count);
 free_rproc:
+	device_init_wakeup(adsp->dev, false);
 	rproc_free(rproc);
 
 	return ret;
@@ -487,6 +488,7 @@ static int adsp_remove(struct platform_device *pdev)
 	qcom_remove_sysmon_subdev(adsp->sysmon);
 	qcom_remove_smd_subdev(adsp->rproc, &adsp->smd_subdev);
 	qcom_remove_ssr_subdev(adsp->rproc, &adsp->ssr_subdev);
+	device_init_wakeup(adsp->dev, false);
 	rproc_free(adsp->rproc);
 
 	return 0;
-- 
2.35.1



