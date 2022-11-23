Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F9811C29
	for <patches@lists.linux.dev>; Wed, 23 Nov 2022 09:15:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 674E3C433D7;
	Wed, 23 Nov 2022 09:15:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669194952;
	bh=RbTjZk2cy9m5HP6NBRnKTUBHw62JRHbrcuQY1H0EGRc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t1LgikINYyzN11RS9wN2TQbmDxcpyzhYAi6QKSQ3ZLtLSmjQazk4D5+pJrfceK0az
	 HkZmVaF0CTdrJcuhn8yOs1F8/GuiAyDi0+K9A3jsxzqbfesEzG0olGBabsJ+TEmKJm
	 i/g9rxutAe8ubjqHO4I8jzsX5qIVVaJg05TRklnI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wei Yongjun <weiyongjun1@huawei.com>,
	Martin Schiller <ms@dev.tdt.de>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 107/156] net/x25: Fix skb leak in x25_lapb_receive_frame()
Date: Wed, 23 Nov 2022 09:51:04 +0100
Message-Id: <20221123084601.845303511@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084557.816085212@linuxfoundation.org>
References: <20221123084557.816085212@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Wei Yongjun <weiyongjun1@huawei.com>

[ Upstream commit 2929cceb2fcf0ded7182562e4888afafece82cce ]

x25_lapb_receive_frame() using skb_copy() to get a private copy of
skb, the new skb should be freed in the undersized/fragmented skb
error handling path. Otherwise there is a memory leak.

Fixes: cb101ed2c3c7 ("x25: Handle undersized/fragmented skbs")
Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
Acked-by: Martin Schiller <ms@dev.tdt.de>
Link: https://lore.kernel.org/r/20221114110519.514538-1-weiyongjun@huaweicloud.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/x25/x25_dev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/x25/x25_dev.c b/net/x25/x25_dev.c
index 25bf72ee6cad..226397add422 100644
--- a/net/x25/x25_dev.c
+++ b/net/x25/x25_dev.c
@@ -117,7 +117,7 @@ int x25_lapb_receive_frame(struct sk_buff *skb, struct net_device *dev,
 
 	if (!pskb_may_pull(skb, 1)) {
 		x25_neigh_put(nb);
-		return 0;
+		goto drop;
 	}
 
 	switch (skb->data[0]) {
-- 
2.35.1



