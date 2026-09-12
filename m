Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A339435C6AA;
	Sat, 12 Sep 2026 11:58:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789214334; cv=none; b=uKq1En5m8tONgTFf/+WrAAhiQ9/6F6o96h5v2wiey3XJhGedahW5fnmrT7liwQ2gDgzXiPGybEUie2DVzQ0pPPLKpGoEk3CLTB7TGRhWXvi2tAlFzI/bi1Jqb1WyzPrC0U6WD6zpWV4TWscdhpkZ8cChcpJBYRdaprUdJ95l6F0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789214334; c=relaxed/simple;
	bh=6iIE9Y1oW8QKG/uEIUg9gTU2U4GiDbRam8gdT5wfUHs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KGcfEuSYE6aq2KWYfcgTPFpP3eqlC3TzmDCKVmZIscTdGkUl5jMN/XM+EYdrDgDXiakkxKM0FPWm41QP5XWX/ldExHRk/gbkVeU8ZVIt3Yn40sVgT6sLXK5FqxANj2chFQYcGz+Ghd00f64g8GCxJmm5NM5XlI95naz/zV6mt6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r7Tnd9RU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r7Tnd9RU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A79B21F000FF;
	Sat, 12 Sep 2026 11:58:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789214333;
	bh=mUW3ygFuL7ihSQiE/43DmSvts7ZN/4KV+mPTNsgAmjA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=r7Tnd9RU1n8U9xeJ01fw577H2Ng2idHuQ5ta2PHlJNpVPJ6ZJUdXICkQ4RCLyOi27
	 J6xLeU6POyQRQ/sQSPs5FRNyeY/pDqRhgmtAtu2JkzgTJtVp8O/c5Dtneb4UUKhtAc
	 LbyPA3jsaY6faJc1JTVGu4OhxRDdfqpObwfKYHj4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sven Eckelmann <sven@narfation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0305/1376] batman-adv: fix TX priority extraction for BATADV_FORW_MCAST
Date: Sat, 12 Sep 2026 08:45:31 +0200
Message-ID: <20260912065614.347483332@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sven Eckelmann <sven@narfation.org>

commit 7aedb59b80993c912ab45ce24386a2775150962b upstream.

batadv_mcast_forw_mode_by_count() pushs the skb->data for BATADV_FORW_MCAST
forwarding via batadv_mcast_forw_mcsend(). But the
batadv_skb_set_priority() expects the ethernet header directly before
(skb->data + offset). With the moved skb->data, just some random data would
be accessed to get the priority data.

Move the batadv_skb_set_priority() before the decision about the handling
multicast packets and potential header modifications.

Cc: stable@vger.kernel.org
Fixes: 90039133221e ("batman-adv: mcast: implement multicast packet generation")
[ Context ]
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/batman-adv/soft-interface.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/net/batman-adv/soft-interface.c b/net/batman-adv/soft-interface.c
index aaebe74c1bc0a..47715a612320a 100644
--- a/net/batman-adv/soft-interface.c
+++ b/net/batman-adv/soft-interface.c
@@ -271,6 +271,8 @@ static netdev_tx_t batadv_interface_tx(struct sk_buff *skb,
 	if (batadv_compare_eth(ethhdr->h_dest, ectp_addr))
 		goto dropped;
 
+	batadv_skb_set_priority(skb, 0);
+
 	gw_mode = atomic_read(&bat_priv->gw.mode);
 	if (is_multicast_ether_addr(ethhdr->h_dest)) {
 		/* if gw mode is off, broadcast every packet */
@@ -304,6 +306,9 @@ static netdev_tx_t batadv_interface_tx(struct sk_buff *skb,
 
 send:
 		if (do_bcast && !is_broadcast_ether_addr(ethhdr->h_dest)) {
+			/* WARNING batadv_mcast_forw_mode might add more headers
+			 * in front of the skb. and might even reallocate the skb
+			 */
 			forw_mode = batadv_mcast_forw_mode(bat_priv, skb, vid,
 							   &mcast_is_routable);
 			switch (forw_mode) {
@@ -321,8 +326,6 @@ static netdev_tx_t batadv_interface_tx(struct sk_buff *skb,
 		}
 	}
 
-	batadv_skb_set_priority(skb, 0);
-
 	/* ethernet packet should be broadcasted */
 	if (do_bcast) {
 		primary_if = batadv_primary_if_get_selected(bat_priv);
-- 
2.53.0



