Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042451;
	b=heAQzb4yxToexEfbvEJfFE2bWIGY1S0bQE6/iGBGFrWz8+67bGzH0qytusfU2Sr1v71a
	 clZ8UF/5u8TRxc1sgl5p/+cBoSVeKWJB7ueA5WPlqTRnUfLNsEGupAKZ5vNJEbHdPyk/d
	 P3qOUtWIpDoGxbFQaR+D28i7j67fKtumqGfDitn9memj7ozjaz1xqzCM7vmF0FxLbh6wu
	 0fxttNS2oxxC1pacW+boy4phfEDhaqhKvmklOl+lq/CqInWS3pbRHx3pDqxlL1G30jVil
	 ZhF2zOTAHH38wkj8EwkmYn9thaSNyDq/vow6DqwYwCOmmz1LxifaR/6SKK5ig1IL7vg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042451;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Q9q9dWRybe2FOxte0V5Rvye/hRM4svAIQxn+8eH1yLI=;
	b=hbFKPAZFSOHwJpO58gikwSxQNk24JmZdq9VD4chWHT6BDkrK8Bjpx6GYpKUjRqIlBo/6
	 Knu8Vl8iLBu3a4B//YXAsYscPRmy5VGsS58ZAhhW1OpyQ9Iaiz7K+E8kI5YrqqnLy2+jS
	 i9zJ5shlssfb+uH1CfFKIdEXozTiiAiwqdnuQhkI1VVTq8mhExBb2u05wZXmGO7FeCn4g
	 9eRLe7QmYhHfyDPS//N39210B6xSx5h7TPKd82WDBWBQyoX7scQP2cgsyS8WVjj+UoViQ
	 EsE0xxw2702vgv6jjdvc7BHlRwe11nKyWEu1BWZqsmA+TKDIGOCcCo/N506iR1h75nw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ETWeyeXR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A77F4606A325;
	Wed, 18 Nov 2026 22:54:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ETWeyeXR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B232D1F000C4;
	Wed, 18 Nov 2026 22:54:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042451;
	bh=Q9q9dWRybe2FOxte0V5Rvye/hRM4svAIQxn+8eH1yLI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ETWeyeXRZRKWhFd7NtovaAAl61uqFyEidkmYWR3hV7G9ZVe8RPzM47BHw+as8m9M2
	 uXNRVvA9+d85zL37WQR0mHzs+QjIZ6fuopep4fm/Ww5H/UcWF2XDe/uwhyDakpkB8i
	 eR9SeaptFIvozbnwedTiVu+x0lc9z8XX5psQqrD4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dudu Lu <phx0fer@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Daniel Machon <daniel.machon@microchip.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 3175/3318] net/sched: gred: keep the qdisc lock while updating the table
Date: Wed, 18 Nov 2026 16:03:17 +0100
Message-ID: <20261118150455.075162233@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dudu Lu <phx0fer@gmail.com>

[ Upstream commit 306f788134a21a3d60c1eb872d0ec0ce7c7e09bc ]

gred_change_table_def() publishes table->DPs/def/red_flags under
sch_tree_lock(), drops the lock, and then keeps writing state the
datapath reads without it:

  - gred_enable_rio_mode()/gred_disable_rio_mode()/gred_disable_wred_mode()
    set/clear table->flags;
  - the red_flags_changed loop writes table->tab[i]->red_flags;
  - the shadowed-VQ loop frees table->tab[i] and clears the slot.

gred_enqueue() and gred_dequeue() read those same fields (test_bit on
table->flags, q->red_flags, t->tab[]/t->DPs) under the same root lock on
another CPU, so the post-unlock writes race with the enqueue path:

  BUG: KCSAN: data-race in gred_change_table_def [sch_gred] / gred_enqueue [sch_gred]
  read (marked) to 0xffff000007ad3b00 of 8 bytes by task 110 on cpu 0:
   gred_enqueue+0x88/0xc60 [sch_gred]
   dev_qdisc_enqueue+0x4c/0x19c
   __dev_queue_xmit+0x10a4/0x1ea4

The comment justifying the early unlock only covers the DP-vs-DPs check,
which the shadowed-VQ free loop relies on; it does not cover the scalar
mode bits and per-VQ red_flags written afterwards.  Move the unlock below
those updates so everything the datapath reads is published under the
lock that protects it.

Fixes: 6639607ed9de ("[PKT_SCHED]: GRED: Use a central table definition change procedure")
Signed-off-by: Dudu Lu <phx0fer@gmail.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Reviewed-by: Daniel Machon <daniel.machon@microchip.com>
Link: https://patch.msgid.link/20261021155434.66572-1-phx0fer@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/sch_gred.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/net/sched/sch_gred.c b/net/sched/sch_gred.c
index 4f44a268286fa..63c23af51b4a3 100644
--- a/net/sched/sch_gred.c
+++ b/net/sched/sch_gred.c
@@ -442,13 +442,6 @@ static int gred_change_table_def(struct Qdisc *sch, struct nlattr *dps,
 	red_flags_changed = table->red_flags != sopt->flags;
 	table->red_flags = sopt->flags;
 
-	/*
-	 * Every entry point to GRED is synchronized with the above code
-	 * and the DP is checked against DPs, i.e. shadowed VQs can no
-	 * longer be found so we can unlock right here.
-	 */
-	sch_tree_unlock(sch);
-
 	if (sopt->grio) {
 		gred_enable_rio_mode(table);
 		gred_disable_wred_mode(table);
@@ -474,6 +467,15 @@ static int gred_change_table_def(struct Qdisc *sch, struct nlattr *dps,
 		}
 	}
 
+	/*
+	 * Keep the lock until every field the datapath reads (the
+	 * RIO/WRED mode bits, the per-VQ red_flags and the tab[] slots)
+	 * has been updated: gred_enqueue()/gred_dequeue() read them under
+	 * the same lock, so publishing them after the unlock races with
+	 * the enqueue path.
+	 */
+	sch_tree_unlock(sch);
+
 	gred_offload(sch, TC_GRED_REPLACE);
 	return 0;
 }
-- 
2.53.0



