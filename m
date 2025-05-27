Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11594154C15;
	Tue, 27 May 2025 17:02:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748365334; cv=none; b=CScz8PSt6MS/ZNN/1QPMJl+vZ/NMDCqrno8ckMtq+kPsJ7Hh/w251eCNQ56XHBa9WV9LiEhxTSruouPzHiwP2m2hkCER24DQNgWOdlH5R+5QuEZIT2koUDf4JV/xSlf/VpT2ilq/7ROWUgYk2/KGGulxEuAC1ckYbp0IlR4lHzw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748365334; c=relaxed/simple;
	bh=zN7F5D92SYVT3oMalTUza6LQodrWOle5MaBVVqW65CI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kNYayJkh3kVBZwiJbvXSfu8tq5ClqOCQNWFE4oh6vZSzeEtcP9BU/1bKoA3GTheQ52Qev2NMV+eQo+8DSp8jQuusbn/fL0Pxbl/qRjfD8mPj5gpVb0NUPe/zlg/KfRzioroS5U5+DYQZD25GYgYTzUf8OWTw8oOvTSoSX678zGo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nqK3h1fb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nqK3h1fb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9698BC4CEE9;
	Tue, 27 May 2025 17:02:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748365333;
	bh=zN7F5D92SYVT3oMalTUza6LQodrWOle5MaBVVqW65CI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nqK3h1fbZKFqtBi97obgoRHYdrBzRddgrjXOOW1/xj0FTeD3TShj5WvYQNVo1UFDB
	 nsJOv3hD8sGQ3kW59zxffkVGfKxtZJzVTffSKHV1GTiFnFpzIXGFMHz7hw9IJsoqXS
	 tqxaAFVpQQhK1m5Gp/ZwGzhFSAEpdzb1MaHrQxFs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ahmad Fatoum <a.fatoum@pengutronix.de>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 341/626] pmdomain: imx: gpcv2: use proper helper for property detection
Date: Tue, 27 May 2025 18:23:54 +0200
Message-ID: <20250527162458.869112875@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ahmad Fatoum <a.fatoum@pengutronix.de>

[ Upstream commit 6568cb40e73163fa25e2779f7234b169b2e1a32e ]

Starting with commit c141ecc3cecd7 ("of: Warn when of_property_read_bool()
is used on non-boolean properties"), probing the gpcv2 device on i.MX8M
SoCs leads to warnings when LOCKDEP is enabled.

Fix this by checking property presence with of_property_present as
intended.

Signed-off-by: Ahmad Fatoum <a.fatoum@pengutronix.de>
Link: https://lore.kernel.org/r/20250218-gpcv2-of-property-present-v1-1-3bb1a9789654@pengutronix.de
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pmdomain/imx/gpcv2.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pmdomain/imx/gpcv2.c b/drivers/pmdomain/imx/gpcv2.c
index e03c2cb39a693..0dbf1893abfa3 100644
--- a/drivers/pmdomain/imx/gpcv2.c
+++ b/drivers/pmdomain/imx/gpcv2.c
@@ -1361,7 +1361,7 @@ static int imx_pgc_domain_probe(struct platform_device *pdev)
 	}
 
 	if (IS_ENABLED(CONFIG_LOCKDEP) &&
-	    of_property_read_bool(domain->dev->of_node, "power-domains"))
+	    of_property_present(domain->dev->of_node, "power-domains"))
 		lockdep_set_subclass(&domain->genpd.mlock, 1);
 
 	ret = of_genpd_add_provider_simple(domain->dev->of_node,
-- 
2.39.5



