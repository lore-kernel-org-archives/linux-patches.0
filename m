Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3451525EF82;
	Tue, 11 Mar 2025 15:29:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741706962; cv=none; b=sDLLB5LJCE6UrfJ6AZyHyVXqxZPP4hTOGbzPAXAhyEREAPEh9Y1z9NFL5Dh0N0thkMs/iGQIUVo+idBtYDienzCF7ZpmPZLk8h6ww8seWAuWL97hjJIzOeulKnjYikcq0UqO5th72hvpdWcaUcjKnCAIMKJ4cqSbRQE1Ro3nuUo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741706962; c=relaxed/simple;
	bh=JUfLPdr3cBlXTxGPcVidw3nnSrsUbmJIIrdlR8LBWH4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eZ2kfLZsE+G8gWmHFJrRDO2PaYRyZAT6moupUQvq/GXP+xGAWM/r+DqLDNFPMloyo1B5IIUy0D5Kqc0jidET0GD70LsHFP/uACNOgz6dcHuA34o3QVpC4uho8Gx56lCjdSFgqpyOKXnomLKYa3XdcAfChuWz9UFsS/nfKJpwmHU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ULxZljVg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ULxZljVg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DFF0C4CEE9;
	Tue, 11 Mar 2025 15:29:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741706961;
	bh=JUfLPdr3cBlXTxGPcVidw3nnSrsUbmJIIrdlR8LBWH4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ULxZljVgFOmETBbnKJIGGFxL3ApmjuxZwFzOtWqtZ8AxlIc21KtwcwFKJd4FiwrwE
	 MzWLh+IbbRFayNA7/PchPpbvb+8ce40xjzxsd04U81wOb6lOiCeCyx4zIhZjv7LMlC
	 8vOmApZDA67ViYz/N3M3r81aGGr/KPYqiuxsSnWg=
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
Subject: [PATCH 5.10 228/462] ndisc: ndisc_send_redirect() must use dev_get_by_index_rcu()
Date: Tue, 11 Mar 2025 15:58:14 +0100
Message-ID: <20250311145807.370339897@linuxfoundation.org>
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
index 4f46b0a2e5680..c0a5552733177 100644
--- a/net/ipv6/ndisc.c
+++ b/net/ipv6/ndisc.c
@@ -1607,7 +1607,7 @@ void ndisc_send_redirect(struct sk_buff *skb, const struct in6_addr *target)
 	bool ret;
 
 	if (netif_is_l3_master(skb->dev)) {
-		dev = __dev_get_by_index(dev_net(skb->dev), IPCB(skb)->iif);
+		dev = dev_get_by_index_rcu(dev_net(skb->dev), IPCB(skb)->iif);
 		if (!dev)
 			return;
 	}
-- 
2.39.5



