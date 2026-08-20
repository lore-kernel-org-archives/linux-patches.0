Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87AAC3815D5;
	Thu, 20 Aug 2026 15:19:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787239192; cv=none; b=mwO6WshzCnMitiNZLDOZRsGHORlhAl6Oqr7um9gdTsEiV1p03vO99KOY1xUna+Or6LmKZHx2hY4faugGo5W88MOlrPxSwQTl57yPTUtueog9iddMlWBJw7Bed47rj5QQa53zNv/g1CL0YDa/zw5F3+bXznjx5uwfSYccnp2pfRk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787239192; c=relaxed/simple;
	bh=Y9xszjncqB7/PRCgjnLADLbDrzp96L65/nMo4iqjG8w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DFsW34gcv83diDtbvH+oAI/uo50Od9JaTlpokW6PHLkEmjUqnWVtILy8Sbi38VuvV9SVP+tUFKF7/oKtY+BwIBFJkc0e3562d9ajy6780wzJfDrO2vRjHOe55U5r6LjB66FotWXdJO6sxjaKwqO23JzZv/nuzJO8inK1isjS+Vg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tZXXqsnC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tZXXqsnC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19C3E1F00A3A;
	Thu, 20 Aug 2026 15:19:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787239191;
	bh=3MMa0rjMHJVxWLJ86EdskvJr3fs20yaspKRZIAgjCcg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tZXXqsnC2dcHZuFHW6qMIR0b41ACet+zkOa+3NP3k76vgEVGYhdNvXjhBrCG5Wa7f
	 oZ9CVtkP+GmRKHzcUvjPKhrAlL/cpJCL+EIs2LZtOmqSyWE/BTjtEV50tUNUA5BRNq
	 u/HBazf8On+t1iLT5GOr43X+1LjNtKJncrdt8U70=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 181/217] netfilter: ipset: fix list type element drift bug
Date: Thu, 20 Aug 2026 16:55:49 +0200
Message-ID: <20260820145243.178329288@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145237.531699751@linuxfoundation.org>
References: <20260820145237.531699751@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 7bb807b3c6282..3710772ad8884 100644
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



