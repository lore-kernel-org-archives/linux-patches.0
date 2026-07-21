Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84A9344AB8E;
	Tue, 21 Jul 2026 22:50:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784674227; cv=none; b=iQO/I7TSyfLc1aOnuzzjYXFl3dGLXywMFmnUob6p/enCQoMP7kK/gLg67cZHaFARdNGqheWr0aif+BjQWdR4Bz9CUkyaX47m7vBl6JRWp68YGNpI/vcNgCo0saDLVGSv679R5P6XKrfpIZGz5Q0eK0x39mECOpR1XGEb1DPM07c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784674227; c=relaxed/simple;
	bh=8hqCBZ34+0CJ7X2IN24giG+gSanYnSiwPB7XQB08bRw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LM0ReDKWS4gnlU/c36nIj8yzOuG1eAO+P8xVQmevlOBMbjWMGnZykB0lzxQI1QX5jKUD2ff+7ZSYcL8MpAuS7aJNtV/jOjIiNy0dugb3qmd2Rz6p6loieaJJGha+iS9CSQP7B7By+bvN6nI1514rmP8ImsNB83OU63vICP1JFX8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q9H82nvA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q9H82nvA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB4BF1F000E9;
	Tue, 21 Jul 2026 22:50:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784674226;
	bh=ZMjvrwWAeV3fmSIeM2Ae9HYwvEs87kFI8mr38hPRyME=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Q9H82nvAXrGtcCMuiPOn8Ux3OW+S6TCIahQGt+qonyNLt1nQ0rdtIcmz7xoPGuJtc
	 zA2HAJgXrqbJ2L0crIwzHOkL9JJAsiZGwI6furxhoD+/309xBsBx1jmPbQpXfsvSpv
	 0Hkxj935P2BWjkN3m+9GU2lVrMaTx0sVjZUFyO94=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sven Eckelmann <sven@narfation.org>
Subject: [PATCH 5.10 462/699] batman-adv: bla: reacquire gw address after skb realloc
Date: Tue, 21 Jul 2026 17:23:41 +0200
Message-ID: <20260721152406.119165633@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

From: Sven Eckelmann <sven@narfation.org>

commit cdf3b5af2bc4431e58629e8ad2086b1e9185c761 upstream.

The pskb_may_pull() called by batadv_bla_is_backbone_gw() could reallocate
the buffer behind the skb. Variables which were pointing to the old buffer
need to be reassigned to avoid an use-after-free.

Cc: stable@vger.kernel.org
Fixes: 9e794b6bf4a2 ("batman-adv: drop unicast packets from other backbone gw")
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/batman-adv/routing.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/batman-adv/routing.c
+++ b/net/batman-adv/routing.c
@@ -1002,6 +1002,7 @@ int batadv_recv_unicast_packet(struct sk
 							  hdr_size);
 			batadv_orig_node_put(orig_node_gw);
 			if (is_gw) {
+				orig_addr_gw = eth_hdr(skb)->h_source;
 				batadv_dbg(BATADV_DBG_BLA, bat_priv,
 					   "%s(): Dropped unicast pkt received from another backbone gw %pM.\n",
 					   __func__, orig_addr_gw);


