Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DAC746EF91;
	Tue, 21 Jul 2026 19:08:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660895; cv=none; b=EVlgP5ZBseR2xtuzQ73MX2NWkELMbY1RnBUXiJ/k4mJpk7seIdhf802951J3hy5894IOZUmLDSK0IN9dcckyd54asBhptXXdqbmXTZ1W5Bd0ygItzSbNp2Buut+Djj2YU1mgWZFKmhvmccOp++HDxHIIzn7KuxEFLHMx1HW842s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660895; c=relaxed/simple;
	bh=DeMtrZweBU2jHPx+8dCqSk3EOrPcExrNhogPmF3V/fU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kefgLibLZTiweTsxaHiDbBzi1C1hnI/uvuCvijzDV5PdD9pLkajJnKmcx2V59YOaEdlz2cwH20Y8WKU68z7SenSpvY2/OKLpnbUCO77ObLORE4iwG6My2ov1j3ygGDhP9hW45JlyOfG7rN+oyq+NbV2sbk3NyTBi0rEJcYCC5dc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Vz5WHdT3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Vz5WHdT3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 639391F00A3D;
	Tue, 21 Jul 2026 19:08:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660890;
	bh=Mj6yylMrtkjjjcXsb2cw7huVO3hxxhlR/xX87KrPODE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Vz5WHdT3McQQ+NBqHjTh08cLz1VUCD7c4Gy7L8fUoA1XqhqH2SMMVNCSDJY5iY26k
	 kfPlSviXxyUs6zGjdoyIpYzwSPtm6c5VO4SHOqFbqOh7WbHhXrMUJjInQ5Sdj4Le5q
	 dvO7O94NnGfe9RPgd8ASfJpwUfuCwPqnF1WTS0HY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1149/2077] netfilter: ipset: make sure gc is properly stopped
Date: Tue, 21 Jul 2026 17:13:42 +0200
Message-ID: <20260721152619.922679549@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jozsef Kadlecsik <kadlec@netfilter.org>

[ Upstream commit 4a597a87e2e2f608edb6be2c510dc826b4fdfb53 ]

Sashiko noticed that when destroying a set,
cancel_delayed_work_sync() was called while gc
calls queue_delayed_work() unconditionally which
can lead not to properly shutting down the gc.

Fixes: f66ee0410b1c ("netfilter: ipset: Fix "INFO: rcu detected stall in hash_xxx" reports")
Signed-off-by: Jozsef Kadlecsik <kadlec@netfilter.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/ipset/ip_set_hash_gen.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/ipset/ip_set_hash_gen.h b/net/netfilter/ipset/ip_set_hash_gen.h
index 00c27b95207f79..dedf59b661ddf3 100644
--- a/net/netfilter/ipset/ip_set_hash_gen.h
+++ b/net/netfilter/ipset/ip_set_hash_gen.h
@@ -606,7 +606,7 @@ mtype_cancel_gc(struct ip_set *set)
 	struct htype *h = set->data;
 
 	if (SET_WITH_TIMEOUT(set))
-		cancel_delayed_work_sync(&h->gc.dwork);
+		disable_delayed_work_sync(&h->gc.dwork);
 }
 
 static int
-- 
2.53.0



