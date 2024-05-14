Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27668F9D4;
	Tue, 14 May 2024 11:58:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715687902; cv=none; b=iCpoYLOLgpV9o/1PlUFTsrmOshQ8peQMGATZ0CXUa7PJ7966AuV+qT+XZlE7GrQUCXy95WLHswnxTIvYkM4HTjUXOmxSfsrkj71trry58XiWBYaMll0iZxKPkXga3fspDuNII4n4TNqJ6S4M4OYFcKPvFV8s8VRM63DeC7JXpt0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715687902; c=relaxed/simple;
	bh=QAdWOLByrqwRdzoEvyeuEhaI0uQNsZ/i09jHfHFhkII=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=H+lwpBH2zOFwi7qLsuSgMoICwac6Mqso3ZiTpg1ZWOSm1kaanoD6cRrkBm4HkzoNiu7dXWUDkkDL9h7i3i6pf7ssKWvLMqZS6liDTCcEjnckeoCFB9MY3vjKND/YG0YqNS729CoNE5aOFIl696uNyhQUt+hNuyoSyUb99Mjs5tw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qRw81B0Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qRw81B0Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CF02C2BD10;
	Tue, 14 May 2024 11:58:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715687902;
	bh=QAdWOLByrqwRdzoEvyeuEhaI0uQNsZ/i09jHfHFhkII=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qRw81B0YTIE7fMO983nc6ulHue1zoampEKvySpIxkt6QvfnU2LiV99ZnM24eEebdv
	 GDSaFnRpmcJWz7NwwJoZPKLnK9BxmADpCMzfbWad08yFhreXdTBQccYosDbM+FjDIq
	 89Gsd/Dy4x0boy2nyyQjkmTcJANPMOhIxdiYv16I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	=?UTF-8?q?R=C3=A9mi=20Denis-Courmont?= <courmisch@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 113/168] phonet: fix rtm_phonet_notify() skb allocation
Date: Tue, 14 May 2024 12:20:11 +0200
Message-ID: <20240514101010.950935427@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101006.678521560@linuxfoundation.org>
References: <20240514101006.678521560@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit d8cac8568618dcb8a51af3db1103e8d4cc4aeea7 ]

fill_route() stores three components in the skb:

- struct rtmsg
- RTA_DST (u8)
- RTA_OIF (u32)

Therefore, rtm_phonet_notify() should use

NLMSG_ALIGN(sizeof(struct rtmsg)) +
nla_total_size(1) +
nla_total_size(4)

Fixes: f062f41d0657 ("Phonet: routing table Netlink interface")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Acked-by: Rémi Denis-Courmont <courmisch@gmail.com>
Link: https://lore.kernel.org/r/20240502161700.1804476-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/phonet/pn_netlink.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/phonet/pn_netlink.c b/net/phonet/pn_netlink.c
index 59aebe2968907..dd4c7e9a634fb 100644
--- a/net/phonet/pn_netlink.c
+++ b/net/phonet/pn_netlink.c
@@ -193,7 +193,7 @@ void rtm_phonet_notify(int event, struct net_device *dev, u8 dst)
 	struct sk_buff *skb;
 	int err = -ENOBUFS;
 
-	skb = nlmsg_new(NLMSG_ALIGN(sizeof(struct ifaddrmsg)) +
+	skb = nlmsg_new(NLMSG_ALIGN(sizeof(struct rtmsg)) +
 			nla_total_size(1) + nla_total_size(4), GFP_KERNEL);
 	if (skb == NULL)
 		goto errout;
-- 
2.43.0



