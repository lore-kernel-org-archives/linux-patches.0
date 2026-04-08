Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E1A53D4134;
	Wed,  8 Apr 2026 18:09:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775671763; cv=none; b=oa9mKECVgX4C7JroMeXVeoWbjjFM/7tX61V2hC9wKeN0OmruCn+wRJ0m8FhpNO6kOgpGhkY6e/phI/klFJWOMMzgbe6rgpz43yN+eOaDzt7a0tpUKYHYXw+b7R7bSPPnGD4QkLoHPsHHK7EcxVOk4uFxvGYPx9sKMrmP2XJK0zE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775671763; c=relaxed/simple;
	bh=CjkrcT//t4qFdV4JwCbJxHOhNcE+Qve9QyM1mNh/Fjw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AUKpP+d5oI01hHfRUqrZv+M5dmLITtdo5VZcoG/KpgTP/zQmlUieXALJOQsGR1n8ZKGiZvV26sWjw79x9JuWP6FVvDwvZYTiIgNil6QUiPQZucddqiKY4iiODrPMIwKyje8nqskvkAvCKJBqKvRzphjE4dtoCGec3eqe+uZBr2s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YvvJmnjL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YvvJmnjL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7C94C19421;
	Wed,  8 Apr 2026 18:09:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775671763;
	bh=CjkrcT//t4qFdV4JwCbJxHOhNcE+Qve9QyM1mNh/Fjw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YvvJmnjLsMXKnO3cqvzfFwSlYQvr9M82rpNxgj4jnu6WVbTiyr0C/7cud7aqt/kwY
	 GpAQFgS8ip9cFfTlsXmzG60YLOb8E3zEKvg+X6AxaEtmphgeQ/oDYEckBDTP7pz+7m
	 b9doIC5gxa7XpdRP1+04QF46nI0n0zWkBdHWOE70=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 059/312] netfilter: nf_conntrack_expect: skip expectations in other netns via proc
Date: Wed,  8 Apr 2026 19:59:36 +0200
Message-ID: <20260408175935.941946664@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175933.715315542@linuxfoundation.org>
References: <20260408175933.715315542@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit 3db5647984de03d9cae0dcddb509b058351f0ee4 ]

Skip expectations that do not reside in this netns.

Similar to e77e6ff502ea ("netfilter: conntrack: do not dump other netns's
conntrack entries via proc").

Fixes: 9b03f38d0487 ("netfilter: netns nf_conntrack: per-netns expectations")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_conntrack_expect.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/netfilter/nf_conntrack_expect.c b/net/netfilter/nf_conntrack_expect.c
index 81ca348915c98..7bc64eb89bac4 100644
--- a/net/netfilter/nf_conntrack_expect.c
+++ b/net/netfilter/nf_conntrack_expect.c
@@ -627,11 +627,15 @@ static int exp_seq_show(struct seq_file *s, void *v)
 {
 	struct nf_conntrack_expect *expect;
 	struct nf_conntrack_helper *helper;
+	struct net *net = seq_file_net(s);
 	struct hlist_node *n = v;
 	char *delim = "";
 
 	expect = hlist_entry(n, struct nf_conntrack_expect, hnode);
 
+	if (!net_eq(nf_ct_exp_net(expect), net))
+		return 0;
+
 	if (expect->timeout.function)
 		seq_printf(s, "%ld ", timer_pending(&expect->timeout)
 			   ? (long)(expect->timeout.expires - jiffies)/HZ : 0);
-- 
2.51.0



