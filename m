Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DFEB42A9B;
	Tue, 27 May 2025 17:40:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748367627; cv=none; b=JD/AQiK5Yy1OLUvXBGWn6qyFFwjS1mp21YgGeTmy4aWzgEqEsdpyWXUTtAkk2EVeHpUpG5sFrU/V3hmEsmrfWdwbgG+DU9hK7IGj6sWR+vwJpOH5GW+99RuSrKJLN5Vc8Z7HA6DJSMyu75YEtF8uT/e8laI+W4h5pW61tbrrCwY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748367627; c=relaxed/simple;
	bh=d5PN463wYmTk71twqrtXzfUCwEts+n8bpQH1wkQu3Vs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RqAAVgekN83/jthRCwpAjBF9GIu3BXSLMJwkEET7J7pa+sGXGNnERYtacrdpcq+pSpfJu4K+O3GO6M+jhhNHhL6lcnNjdw5bwRmOHt4YCVV6w7ZuF0vqahLI8sutYZXwPDWHMcCPUl1BHhqxK6rzEINLu0ybzUEvbE9mxmB2/RY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zZ/CwA3i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zZ/CwA3i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDD18C4CEE9;
	Tue, 27 May 2025 17:40:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748367626;
	bh=d5PN463wYmTk71twqrtXzfUCwEts+n8bpQH1wkQu3Vs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zZ/CwA3i3IJI7nYKkaLX6ODZ+NGt5vZ00X2xyfW/54I8btO8HVU/UoP4NLE0VNtPA
	 XW9DtgbyTgrL8v8ae+mmLP2L1aM189KvWKFpP6IIxhuI9/4HP03vDBimQaA+ptFFQo
	 v55g6CiAgn/JJgrpCahHEBCKcvARkMV5ea/VSwjQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ahmad Fatoum <a.fatoum@pengutronix.de>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 418/783] pmdomain: imx: gpcv2: use proper helper for property detection
Date: Tue, 27 May 2025 18:23:35 +0200
Message-ID: <20250527162530.123538415@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
index 958d34d4821b1..105fcaf13a34c 100644
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



