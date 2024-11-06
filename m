Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A99CE1DF995;
	Wed,  6 Nov 2024 12:27:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730896065; cv=none; b=u4iRlEzUAwZFQc//pECZzNWaCj1M7BjGH8PC0f2fPrKXYM3xmxya6YWkTWvbacKpJXOkQ2R/DvNZDshOAJjRNLxutUvYirpbF/0ur7Zi2ddpUcM9Pzv3FsZnROmxSh+P9kZLQh/N3MXQJbOf705hAPpbvKf+LqUyNevcXm4Rqc0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730896065; c=relaxed/simple;
	bh=dAMbRBplsCB8Z3PiZYtKo85iQ73JQWxoUccH0cES8WU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DrPUq0T8Pxe7UU5mrlioP80tnvS/apHcQU7adpRQoWnLVDkofcMFJ72Qzq0nU0mM+Gg1vlZ4BXGG6cc2EUz7yDnvvkhXORls0id/2oFwJr8s7gaiM1beU0UjsG0WaZ5tQyJnzCW9jXYvnM3vwzRnQXDk69wGJz0Z7OMGONr735U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UIW2VGlj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UIW2VGlj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2ECB5C4CED4;
	Wed,  6 Nov 2024 12:27:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730896065;
	bh=dAMbRBplsCB8Z3PiZYtKo85iQ73JQWxoUccH0cES8WU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UIW2VGlj5+yZgM2t+dbdxRK+E2TRwBIaf4P6jvJ0fgmHiG7VDm4SNV7M87k6aWZy/
	 9DznJOudlMJb4EaBffMUWQlYrzbyida3t6wrg3EktYubcKypaZLtSl4w44OpsHwVwZ
	 IpATf6zZim6t7AyoVWyOae8aBEYopOaJxtzrIDKc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wang Liang <wangliang74@huawei.com>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 042/245] net: fix crash when config small gso_max_size/gso_ipv4_max_size
Date: Wed,  6 Nov 2024 13:01:35 +0100
Message-ID: <20241106120320.261280726@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120319.234238499@linuxfoundation.org>
References: <20241106120319.234238499@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wang Liang <wangliang74@huawei.com>

[ Upstream commit 9ab5cf19fb0e4680f95e506d6c544259bf1111c4 ]

Config a small gso_max_size/gso_ipv4_max_size will lead to an underflow
in sk_dst_gso_max_size(), which may trigger a BUG_ON crash,
because sk->sk_gso_max_size would be much bigger than device limits.
Call Trace:
tcp_write_xmit
    tso_segs = tcp_init_tso_segs(skb, mss_now);
        tcp_set_skb_tso_segs
            tcp_skb_pcount_set
                // skb->len = 524288, mss_now = 8
                // u16 tso_segs = 524288/8 = 65535 -> 0
                tso_segs = DIV_ROUND_UP(skb->len, mss_now)
    BUG_ON(!tso_segs)
Add check for the minimum value of gso_max_size and gso_ipv4_max_size.

Fixes: 46e6b992c250 ("rtnetlink: allow GSO maximums to be set on device creation")
Fixes: 9eefedd58ae1 ("net: add gso_ipv4_max_size and gro_ipv4_max_size per device")
Signed-off-by: Wang Liang <wangliang74@huawei.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20241023035213.517386-1-wangliang74@huawei.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/rtnetlink.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index 97a38a7e1b2cc..3c5dead0c71ce 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -2032,7 +2032,7 @@ static const struct nla_policy ifla_policy[IFLA_MAX+1] = {
 	[IFLA_NUM_TX_QUEUES]	= { .type = NLA_U32 },
 	[IFLA_NUM_RX_QUEUES]	= { .type = NLA_U32 },
 	[IFLA_GSO_MAX_SEGS]	= { .type = NLA_U32 },
-	[IFLA_GSO_MAX_SIZE]	= { .type = NLA_U32 },
+	[IFLA_GSO_MAX_SIZE]	= NLA_POLICY_MIN(NLA_U32, MAX_TCP_HEADER + 1),
 	[IFLA_PHYS_PORT_ID]	= { .type = NLA_BINARY, .len = MAX_PHYS_ITEM_ID_LEN },
 	[IFLA_CARRIER_CHANGES]	= { .type = NLA_U32 },  /* ignored */
 	[IFLA_PHYS_SWITCH_ID]	= { .type = NLA_BINARY, .len = MAX_PHYS_ITEM_ID_LEN },
@@ -2057,7 +2057,7 @@ static const struct nla_policy ifla_policy[IFLA_MAX+1] = {
 	[IFLA_TSO_MAX_SIZE]	= { .type = NLA_REJECT },
 	[IFLA_TSO_MAX_SEGS]	= { .type = NLA_REJECT },
 	[IFLA_ALLMULTI]		= { .type = NLA_REJECT },
-	[IFLA_GSO_IPV4_MAX_SIZE]	= { .type = NLA_U32 },
+	[IFLA_GSO_IPV4_MAX_SIZE]	= NLA_POLICY_MIN(NLA_U32, MAX_TCP_HEADER + 1),
 	[IFLA_GRO_IPV4_MAX_SIZE]	= { .type = NLA_U32 },
 };
 
-- 
2.43.0



