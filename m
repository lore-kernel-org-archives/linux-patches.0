Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6717128ED
	for <patches@lists.linux.dev>; Mon, 12 Dec 2022 13:50:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B813DC433D2;
	Mon, 12 Dec 2022 13:50:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1670853031;
	bh=kuovvVt6c/Qo9Xo2YPTjD7mnvOC5FDdBwHlk9fvJrfI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nfqPhDx6R8dwQiwa4YvJrZlZO8dfzIP+UGcXc10iAp1UAiuFyusJNUKuG6+FL2OVA
	 IEA6scsSpDvRGkK+MJEdHlR5OvSzlhbrIERNopfuaCe+OGzXdu96AGSZXr0gGg4f5/
	 w1jx9El/4kJFANzQFA63GSqUV3XzDR5zZ2Kh9y8A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	YueHaibing <yuehaibing@huawei.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 43/49] tipc: Fix potential OOB in tipc_link_proto_rcv()
Date: Mon, 12 Dec 2022 14:19:21 +0100
Message-Id: <20221212130915.817494785@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221212130913.666185567@linuxfoundation.org>
References: <20221212130913.666185567@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: YueHaibing <yuehaibing@huawei.com>

[ Upstream commit 743117a997bbd4840e827295c07e59bcd7f7caa3 ]

Fix the potential risk of OOB if skb_linearize() fails in
tipc_link_proto_rcv().

Fixes: 5cbb28a4bf65 ("tipc: linearize arriving NAME_DISTR and LINK_PROTO buffers")
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Link: https://lore.kernel.org/r/20221203094635.29024-1-yuehaibing@huawei.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/tipc/link.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/tipc/link.c b/net/tipc/link.c
index 0d2ee4eb131f..ee4aca974622 100644
--- a/net/tipc/link.c
+++ b/net/tipc/link.c
@@ -1595,7 +1595,9 @@ static int tipc_link_proto_rcv(struct tipc_link *l, struct sk_buff *skb,
 	if (tipc_own_addr(l->net) > msg_prevnode(hdr))
 		l->net_plane = msg_net_plane(hdr);
 
-	skb_linearize(skb);
+	if (skb_linearize(skb))
+		goto exit;
+
 	hdr = buf_msg(skb);
 	data = msg_data(hdr);
 
-- 
2.35.1



