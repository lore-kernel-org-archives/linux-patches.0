Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BFE233A014
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:03:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301807; cv=none; b=Jc+4Qj6/al5Z+oTX1ct9XVsh2EMTggWNFq0PshaoeE3cnupeO3x9x6eMhTDjK3O9u0ZJL+RXjXI7qDvF6Mo3xSO/rCdYynBa9eL7qH1oLo7WPZUpicNxWEdtVnShAb3Vxc5vGGO1m7wIETiYxKrhfe6VF2PW+8INL2Nh/NhoZlA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301807; c=relaxed/simple;
	bh=iG84cSmXwf7iaN5dapUhfDfS5kTRSvY+qAa+KN6TtBI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PCzwHodM6Gtjxuw3Pc+F2QxKkvI+h5Q1XBWrvBzYh+om2jw4Ebv/p3GMRprcgX/U1kNejePfj6+Olwox+qlKzxXESHkK+YSfPx4UNM7GGR4vK5dRpL2PJ0OFVPmVZ6KpEpX0Tlf8X4esFgybuk54oheQUrOlHeteOLXaLU7GpBg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VY0swf5T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VY0swf5T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7D4AC2BC9E;
	Sat, 28 Feb 2026 18:03:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301807;
	bh=iG84cSmXwf7iaN5dapUhfDfS5kTRSvY+qAa+KN6TtBI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VY0swf5TxbYWO+miA6Q9jVwN2FxPq8BVuum5TDdnNZZL+5FSFqitiDVxVmL2KhtTM
	 XcOWQuXkgi36uiSseWij40H4bzk83IWuRfKQjvJb9Q4kcoF+StGbrS5zupmUBrJPst
	 F/5EeTm3Y/QTnQBsxwGpVwj965m4mZ7fkJTJfh3VhMsphArRSpnl0yu2BO8wv/v+Au
	 6tPJfCqHYZLTNyV9COLycDeN+kVy5DZf8K4fblJT28/CxYMq0aT9B6mGEls6oGBuhP
	 W5D8pr7Fh6XDYldg+wrqp05fYKZcvs4Nyia33yii91YF1Sh1SQuckZawzFISWc+zg5
	 406qKGfIlntfQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Anshumali Gaur <agaur@marvell.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 220/385] octeontx2-af: Fix PF driver crash with kexec kernel booting
Date: Sat, 28 Feb 2026 12:57:22 -0500
Message-ID: <20260228180011.1568201-220-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Anshumali Gaur <agaur@marvell.com>

[ Upstream commit 2d2d574309e3ae84ee794869a5da8b4c38753a94 ]

During a kexec reboot the hardware is not power-cycled, so AF state from
the old kernel can persist into the new kernel. When AF and PF drivers
are built as modules, the PF driver may probe before AF reinitializes
the hardware.

The PF driver treats the RVUM block revision as an indication that AF
initialization is complete. If this value is left uncleared at shutdown,
PF may incorrectly assume AF is ready and access stale hardware state,
leading to a crash.

Clear the RVUM block revision during AF shutdown to avoid PF
mis-detecting AF readiness after kexec.

Fixes: 54494aa5d1e6 ("octeontx2-af: Add Marvell OcteonTX2 RVU AF driver")
Signed-off-by: Anshumali Gaur <agaur@marvell.com>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Link: https://patch.msgid.link/20260203050701.2616685-1-agaur@marvell.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/octeontx2/af/rvu.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
index 74201e0210bbf..d5e2ebedd433e 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
@@ -3529,11 +3529,22 @@ static void rvu_remove(struct pci_dev *pdev)
 	devm_kfree(&pdev->dev, rvu);
 }
 
+static void rvu_shutdown(struct pci_dev *pdev)
+{
+	struct rvu *rvu = pci_get_drvdata(pdev);
+
+	if (!rvu)
+		return;
+
+	rvu_clear_rvum_blk_revid(rvu);
+}
+
 static struct pci_driver rvu_driver = {
 	.name = DRV_NAME,
 	.id_table = rvu_id_table,
 	.probe = rvu_probe,
 	.remove = rvu_remove,
+	.shutdown = rvu_shutdown,
 };
 
 static int __init rvu_init_module(void)
-- 
2.51.0

