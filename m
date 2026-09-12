Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5552288B9;
	Sat, 12 Sep 2026 16:41:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789231275; cv=none; b=EYQl7bDEZyH+ixDv76QPvHB8eIidOEvdVMSLaOfGXVaMvyVeSchlOAyx5CFGy8cJnU/tj2UZ76DlgFxo/UksEVGHUSNcm2lbjrTOldpdJzjS9ytp7+Ex34XOJ/tx57otBNMi3i9tRNodVMjkxPcxbrvhL+HvMXjmDGGNnwQIsrY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789231275; c=relaxed/simple;
	bh=6jsdxBuZqHzy5e0j+4XvYCacFCsmiF0HtqPoO/NAo/k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X5WKdXdk4FFVva5asjjDAJ8bOWPBkAIjoQ5YbVk+2VRwKvj7OHJz5hwD3zpp7CzjrBxXZXmTZFzt0NG8hoE7TTmNBSss4JuPJ4Z0/bePQlXXFBvfHUEsMhENt2H0gZ+iXcj9FjUlSbsAMKVGdXcn118TRLOpCuusD3WOO5TXdcQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VFNVAZLt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VFNVAZLt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B01421F000FF;
	Sat, 12 Sep 2026 16:41:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789231273;
	bh=qrrIgsAhJpuEFBLMkExfUFzVfc+/V0qKiPDoRsQz0IA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VFNVAZLtuYAWbUVgg1Dj2+CFrcpYVns1gAW05i7RxaNnbkoUGP0YURpY31p5rjupS
	 iIJAHkD+gujuGznWJ0aduGc+SrCVMQfYYxcB60AwctsPwcwvNJSs2tO3Z3DdsytfcN
	 YKYhlbSpBD78CR54asM4xLKStJ5SdzKWwcT9WJD8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhenghang Xiao <kipreyyy@gmail.com>,
	David Heidelberg <david@ixit.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0963/1191] nfc: nci: fix double completion race in nci_data_exchange_complete
Date: Sat, 12 Sep 2026 09:01:31 +0200
Message-ID: <20260912065609.849005684@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 7a3fb2a397a1e..4db36cddf670e 100644
--- a/net/nfc/nci/data.c
+++ b/net/nfc/nci/data.c
@@ -46,11 +46,11 @@ void nci_data_exchange_complete(struct nci_dev *ndev, struct sk_buff *skb,
 	del_timer_sync(&ndev->data_timer);
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



