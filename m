Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A45E81863
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 15:38:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21D23C433D2;
	Wed, 28 Dec 2022 15:38:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672241902;
	bh=Xpr5SKHcy3+AqEw3RM5XcTOQPUOnyOzvq5pbjUEsZ24=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RHjITqgF+l/7+A5VOIaW36c5nIFFSB9WI1a/4fWz2lnpGZ85T/Fmy6HOr2qeFGLuC
	 GzkXuZkw6U91AkellfF3yiCPLS5zrIOUPmzGx2UDI9YDYVCAeTg3ZEfDuflJw9A4Ii
	 ObBs5+TiMtDLNEbgvPuFvUSpLdUvxUklXwoAzWaI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>,
	Robert Foss <robert.foss@linaro.org>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0303/1146] media: camss: Do not attach an already attached power domain on MSM8916 platform
Date: Wed, 28 Dec 2022 15:30:42 +0100
Message-Id: <20221228144338.382941414@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>

[ Upstream commit 3d658980e6dac2af6a024fdb6ded3d7bc44dc9ff ]

The change to dynamically allocated power domains neglected a case of
CAMSS on MSM8916 platform, where a single VFE power domain is neither
attached, linked or managed in runtime in any way explicitly.

This is a special case and it shall be kept as is, because the power
domain management is done outside of the driver, and it's very different
in comparison to all other platforms supported by CAMSS.

Fixes: 6b1814e26989 ("media: camss: Allocate power domain resources dynamically")
Signed-off-by: Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
Reviewed-by: Robert Foss <robert.foss@linaro.org>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/qcom/camss/camss.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/media/platform/qcom/camss/camss.c b/drivers/media/platform/qcom/camss/camss.c
index 1118c40886d5..a157cac72e0a 100644
--- a/drivers/media/platform/qcom/camss/camss.c
+++ b/drivers/media/platform/qcom/camss/camss.c
@@ -1465,6 +1465,14 @@ static int camss_configure_pd(struct camss *camss)
 		return camss->genpd_num;
 	}
 
+	/*
+	 * If a platform device has just one power domain, then it is attached
+	 * at platform_probe() level, thus there shall be no need and even no
+	 * option to attach it again, this is the case for CAMSS on MSM8916.
+	 */
+	if (camss->genpd_num == 1)
+		return 0;
+
 	camss->genpd = devm_kmalloc_array(dev, camss->genpd_num,
 					  sizeof(*camss->genpd), GFP_KERNEL);
 	if (!camss->genpd)
@@ -1698,6 +1706,9 @@ void camss_delete(struct camss *camss)
 
 	pm_runtime_disable(camss->dev);
 
+	if (camss->genpd_num == 1)
+		return;
+
 	for (i = 0; i < camss->genpd_num; i++) {
 		device_link_del(camss->genpd_link[i]);
 		dev_pm_domain_detach(camss->genpd[i], true);
-- 
2.35.1



