Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 656211C5D77;
	Tue, 11 Mar 2025 15:11:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741705869; cv=none; b=FL9qe1phWpfMXzQKC10pTJReWXcpN/H5CqdZFP/jmaeuCvjbueOTpIWlO8HJWx2j7sHTIX4QAUzQJrLwy6E3dZTJOcQe5ec7x30hYresjxb/ip5E4eV9l2Qsdh/UPXxVtpRIzBmj7X0ZxF9U5D+iOS3wVcnX//X64ot+dHWR+ww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741705869; c=relaxed/simple;
	bh=Y9/Egp74PHlU/o5tAcExcCagYvPV6UYHlwPe3ih4Cps=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y3aOMU0/iCAl8GXitOyLCNvZ2of5k373iXbHEIfUgUD00A/hfl3KwVTvd4dnBWNYNPaLgMAn5ah2mh3wT13RmDcwZX5Fipppb5C2G0Vp23khDrmkE359fdInwZYcjNUtUo3VUQbjSvXqSyK3HEZ25E3vlsBZQ9UcTYR2V7LGOs0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uXgw+KpN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uXgw+KpN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2A45C4CEE9;
	Tue, 11 Mar 2025 15:11:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741705869;
	bh=Y9/Egp74PHlU/o5tAcExcCagYvPV6UYHlwPe3ih4Cps=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uXgw+KpNW0F6geOQpsG62j3wT2qtthJyty49RBHZfrF5cpNLFPzLSlz6aA7VZnsq3
	 7loW2/+1uRAfOlg0trghH+x+QPMH1zwSTfeSbYwKbZija2ROxeT9iNmZaq9fdXRUwi
	 /3IdiUFMxtQhx7dCO7H3SM3AscDqJOf4bpYdgdyk=
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
Subject: [PATCH 5.4 163/328] ndisc: ndisc_send_redirect() must use dev_get_by_index_rcu()
Date: Tue, 11 Mar 2025 15:58:53 +0100
Message-ID: <20250311145721.384916735@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145714.865727435@linuxfoundation.org>
References: <20250311145714.865727435@linuxfoundation.org>
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
index 64729e7e6a866..3096807caecab 100644
--- a/net/ipv6/ndisc.c
+++ b/net/ipv6/ndisc.c
@@ -1597,7 +1597,7 @@ void ndisc_send_redirect(struct sk_buff *skb, const struct in6_addr *target)
 	bool ret;
 
 	if (netif_is_l3_master(skb->dev)) {
-		dev = __dev_get_by_index(dev_net(skb->dev), IPCB(skb)->iif);
+		dev = dev_get_by_index_rcu(dev_net(skb->dev), IPCB(skb)->iif);
 		if (!dev)
 			return;
 	}
-- 
2.39.5



