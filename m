Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47612384;
	Thu, 13 Jun 2024 12:42:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718282554; cv=none; b=U1QcQij1zAjQphPyTiJcItVazdJ899+huWkY1IfzOH1IxgDle2vteyouqgVAu1uce9EbmTeyX8ZbLXWphqXt8bBFJ1FIT86RRokDnf4saDH6hV58OGRkHy3DdKlXsJJHnZbaJt6TAFfZJfIH3eFkEt8xgqYBwdr1R4h9jtgAGIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718282554; c=relaxed/simple;
	bh=Uo2GhsOJUkzhvLfpKhaKT8+Go2q3FK3kQnTz3OPIO80=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P219gVEjdkwLyh3v9KeqUY8OhtsEAfWuchD+1SopGppbDAMNDJWUXLhTzMn5vMEIdoin+1habMbqtlpytku5FL6biI++eIEWmL7vTHpv+7NGvYc4RPnxyzvcET8MMNIS7c1q/i/1Xc99mVUColZLN3pv9fq6SBGKm0vjAL+4Qpk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pIx/GaaY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pIx/GaaY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4338C2BBFC;
	Thu, 13 Jun 2024 12:42:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718282554;
	bh=Uo2GhsOJUkzhvLfpKhaKT8+Go2q3FK3kQnTz3OPIO80=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pIx/GaaYHBpFYODAtrcut+sDwWoYPbvKagEwl1CdpSHM1zbrI6SrKLtE5k9pExpx+
	 QSCTVRomMIOXClOE/6NKMhAn5vi0bfSUSS2r+jfnSlXeR2ExnVLlKziUBZmzXVEBNx
	 vindUsYxEfeSd+5uc3fmLDTl9Wmx+fbHnwn1JNNs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrea Mayer <andrea.mayer@uniroma2.it>,
	Simon Horman <horms@kernel.org>,
	David Ahern <dsahern@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 285/402] ipv6: sr: fix missing sk_buff release in seg6_input_core
Date: Thu, 13 Jun 2024 13:34:02 +0200
Message-ID: <20240613113313.271099912@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113302.116811394@linuxfoundation.org>
References: <20240613113302.116811394@linuxfoundation.org>
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

From: Andrea Mayer <andrea.mayer@uniroma2.it>

[ Upstream commit 5447f9708d9e4c17a647b16a9cb29e9e02820bd9 ]

The seg6_input() function is responsible for adding the SRH into a
packet, delegating the operation to the seg6_input_core(). This function
uses the skb_cow_head() to ensure that there is sufficient headroom in
the sk_buff for accommodating the link-layer header.
In the event that the skb_cow_header() function fails, the
seg6_input_core() catches the error but it does not release the sk_buff,
which will result in a memory leak.

This issue was introduced in commit af3b5158b89d ("ipv6: sr: fix BUG due
to headroom too small after SRH push") and persists even after commit
7a3f5b0de364 ("netfilter: add netfilter hooks to SRv6 data plane"),
where the entire seg6_input() code was refactored to deal with netfilter
hooks.

The proposed patch addresses the identified memory leak by requiring the
seg6_input_core() function to release the sk_buff in the event that
skb_cow_head() fails.

Fixes: af3b5158b89d ("ipv6: sr: fix BUG due to headroom too small after SRH push")
Signed-off-by: Andrea Mayer <andrea.mayer@uniroma2.it>
Reviewed-by: Simon Horman <horms@kernel.org>
Reviewed-by: David Ahern <dsahern@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/seg6_iptunnel.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/net/ipv6/seg6_iptunnel.c b/net/ipv6/seg6_iptunnel.c
index e756ba705fd9b..f98bb719190be 100644
--- a/net/ipv6/seg6_iptunnel.c
+++ b/net/ipv6/seg6_iptunnel.c
@@ -327,10 +327,8 @@ static int seg6_input_core(struct net *net, struct sock *sk,
 	int err;
 
 	err = seg6_do_srh(skb);
-	if (unlikely(err)) {
-		kfree_skb(skb);
-		return err;
-	}
+	if (unlikely(err))
+		goto drop;
 
 	slwt = seg6_lwt_lwtunnel(orig_dst->lwtstate);
 
@@ -355,7 +353,7 @@ static int seg6_input_core(struct net *net, struct sock *sk,
 
 	err = skb_cow_head(skb, LL_RESERVED_SPACE(dst->dev));
 	if (unlikely(err))
-		return err;
+		goto drop;
 
 	if (static_branch_unlikely(&nf_hooks_lwtunnel_enabled))
 		return NF_HOOK(NFPROTO_IPV6, NF_INET_LOCAL_OUT,
@@ -363,6 +361,9 @@ static int seg6_input_core(struct net *net, struct sock *sk,
 			       skb_dst(skb)->dev, seg6_input_finish);
 
 	return seg6_input_finish(dev_net(skb->dev), NULL, skb);
+drop:
+	kfree_skb(skb);
+	return err;
 }
 
 static int seg6_input_nf(struct sk_buff *skb)
-- 
2.43.0



