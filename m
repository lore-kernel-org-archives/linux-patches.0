Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E7F77B
	for <patches@lists.linux.dev>; Wed, 23 Nov 2022 08:55:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90129C4347C;
	Wed, 23 Nov 2022 08:55:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669193728;
	bh=KrvNOB/jWRk0+sIQgnh6ZQSThFAyEoNxallyG23zNL4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qC1Uw5E9CVeIcMBPDfAojCNcaXhiM8rxSfB4IrehctDd5IZ7I864zVB4uihdsAxz5
	 INWyHTL9kRQxvJVOLvSFhNN6/WMYzNUJ9dG0qwfW/ZYfMzuhg3iIUAMf3t39dPHfIk
	 u8KvMgv4hOjKOnYR0wxW+lEbuKfayT+ZgwAwf4RM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wei Yongjun <weiyongjun1@huawei.com>,
	Martin Schiller <ms@dev.tdt.de>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 44/76] net/x25: Fix skb leak in x25_lapb_receive_frame()
Date: Wed, 23 Nov 2022 09:50:43 +0100
Message-Id: <20221123084548.194011849@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084546.742331901@linuxfoundation.org>
References: <20221123084546.742331901@linuxfoundation.org>
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
index 30f71620d4e3..24f2676e3b66 100644
--- a/net/x25/x25_dev.c
+++ b/net/x25/x25_dev.c
@@ -122,7 +122,7 @@ int x25_lapb_receive_frame(struct sk_buff *skb, struct net_device *dev,
 
 	if (!pskb_may_pull(skb, 1)) {
 		x25_neigh_put(nb);
-		return 0;
+		goto drop;
 	}
 
 	switch (skb->data[0]) {
-- 
2.35.1



