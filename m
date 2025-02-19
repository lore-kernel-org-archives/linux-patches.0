Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F3A91E3DC6;
	Wed, 19 Feb 2025 08:56:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739955403; cv=none; b=fIJ2e+Ou6q2xJ460LNZj8/TRdi7ip5gotZ+r5emusuK3cKHbsl8ZsgDT9YgdeaBcYd7TiXqbB8j4F1qZclw1U6sCHJAxnK1VH2HsolkWraWp+y2JBLGvgG0P/7r8B7shvSL/biYJML/iu2AbJAMNDwOCZYjki65rR+lzoCHq8tM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739955403; c=relaxed/simple;
	bh=Z8XA5eMjIwx7Qjr1pb6ldFNkf6xA2XK38UR+O2FVZpc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wo0ol9b2Y98ktBdV7dfYfMiJ6+IjWtxKEG+TYlg44u2f1Bkhr/LG2F57lsDHAI6sPk4WPWHGmUNzE2G4gvNhAoCcWwGYNqBZPtIHv5hJVKyqrjLoYhk0ZJUekYieyverfk6BW6t1z5YoA6SCvnewW49mqfPkjrG1AWM//tQqdPE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hDhCgtKo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hDhCgtKo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3BA7C4CED1;
	Wed, 19 Feb 2025 08:56:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739955403;
	bh=Z8XA5eMjIwx7Qjr1pb6ldFNkf6xA2XK38UR+O2FVZpc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hDhCgtKohlhMF1UF6BQZhVpZubgqGwzT8UHtuQGZ/vax+Dm1xGhRh5fVmp8xC1mL/
	 QlBKZmDTl5rKfBfTHX6oo8qEzzm7seZy/kJCPBCmk2ACWJfLkeN6Fk3+JVIKbKuCQ8
	 WOmwqkXDSmDFpwJnM0jK/nd1h3y7wvWNwTEkms/M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Justin Iurman <justin.iurman@uliege.be>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 225/230] net: ipv6: fix dst refleaks in rpl, seg6 and ioam6 lwtunnels
Date: Wed, 19 Feb 2025 09:29:02 +0100
Message-ID: <20250219082610.488239972@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082601.683263930@linuxfoundation.org>
References: <20250219082601.683263930@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Jakub Kicinski <kuba@kernel.org>

commit c71a192976ded2f2f416d03c4f595cdd4478b825 upstream.

dst_cache_get() gives us a reference, we need to release it.

Discovered by the ioam6.sh test, kmemleak was recently fixed
to catch per-cpu memory leaks.

Fixes: 985ec6f5e623 ("net: ipv6: rpl_iptunnel: mitigate 2-realloc issue")
Fixes: 40475b63761a ("net: ipv6: seg6_iptunnel: mitigate 2-realloc issue")
Fixes: dce525185bc9 ("net: ipv6: ioam6_iptunnel: mitigate 2-realloc issue")
Reviewed-by: Justin Iurman <justin.iurman@uliege.be>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20250130031519.2716843-1-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/ioam6_iptunnel.c |    5 +++--
 net/ipv6/rpl_iptunnel.c   |    6 ++++--
 net/ipv6/seg6_iptunnel.c  |    6 ++++--
 3 files changed, 11 insertions(+), 6 deletions(-)

--- a/net/ipv6/ioam6_iptunnel.c
+++ b/net/ipv6/ioam6_iptunnel.c
@@ -338,7 +338,7 @@ static int ioam6_do_encap(struct net *ne
 
 static int ioam6_output(struct net *net, struct sock *sk, struct sk_buff *skb)
 {
-	struct dst_entry *dst = skb_dst(skb), *cache_dst;
+	struct dst_entry *dst = skb_dst(skb), *cache_dst = NULL;
 	struct in6_addr orig_daddr;
 	struct ioam6_lwt *ilwt;
 	int err = -EINVAL;
@@ -409,7 +409,6 @@ do_encap:
 		cache_dst = ip6_route_output(net, NULL, &fl6);
 		if (cache_dst->error) {
 			err = cache_dst->error;
-			dst_release(cache_dst);
 			goto drop;
 		}
 
@@ -431,8 +430,10 @@ do_encap:
 		return dst_output(net, sk, skb);
 	}
 out:
+	dst_release(cache_dst);
 	return dst->lwtstate->orig_output(net, sk, skb);
 drop:
+	dst_release(cache_dst);
 	kfree_skb(skb);
 	return err;
 }
--- a/net/ipv6/rpl_iptunnel.c
+++ b/net/ipv6/rpl_iptunnel.c
@@ -232,7 +232,6 @@ static int rpl_output(struct net *net, s
 		dst = ip6_route_output(net, NULL, &fl6);
 		if (dst->error) {
 			err = dst->error;
-			dst_release(dst);
 			goto drop;
 		}
 
@@ -254,6 +253,7 @@ static int rpl_output(struct net *net, s
 	return dst_output(net, sk, skb);
 
 drop:
+	dst_release(dst);
 	kfree_skb(skb);
 	return err;
 }
@@ -272,8 +272,10 @@ static int rpl_input(struct sk_buff *skb
 	local_bh_enable();
 
 	err = rpl_do_srh(skb, rlwt, dst);
-	if (unlikely(err))
+	if (unlikely(err)) {
+		dst_release(dst);
 		goto drop;
+	}
 
 	if (!dst) {
 		ip6_route_input(skb);
--- a/net/ipv6/seg6_iptunnel.c
+++ b/net/ipv6/seg6_iptunnel.c
@@ -482,8 +482,10 @@ static int seg6_input_core(struct net *n
 	local_bh_enable();
 
 	err = seg6_do_srh(skb, dst);
-	if (unlikely(err))
+	if (unlikely(err)) {
+		dst_release(dst);
 		goto drop;
+	}
 
 	if (!dst) {
 		ip6_route_input(skb);
@@ -571,7 +573,6 @@ static int seg6_output_core(struct net *
 		dst = ip6_route_output(net, NULL, &fl6);
 		if (dst->error) {
 			err = dst->error;
-			dst_release(dst);
 			goto drop;
 		}
 
@@ -596,6 +597,7 @@ static int seg6_output_core(struct net *
 
 	return dst_output(net, sk, skb);
 drop:
+	dst_release(dst);
 	kfree_skb(skb);
 	return err;
 }


