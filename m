Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25D2E155351;
	Tue, 23 Jul 2024 18:28:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721759306; cv=none; b=SoYNyKlvnb9DiTW5l/4OUgV3qYYDglNSM3fO2drde4oWCR9W10e09uPjgLVI0F07JOWfLFr69FOf4WhSswaA+3rTRITDiteAQDhLkfF2aenIFkRdrekBHjmabbPIAyL9EptMHwTwqEbGGiz+3YEJBzhioZRnI56kK218ND06/jU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721759306; c=relaxed/simple;
	bh=o1Z+9KAjkp+D6DoWfMDKwVKGS/kjRmWYDNz0+zgRJtA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jFifvB9dS6TDZ3ZLULc+5SpnEotZviBSFGLpUiEQHJWlFQGsgv5Ayb3C8TykR7VKcKfI4FEYcP0tWEASyn3xwClUoHGqFR1DMdeyR1Siz+HYAPxSmhuMgXq1plEBZJ8BAbe17bcjjreatV0HfUA4ktvGsQdps8s/K4S9/uMddZ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=We/W+QHA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="We/W+QHA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9722BC4AF0A;
	Tue, 23 Jul 2024 18:28:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721759306;
	bh=o1Z+9KAjkp+D6DoWfMDKwVKGS/kjRmWYDNz0+zgRJtA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=We/W+QHAOOCvva1kZzRE6ZAz4F6rTSMsfvaB+qbxqQuz1/XMzFTPEjH96eyOQsGe8
	 /R80Vq39+fS6FoyG/6TDw2/Dt/za9jYolvO1BFPNKCKm8Xizk1PDoqw6o2VtX7p6zM
	 JDrQR+V4U3uLTUKHNKZB1ghEzFShs3mgTLYtFLOw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nick Child <nnac123@linux.ibm.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 072/105] ibmvnic: Add tx check to prevent skb leak
Date: Tue, 23 Jul 2024 20:23:49 +0200
Message-ID: <20240723180406.020576878@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240723180402.490567226@linuxfoundation.org>
References: <20240723180402.490567226@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nick Child <nnac123@linux.ibm.com>

[ Upstream commit 0983d288caf984de0202c66641577b739caad561 ]

Below is a summary of how the driver stores a reference to an skb during
transmit:
    tx_buff[free_map[consumer_index]]->skb = new_skb;
    free_map[consumer_index] = IBMVNIC_INVALID_MAP;
    consumer_index ++;
Where variable data looks like this:
    free_map == [4, IBMVNIC_INVALID_MAP, IBMVNIC_INVALID_MAP, 0, 3]
                                               	consumer_index^
    tx_buff == [skb=null, skb=<ptr>, skb=<ptr>, skb=null, skb=null]

The driver has checks to ensure that free_map[consumer_index] pointed to
a valid index but there was no check to ensure that this index pointed
to an unused/null skb address. So, if, by some chance, our free_map and
tx_buff lists become out of sync then we were previously risking an
skb memory leak. This could then cause tcp congestion control to stop
sending packets, eventually leading to ETIMEDOUT.

Therefore, add a conditional to ensure that the skb address is null. If
not then warn the user (because this is still a bug that should be
patched) and free the old pointer to prevent memleak/tcp problems.

Signed-off-by: Nick Child <nnac123@linux.ibm.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index 8f377d0a80fe6..6d17738c1c536 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -2288,6 +2288,18 @@ static netdev_tx_t ibmvnic_xmit(struct sk_buff *skb, struct net_device *netdev)
 	    (tx_pool->consumer_index + 1) % tx_pool->num_buffers;
 
 	tx_buff = &tx_pool->tx_buff[bufidx];
+
+	/* Sanity checks on our free map to make sure it points to an index
+	 * that is not being occupied by another skb. If skb memory is
+	 * not freed then we see congestion control kick in and halt tx.
+	 */
+	if (unlikely(tx_buff->skb)) {
+		dev_warn_ratelimited(dev, "TX free map points to untracked skb (%s %d idx=%d)\n",
+				     skb_is_gso(skb) ? "tso_pool" : "tx_pool",
+				     queue_num, bufidx);
+		dev_kfree_skb_any(tx_buff->skb);
+	}
+
 	tx_buff->skb = skb;
 	tx_buff->index = bufidx;
 	tx_buff->pool_index = queue_num;
-- 
2.43.0



