Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9971230FA7
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 12:28:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63BAFC433C9;
	Wed, 20 Sep 2023 12:28:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695212885;
	bh=uNYfNDDe27RSkRk7ujvweBjYVal+Olv8aGGGkO6t78A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hJQwumM+j37DtndOiI9Hpx6ysRAhdVCPE9yeENPS48e4iFHWX2nr7WSYYHt4qS1d2
	 qOaRCAqgfVJ5Z3h4T7yK4XBqT5wKfUXX+hI+UoG51S7eoxxfIc55y49jiIJj7U6PMC
	 gPwO4KCBR71zpYTF3KCzbmUwCRPY52LbNmA0+qaE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 082/367] net: arcnet: Do not call kfree_skb() under local_irq_disable()
Date: Wed, 20 Sep 2023 13:27:39 +0200
Message-ID: <20230920112900.662829143@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230920112858.471730572@linuxfoundation.org>
References: <20230920112858.471730572@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jinjie Ruan <ruanjinjie@huawei.com>

[ Upstream commit 786c96e92fb9e854cb8b0cb7399bb2fb28e15c4b ]

It is not allowed to call kfree_skb() from hardware interrupt
context or with hardware interrupts being disabled.
So replace kfree_skb() with dev_kfree_skb_irq() under
local_irq_disable(). Compile tested only.

Fixes: 05fcd31cc472 ("arcnet: add err_skb package for package status feedback")
Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/arcnet/arcnet.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/arcnet/arcnet.c b/drivers/net/arcnet/arcnet.c
index 553776cc1d29d..2b112d3d85409 100644
--- a/drivers/net/arcnet/arcnet.c
+++ b/drivers/net/arcnet/arcnet.c
@@ -434,7 +434,7 @@ static void arcnet_reply_tasklet(unsigned long data)
 
 	ret = sock_queue_err_skb(sk, ackskb);
 	if (ret)
-		kfree_skb(ackskb);
+		dev_kfree_skb_irq(ackskb);
 
 	local_irq_enable();
 };
-- 
2.40.1



