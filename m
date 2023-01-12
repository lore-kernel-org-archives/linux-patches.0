Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C6C4749A
	for <patches@lists.linux.dev>; Thu, 12 Jan 2023 14:11:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74742C433EF;
	Thu, 12 Jan 2023 14:11:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673532670;
	bh=HxwE+veaRYixwckzaukWnmpKyE6DwSBJjs6f6LN2GMg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z6FUV2jelEu7VYtr5V1teljY5oUspfg77R4aqEEAwdInktluS5CkMMLMOtu9MZWOw
	 5clUSB8I8ulN8gdCe1KYBRaC+Fr6Q8eWJMnglA9jJmyp26+ayyOtYA4txup6aH6Vix
	 sugX2PKTVvvvWLo/AgH7Ex/9BsTdgwCB+yxY3HJs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 207/783] hsr: Add a rcu-read lock to hsr_forward_skb().
Date: Thu, 12 Jan 2023 14:48:43 +0100
Message-Id: <20230112135533.934680459@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

[ Upstream commit 5aa2820177af650293b2f9f1873c1f6f8e4ad7a4 ]

hsr_forward_skb() a skb and keeps information in an on-stack
hsr_frame_info. hsr_get_node() assigns hsr_frame_info::node_src which is
from a RCU list. This pointer is used later in hsr_forward_do().
I don't see a reason why this pointer can't vanish midway since there is
no guarantee that hsr_forward_skb() is invoked from an RCU read section.

Use rcu_read_lock() to protect hsr_frame_info::node_src from its
assignment until it is no longer used.

Fixes: f266a683a4804 ("net/hsr: Better frame dispatch")
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/hsr/hsr_forward.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/hsr/hsr_forward.c b/net/hsr/hsr_forward.c
index cb9b54a7abd2..90b0ed16552b 100644
--- a/net/hsr/hsr_forward.c
+++ b/net/hsr/hsr_forward.c
@@ -545,11 +545,13 @@ void hsr_forward_skb(struct sk_buff *skb, struct hsr_port *port)
 {
 	struct hsr_frame_info frame;
 
+	rcu_read_lock();
 	if (fill_frame_info(&frame, skb, port) < 0)
 		goto out_drop;
 
 	hsr_register_frame_in(frame.node_src, port, frame.sequence_nr);
 	hsr_forward_do(&frame);
+	rcu_read_unlock();
 	/* Gets called for ingress frames as well as egress from master port.
 	 * So check and increment stats for master port only here.
 	 */
@@ -564,6 +566,7 @@ void hsr_forward_skb(struct sk_buff *skb, struct hsr_port *port)
 	return;
 
 out_drop:
+	rcu_read_unlock();
 	port->dev->stats.tx_dropped++;
 	kfree_skb(skb);
 }
-- 
2.35.1



