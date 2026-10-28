Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793209565;
	b=0ZdTARGBuGhzm5qUCzjgyn03IkkTyfVZXEIbHYls0CuLXRnc0yw+9R0sDX5ZdSVK3KqJ
	 /BpSP4OnVJsN3vyvEi22PlxwMp7AN7DCp/bwIW/VnLofMU855r5ru2D8suWxwbsibitYZ
	 I2Vr1NA4LzYDYVrBA8H5mc746U6v4T4oLr5TLy3eFCAiyfRo+vdWLu1um5mChZw+f8kBs
	 JuOtV7skS/g2hHO9KkZo2+5XFDPC6hZLwr9eqQR4/4b94tAdTcbGeYHbYXHZnEocZOLH+
	 iEj3KRuUMoOluINExaTspbm4wNfbvWECzJKxJHTEznk08Jgm9tK6iCma7ck1sT+T4lg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793209565;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tm9coUt8jdhNC0XwijNIYd+RPn1Y61U6hfbOzodh0Ss=;
	b=09etXaZg10EXNHIfCLxrEr4k18YXASRiPYeuaCg//rwUcKhyIQXWutww9ASppyLWqQTc
	 B2LtzH9qGnzSsGqw1w5sI7FrTLRizGJut96GNw8Xx62HbA9kxeRLxXDgWbzTCMRjRq418
	 9rfR5M2ezF34IFlAqANSQXFHeoznfRx9WWOCWd+0r44FpEbedk408+Ye6GjsltzQuv59e
	 tIOipDWcNHmD75WVbwn12hIoy0No71+inF/Ad5wu5lcXaiIsTNzf1Ox8l/qh5KppbhiQ8
	 wO3FnCsQxPEE+2GkDQP/vf1GNZY6apvW+fsFp92PRbu7hexeTgR02Ee6OLgc7/Z2x6A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=azqzJxzI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 955A3606A31D;
	Wed, 28 Oct 2026 17:46:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=azqzJxzI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E64131F01825;
	Wed, 28 Oct 2026 17:46:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793209565;
	bh=tm9coUt8jdhNC0XwijNIYd+RPn1Y61U6hfbOzodh0Ss=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=azqzJxzIN9Vd2+LcRlDf3p007sTsGQ0VBix8r7wuiCQNkNVjmcCFuoPhLfT4l5LZZ
	 QO/9RwqvXLSisTPW1ekC0VsG8tUdqW+cc4ZPGrsv5KOUGWJlvzumCB0QVVuCe67Txt
	 FeW7no87ulrOMs6VtgtHPcPKCzYCvHVFLBMZ8YXY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vega <vega@nebusec.ai>,
	Zihan Xi <zihanx@nebusec.ai>,
	Eric Dumazet <edumazet@google.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 473/516] ipv4: avoid divide by zero in fib_rebalance
Date: Wed, 28 Oct 2026 18:00:25 +0100
Message-ID: <20261028170014.687165675@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zihan Xi <zihanx@nebusec.ai>

commit 5046d2880fec7d49ebed2fd2866747ee1d06ad71 upstream.

fib_rebalance() computes the total eligible nexthop weight in one pass
and programs upper bounds in a second pass. A concurrent change to
ignore_routes_with_linkdown can make the first pass return zero while
the second pass sees an eligible nexthop, resulting in division by zero.

If the first pass reports a zero total, set each nexthop upper bound to
-1 and skip the division. This matches the IPv6 fix in commit
d2c26c2911dd ("ipv6: avoid divide by zero in rt6_multipath_rebalance")
and preserves the lock-free rebalance path.

Fixes: 0e884c78ee19 ("ipv4: L3 hash-based multipath")
Cc: stable@vger.kernel.org
Reported-by: Vega <vega@nebusec.ai>
Signed-off-by: Zihan Xi <zihanx@nebusec.ai>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Link: https://patch.msgid.link/20260827182514.4667-2-zihanx@nebusec.ai
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/fib_semantics.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/ipv4/fib_semantics.c
+++ b/net/ipv4/fib_semantics.c
@@ -851,7 +851,7 @@ static void fib_rebalance(struct fib_inf
 	change_nexthops(fi) {
 		int upper_bound;
 
-		if (nexthop_nh->fib_nh_flags & RTNH_F_DEAD) {
+		if (!total || nexthop_nh->fib_nh_flags & RTNH_F_DEAD) {
 			upper_bound = -1;
 		} else if (ip_ignore_linkdown(nexthop_nh->fib_nh_dev) &&
 			   nexthop_nh->fib_nh_flags & RTNH_F_LINKDOWN) {


