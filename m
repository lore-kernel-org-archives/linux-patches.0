Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B49E518B0A;
	Wed, 25 Feb 2026 01:34:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983261; cv=none; b=iXHmOj47h3Zhas1yK2x3B2LiI+BTiqBOBrMD1WncMghFnfavjaLL7MWEp1hzTbiJcJC4O4IfJZM9ofZAw3msNaAvekie2FAdkZkPTM8N+c9wC14f4y2CLMuQFVCUUPpVX3vvBG2u5vh38WOJve1XziNY5m06GXzfp47B2sGoy7w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983261; c=relaxed/simple;
	bh=M2jzVvPnF3W8ryqc3DgYDwZUeo9bwKpKmYxOJyHBKmA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RGCiVNID+iaWLPgO9rYZTSyQo+wlssNkfBPpO8KZ8hJe9yFVGAp7g6vhks9TqW6Ho2IIz0yhlk3KJvDhFhREcFAysPWITR5xi42KLssksboHJVKbTUFwFyJsfM4WCK1Zh7XED17ayVqq+5slAvHFAlRKtOZcZxsXUic0Wf3yupE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HfRg95KE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HfRg95KE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6ED16C116D0;
	Wed, 25 Feb 2026 01:34:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983261;
	bh=M2jzVvPnF3W8ryqc3DgYDwZUeo9bwKpKmYxOJyHBKmA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HfRg95KEU38bebrjf6cJXqJ2WEmDdANneteOoQU69XIpNull9Gyej0KA69n5OLHuW
	 vh5cxoNVLEL5UJhJzatV4VAcp+BgFQUFgCpryGqP7iG1bQ5rOgf8gbxZ1mfpPr3U1W
	 3hhwmvVD1kRgWpR1W9OERGarU+svTYFPjB9gTQ+s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anshumali Gaur <agaur@marvell.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 403/781] octeontx2-af: Fix PF driver crash with kexec kernel booting
Date: Tue, 24 Feb 2026 17:18:32 -0800
Message-ID: <20260225012409.589609411@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

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
index 747fbdf2a908f..8530df8b3fdaf 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
@@ -3632,11 +3632,22 @@ static void rvu_remove(struct pci_dev *pdev)
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



