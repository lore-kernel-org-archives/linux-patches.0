Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C37F3E123F;
	Wed, 20 May 2026 17:41:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779298889; cv=none; b=d+/LWwKZYiPR5YYMvQB8TJTRGDktwRcMEuzjCReEsSnz/T/UkaAdYGkMBui2af1Py6TmpFD5o62BSKHl2OHPWLl5rcFkshLy1XQJl6Vj2IqK7xLxUIqOhWOuX/8G4YLzVX/kztWLP9gsPeWai0J8jhhMJejlgb1wzRbuf1etBAo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779298889; c=relaxed/simple;
	bh=CqDyb5hodgn2MmWFEP7TUt5gowsa6cK4kyuxwLugshM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=njyh7vQOKKp+PoJHYKZaCPZ5BRF9DWJFs+/VnXxOzyaQHGH/ewXxMnrjOH3EaMBsxsXKIXjQBLjpZxvCPS6/ul3JJQrMMKty7vryMVWdTHx4oD3aPAGPRjMPgAFA9QzXnanwnpCtXvfJ/qwd/mpHjVBVNxLC88WeYxwhzfKNaO8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eP5Mcgrr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eP5Mcgrr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F1801F00893;
	Wed, 20 May 2026 17:41:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779298888;
	bh=Lv/8NpoFn/bAUGSt3ImQmJVU49qqLVaOzvUVhEhpEwY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eP5McgrrPULcMI+w0jSYlLA3dFkBQSrheB5tP+ApkfTbEDO5SlT5k9pF1ASJHJAl5
	 Is5Wcye92CeU+xF20pBwVm5wnVCqt1lRc1Kxq1TJopZhhxO9L11DTu5BHjqBzf3Kos
	 rEkVanFkeVCau792Sme98AnnFJzgp5ZNTNLPdeBI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Bryan ODonoghue <bod@kernel.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 583/957] clk: qcom: gdsc: Fix error path on registration of multiple pm subdomains
Date: Wed, 20 May 2026 18:17:46 +0200
Message-ID: <20260520162147.173816591@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>

[ Upstream commit 16ba98dace9e7cfe25ad8a314e34befacd91f86f ]

Some pm subdomains may be left in added to a parent domain state, if
gdsc_add_subdomain_list() function fails in the middle and bails from
a GDSC power domain controller registration out.

Fixes: b489235b4dc0 ("clk: qcom: Support attaching GDSCs to multiple parents")
Signed-off-by: Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Reviewed-by: Bryan O'Donoghue <bod@kernel.org>
Link: https://lore.kernel.org/r/20260328012619.832770-1-vladimir.zapolskiy@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/gdsc.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/clk/qcom/gdsc.c b/drivers/clk/qcom/gdsc.c
index 7deabf8400cf6..95aa071202455 100644
--- a/drivers/clk/qcom/gdsc.c
+++ b/drivers/clk/qcom/gdsc.c
@@ -518,10 +518,20 @@ static int gdsc_add_subdomain_list(struct dev_pm_domain_list *pd_list,
 
 		ret = pm_genpd_add_subdomain(genpd, subdomain);
 		if (ret)
-			return ret;
+			goto remove_added_subdomains;
 	}
 
 	return 0;
+
+remove_added_subdomains:
+	for (i--; i >= 0; i--) {
+		struct device *dev = pd_list->pd_devs[i];
+		struct generic_pm_domain *genpd = pd_to_genpd(dev->pm_domain);
+
+		pm_genpd_remove_subdomain(genpd, subdomain);
+	}
+
+	return ret;
 }
 
 static void gdsc_remove_subdomain_list(struct dev_pm_domain_list *pd_list,
-- 
2.53.0



