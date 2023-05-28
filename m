Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB83E611B
	for <patches@lists.linux.dev>; Sun, 28 May 2023 19:15:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 595F8C4339C;
	Sun, 28 May 2023 19:15:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1685301337;
	bh=3DMZE2kgJRKEms66kEwLHTGcWQzi2bwr5csug/Txqmk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xvu11AcPxVme37X7my8CqnI0v1r7ECAuvrwpgpt7KGgIHoC3dH1ozhtSH+/HxogKC
	 bqIK59hUdhhSV4nP+zT0K43+nbH8k9ySYPgjBMIA96BK2nize/BIkzZMzV6Pk+1vyO
	 akBx5PUP+2rlSDNNekj9BX7l7SyRuGr/6xCofJvA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pratyush Yadav <ptyadav@amazon.de>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Willem de Bruijn <willemb@google.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 4.14 76/86] net: fix skb leak in __skb_tstamp_tx()
Date: Sun, 28 May 2023 20:10:50 +0100
Message-Id: <20230528190831.465489713@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230528190828.564682883@linuxfoundation.org>
References: <20230528190828.564682883@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Pratyush Yadav <ptyadav@amazon.de>

commit 8a02fb71d7192ff1a9a47c9d937624966c6e09af upstream.

Commit 50749f2dd685 ("tcp/udp: Fix memleaks of sk and zerocopy skbs with
TX timestamp.") added a call to skb_orphan_frags_rx() to fix leaks with
zerocopy skbs. But it ended up adding a leak of its own. When
skb_orphan_frags_rx() fails, the function just returns, leaking the skb
it just cloned. Free it before returning.

This bug was discovered and resolved using Coverity Static Analysis
Security Testing (SAST) by Synopsys, Inc.

Fixes: 50749f2dd685 ("tcp/udp: Fix memleaks of sk and zerocopy skbs with TX timestamp.")
Signed-off-by: Pratyush Yadav <ptyadav@amazon.de>
Reviewed-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Link: https://lore.kernel.org/r/20230522153020.32422-1-ptyadav@amazon.de
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/skbuff.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -4421,8 +4421,10 @@ void __skb_tstamp_tx(struct sk_buff *ori
 	} else {
 		skb = skb_clone(orig_skb, GFP_ATOMIC);
 
-		if (skb_orphan_frags_rx(skb, GFP_ATOMIC))
+		if (skb_orphan_frags_rx(skb, GFP_ATOMIC)) {
+			kfree_skb(skb);
 			return;
+		}
 	}
 	if (!skb)
 		return;


