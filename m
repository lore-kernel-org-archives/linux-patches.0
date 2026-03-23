Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 133EE3B4EB5;
	Mon, 23 Mar 2026 15:10:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774278647; cv=none; b=VLK+cA3FJLwBB3EKf54dwn1dzU4dhDsrQ8N5zzIwq8knUOP9qkkUu+UJfKjw1W7NjU/7vZenVKAWmjzYRBc+NRwW+bwNNCYp18Na7AS4qAKxzhJ4iglcq5jPds6nix1zc2hwJ0yglOUW9DcNcfNVQT7nyYZR99NHAdS/a7fsckA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774278647; c=relaxed/simple;
	bh=BiJf0McfEDXbyanES6l6PY2qzxudNHKoOUZgqlVhiDs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LBg484p190kQq5jaIMQYobBqSng300R9X5bU6OCydjexz/p9H2idrEDlGbam1fXJdHMZtcGL3yDL59xE/FczUnVqM2xSX+zZzZ0FUvi+5p6ZL3LogxKk0HINuwn0JnhM6foefsEb/IwLYW2gw+53SOnuZbMKr5LUQHgfqwPt/C4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PXj7CUn0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PXj7CUn0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BB75C4CEF7;
	Mon, 23 Mar 2026 15:10:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774278647;
	bh=BiJf0McfEDXbyanES6l6PY2qzxudNHKoOUZgqlVhiDs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PXj7CUn0G54eKJz27MtokbeoLwz4aHGZXltWIJYb6eMOhGF+jYooOgaQuvZNi1wsP
	 kVvtsoE5e8ompGfx+nAIHB/9kxNpt0lVe92E3WfAM775133EAlFYxBmjttphTBpT5I
	 Iuy5Fb5BsDLtV3QTOdLbk47bOts45nEn7HzsgckQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jian Zhang <zhangjian.3032@bytedance.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 331/567] net: ncsi: fix skb leak in error paths
Date: Mon, 23 Mar 2026 14:44:11 +0100
Message-ID: <20260323134542.023524390@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134533.749096647@linuxfoundation.org>
References: <20260323134533.749096647@linuxfoundation.org>
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

From: Jian Zhang <zhangjian.3032@bytedance.com>

commit 5c3398a54266541610c8d0a7082e654e9ff3e259 upstream.

Early return paths in NCSI RX and AEN handlers fail to release
the received skb, resulting in a memory leak.

Specifically, ncsi_aen_handler() returns on invalid AEN packets
without consuming the skb. Similarly, ncsi_rcv_rsp() exits early
when failing to resolve the NCSI device, response handler, or
request, leaving the skb unfreed.

CC: stable@vger.kernel.org
Fixes: 7a82ecf4cfb8 ("net/ncsi: NCSI AEN packet handler")
Fixes: 138635cc27c9 ("net/ncsi: NCSI response packet handler")
Signed-off-by: Jian Zhang <zhangjian.3032@bytedance.com>
Link: https://patch.msgid.link/20260305060656.3357250-1-zhangjian.3032@bytedance.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ncsi/ncsi-aen.c |    3 ++-
 net/ncsi/ncsi-rsp.c |   16 ++++++++++++----
 2 files changed, 14 insertions(+), 5 deletions(-)

--- a/net/ncsi/ncsi-aen.c
+++ b/net/ncsi/ncsi-aen.c
@@ -224,7 +224,8 @@ int ncsi_aen_handler(struct ncsi_dev_pri
 	if (!nah) {
 		netdev_warn(ndp->ndev.dev, "Invalid AEN (0x%x) received\n",
 			    h->type);
-		return -ENOENT;
+		ret = -ENOENT;
+		goto out;
 	}
 
 	ret = ncsi_validate_aen_pkt(h, nah->payload);
--- a/net/ncsi/ncsi-rsp.c
+++ b/net/ncsi/ncsi-rsp.c
@@ -1176,8 +1176,10 @@ int ncsi_rcv_rsp(struct sk_buff *skb, st
 	/* Find the NCSI device */
 	nd = ncsi_find_dev(orig_dev);
 	ndp = nd ? TO_NCSI_DEV_PRIV(nd) : NULL;
-	if (!ndp)
-		return -ENODEV;
+	if (!ndp) {
+		ret = -ENODEV;
+		goto err_free_skb;
+	}
 
 	/* Check if it is AEN packet */
 	hdr = (struct ncsi_pkt_hdr *)skb_network_header(skb);
@@ -1199,7 +1201,8 @@ int ncsi_rcv_rsp(struct sk_buff *skb, st
 	if (!nrh) {
 		netdev_err(nd->dev, "Received unrecognized packet (0x%x)\n",
 			   hdr->type);
-		return -ENOENT;
+		ret = -ENOENT;
+		goto err_free_skb;
 	}
 
 	/* Associate with the request */
@@ -1207,7 +1210,8 @@ int ncsi_rcv_rsp(struct sk_buff *skb, st
 	nr = &ndp->requests[hdr->id];
 	if (!nr->used) {
 		spin_unlock_irqrestore(&ndp->lock, flags);
-		return -ENODEV;
+		ret = -ENODEV;
+		goto err_free_skb;
 	}
 
 	nr->rsp = skb;
@@ -1261,4 +1265,8 @@ out_netlink:
 out:
 	ncsi_free_request(nr);
 	return ret;
+
+err_free_skb:
+	kfree_skb(skb);
+	return ret;
 }


