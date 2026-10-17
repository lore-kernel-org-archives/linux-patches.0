Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4581B3AA4E8;
	Sat, 17 Oct 2026 17:07:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792256861; cv=none; b=JD+3GrAgiRvvZF671lmI1JQn0klQFckeVzLwzzPGlWBfWXnacoVmOaenJ66MMHrWXx8AfY1ZyVcvsNlsCDb+oWxzNKlyPOTeULBWy4yjhrBGEIHoGng9U3QdcqpxsIL8ivmurKNNacOaTHeRwh7R1FBPJe+AYZ2YaC1B+zM0xdc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792256861; c=relaxed/simple;
	bh=/4ZGNBMPuF8qE7bdKLI4end1Noef70WgeACw2prBu2s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pKRmjQwr38vZcscLNIWa34Kfo0uJGwOPpIu6hpp3VIWXtTgEh2fTx6CaXIlFMcDgaQ79CPdCc3Q+F+oZrPT9CvpVLvQ3DidnzNfdCO+EGE2+a18I+a16Jn89CGmW6kjIYe2PGE+ztheRYbS88f2gwOiKCkvksdxG84W7VEzC8sM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ahc+w2Fn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ahc+w2Fn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93F821F000C4;
	Sat, 17 Oct 2026 17:07:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792256860;
	bh=38oyOMgLbmVOkQc0tT7zeytQwnzMLZzaFrCy5QYi47Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ahc+w2Fn7Hm14nsHUdIaKQtApfkXQdLzXnSmy9EOrB2nUoGh7W7uw7VS0Jg3aFtEb
	 umcB9CQ/n5UR+0f7dZkcVH8ekQownJlYeHSf1bNe0iyKSDj2oqulxdQR5VwYzYZOZ+
	 ehPiWmthGMxGuDXjN9MsWrBwIXbyxrUGq5UOWYyI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 0374/1674] xen/netfront: drop RX packets with a short Ethernet header
Date: Sat, 17 Oct 2026 17:44:06 +0200
Message-ID: <20261017160440.716280124@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1233,8 +1233,16 @@ static int handle_incoming_queue(struct
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


