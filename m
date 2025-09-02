Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AA5920B1F5;
	Tue,  2 Sep 2025 13:32:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756819950; cv=none; b=qLVLvVCO3Sm8Cnwzhvj6DiKdLZQsn4mxh2JrD7P8QuKVdYpfCSCNs1+CVhkoLLU1ZltjS2m10IfzBPtOl+f3Gdhgxzy5No0InVzXcTLs/7lzmPUWnywTXdzkNYIfnHa/DZ6IroLPebbRgKNwkphflzlBJSZZpZnBQYGYYwWUqXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756819950; c=relaxed/simple;
	bh=wgQIdReXxbSBVcKNumr5GzPYizrJOhz626zmYIgZqxA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hBl55G5tLoiHAtmyRWxpaij/Y9+xNqxQT241gr90As99YO8QD1XB4320wXSpXzy+A6+7VkUHiz9e2CZHV5ljyxaDIYMh46L+lBSHO4lB18d808G/kPGHqiSwE7Ag5mVNM0WauuXFiCvMAImb4gfQLBEDn61YXxR+bnMmxiuRj4c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=07lsXXTC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="07lsXXTC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0197C4CEED;
	Tue,  2 Sep 2025 13:32:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756819950;
	bh=wgQIdReXxbSBVcKNumr5GzPYizrJOhz626zmYIgZqxA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=07lsXXTC9MLatSw/WBTIUx87BWtExXdfMDlrZ8p47sjwc1tmuLI06ePcjm4IYUWs5
	 6XOGjOE1TiyNJxPkJ/c4DV9rngrHnAZK3R+Nzc5CeoiwWq/z7AEvHuLjvGBtEvtdba
	 1v6VK/YDBGl+g7+VVloT+pX+MoJpOfn+vnFl6Y/Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Somnath Kotur <somnath.kotur@broadcom.com>,
	Michael Chan <michael.chan@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 46/95] bnxt_en: Adjust TX rings if reservation is less than requested
Date: Tue,  2 Sep 2025 15:20:22 +0200
Message-ID: <20250902131941.368657963@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250902131939.601201881@linuxfoundation.org>
References: <20250902131939.601201881@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Chan <michael.chan@broadcom.com>

[ Upstream commit 1ee581c24dfdcbc6de25aac95a48c1f08e9a542c ]

Before we accept an ethtool request to increase a resource (such as
rings), we call the FW to check that the requested resource is likely
available first before we commit.  But it is still possible that
the actual reservation or allocation can fail.  The existing code
is missing the logic to adjust the TX rings in case the reserved
TX rings are less than requested.  Add a warning message (a similar
message for RX rings already exists) and add the logic to adjust
the TX rings.  Without this fix, the number of TX rings reported
to the stack can exceed the actual TX rings and ethtool -l will
report more than the actual TX rings.

Fixes: 674f50a5b026 ("bnxt_en: Implement new method to reserve rings.")
Reviewed-by: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
Reviewed-by: Somnath Kotur <somnath.kotur@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Link: https://patch.msgid.link/20250825175927.459987-3-michael.chan@broadcom.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index dc123822771b6..b8c6087a5c31e 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -7788,6 +7788,11 @@ static int __bnxt_reserve_rings(struct bnxt *bp)
 		hwr.rx = rx_rings << 1;
 	tx_cp = bnxt_num_tx_to_cp(bp, hwr.tx);
 	hwr.cp = sh ? max_t(int, tx_cp, rx_rings) : tx_cp + rx_rings;
+	if (hwr.tx != bp->tx_nr_rings) {
+		netdev_warn(bp->dev,
+			    "Able to reserve only %d out of %d requested TX rings\n",
+			    hwr.tx, bp->tx_nr_rings);
+	}
 	bp->tx_nr_rings = hwr.tx;
 
 	/* If we cannot reserve all the RX rings, reset the RSS map only
@@ -12269,6 +12274,13 @@ static int __bnxt_open_nic(struct bnxt *bp, bool irq_re_init, bool link_re_init)
 	if (rc)
 		return rc;
 
+	/* Make adjustments if reserved TX rings are less than requested */
+	bp->tx_nr_rings -= bp->tx_nr_rings_xdp;
+	bp->tx_nr_rings_per_tc = bnxt_tx_nr_rings_per_tc(bp);
+	if (bp->tx_nr_rings_xdp) {
+		bp->tx_nr_rings_xdp = bp->tx_nr_rings_per_tc;
+		bp->tx_nr_rings += bp->tx_nr_rings_xdp;
+	}
 	rc = bnxt_alloc_mem(bp, irq_re_init);
 	if (rc) {
 		netdev_err(bp->dev, "bnxt_alloc_mem err: %x\n", rc);
-- 
2.50.1



