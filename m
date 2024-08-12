Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A02B186E38;
	Mon, 12 Aug 2024 16:24:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723479888; cv=none; b=YayU2nYtIzWYVzHuWf3FXGd8Q65TdcBTytnH0d8qVfMdk+jrLx/J1OuQo1i6TLQbiGHBNQteP+ytZMFK5rFnC3qlDVc8qZMX2dVrB2f0qaOS91oA7wJ+EXbGJvfnhCL6c9zPidE26NTX/UiEJPZCJ3bSqvam8Qy4rMIAuza0r/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723479888; c=relaxed/simple;
	bh=bSYnFpxdmoARCZKD5x0KFCtL4EzncCxKMGevL6HGQFw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FHVF1NckBVlPIw40RfcZAUPZdF9IE/9JZVD9mgz7d4MSF62KqUfFfCy0KB4XRbNJNypeACBlNXaqTfGs8ByNQo9PjpV/uaKcSA8XEa5ifcafRzX1yLOkX7+lLpCWucuq7W/i20/A9t2pIjiEpjlgCsmWqVZ9YjCBYZk+30siqcY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EjurE2OC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EjurE2OC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8984AC32782;
	Mon, 12 Aug 2024 16:24:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723479888;
	bh=bSYnFpxdmoARCZKD5x0KFCtL4EzncCxKMGevL6HGQFw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EjurE2OCGueizM+loQqJmfVMSEgwuQjVsbk2ybx6MdlKqFqN+ohqL4ITInE8xBmHM
	 EqzZfQVpci0Obl3rP1SGjW2dWNse/O8j+S48iaa96M3vBDqGLtp7zCizQWdmQG0gyf
	 M0vK+Gb2Mt/IvjMsKmDBkt1HxU5lASM+Udg9DfdE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Breno Leitao <leitao@debian.org>,
	Pavan Chebbi <pavan.chebbi@broadcom.com>,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Somnath Kotur <somnath.kotur@broadcom.com>,
	Michael Chan <michael.chan@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 032/263] bnxt_en : Fix memory out-of-bounds in bnxt_fill_hw_rss_tbl()
Date: Mon, 12 Aug 2024 18:00:33 +0200
Message-ID: <20240812160147.772678041@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160146.517184156@linuxfoundation.org>
References: <20240812160146.517184156@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Chan <michael.chan@broadcom.com>

[ Upstream commit da03f5d1b2c319a2b74fe76edeadcd8fa5f44376 ]

A recent commit has modified the code in __bnxt_reserve_rings() to
set the default RSS indirection table to default only when the number
of RX rings is changing.  While this works for newer firmware that
requires RX ring reservations, it causes the regression on older
firmware not requiring RX ring resrvations (BNXT_NEW_RM() returns
false).

With older firmware, RX ring reservations are not required and so
hw_resc->resv_rx_rings is not always set to the proper value.  The
comparison:

if (old_rx_rings != bp->hw_resc.resv_rx_rings)

in __bnxt_reserve_rings() may be false even when the RX rings are
changing.  This will cause __bnxt_reserve_rings() to skip setting
the default RSS indirection table to default to match the current
number of RX rings.  This may later cause bnxt_fill_hw_rss_tbl() to
use an out-of-range index.

We already have bnxt_check_rss_tbl_no_rmgr() to handle exactly this
scenario.  We just need to move it up in bnxt_need_reserve_rings()
to be called unconditionally when using older firmware.  Without the
fix, if the TX rings are changing, we'll skip the
bnxt_check_rss_tbl_no_rmgr() call and __bnxt_reserve_rings() may also
skip the bnxt_set_dflt_rss_indir_tbl() call for the reason explained
in the last paragraph.  Without setting the default RSS indirection
table to default, it causes the regression:

BUG: KASAN: slab-out-of-bounds in __bnxt_hwrm_vnic_set_rss+0xb79/0xe40
Read of size 2 at addr ffff8881c5809618 by task ethtool/31525
Call Trace:
__bnxt_hwrm_vnic_set_rss+0xb79/0xe40
 bnxt_hwrm_vnic_rss_cfg_p5+0xf7/0x460
 __bnxt_setup_vnic_p5+0x12e/0x270
 __bnxt_open_nic+0x2262/0x2f30
 bnxt_open_nic+0x5d/0xf0
 ethnl_set_channels+0x5d4/0xb30
 ethnl_default_set_doit+0x2f1/0x620

Reported-by: Breno Leitao <leitao@debian.org>
Closes: https://lore.kernel.org/netdev/ZrC6jpghA3PWVWSB@gmail.com/
Fixes: 98ba1d931f61 ("bnxt_en: Fix RSS logic in __bnxt_reserve_rings()")
Reviewed-by: Pavan Chebbi <pavan.chebbi@broadcom.com>
Reviewed-by: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
Reviewed-by: Somnath Kotur <somnath.kotur@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Tested-by: Breno Leitao <leitao@debian.org>
Link: https://patch.msgid.link/20240806053742.140304-1-michael.chan@broadcom.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 23627c973e40f..a2d672a698e35 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -7433,19 +7433,20 @@ static bool bnxt_need_reserve_rings(struct bnxt *bp)
 	int rx = bp->rx_nr_rings, stat;
 	int vnic, grp = rx;
 
-	if (hw_resc->resv_tx_rings != bp->tx_nr_rings &&
-	    bp->hwrm_spec_code >= 0x10601)
-		return true;
-
 	/* Old firmware does not need RX ring reservations but we still
 	 * need to setup a default RSS map when needed.  With new firmware
 	 * we go through RX ring reservations first and then set up the
 	 * RSS map for the successfully reserved RX rings when needed.
 	 */
-	if (!BNXT_NEW_RM(bp)) {
+	if (!BNXT_NEW_RM(bp))
 		bnxt_check_rss_tbl_no_rmgr(bp);
+
+	if (hw_resc->resv_tx_rings != bp->tx_nr_rings &&
+	    bp->hwrm_spec_code >= 0x10601)
+		return true;
+
+	if (!BNXT_NEW_RM(bp))
 		return false;
-	}
 
 	vnic = bnxt_get_total_vnics(bp, rx);
 
-- 
2.43.0



