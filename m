Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87FDA3C07A;
	Sat, 12 Sep 2026 19:06:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789239979; cv=none; b=dqTYKpxHz8pQz4R2tohBJJ0ld/UJEL8F8P7GMsiZxv64M5uXenRSWeg383b77BuK9noKmZB+FzTq0I2LzwfWrh12J5Kufy5toXWPv7irczekc2zJFgfSSLTKMzkC6KoegfA6S+yTcu3ZmPP2fa3u5rVEQvtbN6o1tQPILLI6314=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789239979; c=relaxed/simple;
	bh=kPwqsBqGINtrODe81gUebABvKW8NAQezPuU56Dvuufo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gqvsx7AntPiXDwlfHW3psvdNocO+EorKX678u5NytE6eE79XQjppTaP9akuHXK1kFCHye4X6v8rhpPlTlu0dqfMc1MwsKsgvTEb5WYCsz1a613DXwcjSZ5meacnv2CxxMTgKmQ2+A1IMoC1TFx3TdBBhYmIMxJzBciL/rDEwIWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hc4kv3yd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hc4kv3yd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1545B1F000FF;
	Sat, 12 Sep 2026 19:06:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789239976;
	bh=C2U5P2fi7tLD6bBwjYi9LwVggt37Va+zYfKh940RVcY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hc4kv3ydDXzoLvwI44XQuYlVyWJVCN6cYJes0lr2yMQGJ6HGFBO418G30+5uc+tr2
	 M01asQGxNmezU1k/FXOUJDN13GUEFsLXAXz0zMKb8nTqpUMnYTkp3teRfegeDkYtWu
	 lP98Arh1kZzV2xPfsjN0rbUk0J34vSo14gymJrPc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhenghang Xiao <kipreyyy@gmail.com>,
	David Heidelberg <david@ixit.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 775/935] nfc: nci: fix double completion race in nci_data_exchange_complete
Date: Sat, 12 Sep 2026 09:03:25 +0200
Message-ID: <20260912065544.603777814@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



