Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 280A039B949
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:16:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302568; cv=none; b=HBmf14dD2j2ARyIJ1sYMxN4fjxRFMyObjXEvbEzH32r8dUSqpUCmNlwcFw0IFYS+sgvoHHLKoJdyn8cBT0biyn+QHC0h/+NR9j4mp2kmsPp1udEQBK/TTz1zwJ5S0CPbX8N+xU9qPtqIynoJo3V/uWfurn3JyAQWktWfMA0cmE4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302568; c=relaxed/simple;
	bh=Jt+ygqZbXBdof6xhG1JXBV5RVcP2BeFqFc/Z0KZkf7U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CRqOwLxAvtfU2YVuy94SrbVEJX+G61OR2PUanPa4pnqrBfOclmA5lBOa1lFa1BYvW0kd6zb0aoRJE5p04EzGRBOIV0GHaKQU1m6tsiMv3s3IW3lv9JZjZ36VQYDJehM7yoSvdzug5nTyvf0pOErY4Igxgw5nqWgI0mJzpsiBkcg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oq4HiOpV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oq4HiOpV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73A4CC116D0;
	Sat, 28 Feb 2026 18:16:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302568;
	bh=Jt+ygqZbXBdof6xhG1JXBV5RVcP2BeFqFc/Z0KZkf7U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oq4HiOpV0OO/h7hhUDf9VJJwk9d3us0y8dHQWiruociMaC23UDEnGcdjWtWti916u
	 otlw7j1pnpOYM5Sz6T4/ikdNxgWXDYtUOBv+Vag3WONkEZ9Gpz8gZzoD+Zu9sQY/4p
	 N9rkJbfo40pruVmj0ebTotIsFqhBR61i3yYsEl2YdmY/f8ECI7bA/DqGEiMbF9GIOU
	 TjqFSX9uZYzxeNhMFFBTKY9X/0HsWrjjk5DaZ7hJOF6fym/VGCFsDZ5pWiVJGq8uFH
	 gRWrjljA0S688JdSRFT39Fx+9tbciqkefeyWAFc/miIDD9FkBcwB1DQpGhkzYWd3BO
	 P9YCJsOhAk/Tg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Anshumali Gaur <agaur@marvell.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 074/164] octeontx2-af: Fix PF driver crash with kexec kernel booting
Date: Sat, 28 Feb 2026 13:13:33 -0500
Message-ID: <20260228181505.1600663-74-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181505.1600663-1-sashal@kernel.org>
References: <20260228181505.1600663-1-sashal@kernel.org>
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
index 53f742a507dbe..187c66fb2458c 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
@@ -3331,11 +3331,22 @@ static void rvu_remove(struct pci_dev *pdev)
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

