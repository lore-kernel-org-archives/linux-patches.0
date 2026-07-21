Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50C5A38399A;
	Tue, 21 Jul 2026 17:16:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654183; cv=none; b=CA4QGgJRZ7NbIRfl98drss2JAWVxn3urI3O7B/9IcGUZzAq8/PfvgqMQVJa6I1o8HJ1K1YlytN8JAk83sIkVW2/BpQmJu/6OSeRuRJOWiwvT2P+F4US1phm6+fKa7JsvG+ratcPtdMhhJWtW5MCNzAs1cvZ8fBRPuRQXaEKfjTk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654183; c=relaxed/simple;
	bh=nzVcsytwyX29GXB2xrnkJihTokUh2rwox4q3e95ag6s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EGXjIr578H/pV/mt9qEz+JIlFrXJp5fTiU6D4N+XdxYkqICxFip+huuOObD1bYE6gxGQhfRLT6/4IRCsxuAisM1ZXsRexm2PHPTp9OtrdjZc7Dg8CAXGanpJDyXdnl+yhMFcR07au+vMQwZrgcGJug2E8kVZL2Qjtrmv2U9zpaY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OwWeXLuD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OwWeXLuD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7D6A1F000E9;
	Tue, 21 Jul 2026 17:16:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784654182;
	bh=I0D4AHt/KvMPeh3cLyY5vQhrOfuSc6q/RlGKshe1KDY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OwWeXLuDpwlW1Lx9dmmJMAg/Ul17aNemrslYP87z8lvc/jJfUfhzABbN+m7fRl3wx
	 SJFzJVAbSBQrnPKts3wLJ80s2hvlAS59HjNGwmBz/DGda2HxjBKMUc2NAu42UWucR2
	 0YbS2C4P1yvSkfdTef5f4oY7qiPX7V5Z3zsiqvfM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ren Wei <n05ec@lzu.edu.cn>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>
Subject: [PATCH 7.1 1606/2077] netfilter: nf_conntrack_sip: validate skb_dst() before accessing it
Date: Tue, 21 Jul 2026 17:21:19 +0200
Message-ID: <20260721152630.648518965@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pablo Neira Ayuso <pablo@netfilter.org>

commit e5e24a365a5e024efef63cc49abb345fbd4852c5 upstream.

tc ingress and openvswitch do not guarantee routing information to be
available. These subsystems use the conntrack helper infrastructure, and
the SIP helper relies on the skb_dst() to be present if
sip_external_media is set to 1 (which is disabled by default as a module
parameter).

This effectively disables the sip_external_media toggle for these
subsystems without resulting in a crash.

Fixes: cae3a2627520 ("openvswitch: Allow attaching helpers to ct action")
Fixes: b57dc7c13ea9 ("net/sched: Introduce action ct")
Cc: stable@vger.kernel.org
Reported-by: Ren Wei <n05ec@lzu.edu.cn>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/nf_conntrack_sip.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/net/netfilter/nf_conntrack_sip.c
+++ b/net/netfilter/nf_conntrack_sip.c
@@ -956,7 +956,6 @@ static int set_expected_rtp_rtcp(struct
 			return NF_ACCEPT;
 		saddr = &ct->tuplehash[!dir].tuple.src.u3;
 	} else if (sip_external_media) {
-		struct net_device *dev = skb_dst(skb)->dev;
 		struct dst_entry *dst = NULL;
 		struct flowi fl;
 
@@ -978,7 +977,11 @@ static int set_expected_rtp_rtcp(struct
 		 * through the same interface as the signalling peer.
 		 */
 		if (dst) {
-			bool external_media = (dst->dev == dev);
+			const struct dst_entry *this_dst = skb_dst(skb);
+			bool external_media = false;
+
+			if (this_dst && dst->dev == this_dst->dev)
+				external_media = true;
 
 			dst_release(dst);
 			if (external_media)


