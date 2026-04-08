Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2107A3D669E;
	Wed,  8 Apr 2026 18:43:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775673818; cv=none; b=ZuVZhpG5oiIb7haL6+PGHbV6jOKN7zia7HdbJnm49ec3NjuTGzugfmFn58OEEqBSwVn9ljRhudo+/qexFoftWTIDEzlKEJDeiN8lwRD3yWg688cjBXNeRbGe/7lvxtVeHkMwhrOfFq9FfSg4hf3r5iPjUI5wruz4ffgRdTMIOp0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775673818; c=relaxed/simple;
	bh=QMOo+7BPyldoq6n0mbGm+xoBlpooxWqvzbjm34dZRIA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qdgtgGPYL5yhq+6lG4YltfPMSPkqdzeP7qDP34WfB7JWTnnniJ3ZX5hX4kdG0eNp2E2B6aL1KP3NOjII9GUR6WUE7KJcJ0xV10BB0e75OaceAkCl9pQuy/mSPtw8T27CUICXrpsaiv+ygq58WWs0jWK7n3UF2y+Pr3p+64vtgnI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NAbKA9lo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NAbKA9lo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC391C19421;
	Wed,  8 Apr 2026 18:43:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775673818;
	bh=QMOo+7BPyldoq6n0mbGm+xoBlpooxWqvzbjm34dZRIA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NAbKA9lo+d3Pc5KXH/gra4wBk7seNJEsSsevPk6oH2q2yboAv2jNUV4hRr2qQLFIf
	 GUm3IBofkDDBD6axFHYXWZxn70RToGF6jNq7rDuTUojRtQnMBxPS37SdKLzFNmML5X
	 MBe0o+n/yXpdrzSKgEXr2dUmB8NAOfJrvmq9IUbM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yiming Qian <yimingqian591@gmail.com>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 100/242] ipv6: avoid overflows in ip6_datagram_send_ctl()
Date: Wed,  8 Apr 2026 20:02:20 +0200
Message-ID: <20260408175930.827146422@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175927.064985309@linuxfoundation.org>
References: <20260408175927.064985309@linuxfoundation.org>
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

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 4e453375561fc60820e6b9d8ebeb6b3ee177d42e ]

Yiming Qian reported :
<quote>
 I believe I found a locally triggerable kernel bug in the IPv6 sendmsg
 ancillary-data path that can panic the kernel via `skb_under_panic()`
 (local DoS).

 The core issue is a mismatch between:

 - a 16-bit length accumulator (`struct ipv6_txoptions::opt_flen`, type
 `__u16`) and
 - a pointer to the *last* provided destination-options header (`opt->dst1opt`)

 when multiple `IPV6_DSTOPTS` control messages (cmsgs) are provided.

 - `include/net/ipv6.h`:
   - `struct ipv6_txoptions::opt_flen` is `__u16` (wrap possible).
 (lines 291-307, especially 298)
 - `net/ipv6/datagram.c:ip6_datagram_send_ctl()`:
   - Accepts repeated `IPV6_DSTOPTS` and accumulates into `opt_flen`
 without rejecting duplicates. (lines 909-933)
 - `net/ipv6/ip6_output.c:__ip6_append_data()`:
   - Uses `opt->opt_flen + opt->opt_nflen` to compute header
 sizes/headroom decisions. (lines 1448-1466, especially 1463-1465)
 - `net/ipv6/ip6_output.c:__ip6_make_skb()`:
   - Calls `ipv6_push_frag_opts()` if `opt->opt_flen` is non-zero.
 (lines 1930-1934)
 - `net/ipv6/exthdrs.c:ipv6_push_frag_opts()` / `ipv6_push_exthdr()`:
   - Push size comes from `ipv6_optlen(opt->dst1opt)` (based on the
 pointed-to header). (lines 1179-1185 and 1206-1211)

 1. `opt_flen` is a 16-bit accumulator:

 - `include/net/ipv6.h:298` defines `__u16 opt_flen; /* after fragment hdr */`.

 2. `ip6_datagram_send_ctl()` accepts *repeated* `IPV6_DSTOPTS` cmsgs
 and increments `opt_flen` each time:

 - In `net/ipv6/datagram.c:909-933`, for `IPV6_DSTOPTS`:
   - It computes `len = ((hdr->hdrlen + 1) << 3);`
   - It checks `CAP_NET_RAW` using `ns_capable(net->user_ns,
 CAP_NET_RAW)`. (line 922)
   - Then it does:
     - `opt->opt_flen += len;` (line 927)
     - `opt->dst1opt = hdr;` (line 928)

 There is no duplicate rejection here (unlike the legacy
 `IPV6_2292DSTOPTS` path which rejects duplicates at
 `net/ipv6/datagram.c:901-904`).

 If enough large `IPV6_DSTOPTS` cmsgs are provided, `opt_flen` wraps
 while `dst1opt` still points to a large (2048-byte)
 destination-options header.

 In the attached PoC (`poc.c`):

 - 32 cmsgs with `hdrlen=255` => `len = (255+1)*8 = 2048`
 - 1 cmsg with `hdrlen=0` => `len = 8`
 - Total increment: `32*2048 + 8 = 65544`, so `(__u16)opt_flen == 8`
 - The last cmsg is 2048 bytes, so `dst1opt` points to a 2048-byte header.

 3. The transmit path sizes headers using the wrapped `opt_flen`:

- In `net/ipv6/ip6_output.c:1463-1465`:
  - `headersize = sizeof(struct ipv6hdr) + (opt ? opt->opt_flen +
 opt->opt_nflen : 0) + ...;`

 With wrapped `opt_flen`, `headersize`/headroom decisions underestimate
 what will be pushed later.

 4. When building the final skb, the actual push length comes from
 `dst1opt` and is not limited by wrapped `opt_flen`:

 - In `net/ipv6/ip6_output.c:1930-1934`:
   - `if (opt->opt_flen) proto = ipv6_push_frag_opts(skb, opt, proto);`
 - In `net/ipv6/exthdrs.c:1206-1211`, `ipv6_push_frag_opts()` pushes
 `dst1opt` via `ipv6_push_exthdr()`.
 - In `net/ipv6/exthdrs.c:1179-1184`, `ipv6_push_exthdr()` does:
   - `skb_push(skb, ipv6_optlen(opt));`
   - `memcpy(h, opt, ipv6_optlen(opt));`

 With insufficient headroom, `skb_push()` underflows and triggers
 `skb_under_panic()` -> `BUG()`:

 - `net/core/skbuff.c:2669-2675` (`skb_push()` calls `skb_under_panic()`)
 - `net/core/skbuff.c:207-214` (`skb_panic()` ends in `BUG()`)

 - The `IPV6_DSTOPTS` cmsg path requires `CAP_NET_RAW` in the target
 netns user namespace (`ns_capable(net->user_ns, CAP_NET_RAW)`).
 - Root (or any task with `CAP_NET_RAW`) can trigger this without user
 namespaces.
 - An unprivileged `uid=1000` user can trigger this if unprivileged
 user namespaces are enabled and it can create a userns+netns to obtain
 namespaced `CAP_NET_RAW` (the attached PoC does this).

 - Local denial of service: kernel BUG/panic (system crash).
 - Reproducible with a small userspace PoC.
</quote>

This patch does not reject duplicated options, as this might break
some user applications.

Instead, it makes sure to adjust opt_flen and opt_nflen to correctly
reflect the size of the current option headers, preventing the overflows
and the potential for panics.

This applies to IPV6_DSTOPTS, IPV6_HOPOPTS, and IPV6_RTHDR.

Specifically:

When a new IPV6_DSTOPTS is processed, the length of the old opt->dst1opt
is subtracted from opt->opt_flen before adding the new length.

When a new IPV6_HOPOPTS is processed, the length of the old opt->dst0opt
is subtracted from opt->opt_nflen.

When a new Routing Header (IPV6_RTHDR or IPV6_2292RTHDR) is processed,
the length of the old opt->srcrt is subtracted from opt->opt_nflen.

In the special case within IPV6_2292RTHDR handling where dst1opt is moved
to dst0opt, the length of the old opt->dst0opt is subtracted from
opt->opt_nflen before the new one is added.

Fixes: 333fad5364d6 ("[IPV6]: Support several new sockopt / ancillary data in Advanced API (RFC3542).")
Reported-by: Yiming Qian <yimingqian591@gmail.com>
Closes: https://lore.kernel.org/netdev/CAL_bE8JNzawgr5OX5m+3jnQDHry2XxhQT5=jThW1zDPtUikRYA@mail.gmail.com/
Signed-off-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20260401154721.3740056-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/datagram.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/net/ipv6/datagram.c b/net/ipv6/datagram.c
index fff78496803da..9a83f658cd892 100644
--- a/net/ipv6/datagram.c
+++ b/net/ipv6/datagram.c
@@ -762,6 +762,7 @@ int ip6_datagram_send_ctl(struct net *net, struct sock *sk,
 {
 	struct in6_pktinfo *src_info;
 	struct cmsghdr *cmsg;
+	struct ipv6_rt_hdr *orthdr;
 	struct ipv6_rt_hdr *rthdr;
 	struct ipv6_opt_hdr *hdr;
 	struct ipv6_txoptions *opt = ipc6->opt;
@@ -923,9 +924,13 @@ int ip6_datagram_send_ctl(struct net *net, struct sock *sk,
 				goto exit_f;
 			}
 			if (cmsg->cmsg_type == IPV6_DSTOPTS) {
+				if (opt->dst1opt)
+					opt->opt_flen -= ipv6_optlen(opt->dst1opt);
 				opt->opt_flen += len;
 				opt->dst1opt = hdr;
 			} else {
+				if (opt->dst0opt)
+					opt->opt_nflen -= ipv6_optlen(opt->dst0opt);
 				opt->opt_nflen += len;
 				opt->dst0opt = hdr;
 			}
@@ -968,12 +973,17 @@ int ip6_datagram_send_ctl(struct net *net, struct sock *sk,
 				goto exit_f;
 			}
 
+			orthdr = opt->srcrt;
+			if (orthdr)
+				opt->opt_nflen -= ((orthdr->hdrlen + 1) << 3);
 			opt->opt_nflen += len;
 			opt->srcrt = rthdr;
 
 			if (cmsg->cmsg_type == IPV6_2292RTHDR && opt->dst1opt) {
 				int dsthdrlen = ((opt->dst1opt->hdrlen+1)<<3);
 
+				if (opt->dst0opt)
+					opt->opt_nflen -= ipv6_optlen(opt->dst0opt);
 				opt->opt_nflen += dsthdrlen;
 				opt->dst0opt = opt->dst1opt;
 				opt->dst1opt = NULL;
-- 
2.53.0



