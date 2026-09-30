Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 797D351EE15;
	Wed, 30 Sep 2026 18:03:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790791427; cv=none; b=cOnTF6miiQy5WHxy8wHWhHi6eHyZW//i6x1fIoV5S8wc6WlLe0hKLiv4rGzB8SDqEBKgtOzDJiYSngVjqbsliPjT9ABv7edlD3e8vsfXkcNqSCahjKs1h8HqOQn2lw7/C9PK2fnHqTOzXUajnUjDtT1ijVB982SSwSMSQfkhJ7U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790791427; c=relaxed/simple;
	bh=tkjq+Hpjrm9gnmOrLtRERenJBsBv2SmQQbhA41eLKBU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oULFSGT/8xVKcOqvjMBJEUOgpfKE7K0r9khXO6LDft4ztLKh/WzP8/cFMgmflDft+Gwj2BArmuQTC0r7Bet8RvTraOdtlKX8HXgQ6nm8NVXBhvzOGQmpNBbhuh2Wulj2qZ/BBVaRv9eCeGPj8K+AAB1TLQRq+dKCvokytgncDMQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aOaqB+sI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aOaqB+sI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75D461F000FF;
	Wed, 30 Sep 2026 18:03:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790791426;
	bh=Hvptnxy/WOMKVjyOTBqSiVEpT4pyjSMmE+GFspeTYZ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aOaqB+sIy3YVgNlv8vK7BpU72CkM8BUimbTZdyFqQy63La2LkMSlR6cqWq6EoY9zl
	 RWoo4ugZuEfRSsItz9VvXhWSgxcvMuNh4uF4bNzFqs99srGxGHnlQLQMlV6IoKPlyq
	 B55L2ITW42y4s5vdzRFYDxBOLK9MSrUackyoQMy0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 298/752] net: stmmac: reconfigure RX packet parser table in stmmac_hw_setup() after reset
Date: Wed, 30 Sep 2026 17:22:48 +0200
Message-ID: <20260930152404.737944729@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index c9dda6cc2fa7a..496889d498832 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -3317,6 +3317,14 @@ static int stmmac_hw_setup(struct net_device *dev, bool ptp_register)
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



