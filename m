Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B45A134A4
	for <patches@lists.linux.dev>; Mon, 12 Jun 2023 10:46:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D915CC433EF;
	Mon, 12 Jun 2023 10:46:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686566814;
	bh=s6013grOLBFlPEB2a7QwgUNo+2/b3mguGf7o4l+PHwQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TkYpSmcSNHe5TiFuAJCNPmw7QrOSu4NYVrY86rUKQWH60AA6oMHd9ED95BpZzxG3/
	 HhlcQDVpRdCdywg5rQo9NFBbcHHF5M3+X7mO50RCN+C1pDfSN2+qwp4fZuaVh8+KCU
	 mmWkD384H1nFhk3m+qF0cgwAkcvZ8wY9Y7kWoKFk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gavrilov Ilia <Ilia.Gavrilov@infotecs.ru>,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 041/160] netfilter: nf_tables: Add null check for nla_nest_start_noflag() in nft_dump_basechain_hook()
Date: Mon, 12 Jun 2023 12:26:13 +0200
Message-ID: <20230612101716.918834827@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230612101715.129581706@linuxfoundation.org>
References: <20230612101715.129581706@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Gavrilov Ilia <Ilia.Gavrilov@infotecs.ru>

[ Upstream commit bd058763a624a1fb5c20f3c46e632d623c043676 ]

The nla_nest_start_noflag() function may fail and return NULL;
the return value needs to be checked.

Found by InfoTeCS on behalf of Linux Verification Center
(linuxtesting.org) with SVACE.

Fixes: d54725cd11a5 ("netfilter: nf_tables: support for multiple devices per netdev hook")
Signed-off-by: Gavrilov Ilia <Ilia.Gavrilov@infotecs.ru>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_tables_api.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index ef80504c3ccd2..8c74bb1ca78a0 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -1593,6 +1593,8 @@ static int nft_dump_basechain_hook(struct sk_buff *skb, int family,
 
 	if (nft_base_chain_netdev(family, ops->hooknum)) {
 		nest_devs = nla_nest_start_noflag(skb, NFTA_HOOK_DEVS);
+		if (!nest_devs)
+			goto nla_put_failure;
 
 		if (!hook_list)
 			hook_list = &basechain->hook_list;
-- 
2.39.2



