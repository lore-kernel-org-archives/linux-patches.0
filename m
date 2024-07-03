Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 185CC17BB1F;
	Wed,  3 Jul 2024 11:26:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720006016; cv=none; b=O7ve59sjH7zRtGTFVfrCIhk0CPB8dMyI48bgBH1U3YfN1X9oA3SLVXQumDzUJh/kI6/1ciZQOk2df9CeZKbg1SAzH8cPrBEkeQ+ohv7D7xK3EfujgOgRZO9meGENZkj9Zb6Yts1GO4DeoJ5mwC0oDVJUzw8hu1Lz9UnwUF9G+Vo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720006016; c=relaxed/simple;
	bh=yXYXNsn67TCeySGpJKRqqqTigct9CoCM2zYGSaxhUe8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CFabFclGQUokq1IZhVfRKCdg424aAPexH+wxYREaiPyDp13+UKcba8SOAA7SsCMs8WixmUVMOLINLNRs5uNRrBNQvfGFSf4TEdwPwSYd2BlOgB0dmJvtweTydyzEDz6E/cbrASDP90ZAF+Lzj/7Oq8Y9f5T6i8IO2kcP8mte8hg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KyywgSzZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KyywgSzZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96C40C2BD10;
	Wed,  3 Jul 2024 11:26:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720006016;
	bh=yXYXNsn67TCeySGpJKRqqqTigct9CoCM2zYGSaxhUe8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KyywgSzZ46VSAKHzRhjlf7bC+NIbPXYSxHyRVxinhGguwv5L5kVYksnnMWxxOVI1B
	 QPOYCCmCvrKF1rhftg0DcwCJskhZJ4kcAf5DN+UpBUluGBcsKN7BV6naZvLe86bn9u
	 Bv2/hmv3wN5pH8ZApDfta+rY71dSxJiQfzU3A1sk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nick Child <nnac123@linux.ibm.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 272/356] ibmvnic: Free any outstanding tx skbs during scrq reset
Date: Wed,  3 Jul 2024 12:40:08 +0200
Message-ID: <20240703102923.405314024@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102913.093882413@linuxfoundation.org>
References: <20240703102913.093882413@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 890e27b986e2a..7f4539a2e5517 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -3409,6 +3409,12 @@ static void release_sub_crqs(struct ibmvnic_adapter *adapter, bool do_h_free)
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



