Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A5B43246F8;
	Tue, 17 Mar 2026 17:18:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773767931; cv=none; b=uYYP3yPFBobwz5VfplUKXbMCBtARSe05k/7fObWJASkFqvOBwmoP5Y8vWr2oeZ2olYi74Wq2yffPR1OtSwJAAY4+ptys11Hgrk1b/XCZb2puQoqlaYH/+2/nXqkmckjBG/XA6Vp56abll3s02YZ4DkhQ0yVBezRj7j7lS16iJ14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773767931; c=relaxed/simple;
	bh=usv8McoHmnnnP7PSJ0MNiLBSJNowkF9Fj45X0Zq+9To=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aQ8eH6uMVpEqZ/TUXN2md6AUhApRy2yOqTzBZlEdufyJrflofMcFTUTvnBujTjWGuFSkUHUMCvHuod2MGGq7kkShpa5ceBI+xZB683jPB1yql1jdc6qR6h61uPdCNPY0t9Pu3r7GnJ3F5ztRPvh3YN7YnwkKpuq+vBkq925qLnk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LZt1l0l2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LZt1l0l2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0F76C4CEF7;
	Tue, 17 Mar 2026 17:18:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773767931;
	bh=usv8McoHmnnnP7PSJ0MNiLBSJNowkF9Fj45X0Zq+9To=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LZt1l0l2nspYwFoV1nVaFx5zS2J6KkyeXyejfGMaN88A+EyfUFlz1f+mcMgVXa5m2
	 a2O9sp7MXyFF9+oaPeXlqZwzWvr8DtSLweZS/RTl8/58V7zAc2pj1bflZEzM7Lvxie
	 WrZxM2Z1gS4FkrIGF2nmXu+St5JT13cFOOQQtExc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Ng Ho Yin <adrianhoyin.ng@altera.com>,
	Frank Li <Frank.Li@nxp.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 175/333] i3c: dw-i3c-master: Set SIR_REJECT in DAT on device attach and reattach
Date: Tue, 17 Mar 2026 17:33:24 +0100
Message-ID: <20260317163005.846454275@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317162959.345812316@linuxfoundation.org>
References: <20260317162959.345812316@linuxfoundation.org>
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

From: Adrian Ng Ho Yin <adrianhoyin.ng@altera.com>

[ Upstream commit f311a05784634febd299f03476b80f3f18489767 ]

The DesignWare I3C master controller ACKs IBIs as soon as a valid
Device Address Table (DAT) entry is present. This can create a race
between device attachment (after DAA) and the point where the client
driver enables IBIs via i3c_device_enable_ibi().

Set DEV_ADDR_TABLE_SIR_REJECT in the DAT entry during
attach_i3c_dev() and reattach_i3c_dev() so that IBIs are rejected
by default. The bit is managed thereafter by the existing
dw_i3c_master_set_sir_enabled() function, which clears it in
enable_ibi() after ENEC is issued, and restores it in disable_ibi()
after DISEC.

Fixes: 1dd728f5d4d4 ("i3c: master: Add driver for Synopsys DesignWare IP")
Signed-off-by: Adrian Ng Ho Yin <adrianhoyin.ng@altera.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/53f5b8cbdd8af789ec38b95b02873f32f9182dd6.1770962368.git.adrianhoyin.ng@altera.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i3c/master/dw-i3c-master.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/i3c/master/dw-i3c-master.c b/drivers/i3c/master/dw-i3c-master.c
index c06595cb74010..41ddac1d49d5e 100644
--- a/drivers/i3c/master/dw-i3c-master.c
+++ b/drivers/i3c/master/dw-i3c-master.c
@@ -1005,7 +1005,7 @@ static int dw_i3c_master_reattach_i3c_dev(struct i3c_dev_desc *dev,
 		master->free_pos &= ~BIT(pos);
 	}
 
-	writel(DEV_ADDR_TABLE_DYNAMIC_ADDR(dev->info.dyn_addr),
+	writel(DEV_ADDR_TABLE_DYNAMIC_ADDR(dev->info.dyn_addr) | DEV_ADDR_TABLE_SIR_REJECT,
 	       master->regs +
 	       DEV_ADDR_TABLE_LOC(master->datstartaddr, data->index));
 
@@ -1034,7 +1034,7 @@ static int dw_i3c_master_attach_i3c_dev(struct i3c_dev_desc *dev)
 	master->free_pos &= ~BIT(pos);
 	i3c_dev_set_master_data(dev, data);
 
-	writel(DEV_ADDR_TABLE_DYNAMIC_ADDR(master->devs[pos].addr),
+	writel(DEV_ADDR_TABLE_DYNAMIC_ADDR(master->devs[pos].addr) | DEV_ADDR_TABLE_SIR_REJECT,
 	       master->regs +
 	       DEV_ADDR_TABLE_LOC(master->datstartaddr, data->index));
 
-- 
2.51.0



