Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DFC617756
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 11:22:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CFBFC433C8;
	Wed,  9 Aug 2023 11:22:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691580133;
	bh=DDt+tKU63snw0uZUGRLpM/0mQ1YBeLXD0yQis9FtCwE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XoYWKneFLW//dKsQEdukrotjoIW/mfkTkDbsmdFNKbP1Rx+GkwyR3oJxLIbDA45+L
	 fOekp5wu6gtqftGTZhJqpO/88tXL+HfcoCagdYQURv/O2A2jtlHpjS5mJ7zerliMv2
	 I+Vpv3qw3crIdWRfO7d5uqBn685vEAyrCQap5IuA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 208/323] llc: Dont drop packet from non-root netns.
Date: Wed,  9 Aug 2023 12:40:46 +0200
Message-ID: <20230809103707.659010487@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230809103658.104386911@linuxfoundation.org>
References: <20230809103658.104386911@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Kuniyuki Iwashima <kuniyu@amazon.com>

[ Upstream commit 6631463b6e6673916d2481f692938f393148aa82 ]

Now these upper layer protocol handlers can be called from llc_rcv()
as sap->rcv_func(), which is registered by llc_sap_open().

  * function which is passed to register_8022_client()
    -> no in-kernel user calls register_8022_client().

  * snap_rcv()
    `- proto->rcvfunc() : registered by register_snap_client()
       -> aarp_rcv() and atalk_rcv() drop packets from non-root netns

  * stp_pdu_rcv()
    `- garp_protos[]->rcv() : registered by stp_proto_register()
       -> garp_pdu_rcv() and br_stp_rcv() are netns-aware

So, we can safely remove the netns restriction in llc_rcv().

Fixes: e730c15519d0 ("[NET]: Make packet reception network namespace safe")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/llc/llc_input.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/net/llc/llc_input.c b/net/llc/llc_input.c
index 82cb93f66b9bd..f9e801cc50f5e 100644
--- a/net/llc/llc_input.c
+++ b/net/llc/llc_input.c
@@ -162,9 +162,6 @@ int llc_rcv(struct sk_buff *skb, struct net_device *dev,
 	void (*sta_handler)(struct sk_buff *skb);
 	void (*sap_handler)(struct llc_sap *sap, struct sk_buff *skb);
 
-	if (!net_eq(dev_net(dev), &init_net))
-		goto drop;
-
 	/*
 	 * When the interface is in promisc. mode, drop all the crap that it
 	 * receives, do not try to analyse it.
-- 
2.39.2



