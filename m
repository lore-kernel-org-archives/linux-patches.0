Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 515DF2BE7B2;
	Tue,  6 Jan 2026 17:32:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767720735; cv=none; b=bpV4yx2WXcUTEJBzJVyD9Wu85i5ynyWfEfiamViGE7Pxv7gyQhuwWS4TD1sWgQqvgMExyu18KgJgmOR9tFE91DrRXiZfCMF7TvWx5HsC+Vol4jRe9GlwtRuI6jHT4NunpsR9ZM5UHIs18jeH4ZmcCQhvTxLB44eBzSqbcKZJA08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767720735; c=relaxed/simple;
	bh=aZv6BMmQ+wEeTMrw11xzhc0iD7tQMFRcPDm/zPB6V7E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tnVlZxW6PyXdbmZgpQ+xQ2v1zZKZSpT9QKhX+p7n5TFJb6D/uG4bdIoEEXOf0ocb0aVEqtOejgDmvsLNYzRZtKSiYCl51IPoNHCLQ8R8VPO79y8+txQcM+JUUdR67/P1zEyvjgUJXG8A7S5MyUZNWOF6ac5ri06T1P9oy3tuDmc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l4wtj4fn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l4wtj4fn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A6ADC116C6;
	Tue,  6 Jan 2026 17:32:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767720732;
	bh=aZv6BMmQ+wEeTMrw11xzhc0iD7tQMFRcPDm/zPB6V7E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l4wtj4fnHaz0EPOTXoG91xVnaRZiRwbQ6525oyyPFRgnpKlrN78Lw58KT8Er7lxzV
	 soKT/M0oM+apEXybofkh65aTI12Dpsgdg9O0X1KE7iUDuihZwjfK0V+IQHmsRjq3Cm
	 X/pKtwejmZ4mqa5Y+7ATxgUyAw4zmhVqivG1YKLc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Moore <paul@paul-moore.com>,
	Will Rosenberg <whrosenb@asu.edu>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 326/567] ipv6: BUG() in pskb_expand_head() as part of calipso_skbuff_setattr()
Date: Tue,  6 Jan 2026 18:01:48 +0100
Message-ID: <20260106170503.383353655@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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
index a247bb93908b..f5cc02ea3092 100644
--- a/net/ipv6/calipso.c
+++ b/net/ipv6/calipso.c
@@ -1342,7 +1342,8 @@ static int calipso_skbuff_setattr(struct sk_buff *skb,
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



