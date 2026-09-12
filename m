Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13668331A6E;
	Sat, 12 Sep 2026 18:44:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789238645; cv=none; b=ETRMluOSWNS+aNcLBOpqT2XWYNDH5KFUnG8Kva3LYSGiwcuxDHKMkmtaimUVEJH2hQJS4oKJddlvIgCycAhM/SZToiAtCbNtOXjTFPpRdGQMH1iEA+bVB1+akDoPHc81QP6TvDijKBO4vC9k3OPqce8zFcBuSVWgjQOtSQdgoVY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789238645; c=relaxed/simple;
	bh=HIcRXZ30X05ELow8RpkURYQh6tQrezRIZcRij+O+nzQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uOlXDt7QjA5c0EmqacEjeRlBmCkKKEBBH62bfapyYVgklV6tbWhv3s2cE7xJb7x41yIdBQtRXhyl/e2SGf5cqtCRv7r+kV14gqw53jGTrr7ooEp5zkucijdxZehC8HwwWKEH1/c0PbTTTQGeYtvP7Ap+ELFQMLAE9jayu2kzwoI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f4wPZukN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f4wPZukN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0F2F1F000FF;
	Sat, 12 Sep 2026 18:44:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789238644;
	bh=31mn6hNjE5eskFJVsjeofZ3z98Xp3Ke/J4qCXXBehKI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=f4wPZukNCB4IE3+V9G9Bf3LHjUjAh1jaCR2YwZNgvdbpXRhF4y58wK7wZ+xhSNlYE
	 sJbekheeBCqe7YLgJrE04GUzFrBWiYrrtL55qQKHn5R7TYyQ2NCz0KmUQqjUklciny
	 aDCqk/OaVcDffo16hDUrYk0FHnkcAABKR+AF+hIg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Stefan Wahren <wahrenst@gmx.net>,
	Ulf Hansson <ulfh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 505/935] pmdomain: bcm: bcm2835: handle genpd provider registration errors
Date: Sat, 12 Sep 2026 08:58:55 +0200
Message-ID: <20260912065538.399600567@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit a1d9d3b958d69a13783613304f524f489fecdd1f ]

bcm2835_power_probe() initializes all power domains and then registers
the onecell genpd provider, but ignores of_genpd_add_provider_onecell()
failures. Probe can therefore return success even though no provider was
published.

Check the provider registration return value and jump to the existing
cleanup path on failure.

Fixes: 670c672608a1 ("soc: bcm: bcm2835-pm: Add support for power domains under a new binding.")
Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Reviewed-by: Stefan Wahren <wahrenst@gmx.net>
Signed-off-by: Ulf Hansson <ulfh@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/bcm/bcm2835-power.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/soc/bcm/bcm2835-power.c b/drivers/soc/bcm/bcm2835-power.c
index 6a82c66c6674a..4727dfeab7079 100644
--- a/drivers/soc/bcm/bcm2835-power.c
+++ b/drivers/soc/bcm/bcm2835-power.c
@@ -657,7 +657,12 @@ static int bcm2835_power_probe(struct platform_device *pdev)
 	if (ret)
 		goto fail;
 
-	of_genpd_add_provider_onecell(dev->parent->of_node, &power->pd_xlate);
+	ret = of_genpd_add_provider_onecell(dev->parent->of_node,
+					    &power->pd_xlate);
+	if (ret) {
+		dev_err_probe(dev, ret, "failed to add genpd provider\n");
+		goto fail;
+	}
 
 	dev_info(dev, "Broadcom BCM2835 power domains driver");
 	return 0;
-- 
2.53.0



