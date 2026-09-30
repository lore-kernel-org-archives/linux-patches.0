Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 152BD515983;
	Wed, 30 Sep 2026 16:19:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790785153; cv=none; b=hK3A42g9rz0NVRh/7/yQyHvkbaxZtDFFmWpsqEz8L7gUJEHhGLsXOmMQ4sMCloBMzKlYG7UEeJrFSe+R8vNml1b7qcaGDw4Mn38Dw2WRyqiS+BVBBA0AeXOmanvuiRD3mN7M5Vhj+bhBMz/SPlL32XGnLZgvI633GRUgXP8KGC8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790785153; c=relaxed/simple;
	bh=FmVHcuzbauwDJyi3HwlJru1H/qi9EDNqYzQbPPNEMrE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dURKEK71s+trgIPt4mUWAEFcFZ32GtjQRFrGnYZxIcMZO2H6C+CbjoVvnXAhFQJI0xaLGn/ujenL3ZdeaKnzDqcyGXKox497Q+zYwjtW/1o29xZb674Vd99jzGEV/xL5YeJFxRrarQizrHB2X73F8ChByNUlSYQ0d4kYVlP6cDc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Vgii3zZP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Vgii3zZP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3DE91F000FF;
	Wed, 30 Sep 2026 16:19:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790785141;
	bh=I1eKKAZkthoO1gZd7VwN7HGCTGcxLxI10hFDg+xZQyY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Vgii3zZPyAIKe2raskZWSk9+BPDYNqe2sz8eOwToUcRWOfH65XW1IpuY6hq1mE/Sp
	 RaZVW5An6cWLzQQkdmBJzUhBNWwDmCirpa6aLRK60qva5jt9vJ6WJPrlGjxo7ZzF0B
	 G3pvrsNcVl6ryX38BWdjZdNmFoNkKqUV0xkK850k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 397/982] net: stmmac: reconfigure RX packet parser table in stmmac_hw_setup() after reset
Date: Wed, 30 Sep 2026 17:18:53 +0200
Message-ID: <20260930152425.335678835@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>

[ Upstream commit 6b8fed2675fb75d23e6cf2b7e49c94926e884b34 ]

The core software reset issued in stmmac_init_dma_engine() during
ndo_open() callback clears the MTL RX packet parser registers, but
stmmac_rxp_config() is only invoked from the cls_u32 add/delete paths.
After an ifdown/ifup cycle the hardware therefore runs with the default
all-pass table while priv->tc_entries still reports the filters as
installed. Re-apply the RX packet parser table from priv->tc_entries in
stmmac_hw_setup(), right after the software reset, so the filters are
restored when the interface is brought up again.

Fixes: 4dbbe8dde848 ("net: stmmac: Add support for U32 TC filter using Flexible RX Parser")
Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
Link: https://patch.msgid.link/20260831-stmmac_tc_cls32_reconfigure-v1-1-21cb459e64ae@oss.qualcomm.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 16c4640e8e689..fb8c65c2bc0ef 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -3349,6 +3349,14 @@ static int stmmac_hw_setup(struct net_device *dev, bool ptp_register)
 	/* Initialize MTL*/
 	stmmac_mtl_configuration(priv);
 
+	/* Apply the RX packet parser table */
+	if (priv->tc_entries) {
+		ret = stmmac_rxp_config(priv, priv->hw->pcsr, priv->tc_entries,
+					priv->tc_entries_max);
+		if (ret)
+			return ret;
+	}
+
 	/* Initialize Safety Features */
 	stmmac_safety_feat_configuration(priv);
 
-- 
2.53.0



