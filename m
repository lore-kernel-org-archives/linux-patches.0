Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35DAF4E0B83;
	Fri,  9 Oct 2026 14:52:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791557539; cv=none; b=KUXiA7eu5KgymNfUn6zZE3pudCBXHBei/rBwboxBNAJK81HywmKsMszwTL7FsHRIEnBJglU6tNcPZooGx1u/5ICxVVpS3/wUjZvqGGsu9ONQemYzFArklHS8Rlh7Yb286U8/I9Z4uP5yBZ6n5kg++IIdNbA1y47YN6m7GfV5Q90=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791557539; c=relaxed/simple;
	bh=bhY6PixQBI7UF2woXOL+7tpaCC4ZldWp/1YOV5fARuw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CVNTwa9+OK4QSATIFRoJM0Sq2eU9KiSKjY7PFN6H5FuT4dJXiWPSiV64exymwqGYWm0afhx4QxG9O3jVluKNaidMpuNOlHbkXOumwIDydonWTVLeEuZIkRNHjBZN3NsJZYqgl2t2FLizikdya48dA2u+hIPRM6dNPet7J/oj7g8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jQqGMA/n; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jQqGMA/n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85DDE1F000FF;
	Fri,  9 Oct 2026 14:52:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791557538;
	bh=LsrYepROfzAJ0O6XlnA8S/EzrtCAHyNYcEMCBQzJLgs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jQqGMA/nu2MkYkIbGoWqeit3Pc5WVJAZkPFsCQ3GTdOOkn/QGtVB5Lr7QAm2rXdGz
	 1WFznaKnuT6g7Nd5Pjtc35daSOyFAJX6XNtDZyX4FRERgWjLpyX3llPsDU9dsrT6Fz
	 7DT59891wxKfE2yarNlCrb1TaIt7gyTIIP60dFkk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 398/403] xen/netfront: drop RX packets with a short Ethernet header
Date: Fri,  9 Oct 2026 16:12:39 +0200
Message-ID: <20261009141001.667358831@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140952.119038291@linuxfoundation.org>
References: <20261009140952.119038291@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josef Bacik <josef@toxicpanda.com>

commit 089e58805c452e52179482b1025a8e309a57f801 upstream.

handle_incoming_queue() pulls pull_to bytes into the head before
calling eth_type_trans().  pull_to is the length of the first RX slot,
capped at RX_COPY_THRESHOLD, and that length comes from the backend.
Nothing checks it against ETH_HLEN.

If the first slot is shorter than ETH_HLEN and more slots follow, the
head ends up shorter than an Ethernet header while skb->len is longer,
and eth_type_trans() BUG()s in __skb_pull().  If the whole packet is
shorter than ETH_HLEN, eth_type_trans() reads the header past the end
of the data instead.

Pull at least ETH_HLEN, and drop the packet if that fails, which also
drops packets too short to hold an Ethernet header.  This also checks
the return value of the pull, which was ignored.

Fixes: 0d160211965b ("xen: add virtual network device driver")
Cc: stable@vger.kernel.org
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Link: https://patch.msgid.link/20261007-b4-xen-netfront-short-head-v1-1-12d7113a7e4e@toxicpanda.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/xen-netfront.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

--- a/drivers/net/xen-netfront.c
+++ b/drivers/net/xen-netfront.c
@@ -1234,8 +1234,16 @@ static int handle_incoming_queue(struct
 	while ((skb = __skb_dequeue(rxq)) != NULL) {
 		int pull_to = NETFRONT_SKB_CB(skb)->pull_to;
 
-		if (pull_to > skb_headlen(skb))
-			__pskb_pull_tail(skb, pull_to - skb_headlen(skb));
+		/* pull_to comes from the first slot's length, which the
+		 * backend controls.  Make sure the head holds at least an
+		 * Ethernet header for eth_type_trans().
+		 */
+		if (!pskb_may_pull(skb, max(pull_to, ETH_HLEN))) {
+			kfree_skb(skb);
+			packets_dropped++;
+			queue->info->netdev->stats.rx_errors++;
+			continue;
+		}
 
 		/* Ethernet work: Delayed to here as it peeks the header. */
 		skb->protocol = eth_type_trans(skb, queue->info->netdev);


