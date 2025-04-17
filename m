Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3B3A257AD8;
	Thu, 17 Apr 2025 18:35:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744914931; cv=none; b=T/wbKNVIFbYvBqkSLxgGcwKL2obpQ68PCmTY/qajGFoW/uHb0eRbOto4fl0dq6m86ppYVsO2bqit261FxXTCLEL2KTjz6EDPYPq/U2yRcGjVjr4pDOx2MA3nPF/gDSMYNTkJrKT+l4rqc9NzyPOhPP4c9XHU70nKt4JVrNzL7Pk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744914931; c=relaxed/simple;
	bh=pvdUWoW6AO1Mx/nm3dPfpIvJq8QrmcSi8DEnB+Ah2AM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KQFtxiy4aHTZ1IWmDC9KRV34UxQ5Wp3IZ0NdtryTU5WmsjQIF76h+9Ga8yF7hFdLAtkrWskqHCdfg9JOrDFLTOBZIXuFKzgeQtH0DLrvUmjjbZEbIfOr5c4+xftvdS/yCMCdPNEZ00jdUqD91b0ejrsw18Iuq49hSSPT7nAbmk8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pICD6rAR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pICD6rAR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CD65C4CEE7;
	Thu, 17 Apr 2025 18:35:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744914930;
	bh=pvdUWoW6AO1Mx/nm3dPfpIvJq8QrmcSi8DEnB+Ah2AM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pICD6rARcw73+hO0/3KCVXVEH3Ef77vN+EuF4U3vvp2XrW9lsDyG59SCDSMzZeblj
	 9WxVUdFFsqhULVx6U2eXhsaUs6pqg8cahBgpyfmozTjM3tx36aXNNRRisYwdwBBoSE
	 or4VBv1nq0tku06NftccSfrW0ThA89LYBTzFGl8Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryan ODonoghue <bryan.odonoghue@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.13 347/414] clk: qcom: gdsc: Capture pm_genpd_add_subdomain result code
Date: Thu, 17 Apr 2025 19:51:45 +0200
Message-ID: <20250417175125.383742277@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175111.386381660@linuxfoundation.org>
References: <20250417175111.386381660@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
@@ -506,6 +506,23 @@ err_disable_supply:
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
@@ -555,30 +572,27 @@ int gdsc_register(struct gdsc_desc *desc
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
 


