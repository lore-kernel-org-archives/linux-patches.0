Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82A62249F9;
	Tue, 11 Mar 2025 15:32:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741707137; cv=none; b=GySCAqgngolhXTNkCThM+zbBKCIO4u3PxERFdSNHxDZmehvjAqALwVb2PMaDeqO/VB8QMX+1NI3LC3rOksQ5O1j7qeCYlhG4Z7yuSNwNIswSEeqXtnrcHMgdSh2IjDrni26xa+pHX9hsS9OrojkjdX+CCoYiMACkfx0fL7uj5IM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741707137; c=relaxed/simple;
	bh=wNDKbtpPf+fKQ8xrXIjTFSMGExeqmuVVJl/4Jjy0DCk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xy92lRCXC6g0VvaBd+8qYfg/NPzduqMw/DCj/J3gabIafUcD5NMnKt76gy1kMGfmG5kz06CbqeSouxYgYVgG9hEj2ZaSufUsIV/WBBGkVrD/xVQjnfWQhjF0wqqcn0A8J8AszUDCEpN00Vhrz2huKOvgnw3zJ6JZBsy4/A5sil4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tpZeMsOe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tpZeMsOe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CD74C4CEE9;
	Tue, 11 Mar 2025 15:32:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741707137;
	bh=wNDKbtpPf+fKQ8xrXIjTFSMGExeqmuVVJl/4Jjy0DCk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tpZeMsOeK7OgnyBmMN30/7OakTzYok3VFLkjXtr35gpzR/u41UBlRitSwzlHFoTo1
	 L/yu0Kbbyeyh5dVv86b6aA0qnnjOzoLJJb/JfxQyKdtWzlVE7hF97010JHwrZufZpm
	 3CFIlDrEbfPkIHELF8nmG+9OciJnQiGWUJ4MRxBw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	David Ahern <dsahern@kernel.org>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 287/462] arp: use RCU protection in arp_xmit()
Date: Tue, 11 Mar 2025 15:59:13 +0100
Message-ID: <20250311145809.707510102@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145758.343076290@linuxfoundation.org>
References: <20250311145758.343076290@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit a42b69f692165ec39db42d595f4f65a4c8f42e44 ]

arp_xmit() can be called without RTNL or RCU protection.

Use RCU protection to avoid potential UAF.

Fixes: 29a26a568038 ("netfilter: Pass struct net into the netfilter hooks")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Reviewed-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Link: https://patch.msgid.link/20250207135841.1948589-5-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/arp.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/arp.c b/net/ipv4/arp.c
index 8ae9bd6f91c19..6879e0b70c769 100644
--- a/net/ipv4/arp.c
+++ b/net/ipv4/arp.c
@@ -637,10 +637,12 @@ static int arp_xmit_finish(struct net *net, struct sock *sk, struct sk_buff *skb
  */
 void arp_xmit(struct sk_buff *skb)
 {
+	rcu_read_lock();
 	/* Send it off, maybe filter it using firewalling first.  */
 	NF_HOOK(NFPROTO_ARP, NF_ARP_OUT,
-		dev_net(skb->dev), NULL, skb, NULL, skb->dev,
+		dev_net_rcu(skb->dev), NULL, skb, NULL, skb->dev,
 		arp_xmit_finish);
+	rcu_read_unlock();
 }
 EXPORT_SYMBOL(arp_xmit);
 
-- 
2.39.5



