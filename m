Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E123A79C9
	for <patches@lists.linux.dev>; Thu, 12 Jan 2023 14:22:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 478C3C433EF;
	Thu, 12 Jan 2023 14:22:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673533353;
	bh=Qhb+sUdho6z5nw9ePYtSKJflop54eOxYiItcKHX/AWg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y6Pdl0g49B1Tbi2CdH71fReenAHenyhe6EJpzzsfumVWyYghG0E+z+fmFjTOf9IhL
	 gpshMA4dxNZgJQnZ9Vr7SrVgeywmB/n/zdd+Z0YsGqvs6hqfM7lhvnhVC1Zem32TRq
	 9zzHlahZbPnDOY4ShCsl/ANwbwrOaZRftUpN6lL4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qingfang DENG <dqfext@gmail.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 452/783] netfilter: flowtable: really fix NAT IPv6 offload
Date: Thu, 12 Jan 2023 14:52:48 +0100
Message-Id: <20230112135545.202334708@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Qingfang DENG <dqfext@gmail.com>

[ Upstream commit 5fb45f95eec682621748b7cb012c6a8f0f981e6a ]

The for-loop was broken from the start. It translates to:

	for (i = 0; i < 4; i += 4)

which means the loop statement is run only once, so only the highest
32-bit of the IPv6 address gets mangled.

Fix the loop increment.

Fixes: 0e07e25b481a ("netfilter: flowtable: fix NAT IPv6 offload mangling")
Fixes: 5c27d8d76ce8 ("netfilter: nf_flow_table_offload: add IPv6 support")
Signed-off-by: Qingfang DENG <dqfext@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_flow_table_offload.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
index 28306cb66719..746ca77d0aad 100644
--- a/net/netfilter/nf_flow_table_offload.c
+++ b/net/netfilter/nf_flow_table_offload.c
@@ -305,12 +305,12 @@ static void flow_offload_ipv6_mangle(struct nf_flow_rule *flow_rule,
 				     const __be32 *addr, const __be32 *mask)
 {
 	struct flow_action_entry *entry;
-	int i, j;
+	int i;
 
-	for (i = 0, j = 0; i < sizeof(struct in6_addr) / sizeof(u32); i += sizeof(u32), j++) {
+	for (i = 0; i < sizeof(struct in6_addr) / sizeof(u32); i++) {
 		entry = flow_action_entry_next(flow_rule);
 		flow_offload_mangle(entry, FLOW_ACT_MANGLE_HDR_TYPE_IP6,
-				    offset + i, &addr[j], mask);
+				    offset + i * sizeof(u32), &addr[i], mask);
 	}
 }
 
-- 
2.35.1



