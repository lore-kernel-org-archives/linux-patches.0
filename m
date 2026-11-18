Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027950;
	b=vmd8AFv2TyLWWckzOp5uT/J6cJpO0IlBF7/ceM1euCA0fB3vMmf4eWYn9yVJvEzHu5YQ
	 aQbqrHtns/1OKPxnmp65EpsQ++SEE+/G1INrCVxa/jMrWInpCGhzcfCJ8k7FppPF+esY6
	 jJbmrNv7tqA8A0HEBQUN/mFmMSkN2blQrJFN9GyOwoWALech2sS2oyK9j4812cnUfW5kW
	 U6svR8SIwkBMO+Bqs6l6Q9bcd0DGBwTenFLgd8spBoFbN8KeEtZ3jYgWpGbENvPBpgbKP
	 +Tg+RZJozZjUchu3GmyvxKEp0S7PiufX5w6v2c+hi1RZIewGNM5Jx4PkFCgyPWeYdrg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027950;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1TTnYTFX0z7fEVzcTRjxDJ9QuSnzsqyVLuaEKDze7Qw=;
	b=LmrIAXOKJNNxpCbvaZwzm75uq2JuON5wbGYznWZEsl1i7+vjNDhuaqWHvQ2/vU8AID7k
	 NHf87maXdD6ZP15rhlzmmqNLAgZ+VSzOvlDrEcJ/sHCBBvIB3YipPd1NijkoNzYW2+YOs
	 jKqrO7LKAm7WBKyKOMFKZU3ba0ONYWz1pyW2t0kLuXuLL/dhP6mlJV25nskVsqdwR3oeQ
	 QRjSTHxSCcvL1C0I1cdNyEREFW2omH2Ovft7uqO6pT0I1RcTeB+1qYpnyhdmLcEsHFqnD
	 1zQ72LEWYmj29Jk1OtKoibUCOlUYdvcVhiDimFGTJYaYRHLq6ZHHTWWpx6x62MBnUoQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=v0BzcxmR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9186F606A31C;
	Wed, 18 Nov 2026 18:52:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=v0BzcxmR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E28801F000C4;
	Wed, 18 Nov 2026 18:52:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027950;
	bh=1TTnYTFX0z7fEVzcTRjxDJ9QuSnzsqyVLuaEKDze7Qw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=v0BzcxmRmL9zjrk960IAWezcmKmxUUc3g+MXQ9LdnxyHgEgImQvW5K/nAzO981DtC
	 PDE2h6H/R4VlWbMUsm9ftKUGO0qJGwHHGKRRV7smNmx30Yl6D4rENQ7aAB5IM7ZO0z
	 VTrnuqDmjT0YN4Sy/xm2swLJ9rKfLvEALf92CltI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dudu Lu <phx0fer@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Daniel Machon <daniel.machon@microchip.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1972/2151] net/sched: gred: keep the qdisc lock while updating the table
Date: Wed, 18 Nov 2026 16:01:47 +0100
Message-ID: <20261118150233.579242615@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 9185b361dd78e..c3088cddafe79 100644
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



