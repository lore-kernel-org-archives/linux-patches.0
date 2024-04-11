Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83F0913B5B9;
	Thu, 11 Apr 2024 10:08:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712830087; cv=none; b=aryrsNkmvDFSvxMvTyB0RTFyocTLzpscu6+AnjyL0m5OE8oYqukz/NX7XvW6T0kzmZSHOGlpYEBjhILZkyAWvY3hIb2BhliKFHK2lMNTfG0RlNtMCm4oXaI62PTqDTqQG3H4RIFzR5qU1Wl1R/UztCxfWm57sBRo1c4PB+ooTh8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712830087; c=relaxed/simple;
	bh=d275yoIS5cNyQyj4X2Q4xKdNEmeh96bb/TQO8TTnrfA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jei+PpwiUSjFph/FHAwNm6+2kRDIa1/ejPMKa2SxXYRs5okF8nCz2XxdEPW+sLLOn5cAf63FkmUArt9veUJygtGQvhc4Bqzm/aGRIUTG4hlC7K01UM1cT2yFMZGONqyF/udKE/XkQM94TNL+5c/I/WDX7YkENgTSrqrul/FhQfk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WNajBqxC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WNajBqxC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01D9DC433F1;
	Thu, 11 Apr 2024 10:08:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712830087;
	bh=d275yoIS5cNyQyj4X2Q4xKdNEmeh96bb/TQO8TTnrfA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WNajBqxCx0LlGgqLA570do5ODedSaeOZ6dSj5W6R8Xq3SjW5WrY4/kudK3JFiCx6V
	 daWOwX1bFs/JUOLIXg0F+Ob5bi+uMCSqv2Uvb3UWTRYMBrLo0ElVTh2CFceY+blgEk
	 N24/0APNiUuefJECF8hp5PB8V/Tc/79ki3jR217E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 030/143] net: skbuff: add overflow debug check to pull/push helpers
Date: Thu, 11 Apr 2024 11:54:58 +0200
Message-ID: <20240411095421.819736748@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095420.903937140@linuxfoundation.org>
References: <20240411095420.903937140@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Westphal <fw@strlen.de>

[ Upstream commit 219eee9c0d16f1b754a8b85275854ab17df0850a ]

syzbot managed to trigger following splat:
BUG: KASAN: use-after-free in __skb_flow_dissect+0x4a3b/0x5e50
Read of size 1 at addr ffff888208a4000e by task a.out/2313
[..]
  __skb_flow_dissect+0x4a3b/0x5e50
  __skb_get_hash+0xb4/0x400
  ip_tunnel_xmit+0x77e/0x26f0
  ipip_tunnel_xmit+0x298/0x410
  ..

Analysis shows that the skb has a valid ->head, but bogus ->data
pointer.

skb->data gets its bogus value via the neigh layer, which does:

1556    __skb_pull(skb, skb_network_offset(skb));

... and the skb was already dodgy at this point:

skb_network_offset(skb) returns a negative value due to an
earlier overflow of skb->network_header (u16).  __skb_pull thus
"adjusts" skb->data by a huge offset, pointing outside skb->head
area.

Allow debug builds to splat when we try to pull/push more than
INT_MAX bytes.

After this, the syzkaller reproducer yields a more precise splat
before the flow dissector attempts to read off skb->data memory:

WARNING: CPU: 5 PID: 2313 at include/linux/skbuff.h:2653 neigh_connected_output+0x28e/0x400
  ip_finish_output2+0xb25/0xed0
  iptunnel_xmit+0x4ff/0x870
  ipgre_xmit+0x78e/0xbb0

Signed-off-by: Florian Westphal <fw@strlen.de>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://lore.kernel.org/r/20240216113700.23013-1-fw@strlen.de
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/skbuff.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 227f4514476b1..741115aeca2f1 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -2637,6 +2637,8 @@ static inline void skb_put_u8(struct sk_buff *skb, u8 val)
 void *skb_push(struct sk_buff *skb, unsigned int len);
 static inline void *__skb_push(struct sk_buff *skb, unsigned int len)
 {
+	DEBUG_NET_WARN_ON_ONCE(len > INT_MAX);
+
 	skb->data -= len;
 	skb->len  += len;
 	return skb->data;
@@ -2645,6 +2647,8 @@ static inline void *__skb_push(struct sk_buff *skb, unsigned int len)
 void *skb_pull(struct sk_buff *skb, unsigned int len);
 static inline void *__skb_pull(struct sk_buff *skb, unsigned int len)
 {
+	DEBUG_NET_WARN_ON_ONCE(len > INT_MAX);
+
 	skb->len -= len;
 	if (unlikely(skb->len < skb->data_len)) {
 #if defined(CONFIG_DEBUG_NET)
@@ -2669,6 +2673,8 @@ void *__pskb_pull_tail(struct sk_buff *skb, int delta);
 static inline enum skb_drop_reason
 pskb_may_pull_reason(struct sk_buff *skb, unsigned int len)
 {
+	DEBUG_NET_WARN_ON_ONCE(len > INT_MAX);
+
 	if (likely(len <= skb_headlen(skb)))
 		return SKB_NOT_DROPPED_YET;
 
-- 
2.43.0



