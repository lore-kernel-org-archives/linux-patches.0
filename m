Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056944;
	b=DhUDdwiZboE3V+IV7wicTD0k4mrC9GizbBBP0UNoqC8TgO676plRabVoN4gshWJuaAkD
	 2wRnsspfvFM2Bu6VElr24G7ZrP2w39q3dfRTzvcA2xV5rt/eXwioP1QwvhEa5cYhaUJHc
	 AIJ7OmHYucDpN+dORGgJXsig8r5xmPgLAkJNJ4lk9Qu6ZCjpgH5IhywYmiBWiFeh1Y5gD
	 VcVS9TNbhTBsJlXsgum2eGk3EtbRjOsPL7uWbVcGrFy450c1KlzrTNf7/lZosCfohmZYy
	 r+qmcds3kUpIpZ1cEw2MePKm5UAtVDwv7mVzW488SpNvFjYf6yFLkUpvxMmkpNYtC/w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056944;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vCaAh4gCY9DcqTq1KTi0+iLlbD5Gmt7Q/PZqsdZMQZo=;
	b=Sl+4MH8hv6pb+577QRGf1R63rfnY55wmDwLjkv37ZW5Oo/7peCxtg3jIyJeakCPNQFcP
	 j+rYAf7kgWo53Z1id2/L71QZZmi8iTNyZ2S/GBijZeoy6xhxDuXm9GIQjX0VTOMmKRdz2
	 m74g5XFe7CiE0k9Y41A1Tt/9yj0lNpNJmZsKmTKtV2Ir/6NslEXZ0CaJccetsPGX0hocO
	 0iQRTosXNiMasF6a/UmetI7NK2vAHmENB+qvt52I6KyWLwgqxR3Y80J3wb4537EuhmrVM
	 CWSsKvtsIhQtpjDwUst3pLR4nyUPj4LPz04G1G2lgfkEcVcx7o4Ep7L9KHKkZ48Zu1Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oWYbdOMa;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1689E606A325;
	Thu, 19 Nov 2026 02:55:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oWYbdOMa
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 717B81F000C5;
	Thu, 19 Nov 2026 02:55:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056943;
	bh=vCaAh4gCY9DcqTq1KTi0+iLlbD5Gmt7Q/PZqsdZMQZo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oWYbdOMaw5+qVBDvvNobL0EmYFjbrzLqqwjyOlG4rx/oaqyxBtnzchW07ta4dZdVJ
	 o6Ha4Iq4FJyqjkIoNPkbdr1LT/h3Xexh1UAG6uOX/jgkx16hL30wWhsOjSpPLU7qrE
	 jTmuchEUbMMbmHkXbOJVKL3nSLIPpZbbBT89Antk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dudu Lu <phx0fer@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Daniel Machon <daniel.machon@microchip.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 2127/2214] net/sched: gred: keep the qdisc lock while updating the table
Date: Wed, 18 Nov 2026 16:03:23 +0100
Message-ID: <20261118150135.640653610@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 8caf9623f855f..7c42b3b75cd89 100644
--- a/net/sched/sch_gred.c
+++ b/net/sched/sch_gred.c
@@ -435,13 +435,6 @@ static int gred_change_table_def(struct Qdisc *sch, struct nlattr *dps,
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
@@ -467,6 +460,15 @@ static int gred_change_table_def(struct Qdisc *sch, struct nlattr *dps,
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



