Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86DD617A2EA;
	Mon, 22 Sep 2025 19:31:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758569504; cv=none; b=MxNAgXzlXMSxx9o6bbxPfPzAA/Yvi4ggs5YWW6b3WOTUEQBAJb0+2paWDZ10/Q9jdBBhdHoFCuYGzGnkSzcPwm03ThLKN5HGJf8W8G2JCY5+F+PV8Jgg2EIC0PUnijmGP1fPWAwCvdXJ2EGhz6K5Ha9tKcTXhfDuO2q2iHD5TCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758569504; c=relaxed/simple;
	bh=epuEB0g8bJHtYBjWAToAzHgO/mtx2n7y8wd3iweiyfc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ry/Btq6eVDCYFigx+sTsiXT7VUbG1SoW6MTUqJvY016S9myaT7LGkszV0SOfZYOicq7Z8IRDPX+/6CoEbSlMG3Ed5hK1JZkpw+xi2EV+1egbqC9CjQc0PuSZxKpoLwRDJnMw3wdur8L5zZ/vF57Gd5nqN/bmIMXfmP+i2y07aJ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IJ0jrYn+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IJ0jrYn+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C16A4C4CEF0;
	Mon, 22 Sep 2025 19:31:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758569504;
	bh=epuEB0g8bJHtYBjWAToAzHgO/mtx2n7y8wd3iweiyfc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IJ0jrYn+eApM1xGnPdoVloSUTs1sDV5olxI8mNRp6IjOn2lSNg3xQRzK3dRf1E1Zm
	 X2edzujPY92csrnW4uAJZgMmil5iTSpXpNNfgL0HPoaGfvJ2FtYxNgdKRqIcFQHZxi
	 ls4TAe2fyqvYMEdUnwgw1UO5EqeptIyDMBZRxSI0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ioana Ciornei <ioana.ciornei@nxp.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 08/61] dpaa2-switch: fix buffer pool seeding for control traffic
Date: Mon, 22 Sep 2025 21:29:01 +0200
Message-ID: <20250922192403.777691328@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250922192403.524848428@linuxfoundation.org>
References: <20250922192403.524848428@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ioana Ciornei <ioana.ciornei@nxp.com>

[ Upstream commit 2690cb089502b80b905f2abdafd1bf2d54e1abef ]

Starting with commit c50e7475961c ("dpaa2-switch: Fix error checking in
dpaa2_switch_seed_bp()"), the probing of a second DPSW object errors out
like below.

fsl_dpaa2_switch dpsw.1: fsl_mc_driver_probe failed: -12
fsl_dpaa2_switch dpsw.1: probe with driver fsl_dpaa2_switch failed with error -12

The aforementioned commit brought to the surface the fact that seeding
buffers into the buffer pool destined for control traffic is not
successful and an access violation recoverable error can be seen in the
MC firmware log:

[E, qbman_rec_isr:391, QBMAN]  QBMAN recoverable event 0x1000000

This happens because the driver incorrectly used the ID of the DPBP
object instead of the hardware buffer pool ID when trying to release
buffers into it.

This is because any DPSW object uses two buffer pools, one managed by
the Linux driver and destined for control traffic packet buffers and the
other one managed by the MC firmware and destined only for offloaded
traffic. And since the buffer pool managed by the MC firmware does not
have an external facing DPBP equivalent, any subsequent DPBP objects
created after the first DPSW will have a DPBP id different to the
underlying hardware buffer ID.

The issue was not caught earlier because these two numbers can be
identical when all DPBP objects are created before the DPSW objects are.
This is the case when the DPL file is used to describe the entire DPAA2
object layout and objects are created at boot time and it's also true
for the first DPSW being created dynamically using ls-addsw.

Fix this by using the buffer pool ID instead of the DPBP id when
releasing buffers into the pool.

Fixes: 2877e4f7e189 ("staging: dpaa2-switch: setup buffer pool and RX path rings")
Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
Link: https://patch.msgid.link/20250910144825.2416019-1-ioana.ciornei@nxp.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
index 732fd2e389c41..e928fea16e841 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
@@ -2680,7 +2680,7 @@ static int dpaa2_switch_setup_dpbp(struct ethsw_core *ethsw)
 		dev_err(dev, "dpsw_ctrl_if_set_pools() failed\n");
 		goto err_get_attr;
 	}
-	ethsw->bpid = dpbp_attrs.id;
+	ethsw->bpid = dpbp_attrs.bpid;
 
 	return 0;
 
-- 
2.51.0



