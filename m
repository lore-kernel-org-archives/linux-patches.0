Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60B3C5172F8;
	Wed, 30 Sep 2026 16:55:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790787332; cv=none; b=WTF5ArBTYGyrQvtKRePcNxRXfbFKGuXEL4jO3Dj7jz2ngW9X/0IJ2pb0n1ZDIwo8/CIAblVSsQxBUQ/hxTeDg86Xs09vAgJf48BLvY1Jbj3HRG82ycVbJA9kboA9nyruU9pxwi0oH1Z0Y2IgDHYRTMz0Rj6zOYhmaOAwhMmrBKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790787332; c=relaxed/simple;
	bh=jk7099RgprtfLJX9OvHshEWkjz8qdXrsDA4GvOdnibE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HbmPhksA+KvZa3FL7R4ddRjCsDLULxEyI8ViF/hg4btelSbgw5MMjjtDeFwSxS3qvs2pNCWFiCiLTmhnQCkdorjy6WGKbTWcZW1e2aBoWOm7Br530EUd+UNkWd9sb+aR+n8IarqSTR51aN1Z1NFSSbzBJC1FXDeOQQUjUb/PtDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yNdXJi4B; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yNdXJi4B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B80EB1F000FF;
	Wed, 30 Sep 2026 16:55:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790787331;
	bh=GAjiN4PckN8btSVFhEbDEAuS1Q1jA44nCjB9Bd4QuUs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yNdXJi4BFL3X4vqQOz+i7fXqdIZOcVKSa+SSs8SwgG0XD6vcLLrGXKDo8+J20jYdq
	 KvwCY4w3YgUA5VnlOa8bUAseizcqd3iYDM8w8ZFJEiRZNI5StSFpkO6DTh92dAgZeL
	 LbVZnfLKrXSCRPBn4McLFBflN31oeKtN/OjMoy30=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrea Mayer <andrea.mayer@uniroma2.it>,
	Yuya Kusakabe <yuya.kusakabe@gmail.com>,
	Justin Iurman <justin.iurman@gmail.com>,
	Gabriel Goller <g.goller@proxmox.com>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 192/457] net: ipv6: keep room for the mac header in dst_dev_overhead()
Date: Wed, 30 Sep 2026 17:24:57 +0200
Message-ID: <20260930152350.197610453@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152346.024115587@linuxfoundation.org>
References: <20260930152346.024115587@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yuya Kusakabe <yuya.kusakabe@gmail.com>

[ Upstream commit 87cd6b717e4069dca34e0866e57eaeb44d3b173e ]

The seg6, ioam6 and rpl lwtunnels size their skb_cow_head() request as
the length they are about to push plus dst_dev_overhead(), then push the
new headers and rebuild the mac header below them with
skb_mac_header_rebuild().  That rebuild needs skb->mac_len of headroom,
but dst_dev_overhead() leaves LL_RESERVED_SPACE() of the egress device,
16 bytes for plain Ethernet.

Where the mac header is longer than that, as it is on ingress through a
VLAN device with reorder_hdr off, the rebuild runs out of room:
skb_set_mac_header(skb, -skb->mac_len) computes a negative offset,
stores it unchecked in the u16 skb->mac_header, and the memmove that
follows writes skb->mac_len bytes about 64 KB past skb->head.
Forwarding plain ping6 traffic through such a device reproduces it on
all five seg6 encapsulation modes and on the rpl and ioam6 inline paths;
skb->mac_header comes back as 65534 on a 704-byte head.

Return the larger of the two.  The helper already returns skb->mac_len
when it has no dst, so this only makes the other branch agree, and it
covers every caller rather than each call site in turn.

Fixes: 40475b63761a ("net: ipv6: seg6_iptunnel: mitigate 2-realloc issue")
Fixes: dce525185bc9 ("net: ipv6: ioam6_iptunnel: mitigate 2-realloc issue")
Fixes: 985ec6f5e623 ("net: ipv6: rpl_iptunnel: mitigate 2-realloc issue")
Suggested-by: Andrea Mayer <andrea.mayer@uniroma2.it>
Signed-off-by: Yuya Kusakabe <yuya.kusakabe@gmail.com>
Reviewed-by: Justin Iurman <justin.iurman@gmail.com>
Reviewed-by: Gabriel Goller <g.goller@proxmox.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Andrea Mayer <andrea.mayer@uniroma2.it>
Link: https://patch.msgid.link/20260922-seg6-maclen-headroom-v3-1-7b2f982ef79d@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/dst.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/net/dst.h b/include/net/dst.h
index 307073eae7f83..dbedfe72e1fd1 100644
--- a/include/net/dst.h
+++ b/include/net/dst.h
@@ -455,7 +455,8 @@ static inline unsigned int dst_dev_overhead(struct dst_entry *dst,
 					    struct sk_buff *skb)
 {
 	if (likely(dst))
-		return LL_RESERVED_SPACE(dst->dev);
+		return max_t(unsigned int, skb->mac_len,
+			     LL_RESERVED_SPACE(dst->dev));
 
 	return skb->mac_len;
 }
-- 
2.53.0



