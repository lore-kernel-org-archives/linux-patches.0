Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0C121D89F5;
	Tue, 15 Oct 2024 11:41:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728992497; cv=none; b=PAa8FGPBMksdyKWcDayLbrq8dI2Hw21imj8RnnlaiO2lbAFbsdOgLZKJE+z084GWoBxNqKcWIECqcEEuBD0HmgdFatwvykfJ21u3AQEtT89s1r3piO+0ba8uYQ6GbIwcUuFsHKJjlePJBB45BEL0/ipVy3EZGC+FXjMBHBOuGJA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728992497; c=relaxed/simple;
	bh=ro0RwkY1LstZqgSLDStyDZTG2KUoVl9HWkkUABjXqpg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kApHGfplP3ZUo7tUq/j8b7zhzDc6Xhh/G3qYirrg9R49Mz3/8JPXWEFT3kuUhdoxPZS5WtWJMO0hAmlW628wNm6CbItx9LbTBhSFoj77bIukJDYzhT09lTR2jvI+rLekpQ2WKTEaMRhbLsqE5qQCPhubao8MLiup8vTsG6jWpDY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YSSGNSwN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YSSGNSwN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1282DC4CEC6;
	Tue, 15 Oct 2024 11:41:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728992496;
	bh=ro0RwkY1LstZqgSLDStyDZTG2KUoVl9HWkkUABjXqpg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YSSGNSwN54Hv8ULIm0ICqY1ImYju3W/91UdliZhHVS7PPtluzmqpi8rSPzxckRmEl
	 o/DwOlcthCHkBQaZ0ksWcEO/vWi6UmQXFyidGb7EUbWh9Il3zNrpl8MhQi1oYf0Yi+
	 MUIaybdz3o6ZgyhokgOIjSowNt3/T3RkRtzMsqCE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Justin Iurman <justin.iurman@uliege.be>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 132/691] net: ipv6: rpl_iptunnel: Fix memory leak in rpl_input
Date: Tue, 15 Oct 2024 13:21:20 +0200
Message-ID: <20241015112445.594684090@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

From: Justin Iurman <justin.iurman@uliege.be>

[ Upstream commit 2c84b0aa28b9e73e8c4b4ce038269469434ae372 ]

Free the skb before returning from rpl_input when skb_cow_head() fails.
Use a "drop" label and goto instructions.

Fixes: a7a29f9c361f ("net: ipv6: add rpl sr tunnel")
Signed-off-by: Justin Iurman <justin.iurman@uliege.be>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20240911174557.11536-1-justin.iurman@uliege.be
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/rpl_iptunnel.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/net/ipv6/rpl_iptunnel.c b/net/ipv6/rpl_iptunnel.c
index 26adbe7f8a2f0..c1d0f947a7c87 100644
--- a/net/ipv6/rpl_iptunnel.c
+++ b/net/ipv6/rpl_iptunnel.c
@@ -263,10 +263,8 @@ static int rpl_input(struct sk_buff *skb)
 	rlwt = rpl_lwt_lwtunnel(orig_dst->lwtstate);
 
 	err = rpl_do_srh(skb, rlwt);
-	if (unlikely(err)) {
-		kfree_skb(skb);
-		return err;
-	}
+	if (unlikely(err))
+		goto drop;
 
 	local_bh_disable();
 	dst = dst_cache_get(&rlwt->cache);
@@ -287,9 +285,13 @@ static int rpl_input(struct sk_buff *skb)
 
 	err = skb_cow_head(skb, LL_RESERVED_SPACE(dst->dev));
 	if (unlikely(err))
-		return err;
+		goto drop;
 
 	return dst_input(skb);
+
+drop:
+	kfree_skb(skb);
+	return err;
 }
 
 static int nla_put_rpl_srh(struct sk_buff *skb, int attrtype,
-- 
2.43.0



