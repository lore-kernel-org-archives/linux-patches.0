Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C44E3B7747;
	Tue, 13 Oct 2026 12:48:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791895691; cv=none; b=lIv3QpZ5oRqgv4QWFsszkx4fwmHyA5TA1nxezTMPWRRO3bWjD7kMfi+BC64wbCcwJb5zQFvuHl3LnGkQdW/ZKOkZC0Cc2/bIc6VZ+Hs9uvBTBz1Yg8EqCx9ruwYZCjgeNmvvRUl8MmYPx0FKVZLAmxrL5FhNdnxkptuUOjucEmg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791895691; c=relaxed/simple;
	bh=z6rHlw8cz2Ide3uR+aIxcAZubAJW3/JT4H0Sh9rbiDc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mitqez3yzDSud1T2gzlq/tbn2+CktKsxGixQCpFLEzczOXFqkkpSAoVGzfpRoiIGqr6cY5+txnsdAKbC5aNzQ9euhZa2kXdi+cFE4IdHhZ7S/Ouvkod9N3yIK+wqIikNqaGfXjZGpVxr6iMbGTSpRwSUF/vuIIR0Faj+i9k51H4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X/W4Tojj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X/W4Tojj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04F0E1F000FF;
	Tue, 13 Oct 2026 12:48:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791895690;
	bh=4wWsEEiNk/icl2eMtazEhnPndAOtcX6TBh2VRRznT4E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=X/W4Tojj2xBekROTYyIt0lq4Ewh2XW720+Cdi+QHqfVqYmKnVlh5LCAxyRiRfvNb5
	 osOcyOshYlJufJBUOUR7TSSkz8W88KG7qsyZcM+TxbbW0khSHtZtSdv7Bd0j71PFoM
	 xMtVFzd7YUd20z0DJCiXh4eHD6DF5Ew1AgOr5StY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Dipayaan Roy <dipayanroy@linux.microsoft.com>,
	Aditya Garg <gargaditya@linux.microsoft.com>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 323/497] net: mana: remove double CQ cleanup in mana_create_rxq error path
Date: Tue, 13 Oct 2026 13:38:10 +0200
Message-ID: <20261013112915.570258869@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/microsoft/mana/mana_en.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/ethernet/microsoft/mana/mana_en.c b/drivers/net/ethernet/microsoft/mana/mana_en.c
index 46726f743d322..bd1ae41df552d 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_en.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
@@ -2317,9 +2317,6 @@ static struct mana_rxq *mana_create_rxq(struct mana_port_context *apc,
 
 	mana_destroy_rxq(apc, rxq, false);
 
-	if (cq)
-		mana_deinit_cq(apc, cq);
-
 	return NULL;
 }
 
-- 
2.53.0



