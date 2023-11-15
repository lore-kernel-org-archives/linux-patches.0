Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E85E3433BB
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:37:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RSuik5Be"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A143C433CA;
	Wed, 15 Nov 2023 19:37:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700077036;
	bh=5JhIKKy36mbbGkE9Wpl2GgkrRONOCrjz4++/S6ucuBg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RSuik5Bej9+VNZxPrNtR4KtSCd4fOOZnwvqpADaPdWiF3uwdV2kj13sG/1/7YBVAS
	 iJZtD6x4zIcxIV6HfxJLuQWOsT0vdBAmqZB3FJkQ2hbZpwvhs3xBol27rkwSvj8+j5
	 HF/nw/B88L6YNW+xzNcNg6kMoxZGw9QUyQjHYlBg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 499/550] hsr: Prevent use after free in prp_create_tagged_frame()
Date: Wed, 15 Nov 2023 14:18:03 -0500
Message-ID: <20231115191635.512046568@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191600.708733204@linuxfoundation.org>
References: <20231115191600.708733204@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

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



