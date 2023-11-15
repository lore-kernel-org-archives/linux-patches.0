Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCE3943AD2
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 20:52:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jeo22Zm/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FE25C4E768;
	Wed, 15 Nov 2023 20:52:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700081536;
	bh=2tPstXFcfip3Wz8K7boHtsly87JSqbnOtGmRYHFIg3o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jeo22Zm/nxJfhAyK9/FdOJub7e9FraTbiaBVZq5tLWDKVMUAlCw38d/3JyOxx5KP9
	 KbM7YgFuvWu5/eBPHoEolesUIgEerqiYL0lbg1LiqqR9dxH6O8CGzrAvhhGhlgpi5X
	 CELwYkorLW+vHQFngwfuNsR7n5JNVDLaMuXN8WDQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 213/244] hsr: Prevent use after free in prp_create_tagged_frame()
Date: Wed, 15 Nov 2023 15:36:45 -0500
Message-ID: <20231115203601.132360812@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115203548.387164783@linuxfoundation.org>
References: <20231115203548.387164783@linuxfoundation.org>
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
index 12ba43023d30e..e31747d328e70 100644
--- a/net/hsr/hsr_forward.c
+++ b/net/hsr/hsr_forward.c
@@ -300,9 +300,7 @@ struct sk_buff *prp_create_tagged_frame(struct hsr_frame_info *frame,
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



