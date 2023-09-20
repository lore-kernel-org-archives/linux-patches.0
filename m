Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8862423752
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 12:04:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09A1BC433C7;
	Wed, 20 Sep 2023 12:04:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695211450;
	bh=LqP3BvptvtgQ3PNJPC8+91f0V4FnJX34pOp9eNDaxYs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QklwfMD5dEOk/qj5A/zM4E4nKe4ydWCg04z6UsGeme7Bn4oGVCeLKI9poFixhtp7m
	 UQrbZBico/7Ve270UEeH5STA/fzkdRlUH10T/djx/VoGOaCGpY9JjR+/BcYnbtk5Th
	 BXFta23mp0CNyavBxh0v5cvvgDyJN67ag4l1PHB8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	David Laight <David.Laight@ACULAB.COM>,
	Kyle Zeng <zengyhkyle@gmail.com>,
	Simon Horman <horms@kernel.org>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.14 097/186] igmp: limit igmpv3_newpack() packet size to IP_MAX_MTU
Date: Wed, 20 Sep 2023 13:30:00 +0200
Message-ID: <20230920112840.468724448@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230920112836.799946261@linuxfoundation.org>
References: <20230920112836.799946261@linuxfoundation.org>
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

4.14-stable review patch.  If anyone has any objections, please let me know.

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
@@ -360,8 +360,9 @@ static struct sk_buff *igmpv3_newpack(st
 	struct flowi4 fl4;
 	int hlen = LL_RESERVED_SPACE(dev);
 	int tlen = dev->needed_tailroom;
-	unsigned int size = mtu;
+	unsigned int size;
 
+	size = min(mtu, IP_MAX_MTU);
 	while (1) {
 		skb = alloc_skb(size + hlen + tlen,
 				GFP_ATOMIC | __GFP_NOWARN);


