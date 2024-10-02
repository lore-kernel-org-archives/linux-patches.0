Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33F4F2BAF9;
	Wed,  2 Oct 2024 13:59:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727877556; cv=none; b=oO8j/DkcNUdJbqBkL6dGKu1XI73frLCySQsDNZgfTYjbhiMYALLyKK/1uTp8Rr6feuak9afei5rusNOFDG4LyyDrt2qp872aJzbxPEHrZ0b/FtS7DzoBY5HLBR7V99wO0DNHQYClNhO/+NWKwXEFdbjzbkoCBhfAeqOi6giUxmw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727877556; c=relaxed/simple;
	bh=r5JpGOqQPHcRPWTcAfQPRZofTcTDihGE5p4ArsODt00=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=anTW7+h59auUcEbsn8E/zeGt1eHKu/Z4OUQM2S3muA50SKw3yA5CPz6eTgev/YWx1VMNBppkyBz3xqW7qgpTSYby3HVZ3Omr948rdQxKpGgE2ET7nOJafnomVSHJdizCNCfPzitmgeQhRqk60enpLI/mFlcpiMA+4HmY90GnDWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vS2TouYb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vS2TouYb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E2DBC4CEC2;
	Wed,  2 Oct 2024 13:59:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727877555;
	bh=r5JpGOqQPHcRPWTcAfQPRZofTcTDihGE5p4ArsODt00=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vS2TouYb/Cat1Wjw3QcoufbjqKgjzLO3ldUXXk3NpK5S60v1ve8M39/9EX3mMy0UX
	 sAJhreDiOjwjdbk1+cU8qGhu/clgBj0hGo4k0t/M9y0QUhNNR9bpqw5kb4k5DLk0Wd
	 aFc5CuK3SQm4O4a08EDuGTlKVudgjJuikBzCLpts=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Justin Iurman <justin.iurman@uliege.be>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 099/634] net: ipv6: rpl_iptunnel: Fix memory leak in rpl_input
Date: Wed,  2 Oct 2024 14:53:19 +0200
Message-ID: <20241002125815.021102016@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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



