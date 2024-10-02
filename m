Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05AD51D0BB4;
	Wed,  2 Oct 2024 14:28:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727879303; cv=none; b=fgr9Eme01gG9fO/p+d2gQzPGKs/Vk1MIzAlcTUqib588nvpVAvZMZPtVvktJEzqAVdK5nDrUAKzmO+4pSttMKODpRmHGuQayjD3URBWLlo/k3xO3HGkYYZU5+ekHsbE0SapC65zqcAkCHIaMUuu0mrtskK7XZlyCGsrcvOaw52o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727879303; c=relaxed/simple;
	bh=mbXKjQ9RM3jHzY8u3ohX1yb8I4oZUncit+//1QJXIJU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FbxJoC5SWl6/4FvR08WdI/CcmtCNpAg82HuNrKe5MTCHMqT9i6kzew5yYZ9+vfRtBYElYW3BOGCkpS3X72/laMNYM8/PjEIV9RtCS9zFT+pJAkeWyAE7smqRJkyr4ekbOcN098uU79qPdyxMiCLgQPJUh4sgG7DLOOCjr0NXqnQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O1nqWhn0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O1nqWhn0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84006C4CEC2;
	Wed,  2 Oct 2024 14:28:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727879302;
	bh=mbXKjQ9RM3jHzY8u3ohX1yb8I4oZUncit+//1QJXIJU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O1nqWhn0N+NXbZzn6rgOoM/Ed7+i1IkV2zuIJN4KiWmJ+0VSnvInQJs/P2AutSCNN
	 snfNR/1U+xF2Gc0UTUn3jWqRxtu8QQsSdfMiNpiORclUnY46Jh/IduIcD1OXHBU/+d
	 IgiyqoM/9eGTLycTVi5jI+DgARvNzie50a85gi2w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Justin Iurman <justin.iurman@uliege.be>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 073/538] net: ipv6: rpl_iptunnel: Fix memory leak in rpl_input
Date: Wed,  2 Oct 2024 14:55:12 +0200
Message-ID: <20241002125755.095624551@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 2c83b7586422d..db3c19a42e1ca 100644
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
@@ -286,9 +284,13 @@ static int rpl_input(struct sk_buff *skb)
 
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



