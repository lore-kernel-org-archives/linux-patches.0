Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FA462DF9F;
	Tue, 20 Feb 2024 21:35:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708464916; cv=none; b=QoVnJBEL7IpQPTtgFohwY54CF3u7zZ97DADyNY4R9P7A/jjUIbYfbNnlIvn9tVkErtEKPV6JTXeTaUiJ8XRMgwkiZ5XDrJSWY2ePDwD14+c6a7UyOlE4brtstZV6bCsR7Pg5445Hk3uY72rLVffkBhVUAos2d283IYfiEavxoSM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708464916; c=relaxed/simple;
	bh=qIc+apUYueI3Gen5swJuPx0NKJoWgR9Fk/jjAkuHGHY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E40iKWV1Hc7N0WmxnuR/kulYB+nz1102Fl2zCy0L8y7huUvqY/Hs8wX5cs15KL7atmk97pXGrW5my6w6itq0tEHCsAkmOVNOwUHmNCUUPve1w0HvnzbHVcAxgT2nuvxHvfI0HGm2m6i7vCT12P+BwfR+zfUXu/5Cq1Id4p+SyjM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wdr8fwUW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wdr8fwUW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 859D3C433F1;
	Tue, 20 Feb 2024 21:35:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708464915;
	bh=qIc+apUYueI3Gen5swJuPx0NKJoWgR9Fk/jjAkuHGHY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wdr8fwUWF3sP7FH4iO2cP6/vIU5rEjrtSY5X1zMqihOTMBc3cMzu9idDDyFK0/LA9
	 mWbhaFBIziuix9QHvIRQK3UdF1l4oLPlI1kNT2LEfo5SnDntOcqI6sG7wHEBEsWCir
	 YTpIaf2uklFLytHkn4RhVtK+4vjs7x/rX7JGeO9Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eugen Hristev <eugen.hristev@collabora.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.7 177/309] pmdomain: mediatek: fix race conditions with genpd
Date: Tue, 20 Feb 2024 21:55:36 +0100
Message-ID: <20240220205638.690757821@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205633.096363225@linuxfoundation.org>
References: <20240220205633.096363225@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eugen Hristev <eugen.hristev@collabora.com>

commit c41336f4d69057cbf88fed47951379b384540df5 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pmdomain/mediatek/mtk-pm-domains.c |   15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

--- a/drivers/pmdomain/mediatek/mtk-pm-domains.c
+++ b/drivers/pmdomain/mediatek/mtk-pm-domains.c
@@ -561,6 +561,11 @@ static int scpsys_add_subdomain(struct s
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
@@ -570,11 +575,6 @@ static int scpsys_add_subdomain(struct s
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
@@ -588,9 +588,6 @@ static void scpsys_remove_one_domain(str
 {
 	int ret;
 
-	if (scpsys_domain_is_on(pd))
-		scpsys_power_off(&pd->genpd);
-
 	/*
 	 * We're in the error cleanup already, so we only complain,
 	 * but won't emit another error on top of the original one.
@@ -600,6 +597,8 @@ static void scpsys_remove_one_domain(str
 		dev_err(pd->scpsys->dev,
 			"failed to remove domain '%s' : %d - state may be inconsistent\n",
 			pd->genpd.name, ret);
+	if (scpsys_domain_is_on(pd))
+		scpsys_power_off(&pd->genpd);
 
 	clk_bulk_put(pd->num_clks, pd->clks);
 	clk_bulk_put(pd->num_subsys_clks, pd->subsys_clks);


