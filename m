Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E8DB146A67;
	Tue, 25 Jun 2024 09:57:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719309444; cv=none; b=QObVtCuVtw7uXs4WunB7QNwTCNabdX8RGkanlZbOk286JLoYQeD5gTHwwbSXgMgxHmzAmwDqV9fPdkKvkKpuu1hyRNa1O94oqNQ8Zfi3xYyvtlVqEuue9yWmsZq+cn4JZUWoGRPz7W3fBamC6tAoSxf+wLulxjRWHaXsg+QDYsI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719309444; c=relaxed/simple;
	bh=w9/M/+147DJpjZisiQ/d12FZGLQ2smiHYaoJTkzq0+A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BvliisquLnuhnjW7+tFo8yuehc0wRSxl1nhXFdGZJKdtb//l4JiAnv3Q1yQQ0GgbeMMRMOeETpqnFB5vK/MZLKoNehg3PJjNL3CURcDz1HYjBn+UFuo27AUNLedanzKxo1xdnt1GSjyWPIu5NlnwTFUlMKea5lYYqzOYm3XOyUE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oG0bTmSK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oG0bTmSK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B868C32781;
	Tue, 25 Jun 2024 09:57:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719309444;
	bh=w9/M/+147DJpjZisiQ/d12FZGLQ2smiHYaoJTkzq0+A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oG0bTmSKcFvhhvwD6Ra9FwS6goeWsid/RAbiLqOqDyYcreAqYHl8/mi16KVZ/nxII
	 euZgHMkP+HtCzGKtVEAp2mgRBLnlEKwcblPQAiJ/tuMJm8B8bBBbsyU8BImfuAbpN+
	 oj0pZU27NlJYUYCE69CFqFe3s/L8QT3fYUL7RX7s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Breno Leitao <leitao@debian.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 018/131] netpoll: Fix race condition in netpoll_owner_active
Date: Tue, 25 Jun 2024 11:32:53 +0200
Message-ID: <20240625085526.639477536@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085525.931079317@linuxfoundation.org>
References: <20240625085525.931079317@linuxfoundation.org>
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

From: Breno Leitao <leitao@debian.org>

[ Upstream commit c2e6a872bde9912f1a7579639c5ca3adf1003916 ]

KCSAN detected a race condition in netpoll:

	BUG: KCSAN: data-race in net_rx_action / netpoll_send_skb
	write (marked) to 0xffff8881164168b0 of 4 bytes by interrupt on cpu 10:
	net_rx_action (./include/linux/netpoll.h:90 net/core/dev.c:6712 net/core/dev.c:6822)
<snip>
	read to 0xffff8881164168b0 of 4 bytes by task 1 on cpu 2:
	netpoll_send_skb (net/core/netpoll.c:319 net/core/netpoll.c:345 net/core/netpoll.c:393)
	netpoll_send_udp (net/core/netpoll.c:?)
<snip>
	value changed: 0x0000000a -> 0xffffffff

This happens because netpoll_owner_active() needs to check if the
current CPU is the owner of the lock, touching napi->poll_owner
non atomically. The ->poll_owner field contains the current CPU holding
the lock.

Use an atomic read to check if the poll owner is the current CPU.

Signed-off-by: Breno Leitao <leitao@debian.org>
Link: https://lore.kernel.org/r/20240429100437.3487432-1-leitao@debian.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/netpoll.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/netpoll.c b/net/core/netpoll.c
index 4ac8d0ad9f6fc..fd2195cfcb4aa 100644
--- a/net/core/netpoll.c
+++ b/net/core/netpoll.c
@@ -316,7 +316,7 @@ static int netpoll_owner_active(struct net_device *dev)
 	struct napi_struct *napi;
 
 	list_for_each_entry_rcu(napi, &dev->napi_list, dev_list) {
-		if (napi->poll_owner == smp_processor_id())
+		if (READ_ONCE(napi->poll_owner) == smp_processor_id())
 			return 1;
 	}
 	return 0;
-- 
2.43.0



