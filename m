Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B29B1F923
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 18:55:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF5BAC433C8;
	Fri, 21 Jul 2023 18:55:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689965755;
	bh=sU2EJAQIZCKW44hl/+rJjinYlgn6NxEb3EieyJ91ZFQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iNJAw0tntqscLfefWKpb7C7KDU4UQXmDnOgCoyUmS94l4R/XvMCR7TlVnMmCjvG72
	 oMiyjk4Re57y5Fofupo4n+9b9N+VkIY9d0gtVfxDy96MDNNzWyiNB2YJZMU841pCKk
	 QRnLkuEhfXk2HV58ad9IgAlsSC8FUkNj1cz1Ce3M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tobias Klauser <tklauser@distanz.ch>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 074/532] bpf: Omit superfluous address family check in __bpf_skc_lookup
Date: Fri, 21 Jul 2023 17:59:38 +0200
Message-ID: <20230721160618.626428288@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160614.695323302@linuxfoundation.org>
References: <20230721160614.695323302@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Tobias Klauser <tklauser@distanz.ch>

[ Upstream commit 2064a132c0de3426d5ba43023200994e0c77e652 ]

family is only set to either AF_INET or AF_INET6 based on len. In all
other cases we return early. Thus the check against AF_UNSPEC can be
omitted.

Signed-off-by: Tobias Klauser <tklauser@distanz.ch>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/bpf/20220630082618.15649-1-tklauser@distanz.ch
Stable-dep-of: 9a5cb79762e0 ("bpf: Fix bpf socket lookup from tc/xdp to respect socket VRF bindings")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/filter.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/net/core/filter.c b/net/core/filter.c
index 519315a1acf3a..a8291ba156446 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -6177,8 +6177,8 @@ __bpf_skc_lookup(struct sk_buff *skb, struct bpf_sock_tuple *tuple, u32 len,
 		 u64 flags)
 {
 	struct sock *sk = NULL;
-	u8 family = AF_UNSPEC;
 	struct net *net;
+	u8 family;
 	int sdif;
 
 	if (len == sizeof(tuple->ipv4))
@@ -6188,8 +6188,7 @@ __bpf_skc_lookup(struct sk_buff *skb, struct bpf_sock_tuple *tuple, u32 len,
 	else
 		return NULL;
 
-	if (unlikely(family == AF_UNSPEC || flags ||
-		     !((s32)netns_id < 0 || netns_id <= S32_MAX)))
+	if (unlikely(flags || !((s32)netns_id < 0 || netns_id <= S32_MAX)))
 		goto out;
 
 	if (family == AF_INET)
-- 
2.39.2



