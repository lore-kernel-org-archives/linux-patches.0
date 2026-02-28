Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20CDD36C9F9
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:13:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302384; cv=none; b=SaVnwQ5o87HwYcGR5AVoEKPwGtQH9Molr5odOXcGucNBrwKH0sPKu1Iq/3P8nYuv6U+tDZwcPwusfTbhC5Dq/1eVxPLlGXMfXcR74gLZvhSFKW451OKOi4AkHRnbv5O8f2kjuGUdR5Y8vqLygIjk0xm5SBHJUsGHb72r6sYYgAw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302384; c=relaxed/simple;
	bh=XNCyqiQoXrT4aYR2eI5Hey+yIGL5+LPeXY0/1wTBJK0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XUGk4zMZC14Yx8xr245DYNrEOw/Wh0qV2fyzidujNgzQmFbqIKYqW7D27iaINnin2ML2o+VFs5zHHNFEq/bC9Wpy5LP9AlhZPg5p1qCC04Tf/5EYluTCKB/qN4r1P1sxcIggRlEb8dlMgLp6RCK+epiosUD4aWv5K+Eh8RMEL+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XBP+60fE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XBP+60fE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65C78C19424;
	Sat, 28 Feb 2026 18:13:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302384;
	bh=XNCyqiQoXrT4aYR2eI5Hey+yIGL5+LPeXY0/1wTBJK0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XBP+60fEEsHcPIJG6hSbhEi9Sgf153vWRkgR9N2x7NKhCyKs8qW7S6x4mLsXG0yOZ
	 lOS8ClUH0oozj27Zwm21SaI7wIw5QJdmmgiXehceavXRKLINBvSrMkLiXXkk9dJnOh
	 NQdqw95gTGT5QD8LnnZbtJLIuwuy0iWAB1HHjCaLNUnl25rWDTdbOyKJgI+mCW7URJ
	 wJ52RaBi7yADtVtC2yC/TK0bo6KQh+ZjMKTJabuvUTT9DkvV93kVJTgTPDKfMQVOvM
	 gcp2DbR7jKFh8gSCK6ftCHVzTV3LkNfFVX/4qQDE9UbpjbiPnOzIDZshqbtvm7SU+T
	 p3V7wF/LBI/EQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Anshumali Gaur <agaur@marvell.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 112/232] octeontx2-af: Fix PF driver crash with kexec kernel booting
Date: Sat, 28 Feb 2026 13:09:25 -0500
Message-ID: <20260228181127.1592657-112-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181127.1592657-1-sashal@kernel.org>
References: <20260228181127.1592657-1-sashal@kernel.org>
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
index 7034a977102ea..1e3661524040a 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
@@ -3442,11 +3442,22 @@ static void rvu_remove(struct pci_dev *pdev)
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

