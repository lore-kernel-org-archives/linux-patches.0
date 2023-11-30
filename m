Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5AFA54BFB;
	Thu, 30 Nov 2023 16:29:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E1P/BCVs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7124AC433C8;
	Thu, 30 Nov 2023 16:29:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701361766;
	bh=j87Z1vqTmt8bbvbzDxmLpn2zcK56npmmB1c95OgyQTE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E1P/BCVsqzmaPBxSY3jcZh6ek8s1IU1Rf6cidUXsI23LjsMMPfxrv2oQX19ojUdNg
	 uPeqF2jzUpOLyQdEO2ypPDPmVNL52hjjpSCfeJCuq5JWm1wuJfKwIt9gyZ5HdLXvET
	 u2X517YNewrnDHHeboZ4V9LCWk4HrZUsyxDhdwz4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>,
	Robert Foss <robert.foss@linaro.org>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 39/82] media: camss: Split power domain management
Date: Thu, 30 Nov 2023 16:22:10 +0000
Message-ID: <20231130162137.201081652@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231130162135.977485944@linuxfoundation.org>
References: <20231130162135.977485944@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>

[ Upstream commit 46cc031754985ee24034d55687540adb079f8630 ]

There are three cases of power domain management on supported platforms:
1) CAMSS on MSM8916, where a single VFE power domain is operated outside
   of the camss device driver,
2) CAMSS on MSM8996 and SDM630/SDM660, where two VFE power domains are
   managed separately by the camss device driver, the power domains are
   linked and unlinked on demand by their functions vfe_pm_domain_on()
   and vfe_pm_domain_off() respectively,
3) CAMSS on SDM845 and SM8250 platforms, and there are two VFE power
   domains and their parent power domain TITAN_TOP, the latter one
   shall be turned on prior to turning on any of VFE power domains.

Due to a previously missing link between TITAN_TOP and VFEx power domains
in the latter case, which is now fixed by [1], it was decided always to
turn on all found VFE power domains and TITAN_TOP power domain, even if
just one particular VFE is needed to be enabled or none of VFE power
domains are required, for instance the latter case is when vfe_lite is in
use. This misusage becomes more incovenient and clumsy, if next generations
are to be supported, for instance CAMSS on SM8450 has three VFE power
domains.

The change splits the power management support for platforms with TITAN_TOP
parent power domain, and, since 'power-domain-names' property is not
present in camss device tree nodes, the assumption is that the first
N power domains from the 'power-domains' list correspond to VFE power
domains, and, if the number of power domains is greater than number of
non-lite VFEs, then the last power domain from the list is the TITAN_TOP
power domain.

Signed-off-by: Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
Reviewed-by: Robert Foss <robert.foss@linaro.org>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Stable-dep-of: f69791c39745 ("media: qcom: camss: Fix genpd cleanup")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../media/platform/qcom/camss/camss-vfe-170.c | 20 ++++++++++++-
 .../media/platform/qcom/camss/camss-vfe-480.c | 20 ++++++++++++-
 drivers/media/platform/qcom/camss/camss.c     | 30 ++++++++++---------
 3 files changed, 54 insertions(+), 16 deletions(-)

diff --git a/drivers/media/platform/qcom/camss/camss-vfe-170.c b/drivers/media/platform/qcom/camss/camss-vfe-170.c
index 07b64d257512c..f9492b1d16e3e 100644
--- a/drivers/media/platform/qcom/camss/camss-vfe-170.c
+++ b/drivers/media/platform/qcom/camss/camss-vfe-170.c
@@ -671,7 +671,12 @@ static void vfe_isr_wm_done(struct vfe_device *vfe, u8 wm)
  */
 static void vfe_pm_domain_off(struct vfe_device *vfe)
 {
-	/* nop */
+	struct camss *camss = vfe->camss;
+
+	if (vfe->id >= camss->vfe_num)
+		return;
+
+	device_link_del(camss->genpd_link[vfe->id]);
 }
 
 /*
@@ -680,6 +685,19 @@ static void vfe_pm_domain_off(struct vfe_device *vfe)
  */
 static int vfe_pm_domain_on(struct vfe_device *vfe)
 {
+	struct camss *camss = vfe->camss;
+	enum vfe_line_id id = vfe->id;
+
+	if (id >= camss->vfe_num)
+		return 0;
+
+	camss->genpd_link[id] = device_link_add(camss->dev, camss->genpd[id],
+						DL_FLAG_STATELESS |
+						DL_FLAG_PM_RUNTIME |
+						DL_FLAG_RPM_ACTIVE);
+	if (!camss->genpd_link[id])
+		return -EINVAL;
+
 	return 0;
 }
 
diff --git a/drivers/media/platform/qcom/camss/camss-vfe-480.c b/drivers/media/platform/qcom/camss/camss-vfe-480.c
index ab42600f7a745..72f5cfeeb49bf 100644
--- a/drivers/media/platform/qcom/camss/camss-vfe-480.c
+++ b/drivers/media/platform/qcom/camss/camss-vfe-480.c
@@ -478,7 +478,12 @@ static void vfe_isr_wm_done(struct vfe_device *vfe, u8 wm)
  */
 static void vfe_pm_domain_off(struct vfe_device *vfe)
 {
-	/* nop */
+	struct camss *camss = vfe->camss;
+
+	if (vfe->id >= camss->vfe_num)
+		return;
+
+	device_link_del(camss->genpd_link[vfe->id]);
 }
 
 /*
@@ -487,6 +492,19 @@ static void vfe_pm_domain_off(struct vfe_device *vfe)
  */
 static int vfe_pm_domain_on(struct vfe_device *vfe)
 {
+	struct camss *camss = vfe->camss;
+	enum vfe_line_id id = vfe->id;
+
+	if (id >= camss->vfe_num)
+		return 0;
+
+	camss->genpd_link[id] = device_link_add(camss->dev, camss->genpd[id],
+						DL_FLAG_STATELESS |
+						DL_FLAG_PM_RUNTIME |
+						DL_FLAG_RPM_ACTIVE);
+	if (!camss->genpd_link[id])
+		return -EINVAL;
+
 	return 0;
 }
 
diff --git a/drivers/media/platform/qcom/camss/camss.c b/drivers/media/platform/qcom/camss/camss.c
index 5057b2c4cf6c4..f7fa84f623282 100644
--- a/drivers/media/platform/qcom/camss/camss.c
+++ b/drivers/media/platform/qcom/camss/camss.c
@@ -1453,7 +1453,6 @@ static const struct media_device_ops camss_media_ops = {
 static int camss_configure_pd(struct camss *camss)
 {
 	struct device *dev = camss->dev;
-	int last_pm_domain = 0;
 	int i;
 	int ret;
 
@@ -1484,32 +1483,34 @@ static int camss_configure_pd(struct camss *camss)
 	if (!camss->genpd_link)
 		return -ENOMEM;
 
+	/*
+	 * VFE power domains are in the beginning of the list, and while all
+	 * power domains should be attached, only if TITAN_TOP power domain is
+	 * found in the list, it should be linked over here.
+	 */
 	for (i = 0; i < camss->genpd_num; i++) {
 		camss->genpd[i] = dev_pm_domain_attach_by_id(camss->dev, i);
 		if (IS_ERR(camss->genpd[i])) {
 			ret = PTR_ERR(camss->genpd[i]);
 			goto fail_pm;
 		}
+	}
 
-		camss->genpd_link[i] = device_link_add(camss->dev, camss->genpd[i],
-						       DL_FLAG_STATELESS | DL_FLAG_PM_RUNTIME |
-						       DL_FLAG_RPM_ACTIVE);
-		if (!camss->genpd_link[i]) {
-			dev_pm_domain_detach(camss->genpd[i], true);
+	if (i > camss->vfe_num) {
+		camss->genpd_link[i - 1] = device_link_add(camss->dev, camss->genpd[i - 1],
+							   DL_FLAG_STATELESS | DL_FLAG_PM_RUNTIME |
+							   DL_FLAG_RPM_ACTIVE);
+		if (!camss->genpd_link[i - 1]) {
 			ret = -EINVAL;
 			goto fail_pm;
 		}
-
-		last_pm_domain = i;
 	}
 
 	return 0;
 
 fail_pm:
-	for (i = 0; i < last_pm_domain; i++) {
-		device_link_del(camss->genpd_link[i]);
+	for (--i ; i >= 0; i--)
 		dev_pm_domain_detach(camss->genpd[i], true);
-	}
 
 	return ret;
 }
@@ -1709,10 +1710,11 @@ void camss_delete(struct camss *camss)
 	if (camss->genpd_num == 1)
 		return;
 
-	for (i = 0; i < camss->genpd_num; i++) {
-		device_link_del(camss->genpd_link[i]);
+	if (camss->genpd_num > camss->vfe_num)
+		device_link_del(camss->genpd_link[camss->genpd_num - 1]);
+
+	for (i = 0; i < camss->genpd_num; i++)
 		dev_pm_domain_detach(camss->genpd[i], true);
-	}
 }
 
 /*
-- 
2.42.0



