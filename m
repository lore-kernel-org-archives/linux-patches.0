Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18E0D3BED7A;
	Sat, 17 Oct 2026 17:28:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792258128; cv=none; b=T0W2hebcYutfhNXNDIF50gCt2Q9IVuPNiHclmmOUA+525oZes2MaYnF/y23y8C2PuHooAPSHRTVjHLgEsabw4NImnJFEA35HX/drpne0eAsVGRCRZCUIKXB6s0KmolZDp3BZILG3qfk1pR1yZQsTSnXBDN+ChoaSohOGdWSXj3Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792258128; c=relaxed/simple;
	bh=XE/x+xVYWQaz0VQT3GNxnfK90rTBYQUIWCBlSylvq7g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MSRRWFZaIcGQKIyUWAkOWwu8tzTzLXdeHwAj1OwuzMdjFH1ezInfCHO8O836wXTFIQhuWwiw/nCZ/VxEotFqAKM/DZvWyqpTjGmj9/CLSCi2QC1clVtiXWc3eWdxluCAtddUvFfnBfr1YWDf5tcOfSXCgcNaCXGfwUPK1TdI5XI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jlqOFSCC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jlqOFSCC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FC611F000C4;
	Sat, 17 Oct 2026 17:28:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792258127;
	bh=havXaTlI2/4GFM+kY+h/GVrpGRZmjspSgALDEEFgRqo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jlqOFSCChcv/xBmEmLmfzpGBg/TbXakqB2DokId8gls75cbQ1HbAITwJCGIredqyq
	 O6wqEbRbWVheOYNrRu2bAUjfaChP+MJU1TeDi8ASiFKUKi4GDTP4EFHF64K+yZIZZL
	 DSbtVxzRN0DCzR+GsLWc+k17iVq3YZJsgfjCsS6Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Andy Gospodarek <andrew.gospodarek@broadcom.com>,
	Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
	Michael Chan <michael.chan@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0780/1674] bnxt_en: Fix memory corruption when FW resources change during ifdown
Date: Sat, 17 Oct 2026 17:50:52 +0200
Message-ID: <20261017160451.125794010@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sreekanth Reddy <sreekanth.reddy@broadcom.com>

[ Upstream commit 2747328ba2714f1a7454208dbbc1dc0631990b4a ]

bnxt_set_dflt_rings() assumes that it is always called before any TC has
been created.  So it doesn't take bp->num_tc into account and assumes
that it is always 0 or 1.

In the FW resource or capability change scenario, the FW will return
flags in bnxt_hwrm_if_change() that will cause the driver to
reinitialize and call bnxt_cancel_reservations().  This will lead to
bnxt_init_dflt_ring_mode() calling bnxt_set_dflt_rings() and bp->num_tc
may be greater than 1.  This will cause bp->tx_ring[] to be sized too
small and cause memory corruption in bnxt_alloc_cp_rings().

Fix it by properly scaling the TX rings by bp->num_tc in the code
paths mentioned above.  Add 2 helper functions to determine
bp->tx_nr_rings and bp->tx_nr_rings_per_tc.

Fixes: ec5d31e3c15d ("bnxt_en: Handle firmware reset status during IF_UP.")
Reviewed-by: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
Reviewed-by: Andy Gospodarek <andrew.gospodarek@broadcom.com>
Signed-off-by: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Link: https://patch.msgid.link/20250825175927.459987-2-michael.chan@broadcom.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 25 ++++++++++++++++++-----
 1 file changed, 20 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index e066f44e900b6..7bdd94bb4a3a2 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -10515,6 +10515,21 @@ static int bnxt_reinit_after_abort(struct bnxt *bp)
 	return rc;
 }
 
+static int bnxt_tx_nr_rings(struct bnxt *bp)
+{
+	int num_tc = netdev_get_num_tc(bp->dev);
+
+	return num_tc ? bp->tx_nr_rings_per_tc * num_tc :
+			bp->tx_nr_rings_per_tc;
+}
+
+static int bnxt_tx_nr_rings_per_tc(struct bnxt *bp)
+{
+	int num_tc = netdev_get_num_tc(bp->dev);
+
+	return num_tc ? bp->tx_nr_rings / num_tc : bp->tx_nr_rings;
+}
+
 static int __bnxt_open_nic(struct bnxt *bp, bool irq_re_init, bool link_re_init)
 {
 	int rc = 0;
@@ -13462,7 +13477,7 @@ static void bnxt_trim_dflt_sh_rings(struct bnxt *bp)
 	bp->cp_nr_rings = min_t(int, bp->tx_nr_rings_per_tc, bp->rx_nr_rings);
 	bp->rx_nr_rings = bp->cp_nr_rings;
 	bp->tx_nr_rings_per_tc = bp->cp_nr_rings;
-	bp->tx_nr_rings = bp->tx_nr_rings_per_tc;
+	bp->tx_nr_rings = bnxt_tx_nr_rings(bp);
 }
 
 static int bnxt_set_dflt_rings(struct bnxt *bp, bool sh)
@@ -13493,12 +13508,12 @@ static int bnxt_set_dflt_rings(struct bnxt *bp, bool sh)
 		bnxt_trim_dflt_sh_rings(bp);
 	else
 		bp->cp_nr_rings = bp->tx_nr_rings_per_tc + bp->rx_nr_rings;
-	bp->tx_nr_rings = bp->tx_nr_rings_per_tc;
+	bp->tx_nr_rings = bnxt_tx_nr_rings(bp);
 
 	rc = __bnxt_reserve_rings(bp);
 	if (rc && rc != -ENODEV)
 		netdev_warn(bp->dev, "Unable to reserve tx rings\n");
-	bp->tx_nr_rings_per_tc = bp->tx_nr_rings;
+	bp->tx_nr_rings_per_tc = bnxt_tx_nr_rings_per_tc(bp);
 	if (sh)
 		bnxt_trim_dflt_sh_rings(bp);
 
@@ -13507,7 +13522,7 @@ static int bnxt_set_dflt_rings(struct bnxt *bp, bool sh)
 		rc = __bnxt_reserve_rings(bp);
 		if (rc && rc != -ENODEV)
 			netdev_warn(bp->dev, "2nd rings reservation failed.\n");
-		bp->tx_nr_rings_per_tc = bp->tx_nr_rings;
+		bp->tx_nr_rings_per_tc = bnxt_tx_nr_rings_per_tc(bp);
 	}
 	if (BNXT_CHIP_TYPE_NITRO_A0(bp)) {
 		bp->rx_nr_rings++;
@@ -13541,7 +13556,7 @@ static int bnxt_init_dflt_ring_mode(struct bnxt *bp)
 	if (rc)
 		goto init_dflt_ring_err;
 
-	bp->tx_nr_rings_per_tc = bp->tx_nr_rings;
+	bp->tx_nr_rings_per_tc = bnxt_tx_nr_rings_per_tc(bp);
 
 	bnxt_set_dflt_rfs(bp);
 
-- 
2.53.0



