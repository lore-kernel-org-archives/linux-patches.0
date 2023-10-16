Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00ADC241F8
	for <patches@lists.linux.dev>; Mon, 16 Oct 2023 14:24:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YLKSwom7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D25E7C433C9;
	Mon, 16 Oct 2023 14:24:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1697466279;
	bh=Re3DIzwKLdwBWLjEeCJifh/8sdm6ZIKYcEM+4QpszNQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YLKSwom7Ih0bONs1HlnDI2q9TxiXo0KCmU2kB7xTnArJDVSx1toBsjpdlzWKFm70p
	 kaVkN1XXxAABWRKtYbS8nN2XE+sze8VOHgRL4R3/zAk8Mm2VmPOqTvfrCdFR5Gbxuw
	 iDBgT422UducFiBs6Qq8eVhnmwat7M7tVtfonO/c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Artem Chernyshev <artem.chernyshev@red-soft.ru>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 002/191] RDMA/cxgb4: Check skb value for failure to allocate
Date: Mon, 16 Oct 2023 10:39:47 +0200
Message-ID: <20231016084015.459717542@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231016084015.400031271@linuxfoundation.org>
References: <20231016084015.400031271@linuxfoundation.org>
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
index ced615b5ea096..040ba2224f9ff 100644
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



