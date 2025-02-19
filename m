Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EC8E1DF74C;
	Wed, 19 Feb 2025 09:27:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739957269; cv=none; b=Fzsh/YQEVyO3J2nHsY0Bb6N1Tw8T+MuwQcub2mbIOPNrUGN06PT/6nrkUuYMsgCDqHQJLWHdovwRXJaOSjx3fEVF9Mzp14Pr/W3CTZleEXNWmEcq2Pno9ln1dtkwfIqb7Bstm/lKhXq2BVSmMAxmt2Kat8nHfu8sh0a4NMG0Nik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739957269; c=relaxed/simple;
	bh=061oHuBRtZZMJv2RAFqWkjkVHHaHvplEyQ7oL8wCK38=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RWDHiSKZhYNAw16Vhjm50BTf1uh94IrbQoyYqzGFPSkO9rRXgNnsaeY7qBphwoEszVHg6DfsppyvZYJ2U0t9TUolcbc0ppYLQf/fn80POiC+2OB9Ys9xwujxkAkBQo1RJ+lBJdqkU5lYSdMZ7h8yyzIIP9N2ntJSVSrbygDRpQA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ke20De+0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ke20De+0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FC4FC4CED1;
	Wed, 19 Feb 2025 09:27:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739957269;
	bh=061oHuBRtZZMJv2RAFqWkjkVHHaHvplEyQ7oL8wCK38=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ke20De+01bhfteM7lvPY6VYDfT5tgHPsp/fWHS5qcoNUyJB9Okf56g2T4GYXoT1fI
	 TGgtM7OcllPAwcRRmfQKFSsGIlkAJ1Qy0+Pr/pNyiAil1f8kuVDlv8aP9PYRKKVC7z
	 Set0Obd6ArCy6GC9KzAE4Iy/ZSF4EFBsv52OdIcE=
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
Subject: [PATCH 6.1 468/578] ndisc: ndisc_send_redirect() must use dev_get_by_index_rcu()
Date: Wed, 19 Feb 2025 09:27:52 +0100
Message-ID: <20250219082711.416035712@linuxfoundation.org>
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
index 44d3e6ab0c7d4..6df3f4aadf641 100644
--- a/net/ipv6/ndisc.c
+++ b/net/ipv6/ndisc.c
@@ -1684,7 +1684,7 @@ void ndisc_send_redirect(struct sk_buff *skb, const struct in6_addr *target)
 	bool ret;
 
 	if (netif_is_l3_master(skb->dev)) {
-		dev = __dev_get_by_index(dev_net(skb->dev), IPCB(skb)->iif);
+		dev = dev_get_by_index_rcu(dev_net(skb->dev), IPCB(skb)->iif);
 		if (!dev)
 			return;
 	}
-- 
2.39.5



