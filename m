Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 802EE230BDB;
	Fri,  9 Oct 2026 14:22:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791555742; cv=none; b=M5+M7EwJNxoUTnpxkDkJ6b3xNGzAR9KB+Hrq7LCNxvVRLgaNu9474lrOXCAq10QxFSFpfC9C1k0sV2pA9McjKdciSpWrzuiNWyeMrDHo3PZm8cp5HBOBHQCFrCpexg6EGBzXCKSSUHGi7zRFX8mPfADGTarTF0apL5AQfrz2OSA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791555742; c=relaxed/simple;
	bh=21dNqEVPIAvyHgzPGtgVNAaZQNtVa9/oUQ3m2qiscJs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tGL0MWcYhhC4S+sGBDCw41yt8FR1a/Adklwi1cohfpV2CBj02+4HbKFBd+DZMRzMg2pMd/lYtKi9+F1VVA8rVAelQOA7PInKp+lOKbv2ewESzcXyq93gC4zd3c+YbTUI2HDK/5YfMrAwiXH1M5epX4Kd9KIvK1Mu/KjYPf6vvbU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DMtllFwh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DMtllFwh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C806A1F000FF;
	Fri,  9 Oct 2026 14:22:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791555741;
	bh=53rO0ki9u36847+VM///t2yDyWZhLuASYlOI+VNTlTE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DMtllFwhAONDN/8kCXu8uZfO5eVPs6emw1D3zIgbKdba6C6/QnSMYTjVQjq857ij8
	 9yx5nwIxPE6kSiMLSoOce85K97S7z6PmewsddRbQ2x9LEisCNP+LqxJyUg+kbmfgT0
	 Oo2LOdeq48NtAOw1U3BBDnmBN2x7b+7OaaiuLllQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yoshihisa Yamamoto <yoshihisa.yamamoto.xn@renesas.com>,
	Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 108/403] net: pcs: rzn1-miic: Clear MIIC protection state before unprotect sequence
Date: Fri,  9 Oct 2026 16:07:49 +0200
Message-ID: <20261009140954.608764523@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140952.119038291@linuxfoundation.org>
References: <20261009140952.119038291@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yoshihisa Yamamoto <yoshihisa.yamamoto.xn@renesas.com>

[ Upstream commit 8b9993437429c66d11430ae61ffa5937a6abb4ae ]

On RZ/T2H and RZ/N1D MIIC, writing 0x0000 to the MIIC protection
register clears the protection state machine.

The initial protection state cannot be assumed to be constant,
as it may be influenced by previous activity before the driver
takes ownership of the hardware.

Clear the protection state before issuing the unprotect sequence
so that register access always starts from a known state, regardless
of any previous activity.

Fixes: 7dc54d3b8d91 ("net: pcs: add Renesas MII converter driver")
Signed-off-by: Yoshihisa Yamamoto <yoshihisa.yamamoto.xn@renesas.com>
Reviewed-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Link: https://patch.msgid.link/TYCPR01MB74815955A10817B64BD6FB93A4812@TYCPR01MB7481.jpnprd01.prod.outlook.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/pcs/pcs-rzn1-miic.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/pcs/pcs-rzn1-miic.c b/drivers/net/pcs/pcs-rzn1-miic.c
index cea350745a7b6..301cfde2e6dde 100644
--- a/drivers/net/pcs/pcs-rzn1-miic.c
+++ b/drivers/net/pcs/pcs-rzn1-miic.c
@@ -249,6 +249,9 @@ static struct miic_port *phylink_pcs_to_miic_port(struct phylink_pcs *pcs)
 
 static void miic_unlock_regs(struct miic *miic)
 {
+	/* Clear protection state */
+	writel(0x0000, miic->base + MIIC_PRCMD);
+
 	/* Unprotect register writes */
 	writel(0x00A5, miic->base + MIIC_PRCMD);
 	writel(0x0001, miic->base + MIIC_PRCMD);
-- 
2.53.0



