Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA03D2D5C68;
	Tue, 31 Mar 2026 17:00:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774976435; cv=none; b=GhhrhSVtSdTUbPY9hrk+lJonM//oeLb8LkEm9B9i7GM0KAxaR1efnS4AoKnYZpFBREWonvLzaTtc8VNyJ3kZdIPlmWZEfpC47fSFEYm3CSyb4gQiTRzVMAtnbLXeadvLytDWjZZaByrWjMrZQ6jhw+hA/FaQHgWeFZGQzekiV3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774976435; c=relaxed/simple;
	bh=NpdDV44e8Uzu+lY2RVNngfpErlueErbP5Hk2ppdruDY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OnUzoszi1Ds63YBRtmxJFbFjR67cTrJ1N1ojQA4M6/rr9QZn1WbVqYlr0Wu9sVYNE5H+bgc6j72Pgqgq3+yflJO2tDYXQkIW+QiHQuhIsWWt9NLFbpI8k8Hk3c3Fb3vL4JzdGCWjaPvkFafzIuMqXYh5EaZPYhzi7GEGkP9/zGY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TO54BdJ6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TO54BdJ6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BA65C2BCB4;
	Tue, 31 Mar 2026 17:00:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774976435;
	bh=NpdDV44e8Uzu+lY2RVNngfpErlueErbP5Hk2ppdruDY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TO54BdJ6HbBmmd+KhKTd1ptNPR0BgklbaYB8HULjrOoYqRr8qJR17YDT7OJX57nfd
	 re4cNJDyYSkcnKzCDVgjzoiphnunlG5CvlDCfLdiEUppKnLbtrLNb9RT7ehU8QuWBD
	 Nfw0NGBflfs0zchfZsBhKxXhmdQE//o90WCkGdq0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Ray <ian.ray@gehealthcare.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 090/309] nfc: nci: fix circular locking dependency in nci_close_device
Date: Tue, 31 Mar 2026 18:19:53 +0200
Message-ID: <20260331161756.804683378@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161753.468533260@linuxfoundation.org>
References: <20260331161753.468533260@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index d334b7aa8c172..25ba4cbb00e1e 100644
--- a/net/nfc/nci/core.c
+++ b/net/nfc/nci/core.c
@@ -579,8 +579,7 @@ static int nci_close_device(struct nci_dev *ndev)
 	skb_queue_purge(&ndev->rx_q);
 	skb_queue_purge(&ndev->tx_q);
 
-	/* Flush RX and TX wq */
-	flush_workqueue(ndev->rx_wq);
+	/* Flush TX wq, RX wq flush can't be under the lock */
 	flush_workqueue(ndev->tx_wq);
 
 	/* Reset device */
@@ -592,13 +591,13 @@ static int nci_close_device(struct nci_dev *ndev)
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
 
 	timer_delete_sync(&ndev->cmd_timer);
@@ -613,6 +612,9 @@ static int nci_close_device(struct nci_dev *ndev)
 
 	mutex_unlock(&ndev->req_lock);
 
+	/* rx_work may take req_lock via nci_deactivate_target */
+	flush_workqueue(ndev->rx_wq);
+
 	return 0;
 }
 
-- 
2.51.0



