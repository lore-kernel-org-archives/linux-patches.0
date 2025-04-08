Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A51A4269CE6;
	Tue,  8 Apr 2025 12:02:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744113758; cv=none; b=Dv1wON6OU0KxtCULkOOoj0N/jURgXLX278csOzIG9qhDOEiiigmZq1dShmCb8BeEwB4He5mQzkteeFtNjO9qu8VtPSpc0Fs6SmikAjcATF9O+rTXIJWdTsHztuC1ifSxjViYkl6NAY1MvofTuOLhlRajSKc62dwCujkJg3owniw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744113758; c=relaxed/simple;
	bh=QJfrwfsp/cQlzMKWXPz0b0MRe7vQb2I2WMVz1xCF9ds=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=INS5jPlJJqI6DtGinKw7IcwtB7EYxb8kwxdxbnG5totp15Ce/m6cfjYkM6Vzd9gKfZLYJT+NU/P2gSYZond/qmt5GCwDCoXxAkoNe9WBs+h0hEFW7lE9RWSEec/QF6/SDscytAwa0OtMZKOEVGy3CmVe3Nt49DMAJc9mfDlHypU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Lnlc5+BC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Lnlc5+BC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36205C4CEE5;
	Tue,  8 Apr 2025 12:02:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744113758;
	bh=QJfrwfsp/cQlzMKWXPz0b0MRe7vQb2I2WMVz1xCF9ds=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Lnlc5+BCg+m3R7NJvKBVfxNdWtVocEzxfjkPS5Qz4rcCUmTrqSI+o7/Q5GYQlTcy3
	 DjgZEIJ4lQQ9IyswhkjokCdCD7khM7izT4UqNAWlhPmMrjjFNe75yS+kEiNPaynRYg
	 jZN85BENXQCGTdmjViVhKiocatv1xmSzSW1dzW/o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 010/154] netpoll: remove dev argument from netpoll_send_skb_on_dev()
Date: Tue,  8 Apr 2025 12:49:11 +0200
Message-ID: <20250408104815.618149071@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104815.295196624@linuxfoundation.org>
References: <20250408104815.295196624@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 307f660d056b5eb8f5bb2328fac3915ab75b5007 ]

netpoll_send_skb_on_dev() can get the device pointer directly from np->dev

Rename it to __netpoll_send_skb()

Following patch will move netpoll_send_skb() out-of-line.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 505ead7ab77f ("netpoll: hold rcu read lock in __netpoll_send_skb()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/netpoll.h |  5 ++---
 net/core/netpoll.c      | 10 ++++++----
 2 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/include/linux/netpoll.h b/include/linux/netpoll.h
index 3ff0303672842..f5202a59c0274 100644
--- a/include/linux/netpoll.h
+++ b/include/linux/netpoll.h
@@ -63,13 +63,12 @@ int netpoll_setup(struct netpoll *np);
 void __netpoll_cleanup(struct netpoll *np);
 void __netpoll_free(struct netpoll *np);
 void netpoll_cleanup(struct netpoll *np);
-void netpoll_send_skb_on_dev(struct netpoll *np, struct sk_buff *skb,
-			     struct net_device *dev);
+void __netpoll_send_skb(struct netpoll *np, struct sk_buff *skb);
 static inline void netpoll_send_skb(struct netpoll *np, struct sk_buff *skb)
 {
 	unsigned long flags;
 	local_irq_save(flags);
-	netpoll_send_skb_on_dev(np, skb, np->dev);
+	__netpoll_send_skb(np, skb);
 	local_irq_restore(flags);
 }
 
diff --git a/net/core/netpoll.c b/net/core/netpoll.c
index 35a3277ee3567..69f80b531a1c3 100644
--- a/net/core/netpoll.c
+++ b/net/core/netpoll.c
@@ -323,17 +323,19 @@ static int netpoll_owner_active(struct net_device *dev)
 }
 
 /* call with IRQ disabled */
-void netpoll_send_skb_on_dev(struct netpoll *np, struct sk_buff *skb,
-			     struct net_device *dev)
+void __netpoll_send_skb(struct netpoll *np, struct sk_buff *skb)
 {
 	netdev_tx_t status = NETDEV_TX_BUSY;
+	struct net_device *dev;
 	unsigned long tries;
 	/* It is up to the caller to keep npinfo alive. */
 	struct netpoll_info *npinfo;
 
 	lockdep_assert_irqs_disabled();
 
-	npinfo = rcu_dereference_bh(np->dev->npinfo);
+	dev = np->dev;
+	npinfo = rcu_dereference_bh(dev->npinfo);
+
 	if (!npinfo || !netif_running(dev) || !netif_device_present(dev)) {
 		dev_kfree_skb_irq(skb);
 		return;
@@ -376,7 +378,7 @@ void netpoll_send_skb_on_dev(struct netpoll *np, struct sk_buff *skb,
 		schedule_delayed_work(&npinfo->tx_work,0);
 	}
 }
-EXPORT_SYMBOL(netpoll_send_skb_on_dev);
+EXPORT_SYMBOL(__netpoll_send_skb);
 
 void netpoll_send_udp(struct netpoll *np, const char *msg, int len)
 {
-- 
2.39.5



