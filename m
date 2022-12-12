Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE50E28ED
	for <patches@lists.linux.dev>; Mon, 12 Dec 2022 13:53:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 205B5C433EF;
	Mon, 12 Dec 2022 13:53:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1670853205;
	bh=7hzXNrPwFnVAXirEXP0fEzOIsehZfGmeyHlyBiDsPdg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mbGXcZog8GSmNo6cHBitNh97w6AtLdcAVVzGMKMq8RcAYpmjrh1SMfOgdlfGEWyxa
	 svNliOMgZ1D8YMqwb28wpSvGYUT4QnAiqEqwsFccqB1B1y7UV/yEKQCxlc7/SfoPYU
	 gGysyWL3mb4c2LiBm6qEMFVeBhJ99ETVE25MP3aU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	YueHaibing <yuehaibing@huawei.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 33/38] tipc: Fix potential OOB in tipc_link_proto_rcv()
Date: Mon, 12 Dec 2022 14:19:34 +0100
Message-Id: <20221212130913.760595573@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221212130912.069170932@linuxfoundation.org>
References: <20221212130912.069170932@linuxfoundation.org>
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
index d3017811b67a..edcc768a17ce 100644
--- a/net/tipc/link.c
+++ b/net/tipc/link.c
@@ -1477,7 +1477,9 @@ static int tipc_link_proto_rcv(struct tipc_link *l, struct sk_buff *skb,
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



