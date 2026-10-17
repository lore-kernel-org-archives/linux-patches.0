Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0B063BB133;
	Sat, 17 Oct 2026 17:22:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792257779; cv=none; b=P+9VHq8J9qNBztrIssmx30nFC9lA8YiW40Qn9KZzEgiP+2D7WYu8KqgbO40rWJbaCuype5/9Mdgt78MdZWdyWIixWjKlMbwlsL2tUfbsqAOHjkeZNMNVkibqXEZPVY/Sgbk4td8CO3Oimc6KaKOrBDSRbeB6hMbQUEosqarUChw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792257779; c=relaxed/simple;
	bh=Q6f2liuyBXJhKWcYZ1Ik837e4tlcTM+dL4NDEPLxtP8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MJSAH9vSGMVjllKMY5PUyJrZQ8wthspnbbpgSzkJOG0IQAS4+eSDAJzBkkvLf1c9OfSleZJh/l99kP8sBfamdpzdhTjJvmWQ8BZ/WR/Thi4wgyf0OHHikp8Dg2TRDj6P3mBtTwloiqMQtaiDPobyyIEOf8VM0QQRL1fExHdWQI4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WtlKhuHf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WtlKhuHf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EEB81F000C4;
	Sat, 17 Oct 2026 17:22:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792257776;
	bh=5VSvzJWvn/+f4IOR/9Og1Dj+Or15yXfUEy9Wa+MjdNo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WtlKhuHf3ahq9UfQebatNXLtPnTRSxIePiF389v/ULjj8XXST0W4EIIDyzHEeTF48
	 Hzp/tstKNy5yClqSaKhEV2rv2tmwRwSZom2PDHkU912NL2nz14Yg/WAFhkua1CUYib
	 nPMBLFEFSHIlGMeJ/HExTPy4l5IQ4QBIQF7EAag4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ed Santiago <santiago@redhat.com>,
	Stefano Brivio <sbrivio@redhat.com>,
	Eric Dumazet <edumazet@google.com>,
	Willem de Bruijn <willemb@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>,
	David Gibson <david@gibson.dropbear.id.au>
Subject: [PATCH 6.6 0668/1674] udp: Deal with race between UDP socket address change and rehash
Date: Sat, 17 Oct 2026 17:49:00 +0200
Message-ID: <20261017160448.253577135@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stefano Brivio <sbrivio@redhat.com>

[ Upstream commit a502ea6fa94b1f7be72a24bcf9e3f5f6b7e6e90c ]

If a UDP socket changes its local address while it's receiving
datagrams, as a result of connect(), there is a period during which
a lookup operation might fail to find it, after the address is changed
but before the secondary hash (port and address) and the four-tuple
hash (local and remote ports and addresses) are updated.

Secondary hash chains were introduced by commit 30fff9231fad ("udp:
bind() optimisation") and, as a result, a rehash operation became
needed to make a bound socket reachable again after a connect().

This operation was introduced by commit 719f835853a9 ("udp: add
rehash on connect()") which isn't however a complete fix: the
socket will be found once the rehashing completes, but not while
it's pending.

This is noticeable with a socat(1) server in UDP4-LISTEN mode, and a
client sending datagrams to it. After the server receives the first
datagram (cf. _xioopen_ipdgram_listen()), it issues a connect() to
the address of the sender, in order to set up a directed flow.

Now, if the client, running on a different CPU thread, happens to
send a (subsequent) datagram while the server's socket changes its
address, but is not rehashed yet, this will result in a failed
lookup and a port unreachable error delivered to the client, as
apparent from the following reproducer:

  LEN=$(($(cat /proc/sys/net/core/wmem_default) / 4))
  dd if=/dev/urandom bs=1 count=${LEN} of=tmp.in

  while :; do
  	taskset -c 1 socat UDP4-LISTEN:1337,null-eof OPEN:tmp.out,create,trunc &
  	sleep 0.1 || sleep 1
  	taskset -c 2 socat OPEN:tmp.in UDP4:localhost:1337,shut-null
  	wait
  done

where the client will eventually get ECONNREFUSED on a write()
(typically the second or third one of a given iteration):

  2024/11/13 21:28:23 socat[46901] E write(6, 0x556db2e3c000, 8192): Connection refused

This issue was first observed as a seldom failure in Podman's tests
checking UDP functionality while using pasta(1) to connect the
container's network namespace, which leads us to a reproducer with
the lookup error resulting in an ICMP packet on a tap device:

  LOCAL_ADDR="$(ip -j -4 addr show|jq -rM '.[] | .addr_info[0] | select(.scope == "global").local')"

  while :; do
  	./pasta --config-net -p pasta.pcap -u 1337 socat UDP4-LISTEN:1337,null-eof OPEN:tmp.out,create,trunc &
  	sleep 0.2 || sleep 1
  	socat OPEN:tmp.in UDP4:${LOCAL_ADDR}:1337,shut-null
  	wait
  	cmp tmp.in tmp.out
  done

Once this fails:

  tmp.in tmp.out differ: char 8193, line 29

we can finally have a look at what's going on:

  $ tshark -r pasta.pcap
      1   0.000000           :: ? ff02::16     ICMPv6 110 Multicast Listener Report Message v2
      2   0.168690 88.198.0.161 ? 88.198.0.164 UDP 8234 60260 ? 1337 Len=8192
      3   0.168767 88.198.0.161 ? 88.198.0.164 UDP 8234 60260 ? 1337 Len=8192
      4   0.168806 88.198.0.161 ? 88.198.0.164 UDP 8234 60260 ? 1337 Len=8192
      5   0.168827 c6:47:05:8d:dc:04 ? Broadcast    ARP 42 Who has 88.198.0.161? Tell 88.198.0.164
      6   0.168851 9a:55:9a:55:9a:55 ? c6:47:05:8d:dc:04 ARP 42 88.198.0.161 is at 9a:55:9a:55:9a:55
      7   0.168875 88.198.0.161 ? 88.198.0.164 UDP 8234 60260 ? 1337 Len=8192
      8   0.168896 88.198.0.164 ? 88.198.0.161 ICMP 590 Destination unreachable (Port unreachable)
      9   0.168926 88.198.0.161 ? 88.198.0.164 UDP 8234 60260 ? 1337 Len=8192
     10   0.168959 88.198.0.161 ? 88.198.0.164 UDP 8234 60260 ? 1337 Len=8192
     11   0.168989 88.198.0.161 ? 88.198.0.164 UDP 4138 60260 ? 1337 Len=4096
     12   0.169010 88.198.0.161 ? 88.198.0.164 UDP 42 60260 ? 1337 Len=0

On the third datagram received, the network namespace of the container
initiates an ARP lookup to deliver the ICMP message.

In another variant of this reproducer, starting the client with:

  strace -f pasta --config-net -u 1337 socat UDP4-LISTEN:1337,null-eof OPEN:tmp.out,create,trunc 2>strace.log &

and connecting to the socat server using a loopback address:

  socat OPEN:tmp.in UDP4:localhost:1337,shut-null

we can more clearly observe a sendmmsg() call failing after the
first datagram is delivered:

  [pid 278012] connect(173, 0x7fff96c95fc0, 16) = 0
  [...]
  [pid 278012] recvmmsg(173, 0x7fff96c96020, 1024, MSG_DONTWAIT, NULL) = -1 EAGAIN (Resource temporarily unavailable)
  [pid 278012] sendmmsg(173, 0x561c5ad0a720, 1, MSG_NOSIGNAL) = 1
  [...]
  [pid 278012] sendmmsg(173, 0x561c5ad0a720, 1, MSG_NOSIGNAL) = -1 ECONNREFUSED (Connection refused)

and, somewhat confusingly, after a connect() on the same socket
succeeded.

Until commit 4cdeeee9252a ("net: udp: prefer listeners bound to an
address"), the race between receive address change and lookup didn't
actually cause visible issues, because, once the lookup based on the
secondary hash chain failed, we would still attempt a lookup based on
the primary hash (destination port only), and find the socket with the
outdated secondary hash.

That change, however, dropped port-only lookups altogether, as side
effect, making the race visible.

To fix this, while avoiding the need to make address changes and
rehash atomic against lookups, reintroduce primary hash lookups as
fallback, if lookups based on four-tuple and secondary hashes fail.

To this end, introduce a simplified lookup implementation, which
doesn't take care of SO_REUSEPORT groups: if we have one, there are
multiple sockets that would match the four-tuple or secondary hash,
meaning that we can't run into this race at all.

v2:
  - instead of synchronising lookup operations against address change
    plus rehash, reintroduce a simplified version of the original
    primary hash lookup as fallback

v1:
  - fix build with CONFIG_IPV6=n: add ifdef around sk_v6_rcv_saddr
    usage (Kuniyuki Iwashima)
  - directly use sk_rcv_saddr for IPv4 receive addresses instead of
    fetching inet_rcv_saddr (Kuniyuki Iwashima)
  - move inet_update_saddr() to inet_hashtables.h and use that
    to set IPv4/IPv6 addresses as suitable (Kuniyuki Iwashima)
  - rebase onto net-next, update commit message accordingly

Reported-by: Ed Santiago <santiago@redhat.com>
Link: https://github.com/containers/podman/issues/24147
Analysed-by: David Gibson <david@gibson.dropbear.id.au>
Fixes: 30fff9231fad ("udp: bind() optimisation")
Signed-off-by: Stefano Brivio <sbrivio@redhat.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/udp.c | 56 ++++++++++++++++++++++++++++++++++++++++++++++++++
 net/ipv6/udp.c | 50 ++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 106 insertions(+)

diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index 339d9db972e53..86a1b2c9e71fe 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -421,6 +421,49 @@ u32 udp_ehashfn(const struct net *net, const __be32 laddr, const __u16 lport,
 			      udp_ehash_secret + net_hash_mix(net));
 }
 
+/**
+ * udp4_lib_lookup1() - Simplified lookup using primary hash (destination port)
+ * @net:	Network namespace
+ * @saddr:	Source address, network order
+ * @sport:	Source port, network order
+ * @daddr:	Destination address, network order
+ * @hnum:	Destination port, host order
+ * @dif:	Destination interface index
+ * @sdif:	Destination bridge port index, if relevant
+ * @udptable:	Set of UDP hash tables
+ *
+ * Simplified lookup to be used as fallback if no sockets are found due to a
+ * potential race between (receive) address change, and lookup happening before
+ * the rehash operation. This function ignores SO_REUSEPORT groups while scoring
+ * result sockets, because if we have one, we don't need the fallback at all.
+ *
+ * Called under rcu_read_lock().
+ *
+ * Return: socket with highest matching score if any, NULL if none
+ */
+static struct sock *udp4_lib_lookup1(struct net *net,
+				     __be32 saddr, __be16 sport,
+				     __be32 daddr, unsigned int hnum,
+				     int dif, int sdif,
+				     const struct udp_table *udptable)
+{
+	unsigned int slot = udp_hashfn(net, hnum, udptable->mask);
+	struct udp_hslot *hslot = &udptable->hash[slot];
+	struct sock *sk, *result = NULL;
+	int score, badness = 0;
+
+	sk_for_each_rcu(sk, &hslot->head) {
+		score = compute_score(sk, net,
+				      saddr, sport, daddr, hnum, dif, sdif);
+		if (score > badness) {
+			result = sk;
+			badness = score;
+		}
+	}
+
+	return result;
+}
+
 /* called with rcu_read_lock() */
 static struct sock *udp4_lib_lookup2(struct net *net,
 				     __be32 saddr, __be16 sport,
@@ -526,6 +569,19 @@ struct sock *__udp4_lib_lookup(struct net *net, __be32 saddr,
 	result = udp4_lib_lookup2(net, saddr, sport,
 				  htonl(INADDR_ANY), hnum, dif, sdif,
 				  hslot2, skb);
+	if (!IS_ERR_OR_NULL(result))
+		goto done;
+
+	/* Primary hash (destination port) lookup as fallback for this race:
+	 *   1. __ip4_datagram_connect() sets sk_rcv_saddr
+	 *   2. lookup (this function): new sk_rcv_saddr, hashes not updated yet
+	 *   3. rehash operation updating _secondary and four-tuple_ hashes
+	 * The primary hash doesn't need an update after 1., so, thanks to this
+	 * further step, 1. and 3. don't need to be atomic against the lookup.
+	 */
+	result = udp4_lib_lookup1(net, saddr, sport, daddr, hnum, dif, sdif,
+				  udptable);
+
 done:
 	if (IS_ERR(result))
 		return NULL;
diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index 6df2459f25618..8cb969b4d862b 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -162,6 +162,49 @@ static int compute_score(struct sock *sk, struct net *net,
 	return score;
 }
 
+/**
+ * udp6_lib_lookup1() - Simplified lookup using primary hash (destination port)
+ * @net:	Network namespace
+ * @saddr:	Source address, network order
+ * @sport:	Source port, network order
+ * @daddr:	Destination address, network order
+ * @hnum:	Destination port, host order
+ * @dif:	Destination interface index
+ * @sdif:	Destination bridge port index, if relevant
+ * @udptable:	Set of UDP hash tables
+ *
+ * Simplified lookup to be used as fallback if no sockets are found due to a
+ * potential race between (receive) address change, and lookup happening before
+ * the rehash operation. This function ignores SO_REUSEPORT groups while scoring
+ * result sockets, because if we have one, we don't need the fallback at all.
+ *
+ * Called under rcu_read_lock().
+ *
+ * Return: socket with highest matching score if any, NULL if none
+ */
+static struct sock *udp6_lib_lookup1(struct net *net,
+				     const struct in6_addr *saddr, __be16 sport,
+				     const struct in6_addr *daddr,
+				     unsigned int hnum, int dif, int sdif,
+				     const struct udp_table *udptable)
+{
+	unsigned int slot = udp_hashfn(net, hnum, udptable->mask);
+	struct udp_hslot *hslot = &udptable->hash[slot];
+	struct sock *sk, *result = NULL;
+	int score, badness = 0;
+
+	sk_for_each_rcu(sk, &hslot->head) {
+		score = compute_score(sk, net,
+				      saddr, sport, daddr, hnum, dif, sdif);
+		if (score > badness) {
+			result = sk;
+			badness = score;
+		}
+	}
+
+	return result;
+}
+
 /* called with rcu_read_lock() */
 static struct sock *udp6_lib_lookup2(struct net *net,
 		const struct in6_addr *saddr, __be16 sport,
@@ -266,6 +309,13 @@ struct sock *__udp6_lib_lookup(struct net *net,
 	result = udp6_lib_lookup2(net, saddr, sport,
 				  &in6addr_any, hnum, dif, sdif,
 				  hslot2, skb);
+	if (!IS_ERR_OR_NULL(result))
+		goto done;
+
+	/* Cover address change/lookup/rehash race: see __udp4_lib_lookup() */
+	result = udp6_lib_lookup1(net, saddr, sport, daddr, hnum, dif, sdif,
+				  udptable);
+
 done:
 	if (IS_ERR(result))
 		return NULL;
-- 
2.53.0



