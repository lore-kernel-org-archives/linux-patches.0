Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0324C3C1F22;
	Tue, 21 Jul 2026 22:48:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784674116; cv=none; b=BrEINEkFQPFGxX9oOXqMxgP2l0wNvzeggxlWWZV0TFgQCfCcWi7hRz6PoXWdULFfLF5DXlyYE2tJ0BU79Yn605ZA5JiTlm+CwQdETKZrKkk57X0K5UiVKzIquG5fuY0z49aGpvtEWwfZUanck2faRJPS7n5TCeH/2u6hB33wmmI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784674116; c=relaxed/simple;
	bh=TiWHPNMTPojy7h1ixc1/UDNCoCknp2M2pYCnAVqOCcM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n9CAzpg4YZ0g9Yq/xcr5c7XZ7vZPlUiriyH1+D0KULPUo8X9K7vveMWHr9qwmpnCfVaLqzIhkEmwfFGfULFcZ/wOzZAj47oddGFRb2m0wNyxbetl2pX/0sPXNDR8/aczWu1y83t2mpQR/5aIsSkIhmUu6XZy206vYAHbbFQyEys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wPgid0HF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wPgid0HF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 116F71F00A3D;
	Tue, 21 Jul 2026 22:48:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784674107;
	bh=97DMi/64Z76RFcMoE7PxEQJAPLUCLTDGkVRrIKJGV9Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wPgid0HF8/8cKwuU70+qidSPKsEwbW+28iONOGpDqWBiihLpBGelsVD3ntKF2feZc
	 MUU2tEUhGD9HkjqVjtIY2jyisvMJCu9MtSN9rFeLCybRXNo95xGwVsaZvVbWa/BY6H
	 41wNzhgm59Gs9kMEhk64hpZqi1ORBIiVvadDy8qE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Taehee Yoo <ap420073@gmail.com>,
	Cong Wang <xiyou.wangcong@gmail.com>,
	David Ahern <dsahern@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 417/699] ipv6: fix skb drops in igmp6_event_query() and igmp6_event_report()
Date: Tue, 21 Jul 2026 17:22:56 +0200
Message-ID: <20260721152405.101718338@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 2d3916f3189172d5c69d33065c3c21119fe539fc ]

While investigating on why a synchronize_net() has been added recently
in ipv6_mc_down(), I found that igmp6_event_query() and igmp6_event_report()
might drop skbs in some cases.

Discussion about removing synchronize_net() from ipv6_mc_down()
will happen in a different thread.

Fixes: f185de28d9ae ("mld: add new workqueues for process mld events")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Taehee Yoo <ap420073@gmail.com>
Cc: Cong Wang <xiyou.wangcong@gmail.com>
Cc: David Ahern <dsahern@kernel.org>
Link: https://lore.kernel.org/r/20220303173728.937869-1-eric.dumazet@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 9b26518b6896 ("ipv6: mcast: Fix potential UAF in MLD delayed work")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/ndisc.h |  4 ++--
 net/ipv6/mcast.c    | 32 ++++++++++++--------------------
 2 files changed, 14 insertions(+), 22 deletions(-)

diff --git a/include/net/ndisc.h b/include/net/ndisc.h
index 38e4094960cee8..e97ef508664f4c 100644
--- a/include/net/ndisc.h
+++ b/include/net/ndisc.h
@@ -487,9 +487,9 @@ int igmp6_late_init(void);
 void igmp6_cleanup(void);
 void igmp6_late_cleanup(void);
 
-int igmp6_event_query(struct sk_buff *skb);
+void igmp6_event_query(struct sk_buff *skb);
 
-int igmp6_event_report(struct sk_buff *skb);
+void igmp6_event_report(struct sk_buff *skb);
 
 
 #ifdef CONFIG_SYSCTL
diff --git a/net/ipv6/mcast.c b/net/ipv6/mcast.c
index d7fe7ae17bb4c6..e72058af646a84 100644
--- a/net/ipv6/mcast.c
+++ b/net/ipv6/mcast.c
@@ -1371,27 +1371,23 @@ static int mld_process_v2(struct inet6_dev *idev, struct mld2_query *mld,
 }
 
 /* called with rcu_read_lock() */
-int igmp6_event_query(struct sk_buff *skb)
+void igmp6_event_query(struct sk_buff *skb)
 {
 	struct inet6_dev *idev = __in6_dev_get(skb->dev);
 
-	if (!idev)
-		return -EINVAL;
-
-	if (idev->dead) {
-		kfree_skb(skb);
-		return -ENODEV;
-	}
+	if (!idev || idev->dead)
+		goto out;
 
 	spin_lock_bh(&idev->mc_query_lock);
 	if (skb_queue_len(&idev->mc_query_queue) < MLD_MAX_SKBS) {
 		__skb_queue_tail(&idev->mc_query_queue, skb);
 		if (!mod_delayed_work(mld_wq, &idev->mc_query_work, 0))
 			in6_dev_hold(idev);
+		skb = NULL;
 	}
 	spin_unlock_bh(&idev->mc_query_lock);
-
-	return 0;
+out:
+	kfree_skb(skb);
 }
 
 static void __mld_query_work(struct sk_buff *skb)
@@ -1544,27 +1540,23 @@ static void mld_query_work(struct work_struct *work)
 }
 
 /* called with rcu_read_lock() */
-int igmp6_event_report(struct sk_buff *skb)
+void igmp6_event_report(struct sk_buff *skb)
 {
 	struct inet6_dev *idev = __in6_dev_get(skb->dev);
 
-	if (!idev)
-		return -EINVAL;
-
-	if (idev->dead) {
-		kfree_skb(skb);
-		return -ENODEV;
-	}
+	if (!idev || idev->dead)
+		goto out;
 
 	spin_lock_bh(&idev->mc_report_lock);
 	if (skb_queue_len(&idev->mc_report_queue) < MLD_MAX_SKBS) {
 		__skb_queue_tail(&idev->mc_report_queue, skb);
 		if (!mod_delayed_work(mld_wq, &idev->mc_report_work, 0))
 			in6_dev_hold(idev);
+		skb = NULL;
 	}
 	spin_unlock_bh(&idev->mc_report_lock);
-
-	return 0;
+out:
+	kfree_skb(skb);
 }
 
 static void __mld_report_work(struct sk_buff *skb)
-- 
2.53.0



