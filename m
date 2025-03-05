Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 558021946C7;
	Wed,  5 Mar 2025 17:52:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741197126; cv=none; b=BK/Bq654AlaGUP0w+sdWVn9uherZSr4JJXNldoYrTuZFdXwz0Dr84mBEq7dGRt4EXC5RCoPWvxHACuonb7iEdIjPTkL1T+cdmW6UcnhK535Z2i1MfW9BJchB5DJlO7N0JH/FZyf17Oi5YY0ZdAS7gOW4OzXhqy0cFelP7phVFhk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741197126; c=relaxed/simple;
	bh=nEqHWVCfpaoadstBiHD/KsX2pO+kJfi0ZwWSwn/tTc0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rB73FRRS5X7NGQZmKBB1OWmdU741/wGeGTYi3igYY6USpZd5fKPqxc08vM8QmRy9kPYnG06DqprqIwGt8FGwIAag4a5SKEyGgz7KsR60urs6b3LQIGUKhO8lXzUZH36fGMyj3NK3+wynPQ6suwBxKhS3lRgcGRaxXiPsig7sbms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WjEia55J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WjEia55J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7247C4CED1;
	Wed,  5 Mar 2025 17:52:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741197126;
	bh=nEqHWVCfpaoadstBiHD/KsX2pO+kJfi0ZwWSwn/tTc0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WjEia55JY+PoM3QJlfTDdV1/IvYsTzAwtCFqT/J3QBrec7Y1AJH4d3Ph7C3L23sA8
	 Liv0ecUYp/xmFFYusrzDjcE5jE6rZDDvRNxDFoC9SuFRoWxId81+KhGJ8ywrmvFaCo
	 VO4B8NqPHjpEWQUok9eCFLBF3b9PjfvWtpofCmSE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nick Child <nnac123@linux.ibm.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 049/176] ibmvnic: Return error code on TX scrq flush fail
Date: Wed,  5 Mar 2025 18:46:58 +0100
Message-ID: <20250305174507.433385482@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174505.437358097@linuxfoundation.org>
References: <20250305174505.437358097@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nick Child <nnac123@linux.ibm.com>

[ Upstream commit 5cb431dcf8048572e9ffc6c30cdbd8832cbe502d ]

In ibmvnic_xmit() if ibmvnic_tx_scrq_flush() returns H_CLOSED then
it will inform upper level networking functions to disable tx
queues. H_CLOSED signals that the connection with the vnic server is
down and a transport event is expected to recover the device.

Previously, ibmvnic_tx_scrq_flush() was hard-coded to return success.
Therefore, the queues would remain active until ibmvnic_cleanup() is
called within do_reset().

The problem is that do_reset() depends on the RTNL lock. If several
ibmvnic devices are resetting then there can be a long wait time until
the last device can grab the lock. During this time the tx/rx queues
still appear active to upper level functions.

FYI, we do make a call to netif_carrier_off() outside the RTNL lock but
its calls to dev_deactivate() are also dependent on the RTNL lock.

As a result, large amounts of retransmissions were observed in a short
period of time, eventually leading to ETIMEOUT. This was specifically
seen with HNV devices, likely because of even more RTNL dependencies.

Therefore, ensure the return code of ibmvnic_tx_scrq_flush() is
propagated to the xmit function to allow for an earlier (and lock-less)
response to a transport event.

Signed-off-by: Nick Child <nnac123@linux.ibm.com>
Link: https://lore.kernel.org/r/20240416164128.387920-1-nnac123@linux.ibm.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Stable-dep-of: bdf5d13aa05e ("ibmvnic: Don't reference skb after sending to VIOS")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index 6d17738c1c536..7fe1fefef9934 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -2181,7 +2181,7 @@ static int ibmvnic_tx_scrq_flush(struct ibmvnic_adapter *adapter,
 		ibmvnic_tx_scrq_clean_buffer(adapter, tx_scrq);
 	else
 		ind_bufp->index = 0;
-	return 0;
+	return rc;
 }
 
 static netdev_tx_t ibmvnic_xmit(struct sk_buff *skb, struct net_device *netdev)
@@ -2234,7 +2234,9 @@ static netdev_tx_t ibmvnic_xmit(struct sk_buff *skb, struct net_device *netdev)
 		tx_dropped++;
 		tx_send_failed++;
 		ret = NETDEV_TX_OK;
-		ibmvnic_tx_scrq_flush(adapter, tx_scrq);
+		lpar_rc = ibmvnic_tx_scrq_flush(adapter, tx_scrq);
+		if (lpar_rc != H_SUCCESS)
+			goto tx_err;
 		goto out;
 	}
 
@@ -2249,8 +2251,10 @@ static netdev_tx_t ibmvnic_xmit(struct sk_buff *skb, struct net_device *netdev)
 		dev_kfree_skb_any(skb);
 		tx_send_failed++;
 		tx_dropped++;
-		ibmvnic_tx_scrq_flush(adapter, tx_scrq);
 		ret = NETDEV_TX_OK;
+		lpar_rc = ibmvnic_tx_scrq_flush(adapter, tx_scrq);
+		if (lpar_rc != H_SUCCESS)
+			goto tx_err;
 		goto out;
 	}
 
-- 
2.39.5



