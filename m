Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1626F15E84
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 11:28:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VtIzsroM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B11FC433C7;
	Mon, 23 Oct 2023 11:28:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698060537;
	bh=J8B4HoviNBgwck27VSAEMqcm3faMRR0Ar85tLk52z+Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VtIzsroMFHvbbIxpFzZC+0CYlCxNkulV2UQFYcoYA3M7sPRq9xd0q4QsgAftgH2f7
	 G/wdgFD0INwDN2lVz5Q2As3Tt3SoTQe+bShIgujdALtNxd4iOS2t6ExvN+JwXOF9Xo
	 Abre/k3qdrU6pV4LEgieEs2TlwE+JxpzgWt3G/6M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Artem Chernyshev <artem.chernyshev@red-soft.ru>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 001/123] RDMA/cxgb4: Check skb value for failure to allocate
Date: Mon, 23 Oct 2023 12:55:59 +0200
Message-ID: <20231023104817.763008355@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231023104817.691299567@linuxfoundation.org>
References: <20231023104817.691299567@linuxfoundation.org>
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

From: Artem Chernyshev <artem.chernyshev@red-soft.ru>

[ Upstream commit 8fb8a82086f5bda6893ea6557c5a458e4549c6d7 ]

get_skb() can fail to allocate skb, so check it.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: 5be78ee924ae ("RDMA/cxgb4: Fix LE hash collision bug for active open connection")
Signed-off-by: Artem Chernyshev <artem.chernyshev@red-soft.ru>
Link: https://lore.kernel.org/r/20230905124048.284165-1-artem.chernyshev@red-soft.ru
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/cxgb4/cm.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/infiniband/hw/cxgb4/cm.c b/drivers/infiniband/hw/cxgb4/cm.c
index e163c09547ebd..c7214c49f202f 100644
--- a/drivers/infiniband/hw/cxgb4/cm.c
+++ b/drivers/infiniband/hw/cxgb4/cm.c
@@ -1965,6 +1965,9 @@ static int send_fw_act_open_req(struct c4iw_ep *ep, unsigned int atid)
 	int win;
 
 	skb = get_skb(NULL, sizeof(*req), GFP_KERNEL);
+	if (!skb)
+		return -ENOMEM;
+
 	req = __skb_put_zero(skb, sizeof(*req));
 	req->op_compl = htonl(WR_OP_V(FW_OFLD_CONNECTION_WR));
 	req->len16_pkd = htonl(FW_WR_LEN16_V(DIV_ROUND_UP(sizeof(*req), 16)));
-- 
2.40.1



