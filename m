Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0067D44AB91;
	Tue, 21 Jul 2026 22:49:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784674151; cv=none; b=HM7e9jhXkFDjDLq4eHeZS8xJIr4dkTj14aTDtEsDl6fOFIRcY6105VjtrRDxfL4FMUGMKu8gNDSU94vrPaxF3upxnApCfAzTYDsdfaF8UewZiONgtTwIjTvsbFwyaIcgZ7m6gF0kOCAntRAZVXJiP3Payf9BBYKIlGMeblVpmGg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784674151; c=relaxed/simple;
	bh=2iXXpV3fLX0C3cFcutkTYA+yx3mG2X/TVPLzRJw4WLo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i61sZQZH4Dpk48S2KdQEdKU8xB0ofZtHwyxRtj2eQjgTAiX/d0NM42Bz+zakZkgUwyYLO6ENUvS1J0I21pBUMpev+tmp8UuB2k6NEqkKUVw1kQi6XmKP3lxP5j3XRFGwmf3pdZC3ULGsiWxfqqLfgUQGbI7PZBlOPFrm4dPFeSI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xN/XxMzx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xN/XxMzx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13DB61F000E9;
	Tue, 21 Jul 2026 22:49:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784674149;
	bh=AjIZVbdrs2kMx2f1dx20US83PU6FQ1liNJh1t4GP+P8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xN/XxMzxEwST2bW8px4y5l82QnjbhwqeV/JWc6k/dRBIFzecuTCn+SvrW5ymQNJzv
	 V+Xd6TiqN13Kp10UwgQVDwOIN7/ODwsnpmcaD7HgeZSSw3nJIScKcIk2J6m1QV3X5q
	 FkPFoxYObLWj8+jBvoEdqH48rkA8Mt0Ww3H80FlU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuan Tan <yuantan098@gmail.com>,
	Xin Liu <bird@lzu.edu.cn>,
	Yong Wang <edragain@163.com>,
	Ren Wei <n05ec@lzu.edu.cn>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 432/699] net: ife: require ETH_HLEN to be pullable in ife_decode()
Date: Tue, 21 Jul 2026 17:23:11 +0200
Message-ID: <20260721152405.438199351@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yong Wang <edragain@163.com>

commit 9406f6012b7343661efb516a11c62d4db2b62f75 upstream.

ife decode may return after making only the outer IFE header and
metadata pullable. The caller then passes the decapsulated packet to
eth_type_trans(), which expects the inner Ethernet header to be
accessible from the linear data area.

With a malformed IFE frame, the inner Ethernet header may still be
shorter than ETH_HLEN in the linear area, which can lead to a crash in
the original code.

Fix this by extending the pull check in ife_decode() so that the inner
Ethernet header is also guaranteed to be pullable before returning.

Fixes: ef6980b6becb ("introduce IFE action")
Cc: stable@vger.kernel.org
Reported-by: Yuan Tan <yuantan098@gmail.com>
Reported-by: Xin Liu <bird@lzu.edu.cn>
Signed-off-by: Yong Wang <edragain@163.com>
Signed-off-by: Ren Wei <n05ec@lzu.edu.cn>
Link: https://patch.msgid.link/20260610183814.1648888-2-n05ec@lzu.edu.cn
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ife/ife.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/ife/ife.c
+++ b/net/ife/ife.c
@@ -79,7 +79,7 @@ void *ife_decode(struct sk_buff *skb, u1
 	if (unlikely(ifehdrln < 2))
 		return NULL;
 
-	if (unlikely(!pskb_may_pull(skb, total_pull)))
+	if (unlikely(!pskb_may_pull(skb, total_pull + ETH_HLEN)))
 		return NULL;
 
 	ifehdr = (struct ifeheadr *)(skb->data + skb->dev->hard_header_len);


