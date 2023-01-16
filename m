Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0BD246B5
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 16:25:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 670C1C433D2;
	Mon, 16 Jan 2023 16:25:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673886324;
	bh=6fMeqsBhQlnwJlmrq9V19v3RSk4PDUSbLuh83ZtKhC4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wqCHaPUkub8V/zUQ45WVONtzUlIDV/Kx63o5pFmxjsdUbo6BK3Iko5Ze2H58EbiRo
	 J3jur4kUm+bE8SbSXEfT5qbxQHTMkPZ7WznZr9J6ocU+/XvMmPA/qEWyvOIfakvhra
	 GUE3/uSQ+wvGkjcrtweaEfY7erSj0KEt/tWlKqx8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Tranchetti <quic_stranche@quicinc.com>,
	Subash Abhinov Kasiviswanathan <quic_subashab@quicinc.com>,
	Alexander Duyck <alexanderduyck@fb.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 380/658] skbuff: Account for tail adjustment during pull operations
Date: Mon, 16 Jan 2023 16:47:48 +0100
Message-Id: <20230116154926.926608012@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154909.645460653@linuxfoundation.org>
References: <20230116154909.645460653@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Subash Abhinov Kasiviswanathan <quic_subashab@quicinc.com>

[ Upstream commit 2d7afdcbc9d32423f177ee12b7c93783aea338fb ]

Extending the tail can have some unexpected side effects if a program uses
a helper like BPF_FUNC_skb_pull_data to read partial content beyond the
head skb headlen when all the skbs in the gso frag_list are linear with no
head_frag -

  kernel BUG at net/core/skbuff.c:4219!
  pc : skb_segment+0xcf4/0xd2c
  lr : skb_segment+0x63c/0xd2c
  Call trace:
   skb_segment+0xcf4/0xd2c
   __udp_gso_segment+0xa4/0x544
   udp4_ufo_fragment+0x184/0x1c0
   inet_gso_segment+0x16c/0x3a4
   skb_mac_gso_segment+0xd4/0x1b0
   __skb_gso_segment+0xcc/0x12c
   udp_rcv_segment+0x54/0x16c
   udp_queue_rcv_skb+0x78/0x144
   udp_unicast_rcv_skb+0x8c/0xa4
   __udp4_lib_rcv+0x490/0x68c
   udp_rcv+0x20/0x30
   ip_protocol_deliver_rcu+0x1b0/0x33c
   ip_local_deliver+0xd8/0x1f0
   ip_rcv+0x98/0x1a4
   deliver_ptype_list_skb+0x98/0x1ec
   __netif_receive_skb_core+0x978/0xc60

Fix this by marking these skbs as GSO_DODGY so segmentation can handle
the tail updates accordingly.

Fixes: 3dcbdb134f32 ("net: gso: Fix skb_segment splat when splitting gso_size mangled skb having linear-headed frag_list")
Signed-off-by: Sean Tranchetti <quic_stranche@quicinc.com>
Signed-off-by: Subash Abhinov Kasiviswanathan <quic_subashab@quicinc.com>
Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>
Link: https://lore.kernel.org/r/1671084718-24796-1-git-send-email-quic_subashab@quicinc.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/skbuff.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index e9c796e2944e..0547aa2c8b13 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -2115,6 +2115,9 @@ void *__pskb_pull_tail(struct sk_buff *skb, int delta)
 				insp = list;
 			} else {
 				/* Eaten partially. */
+				if (skb_is_gso(skb) && !list->head_frag &&
+				    skb_headlen(list))
+					skb_shinfo(skb)->gso_type |= SKB_GSO_DODGY;
 
 				if (skb_shared(list)) {
 					/* Sucks! We need to fork list. :-( */
-- 
2.35.1



