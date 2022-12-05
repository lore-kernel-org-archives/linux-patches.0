Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3095915C83
	for <patches@lists.linux.dev>; Mon,  5 Dec 2022 19:26:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8FB7C433D6;
	Mon,  5 Dec 2022 19:26:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1670268372;
	bh=w6X0T77v/b7bGsW8IHXNm1L4EmdPzcYpkowNAJoD6so=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dciTwGqoIkhhqpKqeb0aKXncSxSGPU4Y+c0Ja1RQ98d8hfgDuYSrbzqsP3xC1H39R
	 akv67IPH5LqXcllb4pV1o58nM/ZJZD4mKQn+HPrQEcp53ErdJRVkJSejhuldC4DPtg
	 EuEiMCph/6BmtNdnEfcSbswKh6K3UcFcs058uc4g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ziyang Xuan <william.xuanziyang@huawei.com>,
	Max Staudt <max@enpas.org>,
	Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 6.0 078/124] can: can327: can327_feed_frame_to_netdev(): fix potential skb leak when netdev is down
Date: Mon,  5 Dec 2022 20:09:44 +0100
Message-Id: <20221205190810.633795706@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190808.422385173@linuxfoundation.org>
References: <20221205190808.422385173@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ziyang Xuan <william.xuanziyang@huawei.com>

commit 8fa452cfafed521aaf5a18c71003fe24b1ee6141 upstream.

In can327_feed_frame_to_netdev(), it did not free the skb when netdev
is down, and all callers of can327_feed_frame_to_netdev() did not free
allocated skb too. That would trigger skb leak.

Fix it by adding kfree_skb() in can327_feed_frame_to_netdev() when netdev
is down. Not tested, just compiled.

Fixes: 43da2f07622f ("can: can327: CAN/ldisc driver for ELM327 based OBD-II adapters")
Signed-off-by: Ziyang Xuan <william.xuanziyang@huawei.com>
Link: https://lore.kernel.org/all/20221110061437.411525-1-william.xuanziyang@huawei.com
Reviewed-by: Max Staudt <max@enpas.org>
Cc: stable@vger.kernel.org
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/can/can327.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/can/can327.c b/drivers/net/can/can327.c
index 094197780776..ed3d0b8989a0 100644
--- a/drivers/net/can/can327.c
+++ b/drivers/net/can/can327.c
@@ -263,8 +263,10 @@ static void can327_feed_frame_to_netdev(struct can327 *elm, struct sk_buff *skb)
 {
 	lockdep_assert_held(&elm->lock);
 
-	if (!netif_running(elm->dev))
+	if (!netif_running(elm->dev)) {
+		kfree_skb(skb);
 		return;
+	}
 
 	/* Queue for NAPI pickup.
 	 * rx-offload will update stats and LEDs for us.
-- 
2.38.1



