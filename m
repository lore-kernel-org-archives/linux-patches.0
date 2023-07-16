Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B82A58F40
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:33:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F333C433C7;
	Sun, 16 Jul 2023 20:33:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689539630;
	bh=u+cQd26uKkOKwcSL9XUh9w6PH96y/Megmw+RFZwc3H4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ELqDd2D+oQxFUaq65OzVZVEIPtrUheRB1u34gYoRitttMUvenglJGT2PKN5GC9VTr
	 kDFawEuV27tkUfo7otkEioh+uK6Mg0CGVDHSiUlV2tApVSoKxPF3C1Fqa3fy6nWNsm
	 /HVC3j5dbzYk+61bXMnrmy7gJ/1C0o4dS6cOaCPU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 048/591] PM: domains: Move the verification of in-params from genpd_add_device()
Date: Sun, 16 Jul 2023 21:43:07 +0200
Message-ID: <20230716194925.128050221@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194923.861634455@linuxfoundation.org>
References: <20230716194923.861634455@linuxfoundation.org>
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
index b33fc322e0928..56ceba4698024 100644
--- a/drivers/base/power/domain.c
+++ b/drivers/base/power/domain.c
@@ -1624,9 +1624,6 @@ static int genpd_add_device(struct generic_pm_domain *genpd, struct device *dev,
 
 	dev_dbg(dev, "%s()\n", __func__);
 
-	if (IS_ERR_OR_NULL(genpd) || IS_ERR_OR_NULL(dev))
-		return -EINVAL;
-
 	gpd_data = genpd_alloc_dev_data(dev, gd);
 	if (IS_ERR(gpd_data))
 		return PTR_ERR(gpd_data);
@@ -1668,6 +1665,9 @@ int pm_genpd_add_device(struct generic_pm_domain *genpd, struct device *dev)
 {
 	int ret;
 
+	if (!genpd || !dev)
+		return -EINVAL;
+
 	mutex_lock(&gpd_list_lock);
 	ret = genpd_add_device(genpd, dev, dev);
 	mutex_unlock(&gpd_list_lock);
@@ -2514,6 +2514,9 @@ int of_genpd_add_device(struct of_phandle_args *genpdspec, struct device *dev)
 	struct generic_pm_domain *genpd;
 	int ret;
 
+	if (!dev)
+		return -EINVAL;
+
 	mutex_lock(&gpd_list_lock);
 
 	genpd = genpd_get_from_provider(genpdspec);
-- 
2.39.2



