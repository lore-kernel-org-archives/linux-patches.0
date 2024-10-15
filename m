Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B9B91E7640;
	Tue, 15 Oct 2024 11:50:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728993052; cv=none; b=mxcSgoLRtX8aITckpBDx/SgqKR69lecoF0HjAsowY/JopC/cNTqWARjS9XXt5duHthtV4A/L20fjls+5LxhoDd7chJt1cwmCVUeqJM4SeIZhSYxINPsAC4AaqqfAR9ym46TOeddR1LTM+9cEFmEvqksIFDKSpJEq6kMDHwOP5UY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728993052; c=relaxed/simple;
	bh=nNHv7AGunMPT8ckoKQs8DiBLApYuPFUx4eFy7uGcI8I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I+GTveULgtnfWiIgh12HsXaTNW7GUv+wOY1m5iq0XoIBvB4QCMAcGdhMoLwdt1ojWZZvp8dxRo9LZslmGDJJjnj4kzeA3z4rppRqWOPGdcpCVwf268lLu/Z0FYnkKZ8O8p+y/XiNCSNxS7PEOZaZiADEIDWH5xXRqfle4zjjIJo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=plUlpr+y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="plUlpr+y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05518C4CECF;
	Tue, 15 Oct 2024 11:50:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728993052;
	bh=nNHv7AGunMPT8ckoKQs8DiBLApYuPFUx4eFy7uGcI8I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=plUlpr+y5veLkIHpa2tVfUB6NJeSYrbGwzS8ANqfskCaP7crBjCIpyMWevxVCl5BP
	 I3dOg/qGunB+D2LrF3dUiRKYaoFrNqCTaLp6t86qzTMl+CJJAEa25iYhFRaxhDjH+Q
	 JyDvcWqS3ruURZzIDvn+8iM2pCc/uU03WbzMTzOM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 297/691] netfilter: nf_tables: Keep deleted flowtable hooks until after RCU
Date: Tue, 15 Oct 2024 13:24:05 +0200
Message-ID: <20241015112452.133370806@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

From: Phil Sutter <phil@nwl.cc>

[ Upstream commit 642c89c475419b4d0c0d90e29d9c1a0e4351f379 ]

Documentation of list_del_rcu() warns callers to not immediately free
the deleted list item. While it seems not necessary to use the
RCU-variant of list_del() here in the first place, doing so seems to
require calling kfree_rcu() on the deleted item as well.

Fixes: 3f0465a9ef02 ("netfilter: nf_tables: dynamically allocate hooks per net_device in flowtables")
Signed-off-by: Phil Sutter <phil@nwl.cc>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_tables_api.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index f493f4351ca52..71a486d9fd76a 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -8434,7 +8434,7 @@ static void nf_tables_flowtable_destroy(struct nft_flowtable *flowtable)
 		flowtable->data.type->setup(&flowtable->data, hook->ops.dev,
 					    FLOW_BLOCK_UNBIND);
 		list_del_rcu(&hook->list);
-		kfree(hook);
+		kfree_rcu(hook, rcu);
 	}
 	kfree(flowtable->name);
 	module_put(flowtable->data.type->owner);
-- 
2.43.0



