Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16EAA35AC33
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:18:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302716; cv=none; b=OtylWm+p5bJonP9zE0dhdsAf9RGjRR9FQzh2mz4k2Bj2GUyrNMJReFPFBUzTnRObt4VcCXpyLrqSSKOoz1AKW3r/SQ9kvHe+NktN0+YH+J6nI3qSUlfHlNu024vDSpnNTM8s38golQm1uP7njMnsHaRl8tuuQzJciQ1NXw+ry1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302716; c=relaxed/simple;
	bh=C7VUgGpz/qaIwgbnRsBMzcb/Wp9bubvu6OsL8joHcN4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iUsOag1eCQfMhG23sAo9IDb00/nQChAvbOnxIPZVlf/qk7jW/1ydikW9ol0rxRXMymTj9l+6x9imOupx2NETHWm748Ljo27/lmL0yKf/cCpKWiRulP2N3PQxHbrDsDzBEh0ca8BYvrKSmWuqezsAUi+IKLRKQgvLsOSiPWE3iRc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WDlopdhp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WDlopdhp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 654C0C2BC87;
	Sat, 28 Feb 2026 18:18:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302716;
	bh=C7VUgGpz/qaIwgbnRsBMzcb/Wp9bubvu6OsL8joHcN4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WDlopdhpvNjabRcy0AiFKK1gUMvzjsYt6N+/j+HFRflhhZ0JxpPniA4aLD8cpHQ2A
	 o/Vbh0lSHYg5Le44MA6yLWy+Jmw+ogLCKEL87iOhelF2X3xDGOPHozxGB+JPASm1RW
	 PXFv/5sWT6SP2OuBLlFV0XKpLM9GxVwt5YfeYRN8ReizBDbxZO8aZKltFDS/3LoknC
	 WGtyPPqmKYqvguOmSrTw7f3voEKKHJFhF5HniDVRv4WMcPl6wOy/h3uJDHrOoeYP65
	 nRUTgU+ovOlFEXEUkgPRSjdFerhcUqtBhq22LzujRUiEx7o+t1vVJLs7Gwyh+q10k3
	 AX5yHr5P1bBxQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Anshumali Gaur <agaur@marvell.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 075/147] octeontx2-af: Fix PF driver crash with kexec kernel booting
Date: Sat, 28 Feb 2026 13:16:23 -0500
Message-ID: <20260228181736.1605592-75-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181736.1605592-1-sashal@kernel.org>
References: <20260228181736.1605592-1-sashal@kernel.org>
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
index 3514564e2cc60..217b6873a64c6 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
@@ -2880,11 +2880,22 @@ static void rvu_remove(struct pci_dev *pdev)
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

