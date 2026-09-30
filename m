Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23DA53E1230;
	Wed, 30 Sep 2026 19:08:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790795320; cv=none; b=BZ6MAeFmW3TaxCL0+7EYLOJE5WQ2P/ptgtl4s4gR8/VL+0s3/5gkLoEavaJOq9JSAFdzK0KTGiBspWk4z7p+Hh/AuACZazQ3IVCHAkHrg1GTL+6KDP6xCOmkxbHNXnO+clDy41P50nQnRbKRWw3mZFw7LMsjtKwcTBFvKb/YRrE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790795320; c=relaxed/simple;
	bh=fq4O/cXzqWcmfpLrOc4X+StZMvUSkNkRGzhW5t3jIRQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XYq8tgHiD28bl/iwNMr1lGKHY3YmbZgJCA23RJPTajgBID3iJakEq2WGAogdIHIcYQ+273uShnCnl4rGUIRK2tECYGNs2upBnfDFguiMu6lo29OcFlBxZjT3NlZ5XuFnw9/0Yfc+zVNjdicjXcx+M+PsYJzOdmhxDET2a6AsaN8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qw6wB4T2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qw6wB4T2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 803321F00898;
	Wed, 30 Sep 2026 19:08:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790795319;
	bh=ufXtj5XuwtUnwKvUyWEbQsyqkR3juOQk822WbVoHORg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qw6wB4T2PfaXZBRolntGj9zTgwLpJVPcDcuA0ml00FA5gER6kNKoqK7Pf45S1HR0N
	 wnY0ssCURY2NTVi8w/fahlve12pKKpJ2jLLOOXNKUbSGUBCgHYaGvBnaZ/ThmbLTj5
	 ph1Hq0ktgZxO/Tp6wzpP/VhAKcUBqFMv+DqsUq4A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0475/1193] net: stmmac: reconfigure RX packet parser table in stmmac_hw_setup() after reset
Date: Wed, 30 Sep 2026 17:19:19 +0200
Message-ID: <20260930152444.715200779@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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
index 2fc0a87534c72..2bdaa35a05282 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -3330,6 +3330,14 @@ static int stmmac_hw_setup(struct net_device *dev, bool ptp_register)
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



