Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0092538A718;
	Tue, 10 Mar 2026 11:14:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141278; cv=none; b=awpidu+WrYLt8+HhK28/7UM8P4kcqdHw0z8ELEKMgB5yoh34gDPRACR+eNRJwpek3mhprKtfUBP4X7ow8ShY0/W5sKN+ReVXsL6oErn7bIA6i4CMmfuFYNklPmfMDrxQ5kLxv/eMv44UpOLiuSJysr4OMP4Fc/GBO/RozSNQlAM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141278; c=relaxed/simple;
	bh=58Gor0ktNtkTotZ9aPBf5ta6XTsbeRT78T4FL/GLp9k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ukkbei4EDwS2KcwKQFI4vzTOxZjVFvIFBeEl/GL5tkjAeWmGlVPNu5CbL0kXctJ1rLst+Ezrj/HFsS+I0TgP5qYk/kZSLk4iEIgGWV+IR5o4Res1m5RNP6R6Skd07I5/Z/orvJX1R+GPzI81C29F418B98dKUqtWmIJJDZovRJA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AbsA3Jvq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AbsA3Jvq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03493C2BC86;
	Tue, 10 Mar 2026 11:14:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141277;
	bh=58Gor0ktNtkTotZ9aPBf5ta6XTsbeRT78T4FL/GLp9k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AbsA3JvqiZDSkzq01R6xNweMMj71jKl1nJ2o8r0hXhlc6ruEnlJryRv74u0K2B0pN
	 I4w/wYHA1LUwmqXkZ2G9iSpSwnjYtAADa2ji4UbZZaPxrTy46y9iUezVPY8uxnhZHO
	 MB+SRLkAoJzzO129Vfc3u0M3Pk8yQemFRZrj3SxT5qTsnMapl8c9r2mYM17CUa4/oN
	 0RwBm+eo75mfuNCAMNUYPXL96HzGy6a4eMb9ytvR9/flzhe9XvE2DXpURWDIeAHvBQ
	 ufD05CJGx1hQOdXQ+dDhNiY2bVq8IAkQ7O/gb0hC+yPN9eW8tGNDZnjqMD1PeAIGDG
	 z4La9tvukGB8A==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Jakub Kicinski <kuba@kernel.org>,
	Joe Damato <joe@dama.to>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 280/311] nfc: nci: clear NCI_DATA_EXCHANGE before calling completion callback
Date: Tue, 10 Mar 2026 07:05:27 -0400
Message-ID: <80f72393c86f2db9a3bd717b0d714ff030656b2c.1773140655.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773140654.git.sashal@kernel.org>
References: <cover.1773140654.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit 0efdc02f4f6d52f8ca5d5889560f325a836ce0a8 ]

Move clear_bit(NCI_DATA_EXCHANGE) before invoking the data exchange
callback in nci_data_exchange_complete().

The callback (e.g. rawsock_data_exchange_complete) may immediately
schedule another data exchange via schedule_work(tx_work).  On a
multi-CPU system, tx_work can run and reach nci_transceive() before
the current nci_data_exchange_complete() clears the flag, causing
test_and_set_bit(NCI_DATA_EXCHANGE) to return -EBUSY and the new
transfer to fail.

This causes intermittent flakes in nci/nci_dev in NIPA:

  # #  RUN           NCI.NCI1_0.t4t_tag_read ...
  # # t4t_tag_read: Test terminated by timeout
  # #          FAIL  NCI.NCI1_0.t4t_tag_read
  # not ok 3 NCI.NCI1_0.t4t_tag_read

Fixes: 38f04c6b1b68 ("NFC: protect nci_data_exchange transactions")
Reviewed-by: Joe Damato <joe@dama.to>
Link: https://patch.msgid.link/20260303162346.2071888-5-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/nfc/nci/data.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/net/nfc/nci/data.c b/net/nfc/nci/data.c
index 78f4131af3cf3..5f98c73db5afd 100644
--- a/net/nfc/nci/data.c
+++ b/net/nfc/nci/data.c
@@ -33,7 +33,8 @@ void nci_data_exchange_complete(struct nci_dev *ndev, struct sk_buff *skb,
 	conn_info = nci_get_conn_info_by_conn_id(ndev, conn_id);
 	if (!conn_info) {
 		kfree_skb(skb);
-		goto exit;
+		clear_bit(NCI_DATA_EXCHANGE, &ndev->flags);
+		return;
 	}
 
 	cb = conn_info->data_exchange_cb;
@@ -45,6 +46,12 @@ void nci_data_exchange_complete(struct nci_dev *ndev, struct sk_buff *skb,
 	timer_delete_sync(&ndev->data_timer);
 	clear_bit(NCI_DATA_EXCHANGE_TO, &ndev->flags);
 
+	/* Mark the exchange as done before calling the callback.
+	 * The callback (e.g. rawsock_data_exchange_complete) may
+	 * want to immediately queue another data exchange.
+	 */
+	clear_bit(NCI_DATA_EXCHANGE, &ndev->flags);
+
 	if (cb) {
 		/* forward skb to nfc core */
 		cb(cb_context, skb, err);
@@ -54,9 +61,6 @@ void nci_data_exchange_complete(struct nci_dev *ndev, struct sk_buff *skb,
 		/* no waiting callback, free skb */
 		kfree_skb(skb);
 	}
-
-exit:
-	clear_bit(NCI_DATA_EXCHANGE, &ndev->flags);
 }
 
 /* ----------------- NCI TX Data ----------------- */
-- 
2.51.0

