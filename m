Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A55B1AC45F;
	Mon, 14 Oct 2024 14:54:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728917644; cv=none; b=hvMkOVs7RFLodMqaI51iAFLYaYOLGJr7LVKH0Bf7W9IxaSs/BH12/DEmAZso+QYf3a3qkmxKvOd6x1kLVnh+bzEzOg2PNewghj/Me6SlGT2C0ZWDZIH4Bltkowuuqzk7tkL8uNIP+5JWATyEuGK6WwOX3lvgcrKJnh646PONkaY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728917644; c=relaxed/simple;
	bh=Eum7KLTjUGJmEq+g4CBRtkwLTv4i48Uck9foaQN0FY0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bgY8cJz0n1Coo80s6A8HluRs7VoJo7txEyZ8WextbUSBfKHDlC1xVqb+9DPrKw5thq+orYJbfG336G633Wo+wqeEcIAvNPx4QcTTCVdiNDrGuyeYHDWa2FgNZ8jFigSPT467UeAFoOGe/qwfaxEq8SLsuUGNzKIAcdjoo3DAh9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0QRW5nhS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0QRW5nhS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDED5C4CEC3;
	Mon, 14 Oct 2024 14:54:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728917644;
	bh=Eum7KLTjUGJmEq+g4CBRtkwLTv4i48Uck9foaQN0FY0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0QRW5nhSKxpnAph+QBEbFXXCpox4YJptRIY1rgQjhCpWBW7TnLCNLbK0SoG7JZLMl
	 Lyfwn2OWukWnHcl1znX0SonXJA34InMlPhpByDwtLlEoB5kp7yDMwXQQsHimz9AReR
	 +W39nHUDWDCk0y9YcQKNYLDNJnI8h820vIgFUtPM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Justin Iurman <justin.iurman@uliege.be>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 059/798] net: ipv6: rpl_iptunnel: Fix memory leak in rpl_input
Date: Mon, 14 Oct 2024 16:10:13 +0200
Message-ID: <20241014141220.260661845@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



