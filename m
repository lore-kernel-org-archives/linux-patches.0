Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585745;
	b=ceaRhBlp7v0TZNlE076b8rr6pfAdruvHmCn5n2jPiTWzvH100IwCyBxREXcxJFCbF4sk
	 lIr40iSBfHSvI/NAwNKoc70KCXEWRX+EalB3gQzrjV+ZundG9CEPqjBJkkNyPI0DvxcgH
	 PjtqONuLjrYLALwRe/FPuyaLLoTvyy69qM4LihWheTVcP0s7s/+Yy0Ax2MAGCt2khEJmQ
	 hOLnFosSNqEmrDtSqp/T+BNcfyWqUrmGscH83+ExzQsBt1Dpor+mhgUWZP0ObN+q0LJr3
	 T7JW4PpD3bBNqwdTxDxP2Ng5VovSU/hFRO9waLjeEQUWNdH68ydooQg6Jt9XueKkBoQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585745;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6w6tHQ0n6CFf6iNU5krBfjsvYSKwaXbU75gcyg0Ucho=;
	b=A3djL4taF87L/ZaF2GxkOdYoz7T4iJYfktlsCf0a43w30DEEUF0GWElcMpBuwXaw651v
	 LM67hj2gkt31HVehWQ5UcnjKv/OKPBQAhLFYfvK4f2pfJTYwJXhdnVJySj3FnDfunFjNg
	 gwN/IyNIypadB6kOTI+yU8P6tezE1EPi+6urXkv1WQRELHMLhVvOZEks3zoFDaDmxDlJk
	 GPfLDvbdIK0Xwx40ZhJhH1xArqah/eYG1Eqab5//knaASXVjwH+IUpc0nvgsYZ1asR05W
	 12bbKt56xcu0d0StAPI7RXwzPT8g1hd5VX1s6baDR/xQd6ebpEpZxcA9BoLzxt/fUBg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NHWRm3uU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 257FA606A336;
	Fri, 13 Nov 2026 16:02:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NHWRm3uU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C52581F000C4;
	Fri, 13 Nov 2026 16:02:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585745;
	bh=6w6tHQ0n6CFf6iNU5krBfjsvYSKwaXbU75gcyg0Ucho=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NHWRm3uUAyNKZVwc47fI20udKzyYMpZbhPJxWJHIChLTpQiHyL0FSETSelk+VluC/
	 VLFa4gQ3Ozs0BqXUfG6tyuh+fPkIHIscnt1LYQ6TwTTXJ/xi/fKkb0Ak6K0VJ+VZat
	 oPjcYhh2J6Xzo8Fw2YOdE/jtx3i169HS5NIoBC+k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexei Starovoitov <ast@kernel.org>,
	Eric Dumazet <edumazet@kernel.org>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 342/507] net: reject a negative TCP header offset in qdisc_pkt_len_segs_init()
Date: Fri, 13 Nov 2026 10:50:46 -0500
Message-ID: <20261113153806.987439492@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexei Starovoitov <ast@kernel.org>

[ Upstream commit 35d2d6e5ac0d22428b2a0216061f3330c095393c ]

qdisc_pkt_len_segs_init() stores skb_transport_offset(), or the inner
offset, in the unsigned hdr_len. A header in front of skb->data gives a
negative offset. For an offset a little below zero, pskb_may_pull() gets a
small length and succeeds. Then a 64-bit kernel reads the TCP header far
after the skb and can crash. Further below zero pskb_may_pull() fails.

Commit 28a57fb2c5df ("net: iptunnel: fix stale transport header during
tunnel decapsulation") fixed one source of such offsets. Other code that
removes bytes from the front of a packet can leave the same stale header.

Return SKB_DROP_REASON_SKB_BAD_GSO for a negative offset in the TCP branch.
SKB_GSO_UDP_L4 and the other GSO types read no header and still get a wrong
qdisc_pkt_len(). On a 64-bit kernel only packets that cause the read after
the skb today get a new result. Then __dev_queue_xmit() drops them and
returns -EINVAL, but sch_handle_ingress() ignores the result. Their content
can be valid. Thus the code that leaves the header stale needs its own fix.

Fixes: 7fb4c1967011 ("net: pull headers in qdisc_pkt_len_segs_init()")
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Reviewed-by: Eric Dumazet <edumazet@kernel.org>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
CC: stable@vger.kernel.org
Link: https://patch.msgid.link/20261101194433.2637113-1-alexei.starovoitov@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/dev.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index cc7b32ab56085..f803d8ba866ff 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -4204,7 +4204,9 @@ static enum skb_drop_reason qdisc_pkt_len_segs_init(struct sk_buff *skb)
 	if (likely(shinfo->gso_type & (SKB_GSO_TCPV4 | SKB_GSO_TCPV6))) {
 		const struct tcphdr *th;
 
-		if (!pskb_may_pull(skb, hdr_len + sizeof(struct tcphdr)))
+		/* A header in front of skb->data gives a negative offset. */
+		if ((int)hdr_len < 0 ||
+		    !pskb_may_pull(skb, hdr_len + sizeof(struct tcphdr)))
 			return SKB_DROP_REASON_SKB_BAD_GSO;
 
 		th = (const struct tcphdr *)(skb->data + hdr_len);
-- 
2.53.0



