Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA35F244687;
	Wed, 23 Sep 2026 14:18:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790173086; cv=none; b=XrARqSLwsW0oFwVt8TiHXkArmbhTfS+qyNp61a1k3OIN76DgddqTkM81rwXcgrYZqedvBNm2wCPjO4ZBiAU5eR1cLYaC0PQc2jILW18JjxeGvb7NmXNtWk4rnD0eeVjHZO7WuEmLPWXR67bDwvP6ArdoePto+j2FSR9T22E+OzI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790173086; c=relaxed/simple;
	bh=NaCwRE03VLLjfhP3FToDN6MSt85sRgCg+cetSc/DVF4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qcvFYkExu5MmE+E2EThCgSBm/F8k7GYvB62o+ehr5G8cC4waX50ja5jydrPBMPjs0Hc+YDUTJhIb4LjsmJxBn6QkpJCCr6+x9fna0AKMSnlV0ZCNzJoPF0g2TeEJ9h+IJytC/JoDsRMEqjRxhg1d4Fat/IWip6arUUM3qBlgPfw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mXJaqeBI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mXJaqeBI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E0461F00893;
	Wed, 23 Sep 2026 14:18:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790173085;
	bh=cbwL9AASxaF9vnI6QjRym3Nvpnx4n0tvlHiFB+5Wm7k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mXJaqeBIx0fT6OH/ntUPcT442H+NKCAlGYjj/hRrV/xnMXmEApYbwa7PuEyM4F5lp
	 d1AtLb+ShitdalO5uKEP/LsYhVU0ktMynCSE4o5X+yj3A9/1LYBrAMhxSU/NSyPNdD
	 jtReu7Lfd5lxgYV2+fIftrzyYasTDpGsHuupZRKw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 115/438] neighbour: Add missing RCU annotation for neightbl_dump_info().
Date: Wed, 23 Sep 2026 16:02:16 +0200
Message-ID: <20260923140647.761746229@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>
References: <20260923140644.756254324@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuniyuki Iwashima <kuniyu@google.com>

[ Upstream commit 764dcebb033764633700a036c7351a7c6350eec6 ]

neightbl_dump_info() fetches the first non-default neigh_parms
with list_next_entry(&tbl->parms, ...) and iterates through the
list with list_for_each_entry_from_rcu().

However, list_next_entry() does not use RCU helper.

Let's use list_for_each_entry_rcu() and skip the default parms.

Fixes: 4ae34be50064 ("neighbour: Convert RTM_GETNEIGHTBL to RCU.")
Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Link: https://patch.msgid.link/20260909233143.2401847-2-kuniyu@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/neighbour.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/net/core/neighbour.c b/net/core/neighbour.c
index 1349c0eedb642..49dd7df149ef3 100644
--- a/net/core/neighbour.c
+++ b/net/core/neighbour.c
@@ -2611,11 +2611,14 @@ static int neightbl_dump_info(struct sk_buff *skb, struct netlink_callback *cb)
 			break;
 
 		nidx = 0;
-		p = list_next_entry(&tbl->parms, list);
-		list_for_each_entry_from_rcu(p, &tbl->parms_list, list) {
+
+		list_for_each_entry_rcu(p, &tbl->parms_list, list) {
 			if (!net_eq(neigh_parms_net(p), net))
 				continue;
 
+			if (!p->dev)
+				continue;
+
 			if (nidx < neigh_skip)
 				goto next;
 
-- 
2.53.0



