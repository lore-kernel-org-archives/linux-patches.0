Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6B13171A1
	for <patches@lists.linux.dev>; Mon, 22 May 2023 19:18:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F160C433EF;
	Mon, 22 May 2023 19:18:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684783123;
	bh=WcRliFZvaWXFf90+Il4NuHqICBuLlXolzarpaBSu5XE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b82iCRCBdWMrMLc4N4xRHZzACvnxkpKeWg7R8MaeN34aZetYwQh8OCarE8gskToAv
	 NlC0lxGNfkQko+KnS9+S+ZCO7LQ7I1pSMjo96dOtpcTN+Vs/hyYZfr7VQWHN9b24G5
	 MbMXFTD9uHs7zzaP8pWK2hSfhsam0f+9GUxaOvzE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xin Long <lucien.xin@gmail.com>,
	Jon Maloy <jmaloy@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 146/203] tipc: check the bearer min mtu properly when setting it by netlink
Date: Mon, 22 May 2023 20:09:30 +0100
Message-Id: <20230522190359.009451621@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230522190354.935300867@linuxfoundation.org>
References: <20230522190354.935300867@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Xin Long <lucien.xin@gmail.com>

[ Upstream commit 35a089b5d793d2bfd2cc7cfa6104545184de2ce7 ]

Checking the bearer min mtu with tipc_udp_mtu_bad() only works for
IPv4 UDP bearer, and IPv6 UDP bearer has a different value for the
min mtu. This patch checks with encap_hlen + TIPC_MIN_BEARER_MTU
for min mtu, which works for both IPv4 and IPv6 UDP bearer.

Note that tipc_udp_mtu_bad() is still used to check media min mtu
in __tipc_nl_media_set(), as m->mtu currently is only used by the
IPv4 UDP bearer as its default mtu value.

Fixes: 682cd3cf946b ("tipc: confgiure and apply UDP bearer MTU on running links")
Signed-off-by: Xin Long <lucien.xin@gmail.com>
Acked-by: Jon Maloy <jmaloy@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/tipc/bearer.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/tipc/bearer.c b/net/tipc/bearer.c
index 897fc8fc08a0b..1048607a1528a 100644
--- a/net/tipc/bearer.c
+++ b/net/tipc/bearer.c
@@ -1151,8 +1151,8 @@ int __tipc_nl_bearer_set(struct sk_buff *skb, struct genl_info *info)
 				return -EINVAL;
 			}
 #ifdef CONFIG_TIPC_MEDIA_UDP
-			if (tipc_udp_mtu_bad(nla_get_u32
-					     (props[TIPC_NLA_PROP_MTU]))) {
+			if (nla_get_u32(props[TIPC_NLA_PROP_MTU]) <
+			    b->encap_hlen + TIPC_MIN_BEARER_MTU) {
 				NL_SET_ERR_MSG(info->extack,
 					       "MTU value is out-of-range");
 				return -EINVAL;
-- 
2.39.2



