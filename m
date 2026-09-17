Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEDEA53B5F8;
	Thu, 17 Sep 2026 15:35:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789659327; cv=none; b=uWA/6oKZmPOBajJItGVi8gUqPdyRFaWv3JW5AfLFWCKyuPl4kq6FbfVEjM9AWKKzYFnT/Hxs6iFsJotazzuN05SA7ul4X/1fFJf9i2d+zO2JRfxTHzpyoMSCewGFJiq821UsML1u6dAJ2iLTPNaYSI5Xjq1V5I8y6nc2KO5secQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789659327; c=relaxed/simple;
	bh=zQvS5BuO9AKvLIveh4EeDEzYW+3ZoSXCOp6GMszTi5g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sd8vXjYy+kV/itcrBQC1WNl//yorQNWRrE8UIBeoI136mXK8QycR98u4+pMbb6FTWiP7rf59Ew3tPy+i3j3Lgw1n/Fir2GC1KBxIMnif9+CpZpoe4R1RXXhQqpLdHhpE/Wi6lvfXQpo5B+r27b+iWvT9WOCMcuu6me/7sVwN5HU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B+qF8gb8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B+qF8gb8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62F9F1F00898;
	Thu, 17 Sep 2026 15:35:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789659321;
	bh=1o5Yw8uRUOtptzBacl/943pwIXKEY/UjfTbHPWbltUs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=B+qF8gb8rqmXW1FOCOjdS/ZFwAElop1jLxh4BWNS4nqLfgZpWHGt5/Xcp32I3626M
	 sVPh9P4DmXxEs8N7j9PF8DWaW7ikgKzrzc7ZCUu91xBPoKDQQsnv6plLZqLjJpxrnb
	 o4EWxDHjlwKL5MOqSFIrQFHLTHc81wTOps9xvJ5s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 218/733] net: stmmac: reconfigure RX packet parser table in stmmac_hw_setup() after reset
Date: Thu, 17 Sep 2026 16:08:46 +0100
Message-ID: <20260917151356.633383183@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index 1946361081fc2..1e88575fdddbb 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -3676,6 +3676,14 @@ static int stmmac_hw_setup(struct net_device *dev)
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



