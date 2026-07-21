Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC351443AB0;
	Tue, 21 Jul 2026 22:19:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784672360; cv=none; b=g6Ge6SpmIoJYp+FFV/BoPWmOo6/rzAp7kQNnhqswiiQL1GnCXMbaHwA8WQbAOICMboxs/zDEPrchiPXeXfiLmuG5DoHHYsMpE031MRFjFC0yDYbKKbjtt0BTn5PrnCAgOiQQeUTJ5FLiOl2N/AxGjY8I8GPwOrdQIISajy39Thw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784672360; c=relaxed/simple;
	bh=xSOS3Ew1xbndXq2GgYbD6RsypGMP2nWEju6yE4WjvIA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KaxL9cjQPqtTgZZTAOR5Q6TPLuDR/cOuwZkfv1ATz8WKfIkt3SRVwsQclyCOZYKkd5oBbDihC5XYXJM64VWEXJ/RZQ1YzQ1MrEthBHLcgW8G8t3Q4L7nIpeZl1rSalQ2+sKptKgbjbTuxkBqNxsw17PYVdgLAp8bPMNzcno5UkU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aPBlN85U; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aPBlN85U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DEF61F000E9;
	Tue, 21 Jul 2026 22:19:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784672359;
	bh=445NvS+Z61XRdKR9pL5bqbY/g7CtTaBgL42w/Te11u8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aPBlN85U6v0gsU6oUVrhsiO38UxGlDfTiR8l+l1UBquGE2Fei/dkN3bVdxvzHcnKt
	 osUCHtz0xuHnZ/YRkCuw6YitqmsckpsuEgz5MVye5lP9z2JDISG9rxhxcs7MSgUws3
	 23PC8zsL/FeMYC0btf1tGf5YBQz8VQSqY1yKL2c8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Sven Eckelmann <sven@narfation.org>
Subject: [PATCH 5.15 596/843] batman-adv: frag: fix primary_if leak on failed linearization
Date: Tue, 21 Jul 2026 17:23:51 +0200
Message-ID: <20260721152419.455293755@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sven Eckelmann <sven@narfation.org>

commit 353d2c1d5492e53ae34f490a84494124dc3d3531 upstream.

If the skb has a frag_list, it must be linearized before it can be split
using skb_split(). But when this step failed, it must not only free the skb
but also take care of the reference to the already found primary_if.

Cc: stable@vger.kernel.org
Reported-by: Sashiko <sashiko-bot@kernel.org>
Fixes: a063f2fba3fa ("batman-adv: Don't skb_split skbuffs with frag_list")
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/batman-adv/fragmentation.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/batman-adv/fragmentation.c
+++ b/net/batman-adv/fragmentation.c
@@ -551,7 +551,7 @@ int batadv_frag_send_packet(struct sk_bu
 	 */
 	if (skb_has_frag_list(skb) && __skb_linearize(skb)) {
 		ret = -ENOMEM;
-		goto free_skb;
+		goto put_primary_if;
 	}
 
 	/* Create one header to be copied to all fragments */


