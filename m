Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1AC56FB5
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 20:30:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E8E6C433CC;
	Sun, 17 Sep 2023 20:30:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694982659;
	bh=xnh0D6Hhbb2JZsUZ4n0bR27RmPh/cfavY8nf8nvYH1g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BeVmj2UHCdSC7kZQ0MHzHPG9Dve5CS9kfO3DBL6dNajrUdNXFVbu1VnmcG9IX3kij
	 UFY8UBmPHXQRDx/dLpUGPx8dusyObBfoveCRM51HPyuwpvYo2A6seuioSahwAGXja0
	 sw4cURpGX3+LQ8+ZoNSzxr0i90prhigQY73Agzu8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	David Laight <David.Laight@ACULAB.COM>,
	Kyle Zeng <zengyhkyle@gmail.com>,
	Simon Horman <horms@kernel.org>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.15 316/511] igmp: limit igmpv3_newpack() packet size to IP_MAX_MTU
Date: Sun, 17 Sep 2023 21:12:23 +0200
Message-ID: <20230917191121.452536183@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191113.831992765@linuxfoundation.org>
References: <20230917191113.831992765@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

commit c3b704d4a4a265660e665df51b129e8425216ed1 upstream.

This is a follow up of commit 915d975b2ffa ("net: deal with integer
overflows in kmalloc_reserve()") based on David Laight feedback.

Back in 2010, I failed to realize malicious users could set dev->mtu
to arbitrary values. This mtu has been since limited to 0x7fffffff but
regardless of how big dev->mtu is, it makes no sense for igmpv3_newpack()
to allocate more than IP_MAX_MTU and risk various skb fields overflows.

Fixes: 57e1ab6eaddc ("igmp: refine skb allocations")
Link: https://lore.kernel.org/netdev/d273628df80f45428e739274ab9ecb72@AcuMS.aculab.com/
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: David Laight <David.Laight@ACULAB.COM>
Cc: Kyle Zeng <zengyhkyle@gmail.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/igmp.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/ipv4/igmp.c
+++ b/net/ipv4/igmp.c
@@ -353,8 +353,9 @@ static struct sk_buff *igmpv3_newpack(st
 	struct flowi4 fl4;
 	int hlen = LL_RESERVED_SPACE(dev);
 	int tlen = dev->needed_tailroom;
-	unsigned int size = mtu;
+	unsigned int size;
 
+	size = min(mtu, IP_MAX_MTU);
 	while (1) {
 		skb = alloc_skb(size + hlen + tlen,
 				GFP_ATOMIC | __GFP_NOWARN);


