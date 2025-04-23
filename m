Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAB8D2951CA;
	Wed, 23 Apr 2025 15:17:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745421460; cv=none; b=VXGhftPu+XSMA/IFIJ8mc3TSCeKG0QEW4lFlkqJja6eTHuRQEMKPWApzWBQbXSA7zs2HEyMfP57yIOKjtnS7IRrWeqND4GFOh+0t+ZkWr20gNyXVx4Ql2aVz3F9Z4FFcmIhNaM9S0190Gez1t5gK4/xE2t1h115M1IaXhRzSSJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745421460; c=relaxed/simple;
	bh=IaZeOx38S1rUHNS7LFlezwYUqHJHkoMGjhv1HccdvBk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UO7HEH5icMA0tNnKLP5yCxrjwS38mCsq5Xnpy0ad5ka+m0RnUjhzP/LkJXQvSx2YbvssbOxXKKL7tO3LZT2jjRFkjqj1kJX7DJe4Ud0NoGJQGcrmGRyKVdlxSR7T+tIJpsEIOwXeLwwrusAijV7+lntwvY/3N+TbD+RsegFIXgU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NYMRjptf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NYMRjptf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4506AC4CEE2;
	Wed, 23 Apr 2025 15:17:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745421460;
	bh=IaZeOx38S1rUHNS7LFlezwYUqHJHkoMGjhv1HccdvBk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NYMRjptfzioNQQGPrltoEEPrQdpKXx+EWW0xldlynqT5nrPfn+GDESnI/ypWsQTK9
	 UBBBJap/Cpj+P6PO31NUwftg2taQrijZrpuiF6HyAabjlOsbO37LJ83AXzWmjQ2a1H
	 +BYI+7qeWYtwH2fyUFqjQSbprXJ2TFhW5eXyvCq8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryan ODonoghue <bryan.odonoghue@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.1 139/291] clk: qcom: gdsc: Capture pm_genpd_add_subdomain result code
Date: Wed, 23 Apr 2025 16:42:08 +0200
Message-ID: <20250423142630.091648950@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142624.409452181@linuxfoundation.org>
References: <20250423142624.409452181@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Bryan O'Donoghue <bryan.odonoghue@linaro.org>

commit 65a733464553ea192797b889d1533a1a37216f32 upstream.

Adding a new clause to this if/else I noticed the existing usage of
pm_genpd_add_subdomain() wasn't capturing and returning the result code.

pm_genpd_add_subdomain() returns an int and can fail. Capture that result
code and throw it up the call stack if something goes wrong.

Fixes: 1b771839de05 ("clk: qcom: gdsc: enable optional power domain support")
Cc: stable@vger.kernel.org
Signed-off-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Link: https://lore.kernel.org/r/20250117-b4-linux-next-24-11-18-clock-multiple-power-domains-v10-2-13f2bb656dad@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/clk/qcom/gdsc.c |   40 +++++++++++++++++++++++++++-------------
 1 file changed, 27 insertions(+), 13 deletions(-)

--- a/drivers/clk/qcom/gdsc.c
+++ b/drivers/clk/qcom/gdsc.c
@@ -463,6 +463,23 @@ err_disable_supply:
 	return ret;
 }
 
+static void gdsc_pm_subdomain_remove(struct gdsc_desc *desc, size_t num)
+{
+	struct device *dev = desc->dev;
+	struct gdsc **scs = desc->scs;
+	int i;
+
+	/* Remove subdomains */
+	for (i = num - 1; i >= 0; i--) {
+		if (!scs[i])
+			continue;
+		if (scs[i]->parent)
+			pm_genpd_remove_subdomain(scs[i]->parent, &scs[i]->pd);
+		else if (!IS_ERR_OR_NULL(dev->pm_domain))
+			pm_genpd_remove_subdomain(pd_to_genpd(dev->pm_domain), &scs[i]->pd);
+	}
+}
+
 int gdsc_register(struct gdsc_desc *desc,
 		  struct reset_controller_dev *rcdev, struct regmap *regmap)
 {
@@ -507,30 +524,27 @@ int gdsc_register(struct gdsc_desc *desc
 		if (!scs[i])
 			continue;
 		if (scs[i]->parent)
-			pm_genpd_add_subdomain(scs[i]->parent, &scs[i]->pd);
+			ret = pm_genpd_add_subdomain(scs[i]->parent, &scs[i]->pd);
 		else if (!IS_ERR_OR_NULL(dev->pm_domain))
-			pm_genpd_add_subdomain(pd_to_genpd(dev->pm_domain), &scs[i]->pd);
+			ret = pm_genpd_add_subdomain(pd_to_genpd(dev->pm_domain), &scs[i]->pd);
+		if (ret)
+			goto err_pm_subdomain_remove;
 	}
 
 	return of_genpd_add_provider_onecell(dev->of_node, data);
+
+err_pm_subdomain_remove:
+	gdsc_pm_subdomain_remove(desc, i);
+
+	return ret;
 }
 
 void gdsc_unregister(struct gdsc_desc *desc)
 {
-	int i;
 	struct device *dev = desc->dev;
-	struct gdsc **scs = desc->scs;
 	size_t num = desc->num;
 
-	/* Remove subdomains */
-	for (i = num - 1; i >= 0; i--) {
-		if (!scs[i])
-			continue;
-		if (scs[i]->parent)
-			pm_genpd_remove_subdomain(scs[i]->parent, &scs[i]->pd);
-		else if (!IS_ERR_OR_NULL(dev->pm_domain))
-			pm_genpd_remove_subdomain(pd_to_genpd(dev->pm_domain), &scs[i]->pd);
-	}
+	gdsc_pm_subdomain_remove(desc, num);
 	of_genpd_del_provider(dev->of_node);
 }
 


