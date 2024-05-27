Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF3EE15FD01;
	Mon, 27 May 2024 19:04:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716836687; cv=none; b=twRtboQ6J/aBqEZrATAm1kdW7rJb7ATg9Z2E9E+ZkEPlt2JwvmtIgf+MvpKXv0eJyggZ/5aZ9M+wpBT7je7LQkOshJ/7hD9jcRN8d28nPhkfMlVn2uozHDMnRVknUPPh+pWa3JRioLW4OEcR0TOpATHQleEW5M5fCEbwoX+j4J0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716836687; c=relaxed/simple;
	bh=P0mFxoWDVMjK1OE6pMyZIproFT8UC18H0cHnqzVQq74=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=onfxuIxz2hl3xwvK7ajH4oKQfkNdlGkZIKqMpGC/g6WMqtp4sD7yJ/nw/B47UGrF8dDJH9PfqTgBHvr3bEll19A8ukDhlQqIaDRoL+pOYmmitDGBL5jc+DQomxADbYWVNCqzL4YZRW5cJH5RvN0ZuOdq6pZbelkJNu3zYMX8hoM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wbDf1b3o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wbDf1b3o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 662D8C2BBFC;
	Mon, 27 May 2024 19:04:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716836687;
	bh=P0mFxoWDVMjK1OE6pMyZIproFT8UC18H0cHnqzVQq74=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wbDf1b3oNebrVwOfWKLdvbzzEbHejuuZEAtCN/TCoJ49zvq0XAjmnGoy5/m4JGe/P
	 Ke1Xxo+Em8FgEo6wRIP09UW05KO2GxP0OlDO65Ha3cs7PMcvhr53ERh6hnw3Owzy2e
	 5rkiBWsF0y1psoPdVJQRb1dt9p/b5QD13Ptpdw6I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenz Bauer <lmb@isovalent.com>,
	Gabriel Krisman Bertazi <krisman@suse.de>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Willem de Bruijn <willemb@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 150/427] udp: Avoid call to compute_score on multiple sites
Date: Mon, 27 May 2024 20:53:17 +0200
Message-ID: <20240527185616.301148120@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185601.713589927@linuxfoundation.org>
References: <20240527185601.713589927@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gabriel Krisman Bertazi <krisman@suse.de>

[ Upstream commit 50aee97d15113b95a68848db1f0cb2a6c09f753a ]

We've observed a 7-12% performance regression in iperf3 UDP ipv4 and
ipv6 tests with multiple sockets on Zen3 cpus, which we traced back to
commit f0ea27e7bfe1 ("udp: re-score reuseport groups when connected
sockets are present").  The failing tests were those that would spawn
UDP sockets per-cpu on systems that have a high number of cpus.

Unsurprisingly, it is not caused by the extra re-scoring of the reused
socket, but due to the compiler no longer inlining compute_score, once
it has the extra call site in udp4_lib_lookup2.  This is augmented by
the "Safe RET" mitigation for SRSO, needed in our Zen3 cpus.

We could just explicitly inline it, but compute_score() is quite a large
function, around 300b.  Inlining in two sites would almost double
udp4_lib_lookup2, which is a silly thing to do just to workaround a
mitigation.  Instead, this patch shuffles the code a bit to avoid the
multiple calls to compute_score.  Since it is a static function used in
one spot, the compiler can safely fold it in, as it did before, without
increasing the text size.

With this patch applied I ran my original iperf3 testcases.  The failing
cases all looked like this (ipv4):
	iperf3 -c 127.0.0.1 --udp -4 -f K -b $R -l 8920 -t 30 -i 5 -P 64 -O 2

where $R is either 1G/10G/0 (max, unlimited).  I ran 3 times each.
baseline is v6.9-rc3. harmean == harmonic mean; CV == coefficient of
variation.

ipv4:
                 1G                10G                  MAX
	    HARMEAN  (CV)      HARMEAN  (CV)    HARMEAN     (CV)
baseline 1743852.66(0.0208) 1725933.02(0.0167) 1705203.78(0.0386)
patched  1968727.61(0.0035) 1962283.22(0.0195) 1923853.50(0.0256)

ipv6:
                 1G                10G                  MAX
	    HARMEAN  (CV)      HARMEAN  (CV)    HARMEAN     (CV)
baseline 1729020.03(0.0028) 1691704.49(0.0243) 1692251.34(0.0083)
patched  1900422.19(0.0067) 1900968.01(0.0067) 1568532.72(0.1519)

This restores the performance we had before the change above with this
benchmark.  We obviously don't expect any real impact when mitigations
are disabled, but just to be sure it also doesn't regresses:

mitigations=off ipv4:
                 1G                10G                  MAX
	    HARMEAN  (CV)      HARMEAN  (CV)    HARMEAN     (CV)
baseline 3230279.97(0.0066) 3229320.91(0.0060) 2605693.19(0.0697)
patched  3242802.36(0.0073) 3239310.71(0.0035) 2502427.19(0.0882)

Cc: Lorenz Bauer <lmb@isovalent.com>
Fixes: f0ea27e7bfe1 ("udp: re-score reuseport groups when connected sockets are present")
Signed-off-by: Gabriel Krisman Bertazi <krisman@suse.de>
Reviewed-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/udp.c | 21 ++++++++++++++++-----
 net/ipv6/udp.c | 20 ++++++++++++++++----
 2 files changed, 32 insertions(+), 9 deletions(-)

diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index b32cf2eeeb41d..b5ad0c527c521 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -427,15 +427,21 @@ static struct sock *udp4_lib_lookup2(struct net *net,
 {
 	struct sock *sk, *result;
 	int score, badness;
+	bool need_rescore;
 
 	result = NULL;
 	badness = 0;
 	udp_portaddr_for_each_entry_rcu(sk, &hslot2->head) {
-		score = compute_score(sk, net, saddr, sport,
-				      daddr, hnum, dif, sdif);
+		need_rescore = false;
+rescore:
+		score = compute_score(need_rescore ? result : sk, net, saddr,
+				      sport, daddr, hnum, dif, sdif);
 		if (score > badness) {
 			badness = score;
 
+			if (need_rescore)
+				continue;
+
 			if (sk->sk_state == TCP_ESTABLISHED) {
 				result = sk;
 				continue;
@@ -456,9 +462,14 @@ static struct sock *udp4_lib_lookup2(struct net *net,
 			if (IS_ERR(result))
 				continue;
 
-			badness = compute_score(result, net, saddr, sport,
-						daddr, hnum, dif, sdif);
-
+			/* compute_score is too long of a function to be
+			 * inlined, and calling it again here yields
+			 * measureable overhead for some
+			 * workloads. Work around it by jumping
+			 * backwards to rescore 'result'.
+			 */
+			need_rescore = true;
+			goto rescore;
 		}
 	}
 	return result;
diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index 8f7aa8bac1e7b..e0dd5bc2b30eb 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -168,15 +168,21 @@ static struct sock *udp6_lib_lookup2(struct net *net,
 {
 	struct sock *sk, *result;
 	int score, badness;
+	bool need_rescore;
 
 	result = NULL;
 	badness = -1;
 	udp_portaddr_for_each_entry_rcu(sk, &hslot2->head) {
-		score = compute_score(sk, net, saddr, sport,
-				      daddr, hnum, dif, sdif);
+		need_rescore = false;
+rescore:
+		score = compute_score(need_rescore ? result : sk, net, saddr,
+				      sport, daddr, hnum, dif, sdif);
 		if (score > badness) {
 			badness = score;
 
+			if (need_rescore)
+				continue;
+
 			if (sk->sk_state == TCP_ESTABLISHED) {
 				result = sk;
 				continue;
@@ -197,8 +203,14 @@ static struct sock *udp6_lib_lookup2(struct net *net,
 			if (IS_ERR(result))
 				continue;
 
-			badness = compute_score(sk, net, saddr, sport,
-						daddr, hnum, dif, sdif);
+			/* compute_score is too long of a function to be
+			 * inlined, and calling it again here yields
+			 * measureable overhead for some
+			 * workloads. Work around it by jumping
+			 * backwards to rescore 'result'.
+			 */
+			need_rescore = true;
+			goto rescore;
 		}
 	}
 	return result;
-- 
2.43.0



