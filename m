Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4B0A1094D
	for <patches@lists.linux.dev>; Mon, 19 Jun 2023 10:30:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CFE4C433CB;
	Mon, 19 Jun 2023 10:30:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687170619;
	bh=7SZpRBOPuEVYE2QmaYt4jJ9GIL8+s98F+KMoarjT3RY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RCtY+bLfCmVOFc4PpYl4pQ3wOqeJSVcPM15Qrg1wLkeTDFVxmYtUC4hTN4qUuhkZC
	 BV+yn4OmOOxl5lDMqioPFU7XxuJWl95L/NQUbP1aE0pybkFfdj8hCVDWdDfSx6l37v
	 2l0WaHb6N1Y3bMJPdwN1lenzI7vSjvIShMFbgDPU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mirsad Todorovac <mirsad.todorovac@alu.unizg.hr>,
	Guillaume Nault <gnault@redhat.com>,
	David Ahern <dsahern@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 19/32] ping6: Fix send to link-local addresses with VRF.
Date: Mon, 19 Jun 2023 12:29:07 +0200
Message-ID: <20230619102128.553797160@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230619102127.461443957@linuxfoundation.org>
References: <20230619102127.461443957@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Guillaume Nault <gnault@redhat.com>

[ Upstream commit 91ffd1bae1dafbb9e34b46813f5b058581d9144d ]

Ping sockets can't send packets when they're bound to a VRF master
device and the output interface is set to a slave device.

For example, when net.ipv4.ping_group_range is properly set, so that
ping6 can use ping sockets, the following kind of commands fails:
  $ ip vrf exec red ping6 fe80::854:e7ff:fe88:4bf1%eth1

What happens is that sk->sk_bound_dev_if is set to the VRF master
device, but 'oif' is set to the real output device. Since both are set
but different, ping_v6_sendmsg() sees their value as inconsistent and
fails.

Fix this by allowing 'oif' to be a slave device of ->sk_bound_dev_if.

This fixes the following kselftest failure:
  $ ./fcnal-test.sh -t ipv6_ping
  [...]
  TEST: ping out, vrf device+address bind - ns-B IPv6 LLA        [FAIL]

Reported-by: Mirsad Todorovac <mirsad.todorovac@alu.unizg.hr>
Closes: https://lore.kernel.org/netdev/b6191f90-ffca-dbca-7d06-88a9788def9c@alu.unizg.hr/
Tested-by: Mirsad Todorovac <mirsad.todorovac@alu.unizg.hr>
Fixes: 5e457896986e ("net: ipv6: Fix ping to link-local addresses.")
Signed-off-by: Guillaume Nault <gnault@redhat.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Link: https://lore.kernel.org/r/6c8b53108816a8d0d5705ae37bdc5a8322b5e3d9.1686153846.git.gnault@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/ping.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/ipv6/ping.c b/net/ipv6/ping.c
index d5cdba8213a44..49e11bbf390cf 100644
--- a/net/ipv6/ping.c
+++ b/net/ipv6/ping.c
@@ -101,7 +101,8 @@ static int ping_v6_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 	addr_type = ipv6_addr_type(daddr);
 	if ((__ipv6_addr_needs_scope_id(addr_type) && !oif) ||
 	    (addr_type & IPV6_ADDR_MAPPED) ||
-	    (oif && sk->sk_bound_dev_if && oif != sk->sk_bound_dev_if))
+	    (oif && sk->sk_bound_dev_if && oif != sk->sk_bound_dev_if &&
+	     l3mdev_master_ifindex_by_index(sock_net(sk), oif) != sk->sk_bound_dev_if))
 		return -EINVAL;
 
 	/* TODO: use ip6_datagram_send_ctl to get options from cmsg */
-- 
2.39.2



