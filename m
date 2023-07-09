Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6766522E
	for <patches@lists.linux.dev>; Sun,  9 Jul 2023 11:18:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38F19C433C7;
	Sun,  9 Jul 2023 11:18:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1688901518;
	bh=IA/oBXGg0gv5duBELxPN/dxTexwPl1owgMdVSyG/mHc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2osdI88xmTj3EU3Sm5rIhabHID0jD9+tv0CfmCh/hA04v3s7zzMcMuDhdkDYKS8ok
	 8L5HiTifDMsxWBvg03rapUfTvtnBj0vjmW3sysDDNPLhIymo1Ro5HHWkshj7Dj6z28
	 S1w2GO/7T2iAe6drfBjCIFyr98NOHVvpNYq8jR9A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 049/431] PM: domains: Move the verification of in-params from genpd_add_device()
Date: Sun,  9 Jul 2023 13:09:57 +0200
Message-ID: <20230709111452.261084425@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230709111451.101012554@linuxfoundation.org>
References: <20230709111451.101012554@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ulf Hansson <ulf.hansson@linaro.org>

[ Upstream commit 4384a70c8813e8573d1841fd94eee873f80a7e1a ]

Commit f38d1a6d0025 ("PM: domains: Allocate governor data dynamically
based on a genpd governor") started to use the in-parameters in
genpd_add_device(), without first doing a verification of them.

This isn't really a big problem, as most callers do a verification already.

Therefore, let's drop the verification from genpd_add_device() and make
sure all the callers take care of it instead.

Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Fixes: f38d1a6d0025 ("PM: domains: Allocate governor data dynamically based on a genpd governor")
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/power/domain.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/base/power/domain.c b/drivers/base/power/domain.c
index 51b9d4eaab5ea..5cb2023581d4d 100644
--- a/drivers/base/power/domain.c
+++ b/drivers/base/power/domain.c
@@ -1632,9 +1632,6 @@ static int genpd_add_device(struct generic_pm_domain *genpd, struct device *dev,
 
 	dev_dbg(dev, "%s()\n", __func__);
 
-	if (IS_ERR_OR_NULL(genpd) || IS_ERR_OR_NULL(dev))
-		return -EINVAL;
-
 	gpd_data = genpd_alloc_dev_data(dev, gd);
 	if (IS_ERR(gpd_data))
 		return PTR_ERR(gpd_data);
@@ -1676,6 +1673,9 @@ int pm_genpd_add_device(struct generic_pm_domain *genpd, struct device *dev)
 {
 	int ret;
 
+	if (!genpd || !dev)
+		return -EINVAL;
+
 	mutex_lock(&gpd_list_lock);
 	ret = genpd_add_device(genpd, dev, dev);
 	mutex_unlock(&gpd_list_lock);
@@ -2523,6 +2523,9 @@ int of_genpd_add_device(struct of_phandle_args *genpdspec, struct device *dev)
 	struct generic_pm_domain *genpd;
 	int ret;
 
+	if (!dev)
+		return -EINVAL;
+
 	mutex_lock(&gpd_list_lock);
 
 	genpd = genpd_get_from_provider(genpdspec);
-- 
2.39.2



