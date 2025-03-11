Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 080F2255E37;
	Tue, 11 Mar 2025 15:40:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741707651; cv=none; b=Az6rSAu9M7yPIhVg97NN0cB87tbWpvXCs0SDy7ewUm2hJCdK8R91tOmzFXCH0oPoEijHRG6kfaKa/Ym9hoRPR9VH2kN0MnV/H0ospwrjaMOYJfG9j2q0rCjgL6TbaLBdHaa/QllGp0AWEnWKhCVqPAi+Bl3xLjSWPCtNKr3w6fA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741707651; c=relaxed/simple;
	bh=4NL50cxg1MWCvQQuwPRp123jfIXrOfYEmiKruKrJT6A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hXKYi+EXZuBq43/0npylVqPuON0Gd0jrS5zbalh6eITgp/V3vj4/DCGmvyM1rhkWQZRbRrtgpAFiwj0kfaAnbQPD7+wAxbBwZ95gvXR6eW1pK8ickTvsxWNUCPjfXBHtLTbgIZ7hUO8JN+X99Pl3ndE+re+P5YR8CMRoo7CezhA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qm8EQn9S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qm8EQn9S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8173BC4CEE9;
	Tue, 11 Mar 2025 15:40:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741707650;
	bh=4NL50cxg1MWCvQQuwPRp123jfIXrOfYEmiKruKrJT6A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qm8EQn9S74d64V59h4N65V/y89f93C2TjGA/8TuGBbSxwnzi0C6bz79zZV8TlQoSz
	 g5+kGqKeDb3WMfo6IxRjr0KhoJlskSY+45lPalJxlJTgGYt2uXJNY6S6ZLS/b0SwVF
	 5HmNyQ/sr+EBcRYUS5zwd3AX8QTARSoxwr1u1hAU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Justin Iurman <justin.iurman@uliege.be>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 462/462] net: ipv6: fix dst refleaks in rpl, seg6 and ioam6 lwtunnels
Date: Tue, 11 Mar 2025 16:02:08 +0100
Message-ID: <20250311145816.586107514@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145758.343076290@linuxfoundation.org>
References: <20250311145758.343076290@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
 net/ipv6/seg6_iptunnel.c |    2 +-
 2 files changed, 5 insertions(+), 3 deletions(-)

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
@@ -380,7 +380,6 @@ static int seg6_output(struct net *net,
 		dst = ip6_route_output(net, NULL, &fl6);
 		if (dst->error) {
 			err = dst->error;
-			dst_release(dst);
 			goto drop;
 		}
 
@@ -398,6 +397,7 @@ static int seg6_output(struct net *net,
 
 	return dst_output(net, sk, skb);
 drop:
+	dst_release(dst);
 	kfree_skb(skb);
 	return err;
 }


