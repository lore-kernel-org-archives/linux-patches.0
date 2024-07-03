Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39979194AFB;
	Wed,  3 Jul 2024 10:59:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720004351; cv=none; b=r7szoUO/XUhngiEQFfw2THRGIBaDe4RxE5Fekcxi2Zro7R4oyiaGXN+D6h7H7dnjbWXi+s9N/T4tSFRrdXGth7Axn5QGWVFAlLDjPrArb+LaeTKnD/M027NppaVTbSCU9GXUtwtcnLc6hNuUtw62mSztdCqMOIeDxECY1TCXa3o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720004351; c=relaxed/simple;
	bh=ga7SraLqxdN6hs+lgncIRBV8UN5pvsj4Fyw2CgYY7xk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HvdxHvBKbUnQha9HOeZSbXCTJjaJYzDbcL+uQLzFWMtmPn91/GxM3YgGq5FJYY0YWrTEuLWK+43YnZ/uJPi0ArCJGZM/ony/cFeOWHM20o0JckRwk9m58yj11KSUook2QaLMqvD1HFiGvrbpiqkbdrlRugYb7B5QsGLHxkaLM1U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bo4YINfG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bo4YINfG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1D4BC32781;
	Wed,  3 Jul 2024 10:59:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720004351;
	bh=ga7SraLqxdN6hs+lgncIRBV8UN5pvsj4Fyw2CgYY7xk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bo4YINfG/sY9DYl6vbmY9g+PMN1Am3KudSxDhgJVyg3fMrklR31K8o1QF7knMornu
	 ZBJiWPEwK4aoRWq3GNBnBL1JF7/J/ua2NoCm2DTO8M+LfipQPNpZjqdFEUpobKyxjP
	 FvpZE3YoQAqDRI0e63kgFqi/I2bLO895b4yOu3mY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	David Lebrun <dlebrun@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 014/290] ipv6: sr: block BH in seg6_output_core() and seg6_input_core()
Date: Wed,  3 Jul 2024 12:36:35 +0200
Message-ID: <20240703102904.728092632@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102904.170852981@linuxfoundation.org>
References: <20240703102904.170852981@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit c0b98ac1cc104f48763cdb27b1e9ac25fd81fc90 ]

As explained in commit 1378817486d6 ("tipc: block BH
before using dst_cache"), net/core/dst_cache.c
helpers need to be called with BH disabled.

Disabling preemption in seg6_output_core() is not good enough,
because seg6_output_core() is called from process context,
lwtunnel_output() only uses rcu_read_lock().

We might be interrupted by a softirq, re-enter seg6_output_core()
and corrupt dst_cache data structures.

Fix the race by using local_bh_disable() instead of
preempt_disable().

Apply a similar change in seg6_input_core().

Fixes: fa79581ea66c ("ipv6: sr: fix several BUGs when preemption is enabled")
Fixes: 6c8702c60b88 ("ipv6: sr: add support for SRH encapsulation and injection with lwtunnels")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: David Lebrun <dlebrun@google.com>
Acked-by: Paolo Abeni <pabeni@redhat.com>
Link: https://lore.kernel.org/r/20240531132636.2637995-4-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/seg6_iptunnel.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/net/ipv6/seg6_iptunnel.c b/net/ipv6/seg6_iptunnel.c
index 40ac23242c378..a73840da34ed9 100644
--- a/net/ipv6/seg6_iptunnel.c
+++ b/net/ipv6/seg6_iptunnel.c
@@ -325,9 +325,8 @@ static int seg6_input(struct sk_buff *skb)
 
 	slwt = seg6_lwt_lwtunnel(orig_dst->lwtstate);
 
-	preempt_disable();
+	local_bh_disable();
 	dst = dst_cache_get(&slwt->cache);
-	preempt_enable();
 
 	skb_dst_drop(skb);
 
@@ -335,14 +334,13 @@ static int seg6_input(struct sk_buff *skb)
 		ip6_route_input(skb);
 		dst = skb_dst(skb);
 		if (!dst->error) {
-			preempt_disable();
 			dst_cache_set_ip6(&slwt->cache, dst,
 					  &ipv6_hdr(skb)->saddr);
-			preempt_enable();
 		}
 	} else {
 		skb_dst_set(skb, dst);
 	}
+	local_bh_enable();
 
 	err = skb_cow_head(skb, LL_RESERVED_SPACE(dst->dev));
 	if (unlikely(err))
@@ -364,9 +362,9 @@ static int seg6_output(struct net *net, struct sock *sk, struct sk_buff *skb)
 
 	slwt = seg6_lwt_lwtunnel(orig_dst->lwtstate);
 
-	preempt_disable();
+	local_bh_disable();
 	dst = dst_cache_get(&slwt->cache);
-	preempt_enable();
+	local_bh_enable();
 
 	if (unlikely(!dst)) {
 		struct ipv6hdr *hdr = ipv6_hdr(skb);
@@ -386,9 +384,9 @@ static int seg6_output(struct net *net, struct sock *sk, struct sk_buff *skb)
 			goto drop;
 		}
 
-		preempt_disable();
+		local_bh_disable();
 		dst_cache_set_ip6(&slwt->cache, dst, &fl6.saddr);
-		preempt_enable();
+		local_bh_enable();
 	}
 
 	skb_dst_drop(skb);
-- 
2.43.0



