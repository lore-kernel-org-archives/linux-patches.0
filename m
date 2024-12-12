Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25E6D14A82;
	Thu, 12 Dec 2024 15:54:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734018876; cv=none; b=WYn1V6AFs64ULhoFXpPR5cPH6ZUBnj7L80Yq5JVQBAPooNSbTWb5e3vkidHU8X7OJt11IOz2kG9TMdY/GIkXkKN5zc5oO4Rm17JgxrMtz/rzlysUKftIStQD/HsIyrOn6hb2WgH9OtjS8CV8Mb6v7KJa6wLVFE5WSeCBmY2JZaU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734018876; c=relaxed/simple;
	bh=te40OVqwEpDUAjNFXRG0ZZcM5vRdV02+uT55jEMtXqQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BTOkLJXDDhQI/zb5wQA1kyDhVSOvg0kmhcLkEA2kpChlT3junLOms7KBAQvnNphtfJmpXlrByreBVnSwiAHQ2JIHv4gWq9CWfUy6+dH4zv7Bb4pTnPTNk/f8BFMgHbNveo5caMxeXOZ6lhqJIkPcPOPPLJ+1rUR1DUZSUrCwDFs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=voCMWuJq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="voCMWuJq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F4FDC4CED0;
	Thu, 12 Dec 2024 15:54:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734018875;
	bh=te40OVqwEpDUAjNFXRG0ZZcM5vRdV02+uT55jEMtXqQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=voCMWuJqHHeltqIah1yCx4Zcp37CA2VmqLu1nfaK7Ufo22kSjwcf7g47WKxriynP0
	 hsQhL8RutMEl+z9BfiaKa3JXGSv2xQMPxGo0bBtXiJyjN074EOprXKaVClZGOlBVik
	 18xtSisujre2kmSR1AtFX95lnGfjvD/2yHKBivy0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wang Liang <wangliang74@huawei.com>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Bin Lan <bin.lan.cn@windriver.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 030/772] net: fix crash when config small gso_max_size/gso_ipv4_max_size
Date: Thu, 12 Dec 2024 15:49:35 +0100
Message-ID: <20241212144351.192674743@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
---
 net/core/rtnetlink.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index afb52254a47ec..45c54fb9ad03f 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -1939,7 +1939,7 @@ static const struct nla_policy ifla_policy[IFLA_MAX+1] = {
 	[IFLA_NUM_TX_QUEUES]	= { .type = NLA_U32 },
 	[IFLA_NUM_RX_QUEUES]	= { .type = NLA_U32 },
 	[IFLA_GSO_MAX_SEGS]	= { .type = NLA_U32 },
-	[IFLA_GSO_MAX_SIZE]	= { .type = NLA_U32 },
+	[IFLA_GSO_MAX_SIZE]	= NLA_POLICY_MIN(NLA_U32, MAX_TCP_HEADER + 1),
 	[IFLA_PHYS_PORT_ID]	= { .type = NLA_BINARY, .len = MAX_PHYS_ITEM_ID_LEN },
 	[IFLA_CARRIER_CHANGES]	= { .type = NLA_U32 },  /* ignored */
 	[IFLA_PHYS_SWITCH_ID]	= { .type = NLA_BINARY, .len = MAX_PHYS_ITEM_ID_LEN },
-- 
2.43.0



