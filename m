Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5011D38F623
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:09:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302147; cv=none; b=iX+Og/df1D494v8b0jgsdQtBmO2wEQ87keb6Usa/AZjxXXxRr22d4zqFT95Ne9x9P2xGgfgL8oMhbGL1w655129gSLWK/x3Vk/1dDL0In5NdR+cHryxTjEWjkMTqepKV4V2BejkYu5/TMj9DXytBJ5zY+u66oAC5M8H2t0RPZUw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302147; c=relaxed/simple;
	bh=r7Sk7EeAZ/NQENHT4UHoRWbp5+Y6LHUKnXU2bm9jjUA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oTmujhPtQGRpi/oVUg2LGYZwcDY5PD8pSOFaAvemK6JHlu0CvC1d8mDmvaekvJ2Cb5glMM9rpsvjhu8SgcmkLJ4hVaODdJ6khc5bd1yl2tJhAvM+TXGbO7eOcTssOQ/Tk/vI7NTK6pEgbni1+at6yyRHEJfXOPQ4nnmQeQD3His=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=l/GjmV+r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="l/GjmV+r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DDAAC19424;
	Sat, 28 Feb 2026 18:09:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302147;
	bh=r7Sk7EeAZ/NQENHT4UHoRWbp5+Y6LHUKnXU2bm9jjUA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l/GjmV+r9zgcmnMqHd/K+rw63+6YWkA95CsXK/tiavxyfwHVl1dSMwUYWMSr36SvB
	 5VH5iB7TbPx6Yyw1xcQ/268+SHN84kTiNohv5zq9sO/ftsSCuIkhZ1eA2kYkxrMTw4
	 mFrxt6om21AeUFca5tHusxIdsQDDUDBlmw3IbV7yvb9pQY40QcBu3Hv7qoc9roDJJ0
	 FJNRxZG/Zop4Zop2K5Vo11md5WkZXQpRsC8VIXR35OMOAGZK/+5R2QhIvBKPRiAuZh
	 KdyVqFLwZZBJEAgr+y7+VqyFSA4ZXq2ZN0kjB7SH0Q6A77f/lTU6VLn4sF5lWZ6fFv
	 WS5pU3oCe/eWw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Anshumali Gaur <agaur@marvell.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 141/283] octeontx2-af: Fix PF driver crash with kexec kernel booting
Date: Sat, 28 Feb 2026 13:04:43 -0500
Message-ID: <20260228180709.1583486-141-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180709.1583486-1-sashal@kernel.org>
References: <20260228180709.1583486-1-sashal@kernel.org>
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
index 846049b6c4d60..a7fcea9b1ee7e 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
@@ -3444,11 +3444,22 @@ static void rvu_remove(struct pci_dev *pdev)
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

