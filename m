Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E83FD33BBB5;
	Tue, 11 Nov 2025 01:19:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823994; cv=none; b=CObQjhmtoxq/H47vxyyOMmRnLXFXrzP9/nDb47G4Nb2WxX7u7sE/HFrpN5/0z38M2MyxTqhHwaRyqH7F9rhHng9J6xC0iakMrXTiS26LPmGt1QQJmOnOmk1XeXqh6aocjD+xeEPNMrTA2qRrAvhFw9js/kJaX2e4ntHKBnNlTLE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823994; c=relaxed/simple;
	bh=impuB4VsbVZc5F4fTxb98yfOuPv2YaB0svr08r8AKss=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ezjSWwlpCjF67y9y9vCLL4Ki3wIiXqITYHOYl6WEgzQFIjb4FSuKHY8kuZ2mNwWLmJWMSJ/k6KmgeaEgLbEjW2hYuLufw64yUpXyFmCoDniNqaehjnZIMt73Hkt675LvreSuyE5rf+A2Y769V6KecLInlXZLKTpVDlxpuPrgBc8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Sgx64h1X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Sgx64h1X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83D41C16AAE;
	Tue, 11 Nov 2025 01:19:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823993;
	bh=impuB4VsbVZc5F4fTxb98yfOuPv2YaB0svr08r8AKss=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Sgx64h1XgXbcPAEnamb4DX0UUpNayAs90J26rNsOg1bDFVH2hKRMb8oNXV1c7JbOf
	 hJsLgsyvDMXQZUHNd3tEXPaLAxP2MF8ubzkEm4GL3vezFMTbMAZ159PpInhmt3adUL
	 wIE6Dd64r7duGMqsGjH8oWsH4ZT+4byiQr+6upV4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mina Almasry <almasrymina@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 367/565] page_pool: always add GFP_NOWARN for ATOMIC allocations
Date: Tue, 11 Nov 2025 09:43:43 +0900
Message-ID: <20251111004535.124058205@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit f3b52167a0cb23b27414452fbc1278da2ee884fc ]

Driver authors often forget to add GFP_NOWARN for page allocation
from the datapath. This is annoying to users as OOMs are a fact
of life, and we pretty much expect network Rx to hit page allocation
failures during OOM. Make page pool add GFP_NOWARN for ATOMIC allocations
by default.

Reviewed-by: Mina Almasry <almasrymina@google.com>
Link: https://patch.msgid.link/20250912161703.361272-1-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/page_pool.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/core/page_pool.c b/net/core/page_pool.c
index 6a7d740b396f6..cc0dce5246a2b 100644
--- a/net/core/page_pool.c
+++ b/net/core/page_pool.c
@@ -586,6 +586,12 @@ static noinline netmem_ref __page_pool_alloc_pages_slow(struct page_pool *pool,
 	netmem_ref netmem;
 	int i, nr_pages;
 
+	/* Unconditionally set NOWARN if allocating from NAPI.
+	 * Drivers forget to set it, and OOM reports on packet Rx are useless.
+	 */
+	if ((gfp & GFP_ATOMIC) == GFP_ATOMIC)
+		gfp |= __GFP_NOWARN;
+
 	/* Don't support bulk alloc for high-order pages */
 	if (unlikely(pp_order))
 		return page_to_netmem(__page_pool_alloc_page_order(pool, gfp));
-- 
2.51.0



