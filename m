Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 051F52F24
	for <patches@lists.linux.dev>; Wed, 12 Apr 2023 08:51:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 817FDC4339C;
	Wed, 12 Apr 2023 08:51:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1681289472;
	bh=ldw7XbhBb1FduhtV1MrUJHLm5E0vJiafFKpOZ6P+NCM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DjFVFknxa3TW2wsGwGsHcIdM7K/+0sEUCCHz7pKc3pnFWDmsmY3GKkWqTI7HEturD
	 rE9mOpSB0eLiDLnOEV27IYvU5i4UTyGqLJQGGkBtaiqcp9W5+3Z/GeXarc52ueaoqs
	 MdGe+u6dhWEbHhpQpcAnbct7CtvKlPXPvC8si4oE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shuangpeng Bai <sjb7183@psu.edu>,
	Oleksij Rempel <o.rempel@pengutronix.de>,
	Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 6.2 112/173] can: j1939: j1939_tp_tx_dat_new(): fix out-of-bounds memory access
Date: Wed, 12 Apr 2023 10:33:58 +0200
Message-Id: <20230412082842.607767223@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230412082838.125271466@linuxfoundation.org>
References: <20230412082838.125271466@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Oleksij Rempel <o.rempel@pengutronix.de>

commit b45193cb4df556fe6251b285a5ce44046dd36b4a upstream.

In the j1939_tp_tx_dat_new() function, an out-of-bounds memory access
could occur during the memcpy() operation if the size of skb->cb is
larger than the size of struct j1939_sk_buff_cb. This is because the
memcpy() operation uses the size of skb->cb, leading to a read beyond
the struct j1939_sk_buff_cb.

Updated the memcpy() operation to use the size of struct
j1939_sk_buff_cb instead of the size of skb->cb. This ensures that the
memcpy() operation only reads the memory within the bounds of struct
j1939_sk_buff_cb, preventing out-of-bounds memory access.

Additionally, add a BUILD_BUG_ON() to check that the size of skb->cb
is greater than or equal to the size of struct j1939_sk_buff_cb. This
ensures that the skb->cb buffer is large enough to hold the
j1939_sk_buff_cb structure.

Fixes: 9d71dd0c7009 ("can: add support of SAE J1939 protocol")
Reported-by: Shuangpeng Bai <sjb7183@psu.edu>
Tested-by: Shuangpeng Bai <sjb7183@psu.edu>
Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
Link: https://groups.google.com/g/syzkaller/c/G_LL-C3plRs/m/-8xCi6dCAgAJ
Link: https://lore.kernel.org/all/20230404073128.3173900-1-o.rempel@pengutronix.de
Cc: stable@vger.kernel.org
[mkl: rephrase commit message]
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/can/j1939/transport.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/net/can/j1939/transport.c
+++ b/net/can/j1939/transport.c
@@ -604,7 +604,10 @@ sk_buff *j1939_tp_tx_dat_new(struct j193
 	/* reserve CAN header */
 	skb_reserve(skb, offsetof(struct can_frame, data));
 
-	memcpy(skb->cb, re_skcb, sizeof(skb->cb));
+	/* skb->cb must be large enough to hold a j1939_sk_buff_cb structure */
+	BUILD_BUG_ON(sizeof(skb->cb) < sizeof(*re_skcb));
+
+	memcpy(skb->cb, re_skcb, sizeof(*re_skcb));
 	skcb = j1939_skb_to_cb(skb);
 	if (swap_src_dst)
 		j1939_skbcb_swap(skcb);


