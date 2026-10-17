Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 705D239B4A5;
	Sat, 17 Oct 2026 17:12:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792257150; cv=none; b=tPsDtEpGwsA7yfsefSL6ikxJsyDXH0iONW7vlYrwULFD7xApufvO2REq34im+1Ea+MDksz7C2yLrg6XctQgK8Mwuwlssh0MbOG75KRHvcZv9a9CMNr9o4CtdyOGl7qHqyAbdDlizmDvPssLsMVuT+WFQu1OE2SsjQTCEQd4aVXY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792257150; c=relaxed/simple;
	bh=ulywHdPO/buawnGLil5HrlPGRDJPTtjUOPj+ODil2Uk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aWklF7b3UN5URwBAwr/faW1830FenZ2FTL3DvX214II7ctE7UhEASd/pacvP+ZPfmDk4QzMBfek/ueWZwh2q+tkAWOaffBB5SWqGfeM+WdfpaTeQ4ZyubgPMNxDC2/ZlkDAhFnliGc2nKjjQudicN2RDgm+zMROKovW+drsPmyU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mbc6P+nw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mbc6P+nw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7562A1F000C4;
	Sat, 17 Oct 2026 17:12:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792257149;
	bh=Zxwlei8kNH5pE0xjp4wLc5nwvvnaa36pGxJO24pN/fk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mbc6P+nwK2CSZbuI2cNVrRdlOFCsNsRKwejnGtskI/uF+ZosQAxpyT/EgIdKs1UgY
	 wugI++RPeH7kScPGaZ+AoByehsvCA1t3Ixzs8YtBQGm98iHkRr8EGMbBeVJ5/6Liqb
	 caNTUeBu/23Tb8WIwuewAF6pou1VkujQZMilG+P0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ido Schimmel <idosch@nvidia.com>,
	Daehyeon Ko <4ncienth@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 0466/1674] ipv6: do not warn on route notification size race
Date: Sat, 17 Oct 2026 17:45:38 +0200
Message-ID: <20261017160443.081171100@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daehyeon Ko <4ncienth@gmail.com>

commit c97426ec649d99596d8969e1a052c16b14b7b485 upstream.

fib6_info_hw_flags_set() sizes the skb with rt6_nlmsg_size() and later
fills it with rt6_fill_node().  With nexthop compatibility mode enabled,
a concurrent replacement can grow the group between these independent
snapshots.  rt6_fill_node() can then legitimately return -EMSGSIZE, so
the warning does not prove a sizing bug.

Remove the warning.  The existing error path still frees the skb and
reports the error to listeners.

Fixes: 907eea486888 ("net: ipv6: Emit notification when fib hardware flags are changed")
Reported-by: Ido Schimmel <idosch@nvidia.com>
Link: https://lore.kernel.org/netdev/20261007114003.GA1011260@shredder/
Suggested-by: Ido Schimmel <idosch@nvidia.com>
Cc: stable@vger.kernel.org
Signed-off-by: Daehyeon Ko <4ncienth@gmail.com>
Link: https://patch.msgid.link/4012604727e5ba80b69ccd4d08796511397ddaef.1791423190.git.4ncienth@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/route.c |    2 --
 1 file changed, 2 deletions(-)

--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -6340,8 +6340,6 @@ void fib6_info_hw_flags_set(struct net *
 	err = rt6_fill_node(net, skb, f6i, NULL, NULL, NULL, 0, RTM_NEWROUTE, 0,
 			    0, 0);
 	if (err < 0) {
-		/* -EMSGSIZE implies BUG in rt6_nlmsg_size() */
-		WARN_ON(err == -EMSGSIZE);
 		kfree_skb(skb);
 		goto errout;
 	}


