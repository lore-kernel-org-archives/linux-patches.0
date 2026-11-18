Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027733;
	b=0VQrK330XQrdS7o6IyvE2q+V/XQ3d5fRnAINIKQhM4LTtaOmbCNURBk0GWExnOZurbOx
	 ZpBhKGsqNXpIlksE5OQtsK9pZR7nmJQqw4c3Klaz5mFWRvq7BugkRbVvGu0twOgnAdUxb
	 FWB/c61mlCMUvb2X4NpKRJtVqHyYGz16tiPNrTAGeQFudC8fDTnc1SLEbYVa5klsxWF9U
	 jcCvHaCf9D5pggBaVUQz6XTaWXDSnf7lpzjXx7wRSeHO1tC3zmbS7MPJSFFpdWOmGh3Zl
	 ZtpruLlSQKV6Jg7+PUsjuMOrJ1YUvwrWJUTvHc9mhc4MQk897QK3zA5TFwdPcsecljw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027733;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8P9syeyucnU9uaNkPr0qNK3PXmZR00OwP4W3BXhjiRQ=;
	b=UrGMe52MAPs4kxSVWLZv1TW/1Q/sp8fpQaErR/nk1yT+Q7mMN/2gMGcNCiF0SjMxewP9
	 lkQp73TXIRf81u+6EcBvqRjRLl0gUyKGRLyRAVJqiikV1Wx7RaXijZiWHtDVyalyzHxJ4
	 76EafWQRxz1Hy3KrU/mqNquvxWso47ZEYM4R/g318IWJY4hTMoQqCjBOPhq8jBuZYW1lJ
	 H7tIgr2ou+OKspl5J1OmqCS/ZGRz1VVMV2Nj8jPsf+ezT928dBWELbdkK5Su/k/NIQ2zY
	 YmQR0skACJsayIMjsoUgIlu2qvzURLudTq4eQDP9s5wm4xleTDdLOLB7Sm0s38ZRmmA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="PjLvc/ZK";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC1A6606A330;
	Wed, 18 Nov 2026 18:48:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PjLvc/ZK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D69E71F000C5;
	Wed, 18 Nov 2026 18:48:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027733;
	bh=8P9syeyucnU9uaNkPr0qNK3PXmZR00OwP4W3BXhjiRQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PjLvc/ZKDQ3Zzc+/7ysHemvWoWYl706qwzIZu6ieK7jhKm3O+6nht1Ww7p3Tf92ML
	 147MNi++pwCyvQ/BsYAfvCPRvusfr8WmbAnt8QEGNq2omLludZgFXpTrhfJWKGhxRv
	 j8UQZ/fxoPlC3ZTj0pljsn76zukhBB+qsciz8YkA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephan Lipp <Stephan@adalogics.com>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1894/2151] net: shrink the payload-only part of skb dataref to one bit
Date: Wed, 18 Nov 2026 16:00:29 +0100
Message-ID: <20261118150230.787112227@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@kernel.org>

[ Upstream commit 4957ea03bf2696f5da12c09144f48d040696ecc2 ]

skb_shinfo(skb)->dataref is split in two 16-bit halves: the lower
one counts all references, the upper one the payload-only (nohdr)
references.

__skb_clone() increments dataref without bound, and skb_cloned()
only checks the low 16 bits. With 65,537 references the low half
reads 1, the head looks private, and pskb_expand_head() (or
skb_unclone(), skb_cow(), ...) frees it while clones still point
to it.

An unprivileged user can reach this from a user and network namespace:
about 32,770 AF_PACKET sockets on lo bring dataref to 0x10001, then
any pskb_expand_head() on the receive path (here a pull of a large
IPv6 Hop-by-Hop header) frees the shared head:

BUG: KASAN: slab-use-after-free in _copy_to_iter+0x187/0x1330
Read of size 1590 at addr ff110001104a9002 by task dataref_wrap/87
 skb_copy_datagram_iter+0x60/0x190
 packet_recvmsg+0x1f5/0x12b0
 __sys_recvfrom+0x18d/0x290
Freed by task 87:
 kfree+0xf3/0x3b0
 pskb_expand_head+0x344/0xeb0
 __pskb_pull_tail+0xf9/0x1bf0
 ipv6_parse_hopopts+0x377/0x4f0
 ip6_rcv_core+0xc67/0x1620

The upper half never holds more than 1. It is only set by
__skb_header_release(), with atomic_set() on an skb owning its head
(TCP/SCTP output, and GRO which never sees cloned skbs).
__skb_clone() clears nohdr, and __copy_skb_header() does not copy it.

Move SKB_DATAREF_SHIFT to 30, so that the reference count gets 30 bits,
and dataref stays positive. Wrapping it would need 2^30 live clones of
a single skb, which socket buffer limits and memory make unreachable.

This issue was found by Anthropic using Claude, and validated by
Ada Logics.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reported-by: Stephan Lipp <Stephan@adalogics.com>
Signed-off-by: Eric Dumazet <edumazet@kernel.org>
Link: https://patch.msgid.link/20261020151954.22953-1-edumazet@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/skbuff.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 0abf4a80aecfd..1ce81b7028928 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -633,9 +633,9 @@ struct skb_shared_info {
  *
  * Transport layers send out clones of payload skbs they hold for
  * retransmissions. To allow lower layers of the stack to prepend their headers
- * we split &skb_shared_info.dataref into two halves.
- * The lower 16 bits count the overall number of references.
- * The higher 16 bits indicate how many of the references are payload-only.
+ * we split &skb_shared_info.dataref into two parts.
+ * The lower 30 bits count the overall number of references.
+ * Bit 30 indicates whether one of the references is payload-only.
  * skb_header_cloned() checks if skb is allowed to add / write the headers.
  *
  * The creator of the skb (e.g. TCP) marks its skb as &sk_buff.nohdr
@@ -655,7 +655,7 @@ struct skb_shared_info {
  * Having multiple payload-only skbs with different lengths of hdr_len is not
  * possible. The payload-only skbs should never leave their owner.
  */
-#define SKB_DATAREF_SHIFT 16
+#define SKB_DATAREF_SHIFT 30
 #define SKB_DATAREF_MASK ((1 << SKB_DATAREF_SHIFT) - 1)
 
 
-- 
2.53.0



