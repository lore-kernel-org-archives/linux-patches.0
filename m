Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E900D1CAA6C;
	Mon, 10 Mar 2025 18:24:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741631042; cv=none; b=um1v2rX/033gOXadRLvSTP/9GuYVigrAyMpkb87ylBFueQPPTMq8/d9BeWe9YriAfrUcGBONcxHtTZyeKlwqi1m+hb5J3u7UwW7pdlLz3Y68QTEKFK80BCCeMvNNZcfFGe0xebGA0/TorhZLDq3LhhONhCS5shEjOucYhtDgAsg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741631042; c=relaxed/simple;
	bh=xjrKi3xJPfg+HykeVCbYGsfUjFv38YqbJN1NijT4Fxo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=quudsEDZxIY+i5pSl7FhJaDZsH0sJ1GDDwIyrRaQyt7+DNrwNmrMGoMjZteqan5EqpDb3yWSdfgoyAlOs3la0TtWyRtJzO1T8Bpx3zlTiMwyCGavS3mJdlF5gD8By/fPKnKZEZJMIag6nfsCBXkVSkN1uU/Ii8Mkou5xt11htLk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rN8r0Qay; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rN8r0Qay"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B6A7C4CEE5;
	Mon, 10 Mar 2025 18:24:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741631041;
	bh=xjrKi3xJPfg+HykeVCbYGsfUjFv38YqbJN1NijT4Fxo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rN8r0QayLCLO3eq7zcmo/oty5+zj/M8AqqjIZ8OsRm6cAm1gjDKM1T0M2bfiP9Zo6
	 UguV26dxreOg65S2odnYviZoZjy8u5eyyQIv+wPbxIuQGJ/qCcj0uogJyPCbeGWkvk
	 r4NaMN7p7FzmUghFdZcIja2D3Dwn0/ZcpfsRD8/o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Justin Iurman <justin.iurman@uliege.be>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 620/620] net: ipv6: fix dst refleaks in rpl, seg6 and ioam6 lwtunnels
Date: Mon, 10 Mar 2025 18:07:46 +0100
Message-ID: <20250310170610.006675223@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
 net/ipv6/rpl_iptunnel.c  |    6 ++++--
 net/ipv6/seg6_iptunnel.c |    6 ++++--
 2 files changed, 8 insertions(+), 4 deletions(-)

--- a/net/ipv6/rpl_iptunnel.c
+++ b/net/ipv6/rpl_iptunnel.c
@@ -232,7 +232,6 @@ static int rpl_output(struct net *net, s
 		dst = ip6_route_output(net, NULL, &fl6);
 		if (dst->error) {
 			err = dst->error;
-			dst_release(dst);
 			goto drop;
 		}
 
@@ -251,6 +250,7 @@ static int rpl_output(struct net *net, s
 	return dst_output(net, sk, skb);
 
 drop:
+	dst_release(dst);
 	kfree_skb(skb);
 	return err;
 }
@@ -277,8 +277,10 @@ static int rpl_input(struct sk_buff *skb
 	local_bh_enable();
 
 	err = rpl_do_srh(skb, rlwt, dst);
-	if (unlikely(err))
+	if (unlikely(err)) {
+		dst_release(dst);
 		goto drop;
+	}
 
 	skb_dst_drop(skb);
 
--- a/net/ipv6/seg6_iptunnel.c
+++ b/net/ipv6/seg6_iptunnel.c
@@ -490,8 +490,10 @@ static int seg6_input_core(struct net *n
 	local_bh_enable();
 
 	err = seg6_do_srh(skb, dst);
-	if (unlikely(err))
+	if (unlikely(err)) {
+		dst_release(dst);
 		goto drop;
+	}
 
 	skb_dst_drop(skb);
 
@@ -582,7 +584,6 @@ static int seg6_output_core(struct net *
 		dst = ip6_route_output(net, NULL, &fl6);
 		if (dst->error) {
 			err = dst->error;
-			dst_release(dst);
 			goto drop;
 		}
 
@@ -604,6 +605,7 @@ static int seg6_output_core(struct net *
 
 	return dst_output(net, sk, skb);
 drop:
+	dst_release(dst);
 	kfree_skb(skb);
 	return err;
 }


