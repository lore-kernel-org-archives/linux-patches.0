Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 756BE3E0C70;
	Wed, 20 May 2026 17:25:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779297939; cv=none; b=mZuEERq9rZSFJv/jxizPSX5oE3itT/L2UlzwigQrT3ZqYXr/KPqJLs6DRaYa27thK5u4AdxMCMyxanbOggBPhpG88g5hwbl94WGDkHiRzdpSVQxWivGvcijrRY9RQaZypRuErngbsbMy5sVxsPN/4XHAAFKw0i2+HEhpu4cHEpM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779297939; c=relaxed/simple;
	bh=VaMPpjVotzqZAjvOgfFVh9DQhUDLA6LENbf/e8mdkQU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iN73TrIw+6e+keq7FlsTB0YzChzAJVTdLINfHmwSbIAI2aukp/TlEcbTfVaCThFd20fL/gdyGp8ehp+nyj/GavpAUQLPYmpEXPhih+MV9Uev8TTd6gF5qq45SFIvCdBuMNF2tOfdfyZexlaTtHT8fxUwy8IGKi+P8esAgcbk2Z8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OFOpszIK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OFOpszIK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DACA31F000E9;
	Wed, 20 May 2026 17:25:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779297938;
	bh=AzeqqNlGBfiL2xyHI9fFFFW1qg0PO02oXz6OxBJNMbs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OFOpszIK5+TthOXtYvf7543HkctZIFb26qLSfCgNvwnbi34Ivz4hPJeo4r97GB6Ke
	 wRXaESJRdx7tIxFStidL1gDypRNRPVWcRm2WEi/7uZpPiVxxtf3nOk6wq1pf1j7Lhm
	 rVTZMHS7MNL97S1cb7eY5UuAxsG8FweNHX6WDAbU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Willem de Bruijn <willemb@google.com>,
	Gabriel Krisman Bertazi <krisman@suse.de>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 180/957] udp: Force compute_score to always inline
Date: Wed, 20 May 2026 18:11:03 +0200
Message-ID: <20260520162138.457981088@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gabriel Krisman Bertazi <krisman@suse.de>

[ Upstream commit b80a95ccf1604a882bb153c45ccb4056e44c8edb ]

Back in 2024 I reported a 7-12% regression on an iperf3 UDP loopback
thoughput test that we traced to the extra overhead of calling
compute_score on two places, introduced by commit f0ea27e7bfe1 ("udp:
re-score reuseport groups when connected sockets are present").  At the
time, I pointed out the overhead was caused by the multiple calls,
associated with cpu-specific mitigations, and merged commit
50aee97d1511 ("udp: Avoid call to compute_score on multiple sites") to
jump back explicitly, to force the rescore call in a single place.

Recently though, we got another regression report against a newer distro
version, which a team colleague traced back to the same root-cause.
Turns out that once we updated to gcc-13, the compiler got smart enough
to unroll the loop, undoing my previous mitigation.  Let's bite the
bullet and __always_inline compute_score on both ipv4 and ipv6 to
prevent gcc from de-optimizing it again in the future.  These functions
are only called in two places each, udpX_lib_lookup1 and
udpX_lib_lookup2, so the extra size shouldn't be a problem and it is hot
enough to be very visible in profilings.  In fact, with gcc13, forcing
the inline will prevent gcc from unrolling the fix from commit
50aee97d1511, so we don't end up increasing udpX_lib_lookup2 at all.

I haven't recollected the results myself, as I don't have access to the
machine at the moment.  But the same colleague reported 4.67%
inprovement with this patch in the loopback benchmark, solving the
regression report within noise margins.

Eric Dumazet reported no size change to vmlinux when built with clang.
I report the same also with gcc-13:

scripts/bloat-o-meter vmlinux vmlinux-inline
add/remove: 0/2 grow/shrink: 4/0 up/down: 616/-416 (200)
Function                                     old     new   delta
udp6_lib_lookup2                             762     949    +187
__udp6_lib_lookup                            810     975    +165
udp4_lib_lookup2                             757     906    +149
__udp4_lib_lookup                            871     986    +115
__pfx_compute_score                           32       -     -32
compute_score                                384       -    -384
Total: Before=35011784, After=35011984, chg +0.00%

Fixes: 50aee97d1511 ("udp: Avoid call to compute_score on multiple sites")
Reviewed-by: Eric Dumazet <edumazet@google.com>
Acked-by: Willem de Bruijn <willemb@google.com>
Signed-off-by: Gabriel Krisman Bertazi <krisman@suse.de>
Link: https://patch.msgid.link/20260410155936.654915-1-krisman@suse.de
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/udp.c | 12 ++++++------
 net/ipv6/udp.c | 13 +++++++------
 2 files changed, 13 insertions(+), 12 deletions(-)

diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index de0deded74f0a..a55642a42e82f 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -365,10 +365,10 @@ int udp_v4_get_port(struct sock *sk, unsigned short snum)
 	return udp_lib_get_port(sk, snum, hash2_nulladdr);
 }
 
-static int compute_score(struct sock *sk, const struct net *net,
-			 __be32 saddr, __be16 sport,
-			 __be32 daddr, unsigned short hnum,
-			 int dif, int sdif)
+static __always_inline int
+compute_score(struct sock *sk, const struct net *net,
+	      __be32 saddr, __be16 sport, __be32 daddr,
+	      unsigned short hnum, int dif, int sdif)
 {
 	int score;
 	struct inet_sock *inet;
@@ -508,8 +508,8 @@ static struct sock *udp4_lib_lookup2(const struct net *net,
 				continue;
 
 			/* compute_score is too long of a function to be
-			 * inlined, and calling it again here yields
-			 * measurable overhead for some
+			 * inlined twice here, and calling it uninlined
+			 * here yields measurable overhead for some
 			 * workloads. Work around it by jumping
 			 * backwards to rescore 'result'.
 			 */
diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index 813a2ba75824d..d47b4f5ac8705 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -127,10 +127,11 @@ void udp_v6_rehash(struct sock *sk)
 	udp_lib_rehash(sk, new_hash, new_hash4);
 }
 
-static int compute_score(struct sock *sk, const struct net *net,
-			 const struct in6_addr *saddr, __be16 sport,
-			 const struct in6_addr *daddr, unsigned short hnum,
-			 int dif, int sdif)
+static __always_inline int
+compute_score(struct sock *sk, const struct net *net,
+	      const struct in6_addr *saddr, __be16 sport,
+	      const struct in6_addr *daddr, unsigned short hnum,
+	      int dif, int sdif)
 {
 	int bound_dev_if, score;
 	struct inet_sock *inet;
@@ -260,8 +261,8 @@ static struct sock *udp6_lib_lookup2(const struct net *net,
 				continue;
 
 			/* compute_score is too long of a function to be
-			 * inlined, and calling it again here yields
-			 * measurable overhead for some
+			 * inlined twice here, and calling it uninlined
+			 * here yields measurable overhead for some
 			 * workloads. Work around it by jumping
 			 * backwards to rescore 'result'.
 			 */
-- 
2.53.0



