Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0438F13C90B;
	Tue, 25 Jun 2024 10:02:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719309754; cv=none; b=H47ej7WHFBILXe63ggopsTUEYf6Y62hlK3jvLdNOOq1C0Nq3oNCEVsvDoOX85yN13tv3swFZKbO2l1cLboRd9ue15Hn5meVVgFR76LMzMW9EBQwbXHjGhv/qrHxQche1CuK2SCJSFIohoA+XeeRPKhulLIAO2+eoZR03hOlnWB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719309754; c=relaxed/simple;
	bh=se2SVJvfLdFPhbWtXzAPPP+jtcJ60qTqlu2LVEtHiXo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ak3KKV5UDR+eHlx+R5waArBo2qQKzFqtp3iKKKK46Qyj0aTDPixlYIsWpF3MxMyEeq+7mrDIe+sSqV9gJkIQ2BFKnO3XRloDX9PwO8yICN72cY4ugjmEfponwMmYy8OSMfA8eHon9bian0WAauEzh8d0fvgMy/Wevu85FwvziOk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qwp1cRZZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qwp1cRZZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DBD5C32781;
	Tue, 25 Jun 2024 10:02:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719309753;
	bh=se2SVJvfLdFPhbWtXzAPPP+jtcJ60qTqlu2LVEtHiXo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qwp1cRZZlCj8HFSw4dOgopETfLW6gcjJhWezPE8MHieHNgffBOeX47Di7zhbE4jAS
	 AVvRgevfd35J0F5TUDrw3bpIl4BtCu85oYXJTI0q5yP64jcyKx8WNpcCMUedfvB2oi
	 NW4Ndm97i0Ob3J8eaA3TcbDJlAEmbEeVHM9u+fGk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 122/131] pmdomain: ti-sci: Fix duplicate PD referrals
Date: Tue, 25 Jun 2024 11:34:37 +0200
Message-ID: <20240625085530.572327138@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085525.931079317@linuxfoundation.org>
References: <20240625085525.931079317@linuxfoundation.org>
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

From: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>

[ Upstream commit 670c900f69645db394efb38934b3344d8804171a ]

When the dts file has multiple referrers to a single PD (e.g.
simple-framebuffer and dss nodes both point to the DSS power-domain) the
ti-sci driver will create two power domains, both with the same ID, and
that will cause problems as one of the power domains will hide the other
one.

Fix this checking if a PD with the ID has already been created, and only
create a PD for new IDs.

Fixes: efa5c01cd7ee ("soc: ti: ti_sci_pm_domains: switch to use multiple genpds instead of one")
Signed-off-by: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20240415-ti-sci-pd-v1-1-a0e56b8ad897@ideasonboard.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/ti/ti_sci_pm_domains.c | 20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

diff --git a/drivers/soc/ti/ti_sci_pm_domains.c b/drivers/soc/ti/ti_sci_pm_domains.c
index a33ec7eaf23d1..17984a7bffba5 100644
--- a/drivers/soc/ti/ti_sci_pm_domains.c
+++ b/drivers/soc/ti/ti_sci_pm_domains.c
@@ -114,6 +114,18 @@ static const struct of_device_id ti_sci_pm_domain_matches[] = {
 };
 MODULE_DEVICE_TABLE(of, ti_sci_pm_domain_matches);
 
+static bool ti_sci_pm_idx_exists(struct ti_sci_genpd_provider *pd_provider, u32 idx)
+{
+	struct ti_sci_pm_domain *pd;
+
+	list_for_each_entry(pd, &pd_provider->pd_list, node) {
+		if (pd->idx == idx)
+			return true;
+	}
+
+	return false;
+}
+
 static int ti_sci_pm_domain_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
@@ -153,8 +165,14 @@ static int ti_sci_pm_domain_probe(struct platform_device *pdev)
 				break;
 
 			if (args.args_count >= 1 && args.np == dev->of_node) {
-				if (args.args[0] > max_id)
+				if (args.args[0] > max_id) {
 					max_id = args.args[0];
+				} else {
+					if (ti_sci_pm_idx_exists(pd_provider, args.args[0])) {
+						index++;
+						continue;
+					}
+				}
 
 				pd = devm_kzalloc(dev, sizeof(*pd), GFP_KERNEL);
 				if (!pd)
-- 
2.43.0



