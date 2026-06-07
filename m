Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B449309DAF;
	Sun,  7 Jun 2026 10:11:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780827070; cv=none; b=h7mTIFLPn6sDgMzYlx7u3kqME0HblOVc+bsheFngOg4qMG3brJ3gcWW2Xx+8XKDHux3BSX4xnrfghiHOsxb9mm6Wz0iNmNga05G2oV7u015qlA8V/O9G2F+wFY3mFA/TFUzEpsyOHkSHPENVIirILJH8y4+qKGmxvtnKRv2jqeY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780827070; c=relaxed/simple;
	bh=0fH2SXwGv+8tKhFlMrsRog+JyXYWKDN2XAhCieazW/o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=maqhk+filiRCtSDUy/rTAlD4TzqWrwHk8E10gK5Wd2rfRsj8F6T2JN2mpDeg6ZdSu0nUcZwGT7K1MpLNVaB6O96UzvhE/03aa1ia0CbFvD+B8hHtLc/ctgJXd+H2oY+ntrHj7YYQ42DGE90ZEo01JvEX8r7CssqYKLznPDMFwtw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sJZZvP51; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sJZZvP51"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 737B41F00898;
	Sun,  7 Jun 2026 10:11:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780827069;
	bh=/uD2iRGGO8kF9zK3D+yLkW91DMGO2VT+RznF37Hgqpw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sJZZvP51iWL8+FV77cZOUjIQX6XJIiLS7SaVIxKWSrYzLHkTDXGzzWaWBEMVcWyfN
	 9fBIV5ohMEzle50sFcOJ/QNywnueaH7HguRNJK3J8iih8Yq3BdoNOsnWSaqnrNIYSJ
	 9wLSVcufhZJhd1xkUBSD1d2Brf6wsvjQFixRoW7M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>,
	Breno Leitao <leitao@debian.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 037/315] net: Avoid checksumming unreadable skb tail on trim
Date: Sun,  7 Jun 2026 11:57:04 +0200
Message-ID: <20260607095728.903365760@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.528828913@linuxfoundation.org>
References: <20260607095727.528828913@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Björn Töpel <bjorn@kernel.org>

[ Upstream commit 2e357f002c61fd76fd8f12468744a06a5ec48eaa ]

pskb_trim_rcsum_slow() keeps CHECKSUM_COMPLETE valid by subtracting
the checksum of the bytes removed from the skb tail. That assumes the
removed bytes can be read.

io_uring zcrx skbs may contain unreadable net_iov frags. With fbnic
header/data split, small TCP/IPv4 packets can carry Ethernet padding
in such a frag. ip_rcv_core() trims the skb to iph->tot_len before TCP
sees it, and the CHECKSUM_COMPLETE adjustment then calls
skb_checksum() on the padding.

This is exposed by IPv4 because small TCP/IPv4 frames can be shorter
than the Ethernet minimum payload. TCP/IPv6 frames are large enough in
the normal zcrx path, so they do not hit the same padding trim.

Keep the existing checksum adjustment for readable skbs. If the
remaining packet is fully linear, drop CHECKSUM_COMPLETE and let the
stack validate the packet after trimming. If unreadable payload would
remain, fail the trim; the checksum cannot be adjusted without reading
the trimmed tail.

Also clear skb->unreadable when trimming removes all frags.

Fixes: 65249feb6b3d ("net: add support for skbs with unreadable frags")
Signed-off-by: Björn Töpel <bjorn@kernel.org>
Reviewed-by: Breno Leitao <leitao@debian.org>
Link: https://patch.msgid.link/20260522120643.242974-1-bjorn@kernel.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/skbuff.c | 31 +++++++++++++++++++++++++++----
 1 file changed, 27 insertions(+), 4 deletions(-)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index a8911f1b90c15d..6618bfa70ca444 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -2739,6 +2739,8 @@ int ___pskb_trim(struct sk_buff *skb, unsigned int len)
 		skb->data_len  = 0;
 		skb_set_tail_pointer(skb, len);
 	}
+	if (!skb_shinfo(skb)->nr_frags && !skb_has_frag_list(skb))
+		skb->unreadable = 0;
 
 	if (!skb->sk || skb->destructor == sock_edemux)
 		skb_condense(skb);
@@ -2746,16 +2748,37 @@ int ___pskb_trim(struct sk_buff *skb, unsigned int len)
 }
 EXPORT_SYMBOL(___pskb_trim);
 
+static int pskb_trim_rcsum_complete(struct sk_buff *skb, unsigned int len)
+{
+	int delta = skb->len - len;
+
+	if (skb_frags_readable(skb)) {
+		skb->csum = csum_block_sub(skb->csum,
+					   skb_checksum(skb, len, delta, 0),
+					   len);
+		return 0;
+	}
+
+	if (len > skb_headlen(skb))
+		return -EFAULT;
+
+	/* The trimmed bytes are unreadable, but the remaining packet can be
+	 * checksummed by software after trimming.
+	 */
+	skb->ip_summed = CHECKSUM_NONE;
+	return 0;
+}
+
 /* Note : use pskb_trim_rcsum() instead of calling this directly
  */
 int pskb_trim_rcsum_slow(struct sk_buff *skb, unsigned int len)
 {
 	if (skb->ip_summed == CHECKSUM_COMPLETE) {
-		int delta = skb->len - len;
+		int err;
 
-		skb->csum = csum_block_sub(skb->csum,
-					   skb_checksum(skb, len, delta, 0),
-					   len);
+		err = pskb_trim_rcsum_complete(skb, len);
+		if (err)
+			return err;
 	} else if (skb->ip_summed == CHECKSUM_PARTIAL) {
 		int hdlen = (len > skb_headlen(skb)) ? skb_headlen(skb) : len;
 		int offset = skb_checksum_start_offset(skb) + skb->csum_offset;
-- 
2.53.0



