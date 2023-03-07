Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22B86BA48
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 18:21:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CD13C433EF;
	Tue,  7 Mar 2023 18:21:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678213301;
	bh=KbrNRuD8hH7gOnI1vOCWblkMpwXAwaBhdipgrDChGLQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w5q02uUuVx2yiIYcTh4A1rCRvt/KhfxUbmz6XB6z52uPGYhlmgsz6cnB7P0X8XljZ
	 HzWyOcHV5YyHf4zNUB24VTeBJsy75s7I7ybXRU6cAO5RmgIWPETLTRCBLng0qCZHJG
	 jOtALp7HJ/Tdfgh0eS00rJwiKZIblL7bMOOYQRKg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikita Zhandarovich <n.zhandarovich@fintech.ru>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 463/885] RDMA/cxgb4: Fix potential null-ptr-deref in pass_establish()
Date: Tue,  7 Mar 2023 17:56:37 +0100
Message-Id: <20230307170022.617922519@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Nikita Zhandarovich <n.zhandarovich@fintech.ru>

[ Upstream commit 283861a4c52c1ea4df3dd1b6fc75a50796ce3524 ]

If get_ep_from_tid() fails to lookup non-NULL value for ep, ep is
dereferenced later regardless of whether it is empty.
This patch adds a simple sanity check to fix the issue.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: 944661dd97f4 ("RDMA/iw_cxgb4: atomically lookup ep and get a reference")
Signed-off-by: Nikita Zhandarovich <n.zhandarovich@fintech.ru>
Link: https://lore.kernel.org/r/20230202184850.29882-1-n.zhandarovich@fintech.ru
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/cxgb4/cm.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/infiniband/hw/cxgb4/cm.c b/drivers/infiniband/hw/cxgb4/cm.c
index ea3ddf0d24114..ced615b5ea096 100644
--- a/drivers/infiniband/hw/cxgb4/cm.c
+++ b/drivers/infiniband/hw/cxgb4/cm.c
@@ -2676,6 +2676,9 @@ static int pass_establish(struct c4iw_dev *dev, struct sk_buff *skb)
 	u16 tcp_opt = ntohs(req->tcp_opt);
 
 	ep = get_ep_from_tid(dev, tid);
+	if (!ep)
+		return 0;
+
 	pr_debug("ep %p tid %u\n", ep, ep->hwtid);
 	ep->snd_seq = be32_to_cpu(req->snd_isn);
 	ep->rcv_seq = be32_to_cpu(req->rcv_isn);
-- 
2.39.2



