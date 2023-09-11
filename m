Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3264B1170E
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 13:52:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3B96C433C8;
	Mon, 11 Sep 2023 13:52:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694440346;
	bh=BSOJ9h+sCSu8MUzd+wySrv4cioS4i83j26G23kPqPSA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Su3xKKKrf8xrR2Mas1UTY+cMl5BoHxqyhkBqaT3edPMC35+fz0aFp77MqReVHwsKw
	 czVAzkYMRvgWmZUtctOITaTr4lhoANcAhFyYR0ZKAmiu7257NLWe5lVxJV7ATy2RVz
	 Is9XPMFbhzitZI5kimMLtszzKluigqKimiGK2+dE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 029/739] OPP: Fix potential null ptr dereference in dev_pm_opp_get_required_pstate()
Date: Mon, 11 Sep 2023 15:37:08 +0200
Message-ID: <20230911134651.882937623@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.921299741@linuxfoundation.org>
References: <20230911134650.921299741@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>

[ Upstream commit 7ddd8deb1c3c0363a7e14fafb5df26e2089a69a5 ]

"opp" pointer is dereferenced before the IS_ERR_OR_NULL() check. Fix it by
removing the dereference to cache opp_table and dereference it directly
where opp_table is used.

This fixes the following smatch warning:

drivers/opp/core.c:232 dev_pm_opp_get_required_pstate() warn: variable
dereferenced before IS_ERR check 'opp' (see line 230)

Fixes: 84cb7ff35fcf ("OPP: pstate is only valid for genpd OPP tables")
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/opp/core.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/opp/core.c b/drivers/opp/core.c
index 3f46e499d615f..98633ccd170a3 100644
--- a/drivers/opp/core.c
+++ b/drivers/opp/core.c
@@ -227,20 +227,18 @@ EXPORT_SYMBOL_GPL(dev_pm_opp_get_level);
 unsigned int dev_pm_opp_get_required_pstate(struct dev_pm_opp *opp,
 					    unsigned int index)
 {
-	struct opp_table *opp_table = opp->opp_table;
-
 	if (IS_ERR_OR_NULL(opp) || !opp->available ||
-	    index >= opp_table->required_opp_count) {
+	    index >= opp->opp_table->required_opp_count) {
 		pr_err("%s: Invalid parameters\n", __func__);
 		return 0;
 	}
 
 	/* required-opps not fully initialized yet */
-	if (lazy_linking_pending(opp_table))
+	if (lazy_linking_pending(opp->opp_table))
 		return 0;
 
 	/* The required OPP table must belong to a genpd */
-	if (unlikely(!opp_table->required_opp_tables[index]->is_genpd)) {
+	if (unlikely(!opp->opp_table->required_opp_tables[index]->is_genpd)) {
 		pr_err("%s: Performance state is only valid for genpds.\n", __func__);
 		return 0;
 	}
-- 
2.40.1



