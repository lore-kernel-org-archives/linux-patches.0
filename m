Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 853B3418A39;
	Sat, 12 Sep 2026 08:52:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789203178; cv=none; b=fl8847Vl/MdPorSXaFqv5wu10OpGT9pe6bCzTi44Uo0qUhegC5GWfDy0PX4o+vta4B2GEmArFjKGdIhK4Q3IjYjrF3+5hTIg/h8BOkcV2pCKFhwkyDaBuxykb8JNLZLfEHT3Fx+E1xlX0JAZfOL3z1/0im5RYNjHaf5XzjI8JnA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789203178; c=relaxed/simple;
	bh=Imz8V5rbekFKJzya1N9r4btjerULMwpNcEXiIwUAx/o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P0PFMi6h7x/N+1zkfR5ld0Me4sbXnJLLq8qirxIiortdcz4J01+8oHxQUcY6nagx3FDBPAgFGju9v9+zdcHuT/vrqKcrgE/EFyFdiUwC+w6FC4G/QSYV1lnNc1wfx6lqoOw86v7zPNkE2gU/V/W0Vowrbycuys+sbKvAzMI7UFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AZy75pCD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AZy75pCD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 091D11F000FF;
	Sat, 12 Sep 2026 08:52:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789203177;
	bh=tjPcDZejBRZCijpQyHWJxX1pUE5anjngx1J2SX2RTwM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AZy75pCDzMp4hwKMcnfK7jJsShOnQg5D6VIWHHeqxRGSa1ZSxG57ljFJuPV0V7gfI
	 8vhj3fJ43aBZ12UQtl4xewnJeLw3u3AtEj1vz9CFOldYBjIMkmvbpvJl0tWiPhY8Zc
	 Vu1uV3pBdKblyDUe2B6TpSnBA7iMMmDeD2cYVib0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhenghang Xiao <kipreyyy@gmail.com>,
	David Heidelberg <david@ixit.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1354/1815] nfc: nci: fix double completion race in nci_data_exchange_complete
Date: Sat, 12 Sep 2026 08:51:44 +0200
Message-ID: <20260912065720.811476612@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

From: Zhenghang Xiao <kipreyyy@gmail.com>

[ Upstream commit 8265a626cc14a48e46e6dc8c47667e72b4232ac2 ]

nci_close_device() and nci_rx_work can both call
nci_data_exchange_complete() concurrently.  After commit 4527025d440ce8
("nfc: nci: fix circular locking dependency in nci_close_device") moved
flush_workqueue(ndev->rx_wq) after mutex_unlock(&ndev->req_lock),
rx_work is no longer serialized with the explicit completion call in the
close path.  Both callers read the non-NULL callback pointer and invoke
rawsock_data_exchange_complete(), which calls sock_put() -- but only one
sock_hold() was taken, so the second sock_put() underflows the refcount
and frees the socket while it is still in use.

Replace the bare clear_bit(NCI_DATA_EXCHANGE) with
test_and_clear_bit() so that only the first caller proceeds to invoke
the callback.

Fixes: 4527025d440c ("nfc: nci: fix circular locking dependency in nci_close_device")
Signed-off-by: Zhenghang Xiao <kipreyyy@gmail.com>
Link: https://patch.msgid.link/20260526103121.47957-1-kipreyyy@gmail.com
Signed-off-by: David Heidelberg <david@ixit.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/nfc/nci/data.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/net/nfc/nci/data.c b/net/nfc/nci/data.c
index 5f98c73db5afd..4253edea5c8db 100644
--- a/net/nfc/nci/data.c
+++ b/net/nfc/nci/data.c
@@ -46,11 +46,11 @@ void nci_data_exchange_complete(struct nci_dev *ndev, struct sk_buff *skb,
 	timer_delete_sync(&ndev->data_timer);
 	clear_bit(NCI_DATA_EXCHANGE_TO, &ndev->flags);
 
-	/* Mark the exchange as done before calling the callback.
-	 * The callback (e.g. rawsock_data_exchange_complete) may
-	 * want to immediately queue another data exchange.
-	 */
-	clear_bit(NCI_DATA_EXCHANGE, &ndev->flags);
+	/* Claim completion atomically -- both close and rx_work may race here */
+	if (!test_and_clear_bit(NCI_DATA_EXCHANGE, &ndev->flags)) {
+		kfree_skb(skb);
+		return;
+	}
 
 	if (cb) {
 		/* forward skb to nfc core */
-- 
2.53.0



