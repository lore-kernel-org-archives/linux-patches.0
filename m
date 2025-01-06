Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1064165F1F;
	Mon,  6 Jan 2025 15:45:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736178300; cv=none; b=dbc2Yn8hm7RUEPCrr/1ifLdbyeFQ/1q0RnPb8g+RHj8QO7kDPa2St8QYPGmFVNBSR4XNvFw1+mG9rXuXLPeBjE+oLYC5NE3VjUbdkjBqWk+XlYu7eq8uR7zwIkznCNexll//3cyIGNSQQUOV6CNpOM1Ywq5EMKaRc4pe1nxz8Yg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736178300; c=relaxed/simple;
	bh=c73qR9VOS9SF/xIZlVbgWWlKaBjK2KF/kptHgr0uZ2I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=igO6oEokxAKEK98qbWQBBB0B8q+QHF4lxRtpL3U03Ys+xnBwROQ/BiDFbRTXWHJAzZI3ScBulVOIVft8vZKpBks/uTlhcTTcBE+XsBC/RJxpip++nW5FsI45kn15OmxnRb8KK+6pmBxCYvaQcXHuwh8aYYiGEuYxvuWrZ6cdj5c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zufBtSEy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zufBtSEy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05601C4CED6;
	Mon,  6 Jan 2025 15:44:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736178300;
	bh=c73qR9VOS9SF/xIZlVbgWWlKaBjK2KF/kptHgr0uZ2I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zufBtSEy3oQ4sJ2EYcstEOfkj1pc1n4mm1ba91R3Js9YxVi4AqPRUF17xxulW3tiS
	 2GXtwtz2cGeF0z8CgFfdmiYLwUAxVT3fpJG9mfAMcQoL8pvWOlq+jZEU0Pn1dSCQXg
	 4E3mp99/i6f0OpUPauwjFfpghu7TiiyhUlwvI5mg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Vasily Averin <vasily.averin@linux.dev>,
	David Ahern <dsahern@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	Harshvardhan Jha <harshvardhan.j.jha@oracle.com>
Subject: [PATCH 5.10 072/138] ipv6: fix possible UAF in ip6_finish_output2()
Date: Mon,  6 Jan 2025 16:16:36 +0100
Message-ID: <20250106151135.960460894@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151133.209718681@linuxfoundation.org>
References: <20250106151133.209718681@linuxfoundation.org>
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

[ Upstream commit e891b36de161fcd96f12ff83667473e5067b9037 ]

If skb_expand_head() returns NULL, skb has been freed
and associated dst/idev could also have been freed.

We need to hold rcu_read_lock() to make sure the dst and
associated idev are alive.

Fixes: 5796015fa968 ("ipv6: allocate enough headroom in ip6_finish_output2()")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Vasily Averin <vasily.averin@linux.dev>
Reviewed-by: David Ahern <dsahern@kernel.org>
Link: https://patch.msgid.link/20240820160859.3786976-3-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
(cherry picked from commit e891b36de161fcd96f12ff83667473e5067b9037)
Signed-off-by: Harshvardhan Jha <harshvardhan.j.jha@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/ip6_output.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index a8475848d038..48f926157ef8 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -69,11 +69,15 @@ static int ip6_finish_output2(struct net *net, struct sock *sk, struct sk_buff *
 
 	/* Be paranoid, rather than too clever. */
 	if (unlikely(hh_len > skb_headroom(skb)) && dev->header_ops) {
+		/* Make sure idev stays alive */
+		rcu_read_lock();
 		skb = skb_expand_head(skb, hh_len);
 		if (!skb) {
 			IP6_INC_STATS(net, idev, IPSTATS_MIB_OUTDISCARDS);
+			rcu_read_unlock();
 			return -ENOMEM;
 		}
+		rcu_read_unlock();
 	}
 
 	hdr = ipv6_hdr(skb);
-- 
2.39.5



