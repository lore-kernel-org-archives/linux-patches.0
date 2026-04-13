Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AABFF223DCE;
	Mon, 13 Apr 2026 16:47:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776098866; cv=none; b=ZvS/MyUwnkN8Fs6XMZILMjbFIXRrnW73odoHtugbbiuy4Qtr87ieVMlphkN4YIFow2KHhRJchKDPWZfzPQcWsO78nOSnTgyEUiqrCo89Zu6dDuVg/1zwOt0hS1VVfBOSx6VZe6a2BoXYxcOcm4PpXzc1qtZV6CDrpDiUZRZDhQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776098866; c=relaxed/simple;
	bh=ZzLWsPI95kF4W+hgneDvSUZxIZo2WpSc3O4mSn8YRj4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G4l9K0dwBdGoWMMPug4k3d46LYN7lKDcvFi7Wt/2s1OZFtvDM0pZV2TOf0OkyP9o0qLKsxRD4Qkc4xYuAEj3SdRP+QM0nA2NtNazNabegqun6cagVAvHU+qlusxgr8vCNF5SSgmIkPEsOCTtBENfSOk1+E99+IzSjO1fl8vWPWs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UiH+Vx4z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UiH+Vx4z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 411A9C2BCAF;
	Mon, 13 Apr 2026 16:47:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776098866;
	bh=ZzLWsPI95kF4W+hgneDvSUZxIZo2WpSc3O4mSn8YRj4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UiH+Vx4zBCv0NBhWg1lPP8D6EYjwBiCeZWPHQ+rFXoBSracVoR5JocGh8nSYVS7Uz
	 VryNWzW6uDO0NuHtdyYdfgS2WracwNR7d0oW+RMWCc8qYNKeb+QOsulGAU+SLnvjlS
	 ykqmVk1LxtVY0aKTQTHySrJa8GEFakjL8VzUcDhs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jian Zhang <zhangjian.3032@bytedance.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 120/491] net: ncsi: fix skb leak in error paths
Date: Mon, 13 Apr 2026 17:56:05 +0200
Message-ID: <20260413155823.534787336@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155819.042779211@linuxfoundation.org>
References: <20260413155819.042779211@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1146,8 +1146,10 @@ int ncsi_rcv_rsp(struct sk_buff *skb, st
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
@@ -1169,7 +1171,8 @@ int ncsi_rcv_rsp(struct sk_buff *skb, st
 	if (!nrh) {
 		netdev_err(nd->dev, "Received unrecognized packet (0x%x)\n",
 			   hdr->type);
-		return -ENOENT;
+		ret = -ENOENT;
+		goto err_free_skb;
 	}
 
 	/* Associate with the request */
@@ -1177,7 +1180,8 @@ int ncsi_rcv_rsp(struct sk_buff *skb, st
 	nr = &ndp->requests[hdr->id];
 	if (!nr->used) {
 		spin_unlock_irqrestore(&ndp->lock, flags);
-		return -ENODEV;
+		ret = -ENODEV;
+		goto err_free_skb;
 	}
 
 	nr->rsp = skb;
@@ -1231,4 +1235,8 @@ out_netlink:
 out:
 	ncsi_free_request(nr);
 	return ret;
+
+err_free_skb:
+	kfree_skb(skb);
+	return ret;
 }


