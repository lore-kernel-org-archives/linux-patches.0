Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D7041FB4
	for <patches@lists.linux.dev>; Fri,  3 Feb 2023 10:22:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 921B9C433EF;
	Fri,  3 Feb 2023 10:22:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675419758;
	bh=Ia+CmyL4tgPspavrsr98FCV3Q0uMEyNRjnGqumBjqSs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sBYJlDLMQWP2MXE45iHS08kjfyI+//hsDq8kOCas1zcZKYo6mTbLmNX2tlZlKXdsz
	 3TSs+m13hPCaDtPJjohtuC7Elnm+mYJgsSe86SGSatl4M31K1kp4scnrOjBPdb9nP9
	 mX6Gv4sCQ07VYi1g0UREx3QseLVUWyG4auDBRc/s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Borkmann <daniel@iogearbox.net>,
	Willem de Bruijn <willemb@google.com>,
	Yan Zhai <yan@cloudflare.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 26/28] net: fix NULL pointer in skb_segment_list
Date: Fri,  3 Feb 2023 11:13:14 +0100
Message-Id: <20230203101011.064311051@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230203101009.946745030@linuxfoundation.org>
References: <20230203101009.946745030@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Yan Zhai <yan@cloudflare.com>

commit 876e8ca8366735a604bac86ff7e2732fc9d85d2d upstream.

Commit 3a1296a38d0c ("net: Support GRO/GSO fraglist chaining.")
introduced UDP listifyed GRO. The segmentation relies on frag_list being
untouched when passing through the network stack. This assumption can be
broken sometimes, where frag_list itself gets pulled into linear area,
leaving frag_list being NULL. When this happens it can trigger
following NULL pointer dereference, and panic the kernel. Reverse the
test condition should fix it.

[19185.577801][    C1] BUG: kernel NULL pointer dereference, address:
...
[19185.663775][    C1] RIP: 0010:skb_segment_list+0x1cc/0x390
...
[19185.834644][    C1] Call Trace:
[19185.841730][    C1]  <TASK>
[19185.848563][    C1]  __udp_gso_segment+0x33e/0x510
[19185.857370][    C1]  inet_gso_segment+0x15b/0x3e0
[19185.866059][    C1]  skb_mac_gso_segment+0x97/0x110
[19185.874939][    C1]  __skb_gso_segment+0xb2/0x160
[19185.883646][    C1]  udp_queue_rcv_skb+0xc3/0x1d0
[19185.892319][    C1]  udp_unicast_rcv_skb+0x75/0x90
[19185.900979][    C1]  ip_protocol_deliver_rcu+0xd2/0x200
[19185.910003][    C1]  ip_local_deliver_finish+0x44/0x60
[19185.918757][    C1]  __netif_receive_skb_one_core+0x8b/0xa0
[19185.927834][    C1]  process_backlog+0x88/0x130
[19185.935840][    C1]  __napi_poll+0x27/0x150
[19185.943447][    C1]  net_rx_action+0x27e/0x5f0
[19185.951331][    C1]  ? mlx5_cq_tasklet_cb+0x70/0x160 [mlx5_core]
[19185.960848][    C1]  __do_softirq+0xbc/0x25d
[19185.968607][    C1]  irq_exit_rcu+0x83/0xb0
[19185.976247][    C1]  common_interrupt+0x43/0xa0
[19185.984235][    C1]  asm_common_interrupt+0x22/0x40
...
[19186.094106][    C1]  </TASK>

Fixes: 3a1296a38d0c ("net: Support GRO/GSO fraglist chaining.")
Suggested-by: Daniel Borkmann <daniel@iogearbox.net>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Signed-off-by: Yan Zhai <yan@cloudflare.com>
Acked-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/r/Y9gt5EUizK1UImEP@debian
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/skbuff.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -4034,7 +4034,7 @@ struct sk_buff *skb_segment_list(struct
 
 	skb_shinfo(skb)->frag_list = NULL;
 
-	do {
+	while (list_skb) {
 		nskb = list_skb;
 		list_skb = list_skb->next;
 
@@ -4080,8 +4080,7 @@ struct sk_buff *skb_segment_list(struct
 		if (skb_needs_linearize(nskb, features) &&
 		    __skb_linearize(nskb))
 			goto err_linearize;
-
-	} while (list_skb);
+	}
 
 	skb->truesize = skb->truesize - delta_truesize;
 	skb->data_len = skb->data_len - delta_len;


