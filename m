Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4A1728EB
	for <patches@lists.linux.dev>; Mon, 30 Jan 2023 14:07:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27ADBC433D2;
	Mon, 30 Jan 2023 14:07:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675087634;
	bh=2CG7IUnzL+euN8zT90NMrAitxJnqWO3a+rbuOZKM3Rs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tykqzcodbAjwgv7unmauthEzsbjjIwufxHIJOUrkwV9uIH6C41IbITgHpKpq5ypIg
	 562uir80RTYIgAxUjtXS26vTSWgvbalwTcw4iJxkOzdElgovFbrFr5h0QoGsPxM4yB
	 qF2AJjjjdSyIh7HsgbLBvAAY3pxzbxH77zL+y8lw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Sriram Yagnaraman <sriram.yagnaraman@est.tech>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 274/313] netfilter: conntrack: fix bug in for_each_sctp_chunk
Date: Mon, 30 Jan 2023 14:51:49 +0100
Message-Id: <20230130134349.500119625@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134336.532886729@linuxfoundation.org>
References: <20230130134336.532886729@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Sriram Yagnaraman <sriram.yagnaraman@est.tech>

[ Upstream commit 98ee0077452527f971567db01386de3c3d97ce13 ]

skb_header_pointer() will return NULL if offset + sizeof(_sch) exceeds
skb->len, so this offset < skb->len test is redundant.

if sch->length == 0, this will end up in an infinite loop, add a check
for sch->length > 0

Fixes: 9fb9cbb1082d ("[NETFILTER]: Add nf_conntrack subsystem.")
Suggested-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Sriram Yagnaraman <sriram.yagnaraman@est.tech>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_conntrack_proto_sctp.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_conntrack_proto_sctp.c b/net/netfilter/nf_conntrack_proto_sctp.c
index 3704d1c7d3c2..ee317f9a22e5 100644
--- a/net/netfilter/nf_conntrack_proto_sctp.c
+++ b/net/netfilter/nf_conntrack_proto_sctp.c
@@ -155,8 +155,8 @@ static void sctp_print_conntrack(struct seq_file *s, struct nf_conn *ct)
 
 #define for_each_sctp_chunk(skb, sch, _sch, offset, dataoff, count)	\
 for ((offset) = (dataoff) + sizeof(struct sctphdr), (count) = 0;	\
-	(offset) < (skb)->len &&					\
-	((sch) = skb_header_pointer((skb), (offset), sizeof(_sch), &(_sch)));	\
+	((sch) = skb_header_pointer((skb), (offset), sizeof(_sch), &(_sch))) &&	\
+	(sch)->length;	\
 	(offset) += (ntohs((sch)->length) + 3) & ~3, (count)++)
 
 /* Some validity checks to make sure the chunks are fine */
-- 
2.39.0



