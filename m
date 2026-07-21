Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D837B403AFB;
	Tue, 21 Jul 2026 17:30:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655011; cv=none; b=P/ix9EiZF6H93WZf7Qijy2vK43VMhIvhBFKnaD/yHpvxrrs4VqwMcMLPTrO9KcBB0Cee8UH5wudPb8DWmYpUlIDTX29l2mpD2vAW6y1tPk+tAX3LpjDA01v9rImA8Sx6aAm62VdpikO7jJLgzh8p21AXK/cftk8bppXY6rfVhVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655011; c=relaxed/simple;
	bh=Wv6MGKxkWZetKFl5Mh6Gs+/z1KlUVEv7rrpS9aSLvN4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xdev2l8p76Ppn9dtNJf7b6goX2BrQJF0wwkq6OhC4jtsiOzA21FHHnfo3nJGTSw2QXDuAg8vobILZ8LNJzGJ/AHkR3wW+ZzVx4ekPLlnwFri+fkO9tRJJUKZVjpmKR5ds8Mc3NXdFbST4B3gdq0xRI3Rk0hnum/3iw5uCHR91N8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qct+JQ5s; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qct+JQ5s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A75F1F000E9;
	Tue, 21 Jul 2026 17:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784655010;
	bh=jQ1ITtdprS8TQ4q2BJbciMdmEspTnWy3H9/qFMhcpSk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Qct+JQ5slok7oJa2w5+aPdnMrg8hQa/LteS/ht60N9dDUEKntHl9BDIb06gafbbtg
	 flzW66hL7+9oAuMhUh111w7Kl9xoSplItPbvErU+YE8chu0hwnFMGsMDW33Cmb/cLg
	 Rlsi1YK2K957y7l9evvqej2eGVL8QwSxsMPPnCK0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <haoxiang_li2024@163.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.1 1921/2077] octeontx2-af: Free BPID bitmap on setup failure
Date: Tue, 21 Jul 2026 17:26:34 +0200
Message-ID: <20260721152638.023546217@linuxfoundation.org>
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

From: Haoxiang Li <haoxiang_li2024@163.com>

commit 36323f54cd323122a1be89ab2c316a6e55a94e30 upstream.

nix_setup_bpids() allocates bp->bpids with rvu_alloc_bitmap(), which uses
a plain kcalloc(). If any of the following devm_kcalloc() allocations for
the BPID mapping arrays fails, the function returns without freeing the
bitmap. Free the BPID bitmap before returning from those error paths.

Fixes: d6212d2e41a0 ("octeontx2-af: Create BPIDs free pool")
Cc: stable@vger.kernel.org
Signed-off-by: Haoxiang Li <haoxiang_li2024@163.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20260623114316.2182271-1-haoxiang_li2024@163.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
@@ -527,19 +527,24 @@ static int nix_setup_bpids(struct rvu *r
 	bp->fn_map = devm_kcalloc(rvu->dev, bp->bpids.max,
 				  sizeof(u16), GFP_KERNEL);
 	if (!bp->fn_map)
-		return -ENOMEM;
+		goto free_bpids;
 
 	bp->intf_map = devm_kcalloc(rvu->dev, bp->bpids.max,
 				    sizeof(u8), GFP_KERNEL);
 	if (!bp->intf_map)
-		return -ENOMEM;
+		goto free_bpids;
 
 	bp->ref_cnt = devm_kcalloc(rvu->dev, bp->bpids.max,
 				   sizeof(u8), GFP_KERNEL);
 	if (!bp->ref_cnt)
-		return -ENOMEM;
+		goto free_bpids;
 
 	return 0;
+
+free_bpids:
+	rvu_free_bitmap(&bp->bpids);
+	bp->bpids.bmap = NULL;
+	return -ENOMEM;
 }
 
 void rvu_nix_flr_free_bpids(struct rvu *rvu, u16 pcifunc)


