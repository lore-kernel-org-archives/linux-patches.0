Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A70A928368
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 20:01:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rrNfIDQr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55820C433C9;
	Wed, 15 Nov 2023 20:01:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700078461;
	bh=aHYuFOoy7lVSJ74rosKUNgTh9ao5eBW9v+7834LqWok=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rrNfIDQrQRevsnbsR3dSjo7RlDl/IhcNCy+Of5abnC5cTZ2O/CuHm+sA5U0aZVBcL
	 TBG8lxV1xPR51J8WqsxB9924sIM+Se65wSWYD5J45ew6FK4EWGaC78ytuI7rdvMdsK
	 8L5YgoumxmCeynnyxTpYxNOrxJ6TtqBY0Hgp+76c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 336/379] hsr: Prevent use after free in prp_create_tagged_frame()
Date: Wed, 15 Nov 2023 14:26:51 -0500
Message-ID: <20231115192705.032046708@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115192645.143643130@linuxfoundation.org>
References: <20231115192645.143643130@linuxfoundation.org>
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

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit 876f8ab52363f649bcc74072157dfd7adfbabc0d ]

The prp_fill_rct() function can fail.  In that situation, it frees the
skb and returns NULL.  Meanwhile on the success path, it returns the
original skb.  So it's straight forward to fix bug by using the returned
value.

Fixes: 451d8123f897 ("net: prp: add packet handling support")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Acked-by: Paolo Abeni <pabeni@redhat.com>
Link: https://lore.kernel.org/r/57af1f28-7f57-4a96-bcd3-b7a0f2340845@moroto.mountain
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/hsr/hsr_forward.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/net/hsr/hsr_forward.c b/net/hsr/hsr_forward.c
index b71dab630a873..80cdc6f6b34c9 100644
--- a/net/hsr/hsr_forward.c
+++ b/net/hsr/hsr_forward.c
@@ -342,9 +342,7 @@ struct sk_buff *prp_create_tagged_frame(struct hsr_frame_info *frame,
 	skb = skb_copy_expand(frame->skb_std, 0,
 			      skb_tailroom(frame->skb_std) + HSR_HLEN,
 			      GFP_ATOMIC);
-	prp_fill_rct(skb, frame, port);
-
-	return skb;
+	return prp_fill_rct(skb, frame, port);
 }
 
 static void hsr_deliver_master(struct sk_buff *skb, struct net_device *dev,
-- 
2.42.0



