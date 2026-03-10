Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 086C63BE160;
	Tue, 10 Mar 2026 11:29:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773142197; cv=none; b=X6RGo9J8YYZquqkzZyg9oiijwaSc9Cwps81VJQ1H0X7bUOfE+mDcw2pofKDot0CNJu47mpJA4NvO5bi4fCxlnnkDC5FH2IJ6lsLx7gdmCS4gjkc1EFh2trpJAAi4lePPASkYR22hL+ACd4wPrseK0PB9Ex08gUHuw5mECYhpsuw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773142197; c=relaxed/simple;
	bh=58Gor0ktNtkTotZ9aPBf5ta6XTsbeRT78T4FL/GLp9k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S7pJqPJ/+/Q/2DmV+eNUnhv85vKB5OUs0eq2blD0+eKrkB4n7nVZ7Pa0OgoV4fYD7JcJqMorS2KFAQajX7PlWTarb7Y9FzgeOfizk+BQe70SM3RQOJDU48fz3NIHqZBDTneXLtO0WkPuwYG4pWBOjBhq2OVvKXSozN8gUV6e+jw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Mr3d8XE5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Mr3d8XE5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52DB0C19423;
	Tue, 10 Mar 2026 11:29:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773142196;
	bh=58Gor0ktNtkTotZ9aPBf5ta6XTsbeRT78T4FL/GLp9k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Mr3d8XE5/IZxU1WTGsna0QfdmG0+6owAKhM0si7iPOMnITEqeujXuV7PJ+4xI1sNT
	 7WvsTRfZ4R7+CWlN3IzhORMBW8JVzKILmK0olQszwj+n1G777VSvAQxmsB3MkmmpsL
	 NIlJ0eto64DZCid3iOGKGIYCGt3kzPrit++S8kf0/ijyvdHp6K3g0Pswqta+5130oL
	 4uqkJJB+oWfbGKKYbinS8XFRsNOgqhNGKIzLzzdpEH1cpUtXgdMQQ0XiZzvfsZSh7a
	 i9l2u4v/sX5/A9MXLLIM6MomhKOeaWnIDTrH7pzQoG30DIg9wHVPf+09qLZe/v/SJ6
	 Xc6INMwn6U9rw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Jakub Kicinski <kuba@kernel.org>,
	Joe Damato <joe@dama.to>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 286/314] nfc: nci: clear NCI_DATA_EXCHANGE before calling completion callback
Date: Tue, 10 Mar 2026 07:19:05 -0400
Message-ID: <98cb768b1711b317717d8a6d0589371e35577fdf.1773141555.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773141554.git.sashal@kernel.org>
References: <cover.1773141554.git.sashal@kernel.org>
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

