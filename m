Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CA6B3F87FC;
	Tue, 17 Mar 2026 16:57:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773766669; cv=none; b=eZOtjmUNHmi+oWNSNi5hlc6xG8tiRvkEVRgZI0vhDwh9COh4IT5VZHsQkFj91YaiAdXv2fkzPAn3vUH7R+wsr5aPxwp7UV7jfN5AUOT9bCbeSSiKtsPOoVzpWdLHSmIweUwPMzB9eiokl/pu85N7Kc9z3ohApNnM4BE6Uo7Hzlk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773766669; c=relaxed/simple;
	bh=tjX09OsZktgOaEkqs5GHB20L1a9oLSWV1knlUEUlpwU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MmVgOh1Z2xWo1xDLKY3hlZZJ0knD1DVjDF2tE7u2NiGpAAFZvisCSRbJaeTRPlOI0LBBLpZIv5gkSBPt45Dnq6/x/caIpVNOJne6q6/MCW6a1k1cz6MOhaplmKuhArv8pUfZVWTXoOEDhmxcy/f7cTtH6wc5YIOcmZHT7l3B5bM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n8+w15Ri; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n8+w15Ri"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB70AC2BC86;
	Tue, 17 Mar 2026 16:57:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773766669;
	bh=tjX09OsZktgOaEkqs5GHB20L1a9oLSWV1knlUEUlpwU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n8+w15Ri+NoVCEfMAeXoQE5bXk5ae39r71On36bFPVZZoNb1luoyEcmbsdqfS8DX5
	 5ymRSTTARwFPY3wUYbvGvm0BvvWSOHdtiOklzRIHnLXMfUUqYy+I30IuxJ9AgADOkC
	 pL/Mm4Fq6pNK5Ed8NSieCYvstwwN7qwW0vhT8vFg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jian Zhang <zhangjian.3032@bytedance.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.19 296/378] net: ncsi: fix skb leak in error paths
Date: Tue, 17 Mar 2026 17:34:13 +0100
Message-ID: <20260317163017.899010809@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317163006.959177102@linuxfoundation.org>
References: <20260317163006.959177102@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

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


