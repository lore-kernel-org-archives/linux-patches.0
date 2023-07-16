Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23A1C8F70
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 19:56:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9847EC433C7;
	Sun, 16 Jul 2023 19:56:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689537376;
	bh=IA/oBXGg0gv5duBELxPN/dxTexwPl1owgMdVSyG/mHc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SPzUB2XchEpsm/r6U0M5sSwez2g2XPCvHe3gAeuPAuPQ3vIG8kVJF63N4GufckSJQ
	 BHoZaoVjor7m45NFr1IJ8g9/8vfkv8iDub/48EG2P4MfrSP+iZ+3KL9Zd5/Lm97Cnq
	 ijZv/KPItqZrQqV4jKW64b1EiXU4o+RSpG1Bd4oI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 073/800] PM: domains: Move the verification of in-params from genpd_add_device()
Date: Sun, 16 Jul 2023 21:38:46 +0200
Message-ID: <20230716194950.798523426@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194949.099592437@linuxfoundation.org>
References: <20230716194949.099592437@linuxfoundation.org>
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



