Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60E07263C90;
	Tue,  8 Apr 2025 11:22:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744111336; cv=none; b=DtMGbYuGsSG/FRQGblYvT9U1K4StWl4eaegZEjPWsHfSihl43uLuhk1A6D6VvGFCYGgTK4ikGUPRnPehbFtxaR7Jf1UWp2ic1LDgoVfGWoiPYHeDMwA7HYdblincp9SrpnkeSc59YbGcsq5p9nBBp6SspWdUojxdJG0mu6zSL+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744111336; c=relaxed/simple;
	bh=il4aTYLXntvHts8gdbABh0nPoT6ZAcHLc6YolRhYZ6U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DYbgewfpJaCg4bm0lpuZvehDo0JKmnDC/2kebqkF8G39kMxZJhs6RUZdHPoHzVLggU1SJApfo/DbaIVDoaYHF+ovRa0+ixcDt8OwOsWHEbCoTxnq5XruFe7YfQt+zxbQ4DU/jKhlWjtt8XxGD+HjxA2ys8I4O+m2NXqZha49PJ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=neC6ta+v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="neC6ta+v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F6E7C4CEE5;
	Tue,  8 Apr 2025 11:22:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744111333;
	bh=il4aTYLXntvHts8gdbABh0nPoT6ZAcHLc6YolRhYZ6U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=neC6ta+vfqYNx1iSKfPdC324EkfRRNuJ8CMHDdFqDFJ/BuWytSPubrWKwk5CG10YF
	 oEHnPjk/iNce9mOWJCCQDAiVsoy5u2lSebl2bzXwuNug6Z1kQtyt9wZXPFK7s0CaA2
	 e2pcLke1kaE0MBpDUApPv6Wj45hCA5ve1kR2I/kE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Markus Elfring <elfring@users.sourceforge.net>,
	Cheng Xu <chengyou@linux.alibaba.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 395/731] RDMA/erdma: Prevent use-after-free in erdma_accept_newconn()
Date: Tue,  8 Apr 2025 12:44:52 +0200
Message-ID: <20250408104923.462263305@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cheng Xu <chengyou@linux.alibaba.com>

[ Upstream commit 83437689249e6a17b25e27712fbee292e42e7855 ]

After the erdma_cep_put(new_cep) being called, new_cep will be freed,
and the following dereference will cause a UAF problem. Fix this issue.

Fixes: 920d93eac8b9 ("RDMA/erdma: Add connection management (CM) support")
Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
Signed-off-by: Cheng Xu <chengyou@linux.alibaba.com>
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/erdma/erdma_cm.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/infiniband/hw/erdma/erdma_cm.c b/drivers/infiniband/hw/erdma/erdma_cm.c
index 1b23c698ec25c..e0acc185e7193 100644
--- a/drivers/infiniband/hw/erdma/erdma_cm.c
+++ b/drivers/infiniband/hw/erdma/erdma_cm.c
@@ -709,7 +709,6 @@ static void erdma_accept_newconn(struct erdma_cep *cep)
 		erdma_cancel_mpatimer(new_cep);
 
 		erdma_cep_put(new_cep);
-		new_cep->sock = NULL;
 	}
 
 	if (new_s) {
-- 
2.39.5



