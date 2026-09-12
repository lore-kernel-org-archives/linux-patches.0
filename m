Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9519239150B;
	Sat, 12 Sep 2026 19:59:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789243195; cv=none; b=kW/GeR7QWi0pPH5oK0uTej5w7mghCOfSB6lp981ohb8dgbH3yajrwUBxxdN0UPPAXuq24zTJFZoWstmSsryf7zYZBoz4fxYMXPWOtrYkjS6yAgwU+zDuMZA8qa9B1gDJiV7JylqUDJbRHvTJejjyxvqt88qKlyMYlPUaK3ZMYfo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789243195; c=relaxed/simple;
	bh=+Vnjja6RWWO8D+qMI862vnWpFvxCWe5g84RIURTWtL0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tFkU9Jz/habYlMXxgAGTUkjxxUWWH1g/qBR9oqeym2kVFaBTIAbuASYrV0aFVToyy1xRCed19vkgao4XpSvrbZ8iYVGLoNM8KL0U9hnjrD4RR7MXlN4Umwblf980BbGfejDkAXlGtWg3m8c/ieBc9jcyNgEADGnx5YR3+tdYe3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rKz/iZDD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rKz/iZDD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5BDE1F000FF;
	Sat, 12 Sep 2026 19:59:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789243194;
	bh=uCXtyIGuE3Ur3LwruyIkqLtVQrUyrqrwDXZitM1+XvE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rKz/iZDDeewzxhfoC+bzJ0WMwR4JubFpK9JuixiMCVeVmjF9ZCsYFrjAN6wOCZxD1
	 vnkI4j3REH8j7UwSd4+5aRutgsga/hIaKhKTtVB6dyjMWiX4hMQJkNVSyUq+Ckdifl
	 jvmO08TC0HAnqrHmJHafsjJ2FmMZBYudo5RhnIFs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhenghang Xiao <kipreyyy@gmail.com>,
	David Heidelberg <david@ixit.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 670/798] nfc: nci: fix double completion race in nci_data_exchange_complete
Date: Sat, 12 Sep 2026 09:04:58 +0200
Message-ID: <20260912065532.460515463@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 4f06a2903ae75..dacc69e5a8bf7 100644
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



