Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B264F47D46A;
	Thu, 20 Aug 2026 16:50:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787244629; cv=none; b=r8AoLS2Z1rqWQC7TRsD87aKGdfZLjhz4ZN7c0bhNn20fAgVu5HXazL2tBSqFlk+zR9DRRyx2N5WzQ7dAvw8HhCmpojADOO19gAI50iqWM+tqR+vmcgw/eFL3OPacOZoQ6eS6AJm/BA5Cr4AEpl8MPP0RCcmtouXAoQ88XMJmuss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787244629; c=relaxed/simple;
	bh=JbeAcE4l7Y2Be85dG/qUhXwFh47p11kBBRVTt85rqos=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=svfdAdCiL4aV8x1cZZkUXTU1Yyv/D1GSM+rCIkKFCqV5erw15k6tW/kjI0cpKKDw/uLFQCv/EOTTI3bBIH+7sBUq/vC2VeWSxtuyHcfNo6d/uWiw8Aj4VgjCZqYGAiDmdO6V+IJ5wFFk4PqueFVoaScrZPNaD4eyqU9Mx1AmVRE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xyaVp4qb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xyaVp4qb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1712E1F00A3D;
	Thu, 20 Aug 2026 16:50:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787244628;
	bh=OrCAtuUeNtLRHa6iOFnpQdELOZfee5nLcKI2jpaj+ZU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xyaVp4qb/YoVqIEKyesBLTv+0Rc0UdzZbMv/onxC0BopOFahQ6Srx1fWHCyCc/jdx
	 uwghagjbCtQ9g1CWXR/rPHF7wr2WQtp9/j47OPatqhOepSrfqofblzRTzkGIXkNlpM
	 3LrjuJiW2pphLMoRJKdLE/NVcFNJMfu/gdB/bi8Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 221/235] netfilter: ipset: fix list type element drift bug
Date: Thu, 20 Aug 2026 16:57:37 +0200
Message-ID: <20260820145223.317247470@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145216.426568665@linuxfoundation.org>
References: <20260820145216.426568665@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Westphal <fw@strlen.de>

[ Upstream commit 4cbd69766b35a089664cadb1f613bb85f7ef77a9 ]

If list_set_uadd() calls list_set_replace() to swap an expired entry,
the element count remains the same, therefore the increment must be elided.

Fixes: 702b71e7c666 ("netfilter: ipset: Add element count to all set types header")
Link: https://sashiko.dev/#/patchset/20260806101947.2802-1-fw%40strlen.de
Signed-off-by: Florian Westphal <fw@strlen.de>
Acked-by: Jozsef Kadlecsik <kadlec@netfilter.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/ipset/ip_set_list_set.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/ipset/ip_set_list_set.c b/net/netfilter/ipset/ip_set_list_set.c
index 7d1ba6ad514f5..25cfa8693f1a2 100644
--- a/net/netfilter/ipset/ip_set_list_set.c
+++ b/net/netfilter/ipset/ip_set_list_set.c
@@ -301,9 +301,12 @@ list_set_uadd(struct ip_set *set, void *value, const struct ip_set_ext *ext,
 	e->set = set;
 	INIT_LIST_HEAD(&e->list);
 	list_set_init_extensions(set, ext, e);
-	if (n)
+	if (n) {
 		list_set_replace(set, e, n);
-	else if (next)
+		return 0;
+	}
+
+	if (next)
 		list_add_tail_rcu(&e->list, &next->list);
 	else if (prev)
 		list_add_rcu(&e->list, &prev->list);
-- 
2.53.0



