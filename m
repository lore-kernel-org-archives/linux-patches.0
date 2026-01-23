Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3645A29D28F;
	Fri, 23 Jan 2026 18:20:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769192443; cv=none; b=uIVipCP3mnW+jVPyfBjeCXuFsSGElPm2d9loTRVPhDbdxdIsH3FyszdpGUIZ2Ztyr0doK5SwlDd1Vg5i4HOVhvhDReLlmhObA5psNWBqCkeWeBlomFQvafIt2KqkOjbFkH3QB62cePjzRyEA+2CnWzEhrDjLh2XbqRYHcZSdAWA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769192443; c=relaxed/simple;
	bh=cdSJ0d0jGsz67FUmn0GDLjca8jr8Uhj3PHIoyx1a8OA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WKOYnD+FSqMssgqCAc4lMnq4r2UmqjmhUD/6jIb0sntFbKubPBEq15frcB4Nm1dgyT923hrYeXsB7iKIhQB/bsev1Msrvjw1e8kWRHkZGGKgOTqzBQ1XXBL+aSlpI11xvQdZlObfW4JdMuyLbQco1U9qtiW12pkxRD/4rtWkAVc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IUi6T+RO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IUi6T+RO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD49BC19423;
	Fri, 23 Jan 2026 18:20:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769192443;
	bh=cdSJ0d0jGsz67FUmn0GDLjca8jr8Uhj3PHIoyx1a8OA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IUi6T+ROVWZsA7PFugl4Cr44lS2ybCZiEEer5AwDOPjHZWrn+T1/4aSODJfC6sXje
	 fkgAQ3VRJGAtfNvYUjdrMdKMGfNpPK4NmyeWEwFPrBg4v7yCyjGJlnZW3LetDJ6KTI
	 RMHxr4rtQX5j/aN6KtZ6WdDGJZ8/0hKpA7ye/LzKXX/haBXP4uuEtsP7JzGGP59M1p
	 25eixTowWjU+mRMPa9x4QAF6Qubuhg3yjEWJEspML+YIf+SBb1JSk2CGWXt1Rkszug
	 WqCP0dg5TSu100dc6KLj9/fFVLB4NRH3pRVykdJgWEcSMNuhHQ6NJAFW1OtqdZPFcG
	 SGLyHf+xzZ6LQ==
From: Stephen Boyd <sboyd@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	=?UTF-8?q?N=C3=ADcolas=20F=2E=20R=2E=20A=2E=20Prado?= <nfraprado@collabora.com>
Subject: [PATCH 05/10] spmi: mtk-pmif: Add support for MT8196 SPMI Controller
Date: Fri, 23 Jan 2026 10:20:33 -0800
Message-ID: <20260123182039.224314-6-sboyd@kernel.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20260123182039.224314-1-sboyd@kernel.org>
References: <20260123182039.224314-1-sboyd@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>

Add support for the SPMI controller found in the MT8196 SoC:
this supports SPMI 2.0 and features two SPMI buses.

Reviewed-by: Nícolas F. R. A. Prado <nfraprado@collabora.com>
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
---
 drivers/spmi/spmi-mtk-pmif.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/spmi/spmi-mtk-pmif.c b/drivers/spmi/spmi-mtk-pmif.c
index 624611dd4849..1048420b5afb 100644
--- a/drivers/spmi/spmi-mtk-pmif.c
+++ b/drivers/spmi/spmi-mtk-pmif.c
@@ -636,6 +636,14 @@ static const struct pmif_data mt8195_pmif_arb = {
 	.soc_chan = 2,
 };
 
+static const struct pmif_data mt8196_pmif_arb = {
+	.regs = mt8195_regs,
+	.spmimst_regs = mt8195_spmi_regs,
+	.soc_chan = 2,
+	.spmi_ver = 2,
+	.num_spmi_buses = 2,
+};
+
 static int mtk_spmi_irq_init(struct device_node *node,
 			     const struct pmif_data *pdata,
 			     struct pmif_bus *pbus)
@@ -833,6 +841,9 @@ static const struct of_device_id mtk_spmi_match_table[] = {
 	}, {
 		.compatible = "mediatek,mt8195-spmi",
 		.data = &mt8195_pmif_arb,
+	}, {
+		.compatible = "mediatek,mt8196-spmi",
+		.data = &mt8196_pmif_arb,
 	}, {
 		/* sentinel */
 	},
-- 
https://git.kernel.org/pub/scm/linux/kernel/git/clk/linux.git
https://git.kernel.org/pub/scm/linux/kernel/git/sboyd/spmi.git

