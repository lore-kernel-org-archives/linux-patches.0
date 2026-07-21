Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF77E3AFAEC;
	Tue, 21 Jul 2026 20:52:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784667140; cv=none; b=UGuYs8rnp+0oEAhWEiHEbwjqgy/cE0R9y5/0d7hX4mwCmAPFtM2ZAVtbLlOzI5qPBw/SlGWN/FzzmU6Keb+gwzVe8eZeNXOG25x7nZ+moNzL32RqvQxJ/8t+rlOyEtTvklsd49QK843QaxVAOhIFV8/yW5iCDwcoi4pwq2UJW/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784667140; c=relaxed/simple;
	bh=HLJzfEi9AN5RK8fQJIQ14qat1d6a39HXhMHnUZM/9nw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KxzBNDVIgUp/RTv5TDLaAF6GlLHPyhFJ0NIFcBMNYPoEIBb+aOs6DLJxUBsnDvo0WOFzCiI6OeiLRA5SUujJrE+1URit1i85sI2dAby34qpAbFZfxIH57T/8ctixRyaZi3M9cD0R+lStH64ntNA62ASRNApCGkGKl9CfiqBA7I4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gFTpY2iP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gFTpY2iP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 610E41F00A3A;
	Tue, 21 Jul 2026 20:52:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784667138;
	bh=gP7n+I7I71u++w8KRPJfxq061KhKJKr1zxD4y+zxPiQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gFTpY2iP+80NwWOIt7O4Tm4FOTTgeOQOUkcN8ON64qqg2c5tCtmeLvOs+7zJWPdJ+
	 8/nY72WV2WCwRoseV7B8bJWmGFRKVvXrInc7oNB9g3AJRSYPQuPGD7rcSHXaAyMAj9
	 QuaOsFHRQoM4EC5IEp8smHZ0npwnXuv4w5r5GcEs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sven Eckelmann <sven@narfation.org>
Subject: [PATCH 6.6 0948/1266] batman-adv: bla: reacquire gw address after skb realloc
Date: Tue, 21 Jul 2026 17:23:05 +0200
Message-ID: <20260721152503.042205290@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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
@@ -1035,6 +1035,7 @@ int batadv_recv_unicast_packet(struct sk
 							  hdr_size);
 			batadv_orig_node_put(orig_node_gw);
 			if (is_gw) {
+				orig_addr_gw = eth_hdr(skb)->h_source;
 				batadv_dbg(BATADV_DBG_BLA, bat_priv,
 					   "%s(): Dropped unicast pkt received from another backbone gw %pM.\n",
 					   __func__, orig_addr_gw);


