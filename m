Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D0F1569D
	for <patches@lists.linux.dev>; Sun, 28 May 2023 19:25:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFF19C433D2;
	Sun, 28 May 2023 19:25:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1685301952;
	bh=LJOQ8Ufeho3fWvulnkSqpY0O/5nhclBqnBoeXTiMXI8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bGB0Yve4+LmIH0YxCqNO66PnBYpErx0BbBaSthXOOOAzcGQajYfloo1tiZptxgAEZ
	 67O+jgNzdWqnt6yqMeCt5eNiYM52ORE+qK+yUefqstYoR7FxygGCITQOtg4PLEYkEn
	 6IlNi+ePcBi1yKvaRKwjbWZnQvz9VLsrc8w1IGhY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+632b5d9964208bfef8c0@syzkaller.appspotmail.com,
	Eric Dumazet <edumazet@google.com>,
	Dong Chenchen <dongchenchen2@huawei.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 074/161] net: nsh: Use correct mac_offset to unwind gso skb in nsh_gso_segment()
Date: Sun, 28 May 2023 20:09:58 +0100
Message-Id: <20230528190839.508121262@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230528190837.051205996@linuxfoundation.org>
References: <20230528190837.051205996@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Dong Chenchen <dongchenchen2@huawei.com>

[ Upstream commit c83b49383b595be50647f0c764a48c78b5f3c4f8 ]

As the call trace shows, skb_panic was caused by wrong skb->mac_header
in nsh_gso_segment():

invalid opcode: 0000 [#1] PREEMPT SMP KASAN PTI
CPU: 3 PID: 2737 Comm: syz Not tainted 6.3.0-next-20230505 #1
RIP: 0010:skb_panic+0xda/0xe0
call Trace:
 skb_push+0x91/0xa0
 nsh_gso_segment+0x4f3/0x570
 skb_mac_gso_segment+0x19e/0x270
 __skb_gso_segment+0x1e8/0x3c0
 validate_xmit_skb+0x452/0x890
 validate_xmit_skb_list+0x99/0xd0
 sch_direct_xmit+0x294/0x7c0
 __dev_queue_xmit+0x16f0/0x1d70
 packet_xmit+0x185/0x210
 packet_snd+0xc15/0x1170
 packet_sendmsg+0x7b/0xa0
 sock_sendmsg+0x14f/0x160

The root cause is:
nsh_gso_segment() use skb->network_header - nhoff to reset mac_header
in skb_gso_error_unwind() if inner-layer protocol gso fails.
However, skb->network_header may be reset by inner-layer protocol
gso function e.g. mpls_gso_segment. skb->mac_header reset by the
inaccurate network_header will be larger than skb headroom.

nsh_gso_segment
    nhoff = skb->network_header - skb->mac_header;
    __skb_pull(skb,nsh_len)
    skb_mac_gso_segment
        mpls_gso_segment
            skb_reset_network_header(skb);//skb->network_header+=nsh_len
            return -EINVAL;
    skb_gso_error_unwind
        skb_push(skb, nsh_len);
        skb->mac_header = skb->network_header - nhoff;
        // skb->mac_header > skb->headroom, cause skb_push panic

Use correct mac_offset to restore mac_header and get rid of nhoff.

Fixes: c411ed854584 ("nsh: add GSO support")
Reported-by: syzbot+632b5d9964208bfef8c0@syzkaller.appspotmail.com
Suggested-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Dong Chenchen <dongchenchen2@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/nsh/nsh.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/net/nsh/nsh.c b/net/nsh/nsh.c
index e9ca007718b7e..0f23e5e8e03eb 100644
--- a/net/nsh/nsh.c
+++ b/net/nsh/nsh.c
@@ -77,13 +77,12 @@ static struct sk_buff *nsh_gso_segment(struct sk_buff *skb,
 				       netdev_features_t features)
 {
 	struct sk_buff *segs = ERR_PTR(-EINVAL);
+	u16 mac_offset = skb->mac_header;
 	unsigned int nsh_len, mac_len;
 	__be16 proto;
-	int nhoff;
 
 	skb_reset_network_header(skb);
 
-	nhoff = skb->network_header - skb->mac_header;
 	mac_len = skb->mac_len;
 
 	if (unlikely(!pskb_may_pull(skb, NSH_BASE_HDR_LEN)))
@@ -108,15 +107,14 @@ static struct sk_buff *nsh_gso_segment(struct sk_buff *skb,
 	segs = skb_mac_gso_segment(skb, features);
 	if (IS_ERR_OR_NULL(segs)) {
 		skb_gso_error_unwind(skb, htons(ETH_P_NSH), nsh_len,
-				     skb->network_header - nhoff,
-				     mac_len);
+				     mac_offset, mac_len);
 		goto out;
 	}
 
 	for (skb = segs; skb; skb = skb->next) {
 		skb->protocol = htons(ETH_P_NSH);
 		__skb_push(skb, nsh_len);
-		skb_set_mac_header(skb, -nhoff);
+		skb->mac_header = mac_offset;
 		skb->network_header = skb->mac_header + mac_len;
 		skb->mac_len = mac_len;
 	}
-- 
2.39.2



