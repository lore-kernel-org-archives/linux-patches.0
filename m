Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57E19BA3E
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 17:41:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C97E0C433EF;
	Tue,  7 Mar 2023 17:41:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678210915;
	bh=hN1zrcX8L/61v/ZkENGtatESrfr608Y8s+eR9V5xJug=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t96BKODxnXDKdlm/YD/HydYVXu6QB8pUn3yWY6R5ErlARAiUHD+pZMTPx5Ar2zZJe
	 TyQYATlWiKefdWcY1Iy5YkShy4zp02I+iCiahqcmJ1wSpq1nE1710dkuq5+NKEUqvq
	 g5B3PvhmDYGt84Mayacfb6l7HzLaE/P/7u4CHSgI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alok Tiwari <alok.a.tiwari@oracle.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0664/1001] netfilter: nf_tables: NULL pointer dereference in nf_tables_updobj()
Date: Tue,  7 Mar 2023 17:57:16 +0100
Message-Id: <20230307170050.423011835@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Alok Tiwari <alok.a.tiwari@oracle.com>

[ Upstream commit dac7f50a45216d652887fb92d6cd3b7ca7f006ea ]

static analyzer detect null pointer dereference case for 'type'
function __nft_obj_type_get() can return NULL value which require to handle
if type is NULL pointer return -ENOENT.

This is a theoretical issue, since an existing object has a type, but
better add this failsafe check.

Signed-off-by: Alok Tiwari <alok.a.tiwari@oracle.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_tables_api.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 8c09e4d12ac1e..fc8256b00b320 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -6999,6 +6999,9 @@ static int nf_tables_newobj(struct sk_buff *skb, const struct nfnl_info *info,
 			return -EOPNOTSUPP;
 
 		type = __nft_obj_type_get(objtype);
+		if (WARN_ON_ONCE(!type))
+			return -ENOENT;
+
 		nft_ctx_init(&ctx, net, skb, info->nlh, family, table, NULL, nla);
 
 		return nf_tables_updobj(&ctx, type, nla[NFTA_OBJ_DATA], obj);
-- 
2.39.2



