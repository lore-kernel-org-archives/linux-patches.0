Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE19278B61;
	Tue, 27 Feb 2024 14:16:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709043362; cv=none; b=IbReL/mhhI/AJXxSyv58NL0wnzJhJHmVEv3iFMZLhZvXZ+W2+Hiz8KTFshzWWdLStiU/7qbjEYbmO1ZQ3ePz10Fs2BUi1zBspk87Znp9jKlCf0xKWmbZ7m8vlHwHQ8jjdV7UD+tl4WCF7/jkJjkLAN9e9vwqN7vTQJaoe5y1Wjc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709043362; c=relaxed/simple;
	bh=QTdxjl4S0vDuwM362glNowwqOS+ZcNR03nKL1bKuuS8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rLIlDRq+8PldkBneaKwtwIfFZVOngKczDDpbf2RS6lP29zhDkLmpm7lto5COdPD0FWSpdELlJU/qxJj4Q6nUTozJvRMW6+R/0JgQyYVITEbY/TVcOvn9jS3ao0i2hnyelNjzsirovUwibBkn+/SWUk9sFpcYadhGx096NQ+1+6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BQjNQquA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BQjNQquA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E179C433C7;
	Tue, 27 Feb 2024 14:16:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709043362;
	bh=QTdxjl4S0vDuwM362glNowwqOS+ZcNR03nKL1bKuuS8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BQjNQquAaTo3dqS7JqgjAZJZBEzORBK1q7apc06z19Xny83xdgiO/W6wTRsPFk0kN
	 a+2GlQrIPL9mtypgODQrMRwc8PU5GSTSgpiuUp4AXXstIqUmRBjgwIHpaIPf3sw1ry
	 s/jGgPJsRBoBBPAKOEMMQ34r4M3wYtaxLFF+DxzQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eugen Hristev <eugen.hristev@collabora.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 081/195] pmdomain: mediatek: fix race conditions with genpd
Date: Tue, 27 Feb 2024 14:25:42 +0100
Message-ID: <20240227131613.164562141@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131610.391465389@linuxfoundation.org>
References: <20240227131610.391465389@linuxfoundation.org>
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

From: Eugen Hristev <eugen.hristev@collabora.com>

[ Upstream commit c41336f4d69057cbf88fed47951379b384540df5 ]

If the power domains are registered first with genpd and *after that*
the driver attempts to power them on in the probe sequence, then it is
possible that a race condition occurs if genpd tries to power them on
in the same time.
The same is valid for powering them off before unregistering them
from genpd.
Attempt to fix race conditions by first removing the domains from genpd
and *after that* powering down domains.
Also first power up the domains and *after that* register them
to genpd.

Fixes: 59b644b01cf4 ("soc: mediatek: Add MediaTek SCPSYS power domains")
Signed-off-by: Eugen Hristev <eugen.hristev@collabora.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20231225133615.78993-1-eugen.hristev@collabora.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/mediatek/mtk-pm-domains.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/drivers/soc/mediatek/mtk-pm-domains.c b/drivers/soc/mediatek/mtk-pm-domains.c
index 474b272f9b02d..832adb570b501 100644
--- a/drivers/soc/mediatek/mtk-pm-domains.c
+++ b/drivers/soc/mediatek/mtk-pm-domains.c
@@ -499,6 +499,11 @@ static int scpsys_add_subdomain(struct scpsys *scpsys, struct device_node *paren
 			goto err_put_node;
 		}
 
+		/* recursive call to add all subdomains */
+		ret = scpsys_add_subdomain(scpsys, child);
+		if (ret)
+			goto err_put_node;
+
 		ret = pm_genpd_add_subdomain(parent_pd, child_pd);
 		if (ret) {
 			dev_err(scpsys->dev, "failed to add %s subdomain to parent %s\n",
@@ -508,11 +513,6 @@ static int scpsys_add_subdomain(struct scpsys *scpsys, struct device_node *paren
 			dev_dbg(scpsys->dev, "%s add subdomain: %s\n", parent_pd->name,
 				child_pd->name);
 		}
-
-		/* recursive call to add all subdomains */
-		ret = scpsys_add_subdomain(scpsys, child);
-		if (ret)
-			goto err_put_node;
 	}
 
 	return 0;
@@ -526,9 +526,6 @@ static void scpsys_remove_one_domain(struct scpsys_domain *pd)
 {
 	int ret;
 
-	if (scpsys_domain_is_on(pd))
-		scpsys_power_off(&pd->genpd);
-
 	/*
 	 * We're in the error cleanup already, so we only complain,
 	 * but won't emit another error on top of the original one.
@@ -538,6 +535,8 @@ static void scpsys_remove_one_domain(struct scpsys_domain *pd)
 		dev_err(pd->scpsys->dev,
 			"failed to remove domain '%s' : %d - state may be inconsistent\n",
 			pd->genpd.name, ret);
+	if (scpsys_domain_is_on(pd))
+		scpsys_power_off(&pd->genpd);
 
 	clk_bulk_put(pd->num_clks, pd->clks);
 	clk_bulk_put(pd->num_subsys_clks, pd->subsys_clks);
-- 
2.43.0



