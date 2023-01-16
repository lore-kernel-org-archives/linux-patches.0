Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B7096FA0
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 17:05:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4CD0C433EF;
	Mon, 16 Jan 2023 17:05:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673888747;
	bh=2sBOC1WkmsMdI0+iAcpl5T/DLCTGmUbfrW2u4KFMtJQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iR1aFnUkWN9FQQpwNCSkpv/f7iXgXq0+pjQHEz27PBh5gBssTdyWXv7+4A7YUCQ6G
	 zBMyxLTrUL+YZFxpK2nxO8p3Z7O+8Iq/xUWKyRqh3FcHsebRAqKcUVBRfzQ3LgLLlw
	 EBHS6RN5aDpbpFOQejLH4b6kAGt9waUlDNfk4qrA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jianlin Shi <jishi@redhat.com>,
	Jakub Sitnicki <jakub@cloudflare.com>,
	Hangbin Liu <liuhangbin@gmail.com>,
	Jiri Pirko <jiri@nvidia.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 124/338] net/tunnel: wait until all sk_user_data reader finish before releasing the sock
Date: Mon, 16 Jan 2023 16:49:57 +0100
Message-Id: <20230116154826.250153306@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154820.689115727@linuxfoundation.org>
References: <20230116154820.689115727@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Hangbin Liu <liuhangbin@gmail.com>

[ Upstream commit 3cf7203ca620682165706f70a1b12b5194607dce ]

There is a race condition in vxlan that when deleting a vxlan device
during receiving packets, there is a possibility that the sock is
released after getting vxlan_sock vs from sk_user_data. Then in
later vxlan_ecn_decapsulate(), vxlan_get_sk_family() we will got
NULL pointer dereference. e.g.

   #0 [ffffa25ec6978a38] machine_kexec at ffffffff8c669757
   #1 [ffffa25ec6978a90] __crash_kexec at ffffffff8c7c0a4d
   #2 [ffffa25ec6978b58] crash_kexec at ffffffff8c7c1c48
   #3 [ffffa25ec6978b60] oops_end at ffffffff8c627f2b
   #4 [ffffa25ec6978b80] page_fault_oops at ffffffff8c678fcb
   #5 [ffffa25ec6978bd8] exc_page_fault at ffffffff8d109542
   #6 [ffffa25ec6978c00] asm_exc_page_fault at ffffffff8d200b62
      [exception RIP: vxlan_ecn_decapsulate+0x3b]
      RIP: ffffffffc1014e7b  RSP: ffffa25ec6978cb0  RFLAGS: 00010246
      RAX: 0000000000000008  RBX: ffff8aa000888000  RCX: 0000000000000000
      RDX: 000000000000000e  RSI: ffff8a9fc7ab803e  RDI: ffff8a9fd1168700
      RBP: ffff8a9fc7ab803e   R8: 0000000000700000   R9: 00000000000010ae
      R10: ffff8a9fcb748980  R11: 0000000000000000  R12: ffff8a9fd1168700
      R13: ffff8aa000888000  R14: 00000000002a0000  R15: 00000000000010ae
      ORIG_RAX: ffffffffffffffff  CS: 0010  SS: 0018
   #7 [ffffa25ec6978ce8] vxlan_rcv at ffffffffc10189cd [vxlan]
   #8 [ffffa25ec6978d90] udp_queue_rcv_one_skb at ffffffff8cfb6507
   #9 [ffffa25ec6978dc0] udp_unicast_rcv_skb at ffffffff8cfb6e45
  #10 [ffffa25ec6978dc8] __udp4_lib_rcv at ffffffff8cfb8807
  #11 [ffffa25ec6978e20] ip_protocol_deliver_rcu at ffffffff8cf76951
  #12 [ffffa25ec6978e48] ip_local_deliver at ffffffff8cf76bde
  #13 [ffffa25ec6978ea0] __netif_receive_skb_one_core at ffffffff8cecde9b
  #14 [ffffa25ec6978ec8] process_backlog at ffffffff8cece139
  #15 [ffffa25ec6978f00] __napi_poll at ffffffff8ceced1a
  #16 [ffffa25ec6978f28] net_rx_action at ffffffff8cecf1f3
  #17 [ffffa25ec6978fa0] __softirqentry_text_start at ffffffff8d4000ca
  #18 [ffffa25ec6978ff0] do_softirq at ffffffff8c6fbdc3

Reproducer: https://github.com/Mellanox/ovs-tests/blob/master/test-ovs-vxlan-remove-tunnel-during-traffic.sh

Fix this by waiting for all sk_user_data reader to finish before
releasing the sock.

Reported-by: Jianlin Shi <jishi@redhat.com>
Suggested-by: Jakub Sitnicki <jakub@cloudflare.com>
Fixes: 6a93cc905274 ("udp-tunnel: Add a few more UDP tunnel APIs")
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/udp_tunnel.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/ipv4/udp_tunnel.c b/net/ipv4/udp_tunnel.c
index 6539ff15e9a3..d03d74388870 100644
--- a/net/ipv4/udp_tunnel.c
+++ b/net/ipv4/udp_tunnel.c
@@ -186,6 +186,7 @@ EXPORT_SYMBOL_GPL(udp_tunnel_xmit_skb);
 void udp_tunnel_sock_release(struct socket *sock)
 {
 	rcu_assign_sk_user_data(sock->sk, NULL);
+	synchronize_rcu();
 	kernel_sock_shutdown(sock, SHUT_RDWR);
 	sock_release(sock);
 }
-- 
2.35.1



