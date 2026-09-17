Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 420C44EDCD3;
	Thu, 17 Sep 2026 17:19:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789665561; cv=none; b=KiPcrhMU05UqMkupSOHdV5A3WopaK3B7TxaDjF3kKkJZ92qUC0sL8aUqI7qVIZp69Wx+DWB2av1Q6DkkL8uug1j+n6mvRSN5dvRmPH4kAL5TqcriVU/sKFAlk0ZlwnJ4eMXqILKgypzMBgJ8Bp7i32jrinlyrSHhtTp7N9ItxXg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789665561; c=relaxed/simple;
	bh=XvzxMZjmLkMSmf+KRdmkF5tL3/TRDcXn5zR/gaZtnzA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SSfndXkF6gdMwVPByEyLWAJoNtGnaW/su3HF48/Uwv8endUpYOb0kCCQT9pfUksFGe2oy2U2oAEByh70rzunqJtryDM+ryuOYV883PbKvVAIHE75hBrl5GWp0ZVdOsQ8rR0UBPqSACevI4y1pPuTxAS4/hODzVeRS1hRKN+F7Gw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E6UXGLao; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E6UXGLao"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 999D41F00893;
	Thu, 17 Sep 2026 17:19:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789665560;
	bh=uRyTH57RTXhX4UCEuADL08wj+4W/hGcuwc+ooBq0P7k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=E6UXGLaonsHJqDRfAv2pYz/3Rr/EiVoqt4anKxZ1orXMI+SsakhiCrlPOMJqpnWiq
	 sP8oUus2WP6Hy3ECAKiMQOE2rjZNxX0UceRm/zhDy5ZVNblx+3VKQKcMg8PIwFmYSC
	 czPWT4jLv4vFOsMH0OVttrSvK3l1gfa7q6jQdSto=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0746/1250] net: stmmac: reconfigure RX packet parser table in stmmac_hw_setup() after reset
Date: Thu, 17 Sep 2026 16:09:01 +0100
Message-ID: <20260917151612.104402737@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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
index a3eeb68c8d3f4..3f184c91db458 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -3455,6 +3455,14 @@ static int stmmac_hw_setup(struct net_device *dev)
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



