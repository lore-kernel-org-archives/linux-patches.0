Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3664C471271;
	Tue, 21 Jul 2026 18:15:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784657724; cv=none; b=CIO5GSmTXiEqdo5flSPsE2Jz3b0zqslziXt9r8DtQzK1NaYsSekHfuJ/NjkBs8aJcAL5sYPMalu/Yv1QnLQ/V5WO6pyRv+AqBaaYgRPWbBGLqBcezi/bw+LdOmH5Ll5sddiRfH1Bm1ihCv3AIJ7LXcevdzEOJpBBO0O3gMSIK4M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784657724; c=relaxed/simple;
	bh=217PbT4W9uLr7HGBHW24G5G2nFTUR3lgnW20TbSw6/E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DZkrysH60r+y1UENRixjCjVyDOLSG1NeMqBsQ48Y8vMrofVT5tNyErKQmCeG+DrQHvYiR8bGSC61XDSdjjL75ygXpWUj4WkbjhBz9rNhFuvnR/7PVOHa54F2QHuNSQ5KlKmyaSI3PYlIfWqkFf7e6QkkIUHM6Y6scXT/Uf8DnLU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=itNzFAYN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="itNzFAYN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CE461F000E9;
	Tue, 21 Jul 2026 18:15:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784657723;
	bh=fAzSA+nQ+OIkA2fhQUH/5DB7sho499Gi9Fhk6ablpBE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=itNzFAYNcrkaPEWzKAYUXNKd0yXZItZaOXgRlPq8Px+tkASu1KWaGa9MW5CzRX28D
	 ve7SRGqOf1n93x8A6K7jiG6KGvk3mwvW2/t9EjesgYKwDSECj4IMruIFHtS1EuGeWJ
	 DNXzCjTf8M0runMiTeY0KjB83vLohm1SnVaoy0V0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	Justin Iurman <justin.iurman@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0872/1611] ipv6: ioam: fix type confusion of dst_entry
Date: Tue, 21 Jul 2026 17:16:28 +0200
Message-ID: <20260721152535.005160857@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

From: Jiayuan Chen <jiayuan.chen@linux.dev>

[ Upstream commit 9ed19e11d2146076d117d51a940643990118449b ]

IOAM uses a dummy dst_entry(null_dst) to mark that the destination should
not be changed after the transformation. This dst is stored in the IOAM lwt
state and may be passed to dst_cache_set_ip6().

However, the IPv6 dst cache path eventually calls rt6_get_cookie(), which
treats the dst_entry as part of a struct rt6_info. Since the null_dst was
embedded directly as a struct dst_entry in struct ioam6_lwt, this resulted
in an invalid cast and rt6_get_cookie() reading fields from the wrong
object.

In practice, the wrong cookie is not used while dst->obsolete is zero, but
rt6_get_cookie() may also access per-cpu value when rt->sernum is
zero. In this case, rt->sernum aliases ioam6_lwt::cache::reset_ts, which
can become zero, making this a potential invalid pointer access.

Fix this by embedding a full struct rt6_info for the dummy IPv6 route and
passing its dst member to the dst APIs.

Fixes: 47ce7c854563 ("net: ipv6: ioam6: fix double reallocation")
Signed-off-by: Jiayuan Chen <jiayuan.chen@linux.dev>
Reviewed-by: Justin Iurman <justin.iurman@gmail.com>
Link: https://patch.msgid.link/20260618104336.48934-1-jiayuan.chen@linux.dev
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/ioam6_iptunnel.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/ipv6/ioam6_iptunnel.c b/net/ipv6/ioam6_iptunnel.c
index b9f6d892a566c0..cfb2c41634a0b0 100644
--- a/net/ipv6/ioam6_iptunnel.c
+++ b/net/ipv6/ioam6_iptunnel.c
@@ -35,7 +35,7 @@ struct ioam6_lwt_freq {
 };
 
 struct ioam6_lwt {
-	struct dst_entry null_dst;
+	struct rt6_info null_rt;
 	struct dst_cache cache;
 	struct ioam6_lwt_freq freq;
 	atomic_t pkt_cnt;
@@ -176,7 +176,7 @@ static int ioam6_build_state(struct net *net, struct nlattr *nla,
 	 * it is stored in the cache. Then, +1/-1 each time we read the cache
 	 * and release it. Long story short, we're fine.
 	 */
-	dst_init(&ilwt->null_dst, NULL, NULL, DST_OBSOLETE_NONE, DST_NOCOUNT);
+	dst_init(&ilwt->null_rt.dst, NULL, NULL, DST_OBSOLETE_NONE, DST_NOCOUNT);
 
 	atomic_set(&ilwt->pkt_cnt, 0);
 	ilwt->freq.k = freq_k;
@@ -360,7 +360,7 @@ static int ioam6_output(struct net *net, struct sock *sk, struct sk_buff *skb)
 	/* This is how we notify that the destination does not change after
 	 * transformation and that we need to use orig_dst instead of the cache
 	 */
-	if (dst == &ilwt->null_dst) {
+	if (dst == &ilwt->null_rt.dst) {
 		dst_release(dst);
 
 		dst = orig_dst;
@@ -429,7 +429,7 @@ static int ioam6_output(struct net *net, struct sock *sk, struct sk_buff *skb)
 		local_bh_disable();
 		if (orig_dst->lwtstate == dst->lwtstate)
 			dst_cache_set_ip6(&ilwt->cache,
-					  &ilwt->null_dst, &fl6.saddr);
+					  &ilwt->null_rt.dst, &fl6.saddr);
 		else
 			dst_cache_set_ip6(&ilwt->cache, dst, &fl6.saddr);
 		local_bh_enable();
-- 
2.53.0



