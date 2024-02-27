Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 078E113A26F;
	Tue, 27 Feb 2024 14:11:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709043072; cv=none; b=bZAPkiEx9Qth1Ei+15Ci+qIK7b3rsvYI90rgr0n61HUASgtOaAEB75WL3HSLIphsmW7fLpcAI107N9N0aRcl9zTfGk2kQHsjPh7SmUd00XtbwjHDE53NQwm5e1NNLB8AZfAsZdPL+Bmo0YG1k9eBjcpin4fW4lxl91iZxzVww4I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709043072; c=relaxed/simple;
	bh=R+NIgzSWuagCNmFpQFca8KQJYsUdzy3kx6FtpeJYxr0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FWjpiRt7Fq1py0wQaBzIs3BFPnBqYiTtANYGKFZe0UFsxV01B1oFoLKhpLhXCvp8yqoednxu5HG//RlD9h5NziiLxht1QcJo90lD25rcKNZ7l6Abi8s9lHBR11WEsOcK0Opm7Egz99dNRA64bMRyXAvKFo1kv4BDpABDSWUlgvs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cKUsOlpt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cKUsOlpt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58351C433C7;
	Tue, 27 Feb 2024 14:11:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709043071;
	bh=R+NIgzSWuagCNmFpQFca8KQJYsUdzy3kx6FtpeJYxr0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cKUsOlptZSQ15ASZFuYqmA+6ULIVssW/1u9XmGaPGeGb+1NWcwijQPGYfycdsr+0v
	 B0H60V9Wx1m910/A0/MUOLzx2t5Q28IOOc6vl8a2lo8fwpzYZCxVGQPIg9MxO76gqM
	 v0fS/BafkheYUQgXMYNBYq9jCClW/ksg7IDCT/G0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>,
	David Ahern <dsahern@kernel.org>,
	Dylan Yudaken <dylany@fb.com>,
	Yajun Deng <yajun.deng@linux.dev>,
	Petr Machata <petrm@nvidia.com>,
	Hangbin Liu <liuhangbin@gmail.com>,
	Leon Romanovsky <leon@kernel.org>,
	syzbot <syzkaller@googlegroups.com>,
	Willem de Bruijn <willemb@google.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Kees Cook <keescook@chromium.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 224/245] net: dev: Convert sa_data to flexible array in struct sockaddr
Date: Tue, 27 Feb 2024 14:26:52 +0100
Message-ID: <20240227131622.468603288@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131615.098467438@linuxfoundation.org>
References: <20240227131615.098467438@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kees Cook <keescook@chromium.org>

[ Upstream commit b5f0de6df6dce8d641ef58ef7012f3304dffb9a1 ]

One of the worst offenders of "fake flexible arrays" is struct sockaddr,
as it is the classic example of why GCC and Clang have been traditionally
forced to treat all trailing arrays as fake flexible arrays: in the
distant misty past, sa_data became too small, and code started just
treating it as a flexible array, even though it was fixed-size. The
special case by the compiler is specifically that sizeof(sa->sa_data)
and FORTIFY_SOURCE (which uses __builtin_object_size(sa->sa_data, 1))
do not agree (14 and -1 respectively), which makes FORTIFY_SOURCE treat
it as a flexible array.

However, the coming -fstrict-flex-arrays compiler flag will remove
these special cases so that FORTIFY_SOURCE can gain coverage over all
the trailing arrays in the kernel that are _not_ supposed to be treated
as a flexible array. To deal with this change, convert sa_data to a true
flexible array. To keep the structure size the same, move sa_data into
a union with a newly introduced sa_data_min with the original size. The
result is that FORTIFY_SOURCE can continue to have no idea how large
sa_data may actually be, but anything using sizeof(sa->sa_data) must
switch to sizeof(sa->sa_data_min).

Cc: Jens Axboe <axboe@kernel.dk>
Cc: Pavel Begunkov <asml.silence@gmail.com>
Cc: David Ahern <dsahern@kernel.org>
Cc: Dylan Yudaken <dylany@fb.com>
Cc: Yajun Deng <yajun.deng@linux.dev>
Cc: Petr Machata <petrm@nvidia.com>
Cc: Hangbin Liu <liuhangbin@gmail.com>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: syzbot <syzkaller@googlegroups.com>
Cc: Willem de Bruijn <willemb@google.com>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Kees Cook <keescook@chromium.org>
Link: https://lore.kernel.org/r/20221018095503.never.671-kees@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: a7d6027790ac ("arp: Prevent overflow in arp_req_get().")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/socket.h |  5 ++++-
 net/core/dev.c         |  2 +-
 net/core/dev_ioctl.c   |  2 +-
 net/packet/af_packet.c | 10 +++++-----
 4 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/include/linux/socket.h b/include/linux/socket.h
index 041d6032a3489..4c5ce8124f8e7 100644
--- a/include/linux/socket.h
+++ b/include/linux/socket.h
@@ -31,7 +31,10 @@ typedef __kernel_sa_family_t	sa_family_t;
 
 struct sockaddr {
 	sa_family_t	sa_family;	/* address family, AF_xxx	*/
-	char		sa_data[14];	/* 14 bytes of protocol address	*/
+	union {
+		char sa_data_min[14];		/* Minimum 14 bytes of protocol address	*/
+		DECLARE_FLEX_ARRAY(char, sa_data);
+	};
 };
 
 struct linger {
diff --git a/net/core/dev.c b/net/core/dev.c
index 8501645ff67dd..af77dc77eb9c8 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -9090,7 +9090,7 @@ EXPORT_SYMBOL(dev_set_mac_address_user);
 
 int dev_get_mac_address(struct sockaddr *sa, struct net *net, char *dev_name)
 {
-	size_t size = sizeof(sa->sa_data);
+	size_t size = sizeof(sa->sa_data_min);
 	struct net_device *dev;
 	int ret = 0;
 
diff --git a/net/core/dev_ioctl.c b/net/core/dev_ioctl.c
index 0e87237fd8712..6ddfd7bfc5127 100644
--- a/net/core/dev_ioctl.c
+++ b/net/core/dev_ioctl.c
@@ -339,7 +339,7 @@ static int dev_ifsioc(struct net *net, struct ifreq *ifr, void __user *data,
 		if (ifr->ifr_hwaddr.sa_family != dev->type)
 			return -EINVAL;
 		memcpy(dev->broadcast, ifr->ifr_hwaddr.sa_data,
-		       min(sizeof(ifr->ifr_hwaddr.sa_data),
+		       min(sizeof(ifr->ifr_hwaddr.sa_data_min),
 			   (size_t)dev->addr_len));
 		call_netdevice_notifiers(NETDEV_CHANGEADDR, dev);
 		return 0;
diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index d62f79cf873dd..75fb80717e489 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -3252,7 +3252,7 @@ static int packet_bind_spkt(struct socket *sock, struct sockaddr *uaddr,
 			    int addr_len)
 {
 	struct sock *sk = sock->sk;
-	char name[sizeof(uaddr->sa_data) + 1];
+	char name[sizeof(uaddr->sa_data_min) + 1];
 
 	/*
 	 *	Check legality
@@ -3263,8 +3263,8 @@ static int packet_bind_spkt(struct socket *sock, struct sockaddr *uaddr,
 	/* uaddr->sa_data comes from the userspace, it's not guaranteed to be
 	 * zero-terminated.
 	 */
-	memcpy(name, uaddr->sa_data, sizeof(uaddr->sa_data));
-	name[sizeof(uaddr->sa_data)] = 0;
+	memcpy(name, uaddr->sa_data, sizeof(uaddr->sa_data_min));
+	name[sizeof(uaddr->sa_data_min)] = 0;
 
 	return packet_do_bind(sk, name, 0, 0);
 }
@@ -3536,11 +3536,11 @@ static int packet_getname_spkt(struct socket *sock, struct sockaddr *uaddr,
 		return -EOPNOTSUPP;
 
 	uaddr->sa_family = AF_PACKET;
-	memset(uaddr->sa_data, 0, sizeof(uaddr->sa_data));
+	memset(uaddr->sa_data, 0, sizeof(uaddr->sa_data_min));
 	rcu_read_lock();
 	dev = dev_get_by_index_rcu(sock_net(sk), READ_ONCE(pkt_sk(sk)->ifindex));
 	if (dev)
-		strscpy(uaddr->sa_data, dev->name, sizeof(uaddr->sa_data));
+		strscpy(uaddr->sa_data, dev->name, sizeof(uaddr->sa_data_min));
 	rcu_read_unlock();
 
 	return sizeof(*uaddr);
-- 
2.43.0



