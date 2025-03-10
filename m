Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B419E22D7A6;
	Mon, 10 Mar 2025 17:59:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741629565; cv=none; b=phztMUc7qiTJiZAp3MwGLYJS83BuTh76AOM+iQsliuK8Nj/Hv2H0W04iXNryZvk1VOlqqzuoVxSw0ujO4OS0pfi90Bj0bxcpKvA9rCl5U20Ayq/vR1dwZtFOb1s4Trlm63Bu1mGIyDZ2Zkzv0pfhmwUsd3boXODmHivhKFWpN2g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741629565; c=relaxed/simple;
	bh=5KWIh+fn/lhyrLrFy+hfu88NSv7cBmYKYQVbmLzt4BM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KjUKnzkG8vLhPctrjxKrlH4664/QW1fss4LHth88cvHQo706IGESDiDskek8uClCBlN8BahgmmYIyLKGoz4wwfYt1wg8jvwZBbrW0vkkV3VgQLK3HpTIhjyFbWJ9y3KQjvNC30kMulcuCheTxT5giY7k11+DE/gxfbkAiN7PM40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UJTZGUMb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UJTZGUMb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE053C4CEE5;
	Mon, 10 Mar 2025 17:59:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741629565;
	bh=5KWIh+fn/lhyrLrFy+hfu88NSv7cBmYKYQVbmLzt4BM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UJTZGUMb/jp51i6Z1j+hakrAKtUJ0KSPSp0mpsxxuTeaJ98H+2nHrLkBONtTZ2TFT
	 uEqMvva/E1XEvCaP+YJsEMVH4XaS1JLu/bxwRkMDcGDUePoYG4yJ3jPtMLdPYt1Eat
	 Tdcfx9EagnF3B8gyhYHzKmu1PY2nDNEufbln51N0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Stephen Suryaputra <ssuryaextr@gmail.com>,
	David Ahern <dsahern@kernel.org>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 338/620] ndisc: ndisc_send_redirect() must use dev_get_by_index_rcu()
Date: Mon, 10 Mar 2025 18:03:04 +0100
Message-ID: <20250310170558.951738425@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 48145a57d4bbe3496e8e4880b23ea6b511e6e519 ]

ndisc_send_redirect() is called under RCU protection, not RTNL.

It must use dev_get_by_index_rcu() instead of __dev_get_by_index()

Fixes: 2f17becfbea5 ("vrf: check the original netdevice for generating redirect")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Stephen Suryaputra <ssuryaextr@gmail.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Reviewed-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Link: https://patch.msgid.link/20250207135841.1948589-2-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/ndisc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv6/ndisc.c b/net/ipv6/ndisc.c
index d56e80741c5ba..63c1420c58249 100644
--- a/net/ipv6/ndisc.c
+++ b/net/ipv6/ndisc.c
@@ -1619,7 +1619,7 @@ void ndisc_send_redirect(struct sk_buff *skb, const struct in6_addr *target)
 	bool ret;
 
 	if (netif_is_l3_master(skb->dev)) {
-		dev = __dev_get_by_index(dev_net(skb->dev), IPCB(skb)->iif);
+		dev = dev_get_by_index_rcu(dev_net(skb->dev), IPCB(skb)->iif);
 		if (!dev)
 			return;
 	}
-- 
2.39.5



