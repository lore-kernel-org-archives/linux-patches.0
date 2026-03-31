Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AAEF3E92A5;
	Tue, 31 Mar 2026 16:26:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774974418; cv=none; b=BzSnhjD4LOfshqbB1SgJtFOhr5lO+ykoP63cVUNtjRPYiITGgVLQdiFyS/CKLPJLH7OJTrLMlLupNzvuhO8A2/jiQKPw8Y4bG0tMTHTbgsJ6YK8288URXfINkR7B505HffJZycX3k5VnJFwAMa64BYfICcZrHUNNZliclou4cnE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774974418; c=relaxed/simple;
	bh=ff/J5qTE2wHjkj+cgxCqZJmGlozOVC8IudAxnw20mVs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GPq0uZl/w7wHCBwtu3Poj035efD6wO1okJY6kW0JE6lnDTQjyZjZVXQoicRwao1YDu50+t3SyV0Y0RwvRF+N1XH1rvDjg7PtL9lQgkBL9X7z19/LZ+MMlXljCzpJyDmabrFpoc0SXA142yqj5DI4roi1w4Rd1efyA/RQfJVUEXg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q9O/lVd9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q9O/lVd9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B57A1C19423;
	Tue, 31 Mar 2026 16:26:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774974418;
	bh=ff/J5qTE2wHjkj+cgxCqZJmGlozOVC8IudAxnw20mVs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q9O/lVd99nNhKaq+WOGxIYODxoH5Z1qkyf4ShzlDY4Ztc5wtDOZBBWitCROzwZLyL
	 1OhUKCgPhQgERcQ6fr5VTjO4tLYL2V8MsJyV82GYFxFBLw6acRErDnHjOo7UqcZdrY
	 41tmokIAukbxRUtYq83s5Usp7hEvOf7djTLHD+zo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Ray <ian.ray@gehealthcare.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 045/175] nfc: nci: fix circular locking dependency in nci_close_device
Date: Tue, 31 Mar 2026 18:20:29 +0200
Message-ID: <20260331161731.441220906@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161729.779738837@linuxfoundation.org>
References: <20260331161729.779738837@linuxfoundation.org>
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

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit 4527025d440ce84bf56e75ce1df2e84cb8178616 ]

nci_close_device() flushes rx_wq and tx_wq while holding req_lock.
This causes a circular locking dependency because nci_rx_work()
running on rx_wq can end up taking req_lock too:

  nci_rx_work -> nci_rx_data_packet -> nci_data_exchange_complete
    -> __sk_destruct -> rawsock_destruct -> nfc_deactivate_target
    -> nci_deactivate_target -> nci_request -> mutex_lock(&ndev->req_lock)

Move the flush of rx_wq after req_lock has been released.
This should safe (I think) because NCI_UP has already been cleared
and the transport is closed, so the work will see it and return
-ENETDOWN.

NIPA has been hitting this running the nci selftest with a debug
kernel on roughly 4% of the runs.

Fixes: 6a2968aaf50c ("NFC: basic NCI protocol implementation")
Reviewed-by: Ian Ray <ian.ray@gehealthcare.com>
Link: https://patch.msgid.link/20260317193334.988609-1-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/nfc/nci/core.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/net/nfc/nci/core.c b/net/nfc/nci/core.c
index 1f33da345bea6..e2ffdb06bf9aa 100644
--- a/net/nfc/nci/core.c
+++ b/net/nfc/nci/core.c
@@ -575,8 +575,7 @@ static int nci_close_device(struct nci_dev *ndev)
 	skb_queue_purge(&ndev->rx_q);
 	skb_queue_purge(&ndev->tx_q);
 
-	/* Flush RX and TX wq */
-	flush_workqueue(ndev->rx_wq);
+	/* Flush TX wq, RX wq flush can't be under the lock */
 	flush_workqueue(ndev->tx_wq);
 
 	/* Reset device */
@@ -588,13 +587,13 @@ static int nci_close_device(struct nci_dev *ndev)
 		      msecs_to_jiffies(NCI_RESET_TIMEOUT));
 
 	/* After this point our queues are empty
-	 * and no works are scheduled.
+	 * rx work may be running but will see that NCI_UP was cleared
 	 */
 	ndev->ops->close(ndev);
 
 	clear_bit(NCI_INIT, &ndev->flags);
 
-	/* Flush cmd wq */
+	/* Flush cmd and tx wq */
 	flush_workqueue(ndev->cmd_wq);
 
 	del_timer_sync(&ndev->cmd_timer);
@@ -604,6 +603,9 @@ static int nci_close_device(struct nci_dev *ndev)
 
 	mutex_unlock(&ndev->req_lock);
 
+	/* rx_work may take req_lock via nci_deactivate_target */
+	flush_workqueue(ndev->rx_wq);
+
 	return 0;
 }
 
-- 
2.51.0



