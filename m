Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12ACD46EF60;
	Tue, 21 Jul 2026 19:53:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784663601; cv=none; b=d3Csn4lPSuMshIwka3gCymbyCwOpVFF1qbYTzOnieMEPo3tEbkdglPYcrt/5ikFEViaUsEWSNTAeK1PnyRuIYckUhaY/evz8c2Jy+yh81lk/Z0uRAPIyw5NVHaVTGU8EZv1JGbNvNUdpGqGsQrYfueP1zh1gxe5sMjEmBM8fHfA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784663601; c=relaxed/simple;
	bh=5EphviklggIxwQ2wKfxilgX2Yz6p3ie1NnWNoLkRUxQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nPSE2gaCjOgHK97YcOR74xCFHlSzak1+A3Ky7KfFyIVHU50JeL8ACrcy6JiAmZ9NefToRcYtMTUGMcgv+prQsat1wdQMSJZ3OwnaoZoYz4OJqqD2gRE4LckjrJsBjdjwkFBmbCJbM52KyekNoAfsyq3TO5fs015UGB06rp6HEds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G9iq49hv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G9iq49hv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 733541F000E9;
	Tue, 21 Jul 2026 19:53:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784663600;
	bh=3cB3xNb+ComEoiubT2xiAWRE5OsykIE6D/ldIU3RTeo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=G9iq49hv8DxfL2lq0JYSESlTlLYbR215poLU95rLXqlOkMivi08a6upUL+I+/nWVj
	 3Pwy1kD16ft7eO/FunLcMg7N/sWtd8NFZY0/l/ReR1FuVAHl9944hT0BFgNa2UL+Jt
	 5oV0Kbm0Lqt/NIQCo1NKXKqNh4WH8fXIWix8a8+4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sven Eckelmann <sven@narfation.org>
Subject: [PATCH 6.12 0885/1276] batman-adv: bla: reacquire gw address after skb realloc
Date: Tue, 21 Jul 2026 17:22:08 +0200
Message-ID: <20260721152505.854275343@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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
@@ -1036,6 +1036,7 @@ int batadv_recv_unicast_packet(struct sk
 							  hdr_size);
 			batadv_orig_node_put(orig_node_gw);
 			if (is_gw) {
+				orig_addr_gw = eth_hdr(skb)->h_source;
 				batadv_dbg(BATADV_DBG_BLA, bat_priv,
 					   "%s(): Dropped unicast pkt received from another backbone gw %pM.\n",
 					   __func__, orig_addr_gw);


