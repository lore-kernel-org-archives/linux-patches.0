Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E47671519B8;
	Mon, 12 May 2025 18:00:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747072810; cv=none; b=Llrdd826la8b2oX9cWw6dJzfMdz4mGN5IGVZFuogJL48+NVDLpwo+aTDCfT+nPeisXo34O/BXLSZr3VxmydPoA/4cbcvTVh2jwB6kLx1qo6oob+9JbpwpxxY5sFHg6quzl9YPDN8XNvuKJKx3cek3hqWn76fNWVE2T1u+52+hhk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747072810; c=relaxed/simple;
	bh=k/Sr4m8zCKjIoYHzJeOA1YnSFOteCVrc4f2EGWwpx00=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jhLs49r9wmdfECQh8IPw/bJAzifFsNaggqKbVV8BuTDjvDAKqNND4KxpINfMiAHMhdUy8FuSXezm00POb9Nqght7DDSiAs4ExoGyLFoeHtKDstCRGJwOErEr66e7NCeddvklUlmVf7hQXNqH4EqABWotY9ZLkhgblh6aYTUjg70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FUc9Yc43; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FUc9Yc43"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5538AC4CEE9;
	Mon, 12 May 2025 18:00:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747072809;
	bh=k/Sr4m8zCKjIoYHzJeOA1YnSFOteCVrc4f2EGWwpx00=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FUc9Yc43G/p9kuFvopziKRV+uBaHP9b7DgWxnxKCRYgRQNZJAUdQCIDuAVMbxAUq8
	 45afXbHPBqQsjZ/ZcJNj9yszHHw3ssNFxOzQzku8wQ4vkpEvMzstnz0QJHINBg9bQZ
	 g0eALIP/S0j5jsJ3k/EPfNXzcqKyxTgRqdPteiS8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Chaignon <paul.chaignon@gmail.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 034/184] bpf: Scrub packet on bpf_redirect_peer
Date: Mon, 12 May 2025 19:43:55 +0200
Message-ID: <20250512172043.110812353@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172041.624042835@linuxfoundation.org>
References: <20250512172041.624042835@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Paul Chaignon <paul.chaignon@gmail.com>

[ Upstream commit c4327229948879814229b46aa26a750718888503 ]

When bpf_redirect_peer is used to redirect packets to a device in
another network namespace, the skb isn't scrubbed. That can lead skb
information from one namespace to be "misused" in another namespace.

As one example, this is causing Cilium to drop traffic when using
bpf_redirect_peer to redirect packets that just went through IPsec
decryption to a container namespace. The following pwru trace shows (1)
the packet path from the host's XFRM layer to the container's XFRM
layer where it's dropped and (2) the number of active skb extensions at
each function.

    NETNS       MARK  IFACE  TUPLE                                FUNC
    4026533547  d00   eth0   10.244.3.124:35473->10.244.2.158:53  xfrm_rcv_cb
                             .active_extensions = (__u8)2,
    4026533547  d00   eth0   10.244.3.124:35473->10.244.2.158:53  xfrm4_rcv_cb
                             .active_extensions = (__u8)2,
    4026533547  d00   eth0   10.244.3.124:35473->10.244.2.158:53  gro_cells_receive
                             .active_extensions = (__u8)2,
    [...]
    4026533547  0     eth0   10.244.3.124:35473->10.244.2.158:53  skb_do_redirect
                             .active_extensions = (__u8)2,
    4026534999  0     eth0   10.244.3.124:35473->10.244.2.158:53  ip_rcv
                             .active_extensions = (__u8)2,
    4026534999  0     eth0   10.244.3.124:35473->10.244.2.158:53  ip_rcv_core
                             .active_extensions = (__u8)2,
    [...]
    4026534999  0     eth0   10.244.3.124:35473->10.244.2.158:53  udp_queue_rcv_one_skb
                             .active_extensions = (__u8)2,
    4026534999  0     eth0   10.244.3.124:35473->10.244.2.158:53  __xfrm_policy_check
                             .active_extensions = (__u8)2,
    4026534999  0     eth0   10.244.3.124:35473->10.244.2.158:53  __xfrm_decode_session
                             .active_extensions = (__u8)2,
    4026534999  0     eth0   10.244.3.124:35473->10.244.2.158:53  security_xfrm_decode_session
                             .active_extensions = (__u8)2,
    4026534999  0     eth0   10.244.3.124:35473->10.244.2.158:53  kfree_skb_reason(SKB_DROP_REASON_XFRM_POLICY)
                             .active_extensions = (__u8)2,

In this case, there are no XFRM policies in the container's network
namespace so the drop is unexpected. When we decrypt the IPsec packet,
the XFRM state used for decryption is set in the skb extensions. This
information is preserved across the netns switch. When we reach the
XFRM policy check in the container's netns, __xfrm_policy_check drops
the packet with LINUX_MIB_XFRMINNOPOLS because a (container-side) XFRM
policy can't be found that matches the (host-side) XFRM state used for
decryption.

This patch fixes this by scrubbing the packet when using
bpf_redirect_peer, as is done on typical netns switches via veth
devices except skb->mark and skb->tstamp are not zeroed.

Fixes: 9aa1206e8f482 ("bpf: Add redirect_peer helper")
Signed-off-by: Paul Chaignon <paul.chaignon@gmail.com>
Acked-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Martin KaFai Lau <martin.lau@kernel.org>
Link: https://patch.msgid.link/1728ead5e0fe45e7a6542c36bd4e3ca07a73b7d6.1746460653.git.paul.chaignon@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/filter.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/core/filter.c b/net/core/filter.c
index 790345c2546b7..99b23fd2f509c 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -2526,6 +2526,7 @@ int skb_do_redirect(struct sk_buff *skb)
 			goto out_drop;
 		skb->dev = dev;
 		dev_sw_netstats_rx_add(dev, skb->len);
+		skb_scrub_packet(skb, false);
 		return -EAGAIN;
 	}
 	return flags & BPF_F_NEIGH ?
-- 
2.39.5



