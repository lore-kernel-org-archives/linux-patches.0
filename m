Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41D4D1E3DC9;
	Wed, 19 Feb 2025 09:31:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739957471; cv=none; b=cwBLC7eE3uqsvPLnZdYmj8J2ew8txALkYLDh2B/rIrWQC6zM2l1o8MijSp38+gUHUqLT/OIVVfwJ6fZFSIbq4/qz4ftk7Nnl4qD3ENh2hMwZVvog29eE7p2lfYUiA/1bX8XzU8Weyup3VNC71BeHS4142gKZM+HRDR2rVEhZb5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739957471; c=relaxed/simple;
	bh=iMpOL0yrcnbCxP8f6psYBT6FsQ0R0ZRzj2CooLDq5uo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V6CYPd6pzQ+pAIxw5mLDkuV7PMjrCKEQl72lOf/1WVA3PZOCkU9YzDuJKWmoBGpiWjVDh/ZZUJMFFj1RD/WGB1D/9MOZqDhbi7xLJ1XYnT0m+w1Y1GGBv0lGDgQwH4AAOXrEvGo/aKB1ydMg1Fu4e53zXfGf+dee2k3BbaF2GDU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ELCNViN4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ELCNViN4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF49DC4CED1;
	Wed, 19 Feb 2025 09:31:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739957471;
	bh=iMpOL0yrcnbCxP8f6psYBT6FsQ0R0ZRzj2CooLDq5uo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ELCNViN4NFMV5Rif6Su4dmPBtunnG6eOkVZuqzt6mBfSbagfKhQ3DG3lXoAi79HfO
	 CrjxAiM4KvC2VRw9PbVX9FENsOGN30QRvnJsQqyaG0AaR/3Q5qgxO5bjOmUR5Ugdwo
	 uo5wJ+vyEXUWn1aEk0yBhdVOxYkNGu4aIqAIrzv0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 538/578] ipv4: add RCU protection to ip4_dst_hoplimit()
Date: Wed, 19 Feb 2025 09:29:02 +0100
Message-ID: <20250219082714.137165302@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 469308552ca4560176cfc100e7ca84add1bebd7c ]

ip4_dst_hoplimit() must use RCU protection to make
sure the net structure it reads does not disappear.

Fixes: fa50d974d104 ("ipv4: Namespaceify ip_default_ttl sysctl knob")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Link: https://patch.msgid.link/20250205155120.1676781-3-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/route.h | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/include/net/route.h b/include/net/route.h
index af8431b25f800..f396176022377 100644
--- a/include/net/route.h
+++ b/include/net/route.h
@@ -362,10 +362,15 @@ static inline int inet_iif(const struct sk_buff *skb)
 static inline int ip4_dst_hoplimit(const struct dst_entry *dst)
 {
 	int hoplimit = dst_metric_raw(dst, RTAX_HOPLIMIT);
-	struct net *net = dev_net(dst->dev);
 
-	if (hoplimit == 0)
+	if (hoplimit == 0) {
+		const struct net *net;
+
+		rcu_read_lock();
+		net = dev_net_rcu(dst->dev);
 		hoplimit = READ_ONCE(net->ipv4.sysctl_ip_default_ttl);
+		rcu_read_unlock();
+	}
 	return hoplimit;
 }
 
-- 
2.39.5



