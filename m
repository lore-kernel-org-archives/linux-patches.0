Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05C8B13AA50;
	Tue, 27 Feb 2024 14:00:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709042432; cv=none; b=ZMpkHc5UUcTpGH6c0U3zAhgCWj3kugvWN/Yz7RKIZaYo1EFo5udw4LKkRsoh9sOdnKi87ExayG+c6yKfV5XawMAOJ8ARnhjtfO2dfxSuvH4y0O46AMwtRgIB1ZqvAaIUgqzzUi0+nMaOp0f7ZJuJDlpOkXjjHgPA4+EfuhEcb/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709042432; c=relaxed/simple;
	bh=aC6fjPYa4sJUwFyXThyDt4gr6SYH0XXPcgLreB2+VBg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R17wEqKznRTASrwaCBNW7/r+pCnEIbtEjNMsidCSiHsw2WKaWYloYX8uf0caQNoyuhTBXd1NbXivilkd1bRNDuF31HrmCM76y3PyOK8BSVO3X/rRRgy30fkGZgy+LhqJ6rkRf8+rXtofHNW6i6HawLgoqmn76vFRLJ9iHQ5DLzg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J41daLub; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J41daLub"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 481F4C433C7;
	Tue, 27 Feb 2024 14:00:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709042429;
	bh=aC6fjPYa4sJUwFyXThyDt4gr6SYH0XXPcgLreB2+VBg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J41daLubMyYXwV5EB2KLOFBGV3QXscfhJ1gqSyOgjX4cWzq4g7nmi52WHEPduHiAG
	 uFXHH7uzg7ImoNYDtdnNsjXQB91fjxTDU5UcclcWSRKgge20JSxu/1m1LOy7/B9xZ0
	 besxDrTNGxiLMiHDAf0Gy9UmFYbJkRFWnOVUC2Nk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 275/299] netfilter: nf_tables: use kzalloc for hook allocation
Date: Tue, 27 Feb 2024 14:26:26 +0100
Message-ID: <20240227131634.527809975@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131625.847743063@linuxfoundation.org>
References: <20240227131625.847743063@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Westphal <fw@strlen.de>

[ Upstream commit 195e5f88c2e48330ba5483e0bad2de3b3fad484f ]

KMSAN reports unitialized variable when registering the hook,
   reg->hook_ops_type == NF_HOOK_OP_BPF)
        ~~~~~~~~~~~ undefined

This is a small structure, just use kzalloc to make sure this
won't happen again when new fields get added to nf_hook_ops.

Fixes: 7b4b2fa37587 ("netfilter: annotate nf_tables base hook ops")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_tables_api.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 36fdce00bdab4..8808d78d65235 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -2084,7 +2084,7 @@ static struct nft_hook *nft_netdev_hook_alloc(struct net *net,
 	struct nft_hook *hook;
 	int err;
 
-	hook = kmalloc(sizeof(struct nft_hook), GFP_KERNEL_ACCOUNT);
+	hook = kzalloc(sizeof(struct nft_hook), GFP_KERNEL_ACCOUNT);
 	if (!hook) {
 		err = -ENOMEM;
 		goto err_hook_alloc;
-- 
2.43.0



