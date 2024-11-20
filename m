Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E1521A9B5A;
	Wed, 20 Nov 2024 12:59:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732107547; cv=none; b=h4vr/sViEIHz4wH+tbQgF5XxmSlWCOuJG4mkAAXRKWsUjv7/gsmwSfUwC/tWyhBxNR+/IvOzXLljSyIeyRSxfWTWT64W32ToiOJqYwzJuBzzI3NoYO3c/exDGAwt3OutzKaXuhEMH6Tlg6omE60Va+N2iykUQd2R6F4mLdGHbFU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732107547; c=relaxed/simple;
	bh=dY1kb0QkLwlquYIy0w1DyhLl593jWnz1wgQaUu+whKI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AfDMsqA4ONie6cxTfYIUHSRFpCw2JmLbM1ljJTqLGebVaQ3ZFMQRnHCZsIsTZxOxSPhnWveqYolmErbFw5haFtM3s44zRpshWo+KtNocRqMr/8iTGKAz0zylS9kGypqWEJ9itcx8fzNwhNJfgQi0GPBe3OLrjxfD0nvftSw9etE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SRk8nnGC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SRk8nnGC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63EA5C4CECD;
	Wed, 20 Nov 2024 12:59:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1732107547;
	bh=dY1kb0QkLwlquYIy0w1DyhLl593jWnz1wgQaUu+whKI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SRk8nnGCNo1XPrW1Px2pHLXZiAFaMquJ/8H41shpfRELIbG1Fol/1DRDNkr2vpLzp
	 bCX42RzXpaNYlkXH2rdHGSXa6wbOIPO8IAes2uMWa6h2nj3i7Fg9Qp4Sbp4qmyOwM9
	 hytcvJy/u053jnOFVRaaoZeAzKUpoYQwCVs0KmwU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peng Fan <peng.fan@nxp.com>,
	Stefan Wahren <wahrenst@gmx.net>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.11 086/107] pmdomain: imx93-blk-ctrl: correct remove path
Date: Wed, 20 Nov 2024 13:57:01 +0100
Message-ID: <20241120125631.638323246@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241120125629.681745345@linuxfoundation.org>
References: <20241120125629.681745345@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peng Fan <peng.fan@nxp.com>

commit f7c7c5aa556378a2c8da72c1f7f238b6648f95fb upstream.

The check condition should be 'i < bc->onecell_data.num_domains', not
'bc->onecell_data.num_domains' which will make the look never finish
and cause kernel panic.

Also disable runtime to address
"imx93-blk-ctrl 4ac10000.system-controller: Unbalanced pm_runtime_enable!"

Fixes: e9aa77d413c9 ("soc: imx: add i.MX93 media blk ctrl driver")
Signed-off-by: Peng Fan <peng.fan@nxp.com>
Reviewed-by: Stefan Wahren <wahrenst@gmx.net>
Cc: stable@vger.kernel.org
Message-ID: <20241101101252.1448466-1-peng.fan@oss.nxp.com>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pmdomain/imx/imx93-blk-ctrl.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/pmdomain/imx/imx93-blk-ctrl.c
+++ b/drivers/pmdomain/imx/imx93-blk-ctrl.c
@@ -313,7 +313,9 @@ static void imx93_blk_ctrl_remove(struct
 
 	of_genpd_del_provider(pdev->dev.of_node);
 
-	for (i = 0; bc->onecell_data.num_domains; i++) {
+	pm_runtime_disable(&pdev->dev);
+
+	for (i = 0; i < bc->onecell_data.num_domains; i++) {
 		struct imx93_blk_ctrl_domain *domain = &bc->domains[i];
 
 		pm_genpd_remove(&domain->genpd);


