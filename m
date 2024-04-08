Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FF882DF73;
	Mon,  8 Apr 2024 13:20:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712582448; cv=none; b=e4YW5L4bDMsxFkUSh/GHNvHo/0gFAMzlf1MKp27U/tP+LDRe+1OHBYq7qFy6NI9zcmQXbkkwm+bx/JaKKN99KzWXTPO8fC7GNgAAQiPe4ZW+gvcjZqM7pUVc0U7auys/1cJfFsY3s2E6bBEm5DMLeGC10y8MbyxDnBX2BgI1/2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712582448; c=relaxed/simple;
	bh=kvH+FF5Mr8awkA/Z7BrqoSv1plt9V0o8mgegBYdDGV0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aF3HaJAoLvhEJzAmFtmQ6dRT1YAWVijSrWLuFmGogcMMBeQadgVr2llRjuR4kdtt9HOo1f8G2eYQwxVosD1J5U3jvYRT6SjfP3JOmL/avuO0MWBuDU/v6u1oExpwkgpF0lhG909EZduCMKndkiYPVhMrUyADzeBWodIRrlYWXck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rIrYuk5l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rIrYuk5l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9E2CC433F1;
	Mon,  8 Apr 2024 13:20:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712582448;
	bh=kvH+FF5Mr8awkA/Z7BrqoSv1plt9V0o8mgegBYdDGV0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rIrYuk5lnX7XfMdbGXl7DvFK+GcUV5uX9CHjFiLF2kl2CkK5PyEKuCb3Gx2hUmQ2+
	 xebbXrys66SgJ6F7eQ5HKT8+gZu3+fmvDRj5OZ4cjbXEk12qjrwMV9TlFbXUvGkqoE
	 JjVLE1JuifUyMkYcgKXCsdXGsmPsZDfgzc6huoCA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mingi Cho <mgcho.minic@gmail.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 5.15 118/690] netfilter: nf_tables: mark set as dead when unbinding anonymous set with timeout
Date: Mon,  8 Apr 2024 14:49:44 +0200
Message-ID: <20240408125403.818612022@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pablo Neira Ayuso <pablo@netfilter.org>

commit 552705a3650bbf46a22b1adedc1b04181490fc36 upstream.

While the rhashtable set gc runs asynchronously, a race allows it to
collect elements from anonymous sets with timeouts while it is being
released from the commit path.

Mingi Cho originally reported this issue in a different path in 6.1.x
with a pipapo set with low timeouts which is not possible upstream since
7395dfacfff6 ("netfilter: nf_tables: use timestamp to check for set
element timeout").

Fix this by setting on the dead flag for anonymous sets to skip async gc
in this case.

According to 08e4c8c5919f ("netfilter: nf_tables: mark newset as dead on
transaction abort"), Florian plans to accelerate abort path by releasing
objects via workqueue, therefore, this sets on the dead flag for abort
path too.

Cc: stable@vger.kernel.org
Fixes: 5f68718b34a5 ("netfilter: nf_tables: GC transaction API to avoid race with control plane")
Reported-by: Mingi Cho <mgcho.minic@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/nf_tables_api.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -5062,6 +5062,7 @@ static void nf_tables_unbind_set(const s
 
 	if (list_empty(&set->bindings) && nft_set_is_anonymous(set)) {
 		list_del_rcu(&set->list);
+		set->dead = 1;
 		if (event)
 			nf_tables_set_notify(ctx, set, NFT_MSG_DELSET,
 					     GFP_KERNEL);


