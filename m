Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 105CA2517A6;
	Tue, 29 Apr 2025 17:51:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745949068; cv=none; b=Dq9/zywrbdHWGGa3T1Rfe/KubMCv1Nc4M9lF5RBrQPxipUc7UU1iAUPkw1RDeixqkU7GFtcHFTo0RIuUDB2uTbxnNmin4v/G/7QR5Tq+g2w9A4XZLqYqyNT2gzIdIfliIYa2MMxY+Nb33iIaCBPKOf9KGgpbcW8aZzFWokPDnV8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745949068; c=relaxed/simple;
	bh=uCBLZ4nU5hTq08akN5YnnvLO4lsKa0bYK9+SRvjDPHo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=isE2+PUCkVy8rctdZkV1Wnwc9wON4f+B/LZ/qNiJjyVB3DSep8ClK7o/kYIe22W8HFUYosHggwLOyHJVkyQxt/eRv/hVeqKAGHGgdOTdHyiXgPDhX1AgPufPGVMfT59+Fp5+LNkIfeJcgVClVQAKI5qhHZA8CbOiGJMcVwWzTog=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dbgz9YjN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dbgz9YjN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B99CC4CEE3;
	Tue, 29 Apr 2025 17:51:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745949067;
	bh=uCBLZ4nU5hTq08akN5YnnvLO4lsKa0bYK9+SRvjDPHo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dbgz9YjNnRPGEJGwpu9C0DEjrLZ4dkMCYF3pE3vsB22ncJ3ApGd0AP9o5XE/Dz5qV
	 JXgwepkFAjSlT+bsmK3UTIJ28ND2qZyQggtTqlQGSsuBny9v07HniNmUu5mcbp2MDd
	 2c2Hb3KcxOWFgQbrE0x+0zlIayqe1U9oAnaORYeA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wang Liang <wangliang74@huawei.com>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Bin Lan <bin.lan.cn@windriver.com>,
	Sasha Levin <sashal@kernel.org>,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Subject: [PATCH 5.15 204/373] net: fix crash when config small gso_max_size/gso_ipv4_max_size
Date: Tue, 29 Apr 2025 18:41:21 +0200
Message-ID: <20250429161131.555999310@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161123.119104857@linuxfoundation.org>
References: <20250429161123.119104857@linuxfoundation.org>
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
[ Resolve minor conflicts to fix CVE-2024-50258 ]
Signed-off-by: Bin Lan <bin.lan.cn@windriver.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
[Harshit: Clean cherrypick from 6.1.y commit]
Signed-off-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/rtnetlink.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -1899,7 +1899,7 @@ static const struct nla_policy ifla_poli
 	[IFLA_NUM_TX_QUEUES]	= { .type = NLA_U32 },
 	[IFLA_NUM_RX_QUEUES]	= { .type = NLA_U32 },
 	[IFLA_GSO_MAX_SEGS]	= { .type = NLA_U32 },
-	[IFLA_GSO_MAX_SIZE]	= { .type = NLA_U32 },
+	[IFLA_GSO_MAX_SIZE]	= NLA_POLICY_MIN(NLA_U32, MAX_TCP_HEADER + 1),
 	[IFLA_PHYS_PORT_ID]	= { .type = NLA_BINARY, .len = MAX_PHYS_ITEM_ID_LEN },
 	[IFLA_CARRIER_CHANGES]	= { .type = NLA_U32 },  /* ignored */
 	[IFLA_PHYS_SWITCH_ID]	= { .type = NLA_BINARY, .len = MAX_PHYS_ITEM_ID_LEN },


