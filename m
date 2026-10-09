Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EC4034D3BE;
	Fri,  9 Oct 2026 14:50:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791557413; cv=none; b=d4boqY8uhTpgcjuqmAzL0zWQxldSGPUjgqr9S7CwCycKWfh/hRbXK5wCrTvjsv0GJ/so38nYw2unmdcEeIR1lBkNzhlkyb/SZmGNAKLmUG4Ns7JajYazpvb1NCviNND5Z/kG9Y+PFIN6rwd1C8ggJ6mUBG18i66dDiPP7D5iJq4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791557413; c=relaxed/simple;
	bh=zDPKZv5JHa+hVz/isk00qmQB9iFkiyiQDiLfs+6rPnk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aXj4Tx6LnZq1I9+lyz1aSKnj9F6TEX3roDvvsXCaSXUiwNTLe3rAGrOuRiqrOwFpHUgNwAjZAHMXfFB7fMQXu0NTPEsALz0zy3TWrArhxAxnECZnnE8o6f3nZhkQdBLCEXzqD2V6rY1m+9qMBu7XFxngzWAWFeLtd7OO3iHeTiQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p8FCyqfq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p8FCyqfq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2E901F000FF;
	Fri,  9 Oct 2026 14:50:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791557412;
	bh=Fwq9ej6EVdhVPAgYSi9NUyEl3JWi61TGAKCfByx/W0Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=p8FCyqfqVbziw/x92UXIQVVihc0e0nMbkHa9tCnvmzM9zGgWTpkpq+nqbBkzRi8nK
	 P+z1vUS4rdmdCqJtYyx/diGrK/gZh54mFV3zJnD4CW4/a9h8IYkj/xMQkUXukXWCWI
	 y69vimHEvHD/qMtSvAeNGWheDURylQQ8U+RiRtvs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Dipayaan Roy <dipayanroy@linux.microsoft.com>,
	Aditya Garg <gargaditya@linux.microsoft.com>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Hamza Mahfooz <hamzamahfooz@linux.microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 399/403] net: mana: remove double CQ cleanup in mana_create_rxq error path
Date: Fri,  9 Oct 2026 16:12:40 +0200
Message-ID: <20261009141001.689917765@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140952.119038291@linuxfoundation.org>
References: <20261009140952.119038291@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dipayaan Roy <dipayanroy@linux.microsoft.com>

[ Upstream commit 3985c9a56da49af8b2e45cb1fa55c03c89b1d471 ]

In mana_create_rxq(), the error cleanup path calls mana_destroy_rxq()
followed by mana_deinit_cq(). This is incorrect for two reasons:

1. mana_destroy_rxq() already calls mana_deinit_cq() internally,
   so the CQ's GDMA queue is destroyed twice.

2. mana_destroy_rxq() frees the rxq via kfree(rxq) before returning.
   The subsequent mana_deinit_cq(apc, cq) then operates on freed memory
   since cq points to &rxq->rx_cq, which is embedded in the
   already-freed rxq structure — a use-after-free.

Remove the redundant mana_deinit_cq() call from the error path since
mana_destroy_rxq() already handles CQ cleanup. mana_deinit_cq() is
itself safe for an uninitialized CQ as it checks for a NULL gdma_cq
before proceeding.

Fixes: ca9c54d2d6a5 ("net: mana: Add a driver for Microsoft Azure Network Adapter (MANA)")
Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Dipayaan Roy <dipayanroy@linux.microsoft.com>
Reviewed-by: Aditya Garg <gargaditya@linux.microsoft.com>
Link: https://patch.msgid.link/20260430035935.1859220-4-dipayanroy@linux.microsoft.com
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Hamza Mahfooz <hamzamahfooz@linux.microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/microsoft/mana/mana_en.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/ethernet/microsoft/mana/mana_en.c b/drivers/net/ethernet/microsoft/mana/mana_en.c
index c5e13eb662f41..3b5336468f0e6 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_en.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
@@ -2795,9 +2795,6 @@ static struct mana_rxq *mana_create_rxq(struct mana_port_context *apc,
 
 	mana_destroy_rxq(apc, rxq, false);
 
-	if (cq)
-		mana_deinit_cq(apc, cq);
-
 	return NULL;
 }
 
-- 
2.53.0



