Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 697DB1BD505;
	Tue,  2 Jul 2024 17:07:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719940056; cv=none; b=U8JML9pL4T8X1g8CeXEtLqnx9pabMYKT7Tt81BvegwSBC/OY4yO8JllDkvmKAkG/RJNELelET7V2KlawO9PMrdvzZZ9jGcYE7+BGMVr8aQn+p5ZdnorqdW0Kp1WOigXgi8cmnXFcuTRPX7ts/4Q+/o96MNFaUbBovgyAMEytRXc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719940056; c=relaxed/simple;
	bh=aBp1nYm8pTMJJouKQUWXdR1G4bLjLO4bJKpBuACrpls=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DsESpLUc0Tcox9QW42o6kysupbnvS8TpdIrwMMBPmDnoyoxM6NifyBT/7JKIm5bAXucCcXbM9UkLEpf85rtXpvq1qNh+/wExg1Qq3EF3sSVvoJL91CyFKWr3VAzsI4Ypo7ou58fOvkFMtQlA4Jq+fT1o9PHA9XUXnPfAsTbcQc4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NVpiLJyA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NVpiLJyA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8F6EC4AF07;
	Tue,  2 Jul 2024 17:07:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719940056;
	bh=aBp1nYm8pTMJJouKQUWXdR1G4bLjLO4bJKpBuACrpls=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NVpiLJyAODdpLXLz72s8iPvtLR+wt6DtPcaqi+ExAJtdTry3cJjNZEfkFBqxiRyPA
	 LyEmLct/k4oG3AVz3EFpbsYykm9aTTXPFSuWA8H7SElrAVlFltNlPvx0za9ytLBs9R
	 IZk5Q1OqfBdilogluEwyuam+r3e6wWuMioUI8Yow=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nick Child <nnac123@linux.ibm.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 039/222] ibmvnic: Free any outstanding tx skbs during scrq reset
Date: Tue,  2 Jul 2024 19:01:17 +0200
Message-ID: <20240702170245.470049513@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170243.963426416@linuxfoundation.org>
References: <20240702170243.963426416@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nick Child <nnac123@linux.ibm.com>

[ Upstream commit 49bbeb5719c2f56907d3a9623b47c6c15c2c431d ]

There are 2 types of outstanding tx skb's:
Type 1: Packets that are sitting in the drivers ind_buff that are
waiting to be batch sent to the NIC. During a device reset, these are
freed with a call to ibmvnic_tx_scrq_clean_buffer()
Type 2: Packets that have been sent to the NIC and are awaiting a TX
completion IRQ. These are free'd during a reset with a call to
clean_tx_pools()

During any reset which requires us to free the tx irq, ensure that the
Type 2 skb references are freed. Since the irq is released, it is
impossible for the NIC to inform of any completions.

Furthermore, later in the reset process is a call to init_tx_pools()
which marks every entry in the tx pool as free (ie not outstanding).
So if the driver is to make a call to init_tx_pools(), it must first
be sure that the tx pool is empty of skb references.

This issue was discovered by observing the following in the logs during
EEH testing:
	TX free map points to untracked skb (tso_pool 0 idx=4)
	TX free map points to untracked skb (tso_pool 0 idx=5)
	TX free map points to untracked skb (tso_pool 1 idx=36)

Fixes: 65d6470d139a ("ibmvnic: clean pending indirect buffs during reset")
Signed-off-by: Nick Child <nnac123@linux.ibm.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index 30c47b8470ade..722bb724361c2 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -4057,6 +4057,12 @@ static void release_sub_crqs(struct ibmvnic_adapter *adapter, bool do_h_free)
 		adapter->num_active_tx_scrqs = 0;
 	}
 
+	/* Clean any remaining outstanding SKBs
+	 * we freed the irq so we won't be hearing
+	 * from them
+	 */
+	clean_tx_pools(adapter);
+
 	if (adapter->rx_scrq) {
 		for (i = 0; i < adapter->num_active_rx_scrqs; i++) {
 			if (!adapter->rx_scrq[i])
-- 
2.43.0



