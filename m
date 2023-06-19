Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95F785381
	for <patches@lists.linux.dev>; Mon, 19 Jun 2023 10:36:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E6ACC433C8;
	Mon, 19 Jun 2023 10:36:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687170994;
	bh=pmtQrbVyB05o64OBL7vI/Ud+pST33O4d4MPVlPrvjEw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZrZwXAVks8SP8atwSTfvvw3bAbGZY07TFYDOdBgwj8kYdEKLEkGwv/G8Hh798sEal
	 a4SRdwf8PmVX/0utYhSbWznkJokdzJ/4ndY1czMZHsiAMm5htovsbfP43zfetJ5WIt
	 Z+NiIEN74VeMRWB2zAe4XlmbQIke+E1L/c8/QleU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bob Pearson <rpearsonhpe@gmail.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 110/187] RDMA/rxe: Fix packet length checks
Date: Mon, 19 Jun 2023 12:28:48 +0200
Message-ID: <20230619102202.906313889@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230619102157.579823843@linuxfoundation.org>
References: <20230619102157.579823843@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Bob Pearson <rpearsonhpe@gmail.com>

[ Upstream commit 9a3763e87379c97a78b7c6c6f40720b1e877174f ]

In rxe_net.c a received packet, from udp or loopback, is passed to
rxe_rcv() in rxe_recv.c as a udp packet. I.e. skb->data is pointing at the
udp header. But rxe_rcv() makes length checks to verify the packet is long
enough to hold the roce headers as if it were a roce
packet. I.e. skb->data pointing at the bth header. A runt packet would
appear to have 8 more bytes than it actually does which may lead to
incorrect behavior.

This patch calls skb_pull() to adjust the skb to point at the bth header
before calling rxe_rcv() which fixes this error.

Fixes: 8700e3e7c485 ("Soft RoCE driver")
Link: https://lore.kernel.org/r/20230517172242.1806340-1-rpearsonhpe@gmail.com
Signed-off-by: Bob Pearson <rpearsonhpe@gmail.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/sw/rxe/rxe_net.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/infiniband/sw/rxe/rxe_net.c b/drivers/infiniband/sw/rxe/rxe_net.c
index a2ace42e95366..e8403a70c6b74 100644
--- a/drivers/infiniband/sw/rxe/rxe_net.c
+++ b/drivers/infiniband/sw/rxe/rxe_net.c
@@ -159,6 +159,9 @@ static int rxe_udp_encap_recv(struct sock *sk, struct sk_buff *skb)
 	pkt->mask = RXE_GRH_MASK;
 	pkt->paylen = be16_to_cpu(udph->len) - sizeof(*udph);
 
+	/* remove udp header */
+	skb_pull(skb, sizeof(struct udphdr));
+
 	rxe_rcv(skb);
 
 	return 0;
@@ -401,6 +404,9 @@ static int rxe_loopback(struct sk_buff *skb, struct rxe_pkt_info *pkt)
 		return -EIO;
 	}
 
+	/* remove udp header */
+	skb_pull(skb, sizeof(struct udphdr));
+
 	rxe_rcv(skb);
 
 	return 0;
-- 
2.39.2



