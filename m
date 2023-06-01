Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C797FBE8
	for <patches@lists.linux.dev>; Thu,  1 Jun 2023 13:25:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFB79C43444;
	Thu,  1 Jun 2023 13:25:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1685625926;
	bh=DkBxdDW6+VzUY3ta3ik2N2ZSDmm42F2GBWuM6uT4AeA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Bkq1Rv46DhmT8c3emFN1+bFlBCoMyDiKXstWnOa93VqosXiMFhT6VYfR3HS6qIoaO
	 LvqfDeJ6doubCNktkeidvMHORufYPO6XrU3wM/rGaoQbtpF7zgdjA+X4nxaG0Pw9Kc
	 JtqWmd7qG1ZeiPUixFExRzlKeABdn8GTTBxsYsoQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolas Dichtel <nicolas.dichtel@6wind.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 5.15 41/42] ipv{4,6}/raw: fix output xfrm lookup wrt protocol
Date: Thu,  1 Jun 2023 14:21:28 +0100
Message-Id: <20230601131938.548524003@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230601131936.699199833@linuxfoundation.org>
References: <20230601131936.699199833@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Nicolas Dichtel <nicolas.dichtel@6wind.com>

commit 3632679d9e4f879f49949bb5b050e0de553e4739 upstream.

With a raw socket bound to IPPROTO_RAW (ie with hdrincl enabled), the
protocol field of the flow structure, build by raw_sendmsg() /
rawv6_sendmsg()),  is set to IPPROTO_RAW. This breaks the ipsec policy
lookup when some policies are defined with a protocol in the selector.

For ipv6, the sin6_port field from 'struct sockaddr_in6' could be used to
specify the protocol. Just accept all values for IPPROTO_RAW socket.

For ipv4, the sin_port field of 'struct sockaddr_in' could not be used
without breaking backward compatibility (the value of this field was never
checked). Let's add a new kind of control message, so that the userland
could specify which protocol is used.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
CC: stable@vger.kernel.org
Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Link: https://lore.kernel.org/r/20230522120820.1319391-1-nicolas.dichtel@6wind.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/ip.h        |    2 ++
 include/uapi/linux/in.h |    2 ++
 net/ipv4/ip_sockglue.c  |   12 +++++++++++-
 net/ipv4/raw.c          |    5 ++++-
 net/ipv6/raw.c          |    3 ++-
 5 files changed, 21 insertions(+), 3 deletions(-)

--- a/include/net/ip.h
+++ b/include/net/ip.h
@@ -75,6 +75,7 @@ struct ipcm_cookie {
 	__be32			addr;
 	int			oif;
 	struct ip_options_rcu	*opt;
+	__u8			protocol;
 	__u8			ttl;
 	__s16			tos;
 	char			priority;
@@ -95,6 +96,7 @@ static inline void ipcm_init_sk(struct i
 	ipcm->sockc.tsflags = inet->sk.sk_tsflags;
 	ipcm->oif = inet->sk.sk_bound_dev_if;
 	ipcm->addr = inet->inet_saddr;
+	ipcm->protocol = inet->inet_num;
 }
 
 #define IPCB(skb) ((struct inet_skb_parm*)((skb)->cb))
--- a/include/uapi/linux/in.h
+++ b/include/uapi/linux/in.h
@@ -159,6 +159,8 @@ struct in_addr {
 #define MCAST_MSFILTER			48
 #define IP_MULTICAST_ALL		49
 #define IP_UNICAST_IF			50
+#define IP_LOCAL_PORT_RANGE		51
+#define IP_PROTOCOL			52
 
 #define MCAST_EXCLUDE	0
 #define MCAST_INCLUDE	1
--- a/net/ipv4/ip_sockglue.c
+++ b/net/ipv4/ip_sockglue.c
@@ -317,7 +317,14 @@ int ip_cmsg_send(struct sock *sk, struct
 			ipc->tos = val;
 			ipc->priority = rt_tos2priority(ipc->tos);
 			break;
-
+		case IP_PROTOCOL:
+			if (cmsg->cmsg_len != CMSG_LEN(sizeof(int)))
+				return -EINVAL;
+			val = *(int *)CMSG_DATA(cmsg);
+			if (val < 1 || val > 255)
+				return -EINVAL;
+			ipc->protocol = val;
+			break;
 		default:
 			return -EINVAL;
 		}
@@ -1724,6 +1731,9 @@ static int do_ip_getsockopt(struct sock
 	case IP_MINTTL:
 		val = inet->min_ttl;
 		break;
+	case IP_PROTOCOL:
+		val = inet_sk(sk)->inet_num;
+		break;
 	default:
 		release_sock(sk);
 		return -ENOPROTOOPT;
--- a/net/ipv4/raw.c
+++ b/net/ipv4/raw.c
@@ -559,6 +559,9 @@ static int raw_sendmsg(struct sock *sk,
 	}
 
 	ipcm_init_sk(&ipc, inet);
+	/* Keep backward compat */
+	if (hdrincl)
+		ipc.protocol = IPPROTO_RAW;
 
 	if (msg->msg_controllen) {
 		err = ip_cmsg_send(sk, msg, &ipc, false);
@@ -626,7 +629,7 @@ static int raw_sendmsg(struct sock *sk,
 
 	flowi4_init_output(&fl4, ipc.oif, ipc.sockc.mark, tos,
 			   RT_SCOPE_UNIVERSE,
-			   hdrincl ? IPPROTO_RAW : sk->sk_protocol,
+			   hdrincl ? ipc.protocol : sk->sk_protocol,
 			   inet_sk_flowi_flags(sk) |
 			    (hdrincl ? FLOWI_FLAG_KNOWN_NH : 0),
 			   daddr, saddr, 0, 0, sk->sk_uid);
--- a/net/ipv6/raw.c
+++ b/net/ipv6/raw.c
@@ -828,7 +828,8 @@ static int rawv6_sendmsg(struct sock *sk
 
 		if (!proto)
 			proto = inet->inet_num;
-		else if (proto != inet->inet_num)
+		else if (proto != inet->inet_num &&
+			 inet->inet_num != IPPROTO_RAW)
 			return -EINVAL;
 
 		if (proto > 255)


