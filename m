Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB4F24071DA;
	Sun,  7 Jun 2026 10:15:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780827355; cv=none; b=Yp/+8qoVJuCzBNGXtCk4Ix5+6O2sC3xCmGON85RZW0l2TZqfgLAIap2I8vQP06gbMSuBt+q11Ymp/PCOwTXLesLlctXWSvqXMBeTbURzTVdC+rg7xGIh2dbl6uLFG10Iv4uzL/m2eWuQbtOog7KmwvzjNsPFwHXXMWHgNTgZ6II=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780827355; c=relaxed/simple;
	bh=Q/rFjXTfPWlh+TPrrGA3okkBjPWuTnh948BfuVG6B5E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JwVwuQv4DJNM92ZPAvkv290VbnGMcqX6zz8jHIDwizQUt2bUwfHuAqvoq29jOrJx3OiQG9nOonaiUkjf6xYJ11DmPswfz5lj1df1U2cxP+H8PcSWC31AYs12M4V1n6iEY3FPp/rqJ1KtDktj1B6gvnsFsXGZ9lAh8UM4iIpCouQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rWS8Cj6B; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rWS8Cj6B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 033711F00893;
	Sun,  7 Jun 2026 10:15:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780827354;
	bh=wlj0Ln28A7ZK5NuFnq764mTg2hRd3li92TEB95hi/gY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rWS8Cj6BEtbKdCRJlKKfPIsX7WAxiqTGKv2mKicGJ9DrQYbCt/80UI5C4GWzLhrK0
	 AsE5AZ70krkjwfKcyMlmKIprWNgS9XjDJA6RrroL6GINy47FTmd7k06ak9wnJ5LrZU
	 2aQDO4anAgpkaoJf/2CfOoh67Bhx5H4rPXqWGqug=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>,
	Breno Leitao <leitao@debian.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 048/307] net: Avoid checksumming unreadable skb tail on trim
Date: Sun,  7 Jun 2026 11:57:25 +0200
Message-ID: <20260607095729.481353744@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.647295505@linuxfoundation.org>
References: <20260607095727.647295505@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index aa9e9148847363..8c9f026182a6f0 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -2765,6 +2765,8 @@ int ___pskb_trim(struct sk_buff *skb, unsigned int len)
 		skb->data_len  = 0;
 		skb_set_tail_pointer(skb, len);
 	}
+	if (!skb_shinfo(skb)->nr_frags && !skb_has_frag_list(skb))
+		skb->unreadable = 0;
 
 	if (!skb->sk || skb->destructor == sock_edemux)
 		skb_condense(skb);
@@ -2772,16 +2774,37 @@ int ___pskb_trim(struct sk_buff *skb, unsigned int len)
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



